require_relative 'questions'
require_relative 'replies'

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

end
