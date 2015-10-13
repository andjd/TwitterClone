require 'singleton'
require 'sqlite3'
require_relative 'users'
require_relative 'replies'

class QuestionsDatabase < SQLite3::Database

  include Singleton

  def initialize
    super('questions.db')
    self.results_as_hash = true
    self.type_translation = true
  end
end

class Question
  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM questions')
    results.map {|result| Question.new(result)}
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
end
