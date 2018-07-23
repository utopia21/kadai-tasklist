class TasksController < ApplicationController
  before_action :require_user_logged_in, except: [:index]
  before_action :correct_user, only: [:edit, :update, :destroy]
  
  def index
    if logged_in?
      @user = current_user
      @tasks = current_user.tasks.all
    end
  end
  
  def show
    @task = current_user.tasks.find(params[:id])
  end
  
  def new
    @task = current_user.tasks.build
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    
    if @task.save
      flash[:success] = "Taskが正常に登録されました"
      redirect_to @task
    else
      flash.now[:danger] = "Taskが登録されませんでした"
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @task.update(task_params)
      flash[:success] = "Taskが正常に更新されました"
      redirect_to @task
    else
      flash.now[:danger] = "Taskが更新されませんでした"
      render :new
    end
  end
  
  def destroy
    @task.destroy
    
    flash[:success] = "Taskは正常に削除されました"
    redirect_to tasks_url
  end
  
  private
  
  # Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end
