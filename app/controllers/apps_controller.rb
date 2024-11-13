class AppsController < ApplicationController
  def index
    @org = Current.user.org
    @apps = App.all
  end
end
