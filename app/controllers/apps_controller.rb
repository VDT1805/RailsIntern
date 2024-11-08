class AppsController < ApplicationController
  def index
    @org = Org.find(params[:org_id])
    @apps = App.all
  end
end
