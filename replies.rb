require_relative 'questions'
require_relative 'users'
class Reply

  def self.find_by_user_id (user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT *
      FROM replies
      WHERE user_id = ?
    SQL
    results.map {|result| Reply.new(result)}
  end

  def self.find_by_question_id (question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT *
      FROM replies
      WHERE question_id = ?
    SQL
    results.map {|result| Reply.new(result)}
  end



  attr_reader :id, :body, :parent_id, :user_id, :question_id

  def initialize(options = {})
    @id = options['id']
    @body = options['body']
    @parent_id = options['parent_id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  def author
    User.find_by_id(user_id)
  end

  def question
    Question.find_by_id(question_id)
  end


end
