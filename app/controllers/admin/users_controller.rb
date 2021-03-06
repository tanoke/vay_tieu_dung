class Admin::UsersController < ApplicationController
  layout 'layout_admin'
  before_filter :authorize_admin

  def index
    @users = User.paginate(:page => params[:page], :per_page => 10)
  end

  def edit
    @user = User.find(params[:id])
    @birthday = @user.birthday
    if @birthday == nil
      @day = Time.now.day
      @month = Time.now.month
      @year = Time.now.year
    else
      @time = @birthday.split("/")
      @day = @time[0]
      @month = @time[1]
      @year = @time[2]
    end
  end

  def update
    # binding.pry
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update(user_params)
        # upload document user here

        if params[:document]
          # binding.pry
          @media = Medium.create(path: params[:document])
          @user.update(:media_id => @media.id)
        end
        format.html {redirect_to admin_users_path, notice: 'User was successfully updated'}
        format.json { render :show, status: :ok, location: @user}
      else
        format.html { render :show }
        format.json {render json: @user.errors, status: :unprocessable_entity}
      end
    end
  end


  private
  def user_params
    params.require(:user).permit(:email,:password,:name,:phone,:passport,:gender,:marriage,:address,:provined_id,:district_id,:ward_id,:status)
  end
end
