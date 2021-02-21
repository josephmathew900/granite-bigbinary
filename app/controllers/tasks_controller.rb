class TasksController < ApplicationController

  before_action :authenticate_user_using_x_auth_token, except: [:new, :edit]
  before_action :load_task, only: %i[show update destroy]
  
  def index
    tasks = Task.all
    render status: :ok, json: {tasks: tasks}
  end

  def create
    @task=Task.new(task_params)
    if @task.save
      render status: :ok, json: { notice:  t('successfully_created', entity: 'Ticket') }
    else
      errors = @task.errors.full_messages
      render status: :unprocessable_entity, json: {errors: errors}
    end
  end

  def show
    render status: :ok, json: {task: @task, assigned_user: @task.user}
  end

  def update
    if @task.update(task_params)
      render status: :ok, json: { notice: 'Successfully updated task.' }
    else
      render status: :unprocessable_entity, json: { errors: @task.errors.full_messages }
    end
  end

  def destroy
    if @task.destroy
      render status: :ok, json: { notice: 'Successfully deleted task.' }
    else
      render status: :unprocessable_entity, json: { errors: @task.errors.full_messages }
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :user_id)
  end

  def load_task
    @task = Task.find(params[:id])
    rescue ActiveRecord::RecordNotFound => errors
      render json: {errors: errors}, status: :not_found
  end

end
