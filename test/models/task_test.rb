require "test_helper"

class TaskTest < ActiveSupport::TestCase
  def test_instance_of_task
    task = Task.new
    # See if object task actually belongs to Task
    assert_instance_of Task, task
  end
end