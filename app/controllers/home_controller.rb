class HomeController < ApplicationController
  allow_unauthenticated_access(only: :index)
  before_action :resume_session, only: :index # Keep session even when access index
  def index
    if authenticated?
      @user = Current.user
    end
  end

  def dashboard
  end
end
