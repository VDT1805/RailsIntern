class SqsListenerJob
  include Shoryuken::Worker

  shoryuken_options queue: "http://localhost:4566/000000000000/response-queue", auto_delete: true

  def perform(sqs_msg, body)
    employees_attributes = JSON.parse(body).map do |emp|
      {
        org_id: emp['org_id'], 
        email: emp['email'],
        name: emp['name']
      }
    end
    Employee.upsert_all(employees_attributes)
  end
end