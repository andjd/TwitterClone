require_relative 'questions'
require_relative 'replies'
require_relative 'follows'
require_relative 'likes'

class User

  def self.find_by_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT *
      FROM users
      WHERE id = ?
    SQL
    #add error handling if more than one fname/lname pair
    User.new(results.first)
  end


  def self.find_by_name (fname, lname)
    results = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT *
      FROM users
      WHERE fname = ? AND lname = ?
    SQL
    #add error handling if more than one fname/lname pair
    User.new(results.first)
  end



  attr_reader :id, :fname, :lname

  def initialize(o = {})
    @id = o['id']
    @fname = o['fname']
    @lname = o['lname']
  end

  def authored_questions
    Question.find_by_user_id(id)
  end

  def authored_replies
    Reply.find_by_user_id(id)
  end

  def followed_questions
    QuestionFollows.followed_questions_for_user(id)
  end

  def liked_questions
    QLikes.liked_questions_for_user_id(id)
  end

  def average_karma
    results = QuestionsDatabase.instance.execute(<<-SQL, id).first
      SELECT
      COUNT(likes.user_id) /
      CAST(COUNT(DISTINCT questions.id) AS FLOAT)
      FROM users
      JOIN questions
        ON users.id = questions.user_id
      LEFT OUTER JOIN question_likes AS likes
        ON questions.id = likes.question_id
      WHERE users.id = ?
    SQL
  end


end
