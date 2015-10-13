require_relative 'users'
require_relative 'replies'
require_relative 'follows'
require_relative 'questions'

class QLikes

  def self.likers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT users.*
      FROM users
      JOIN question_likes
        ON users.id = question_likes.user_id
      WHERE question_id = ?
    SQL
    results.map { |result| User.new(result) }
  end

  def self.num_likes_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(*) AS num
      FROM question_likes
      JOIN questions
        ON question_likes.question_id = questions.id
      WHERE question_id = ?
    SQL
    results[0]['num']
  end

  def self.liked_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT questions.*
      FROM questions
      JOIN question_likes
        ON questions.id = question_likes.question_id
      WHERE question_likes.user_id = ?
    SQL
    results.map { |result| Question.new(result) }
  end

  def self.most_liked_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM question_likes
      JOIN questions
        ON question_likes.question_id = questions.id
      GROUP BY question_id
      ORDER BY COUNT(questions.user_id)
      LIMIT ?
    SQL
    results.map { |result| Question.new(result) }
  end




  def initialize(o = {})
    @id = o['id']
    @question_id = o['question_id']
    @user_id = o['user_id']
  end

end
