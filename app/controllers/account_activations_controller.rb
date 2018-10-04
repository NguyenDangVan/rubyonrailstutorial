class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      user.update activated: true, activated_at: Time.zone.now
      log_in user
      flash[:success] = t ".acc_actived"
      redirect_to user
    else
      flash[:danger] = t ".invalid_active_link"
      redirect_to root_url
    end
  end
end
