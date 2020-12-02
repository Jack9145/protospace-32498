class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :new, :edit, :update , :destroy]
  before_action :find_id , only: [:show, :edit] 
  before_action :move_to_index, except: [:index, :show]
  
  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show 
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    
  end

  def update
    prototype = Prototype.find(params[:id])
    prototype.update(prototype_params)

    if  prototype.update(prototype_params)
      redirect_to action: :show
    else
      render :edit
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to action: :index
  end

  private
    def prototype_params
      #binding.pry
      params.require(:prototype).permit(:title, :image, :concept, :catch_copy).merge(user_id: current_user.id)
    end

    def find_id
      @prototype = Prototype.find(params[:id])
    end

    def move_to_index
      unless current_user.id === @prototype.user.id
        redirect_to action: :index
      end
    end
  
end
