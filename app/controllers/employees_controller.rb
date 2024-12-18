class EmployeesController < ApplicationController
  def index
    @org = Current.user.org
    @employees = @org.employees
  end

  def show
    @employee = Employee.find(params[:id])
    @apps = App.joins(connections: :accounts).where(accounts: { email: @employee.email }).distinct
  end
end
