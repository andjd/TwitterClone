require_relative 'questions'
require_relative 'users'
require_relative 'replies'
require_relative 'likes'

class QuestionFollow < ModelBase
  def self.followers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT users.*
      FROM users
      JOIN question_follows
        ON users.id = question_follows.user_id
      WHERE question_id = ?
    SQL
    results.map { |result| User.new(result) }
  end

  def self.most_followed_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM question_follows
      JOIN questions
        ON question_follows.question_id = questions.id
      GROUP BY question_id
      ORDER BY COUNT(questions.user_id)
      LIMIT ?
    SQL
    results.map { |result| Question.new(result) }
  end

  def self.followed_questions_for_user(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM users
      JOIN question_follows
        ON users.id = question_follows.user_id
      JOIN questions
        ON question_follows.question_id = questions.id
      WHERE users.id = ?
    SQL
    results.map { |result| Question.new(result) }
  end



  def initialize(o = {})
    @id = o['id']
    @question_id = o['question_id']
    @user_id = o['user_id']
  end

end
