class TasksController < ApplicationController
  
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  before_action :authenticate_user_using_x_auth_token
  before_action :load_task, only: %i[show update destroy]
  
  def index
    tasks = policy_scope(Task)
    render status: :ok, json: {
      tasks: {
        pending: tasks.organize(:pending).as_json(include: {
          user: {
            only: [:name, :id]
          }
        }),
        completed: tasks.organize(:completed)
      }
    }
  end

  def create
    @task = Task.new(task_params.merge(creator_id: @current_user.id))
    authorize @task
    if @task.save
      render status: :ok, json: { notice: t('successfully_created', entity:'Task') }
    else
      errors = @task.errors.full_messages.to_sentence
      render status: :unprocessable_entity, json: { errors: errors }
    end
  end

  def show
    authorize @task
    comments = @task.comments.order('created_at DESC')
    task_creator = User.find(@task.creator_id).name
    render status: :ok, json: { task: @task,
                                assigned_user: @task.user,
                                comments: comments,
                                task_creator: task_creator }
  end

  def update
    authorize @task
    is_not_owner = @task.creator_id != @current_user.id

    if task_params[:authorize_owner] && is_not_owner
      render status: :forbidden, json: { error: t('authorization.denied') }
    else
      if @task.update(task_params.except(:authorize_owner))
        render status: :ok, json: { notice: 'Successfully updated task.' }
      else
        render status: :unprocessable_entity, json: { errors: @task.errors.full_messages }
      end
    end
  end

  def destroy
    authorize @task
    if @task.destroy
      render status: :ok, json: { notice: 'Successfully deleted task.' }
    else
      render status: :unprocessable_entity, json: { errors: @task.errors.full_messages }
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :user_id, :authorize_owner, :progress, :status)
  end

  def load_task
    @task = Task.find(params[:id])
    rescue ActiveRecord::RecordNotFound => errors
      render json: {errors: errors}, status: :not_found
  end

end
