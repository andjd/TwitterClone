require 'singleton'
require 'sqlite3'

class String #add to_underscore
   def to_underscore!
     gsub!(/(.)([A-Z])/,'\1_\2')
     downcase!
   end

   def to_underscore
     dup.tap { |s| s.to_underscore! }
   end
end


class QuestionsDatabase < SQLite3::Database

  include Singleton

  def initialize
    super('questions.db')
    self.results_as_hash = true
    self.type_translation = true
  end
end

class ModelBase
  def self.all
    results = QuestionsDatabase.instance.execute(<<-SQL)
        SELECT *
        FROM #{self.name.to_underscore.concat("s")}
      SQL
    results.map {|result| self.new(result)}
  end

  def save
    self.instance_variables.each do |variable|
      val = self.instance_variable_get(variable)
      key = variable.to_s[1..-1] #removes the snail
      next if key == 'id'
      if id.nil?
        puts key, val
        QuestionsDatabase.instance.execute(<<-SQL, val )
           INSERT INTO #{self.class.to_s.to_underscore.concat("s")}
           ( #{key} )
           VALUES ( ? )
         SQL
         @id = QuestionsDatabase.instance.last_insert_row_id
      else
        QuestionsDatabase.instance.execute(<<-SQL, val, self.id)
          UPDATE #{self.class.to_s.to_underscore.concat("s")}
          SET #{key} = ?
          WHERE id = ?
        SQL
      end
    end
  end

end

require_relative 'users'
require_relative 'replies'
require_relative 'follows'
require_relative 'likes'

class Question < ModelBase


  def self.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end

  def self.find_by_id(id)
    self.all.each do |question|
      return question if question.id == id
    end
  end

  def self.find_by_user_id (user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT *
      FROM questions
      WHERE user_id = ?
    SQL
    results.map { |result| Question.new(result) }
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end


  attr_accessor :id, :title, :body, :user_id

  def initialize (options = {})
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end

  def user
    User.find_by_id(user_id)
  end

  def replies
    Reply.find_by_question_id(id)
  end

  def followers
    QuestionFollow.followers_for_question_id(id)
  end

  def likers
    QuestionLike.likers_for_question_id(id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(id)
  end



end
