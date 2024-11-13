class HomeController < ApplicationController
  allow_unauthenticated_access(only: :index)
  before_action :resume_session, only: :index # Keep session even when access index
  def index
    if authenticated?
      @user = Current.user
    end
  end

  def dashboard
    org = Current.user.org
    @org_name = org.name
    @connection_count = org.connections.count
    @accounts_count = Account.joins(:connection).where(connections: { org_id: org.id }).count
  end
end
