class Users::RegistrationsController < Devise::RegistrationsController
# before_action :configure_sign_up_params, only: [:create]
# before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  def create
    random = rand(111111...999999)
    params[:user][:active_code] = random
    params[:user][:status] = 0
    params[:user][:password] = random
    params[:user][:password_confirmation] = random
    build_resource(registration_params)

    if resource.save
    #   render :json => params
    # return
      RegisterMailer.register_email(resource).deliver_now
      # render :json => resource
      # return
      # if resource.active_for_authentication?
      #   render :json => 'AAA'
      #   return
      #   set_flash_message :notice, :signed_up if is_navigational_format?
      #   sign_up(resource_name, resource)
      #   respond_with resource, :location => after_sign_up_path_for(resource)
      # else
      #   render :json => 'BBB'
      #   return
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        respond_with resource, :location => after_sign_up_path_for(resource)
      # end
    else
      clean_up_passwords
      respond_with resource
    end
  end  

  private

  def registration_params
    # params.require(:user).permit(:email, :title_id, :first_name, :last_name, :province_id, :password, :password_confirmation)
    params.require(:user).permit(:email, :password, :password_confirmation, :active_code, :status)
  end
end
