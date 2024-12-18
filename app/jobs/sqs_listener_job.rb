class SqsListenerJob
  include Shoryuken::Worker

  shoryuken_options queue: Rails.application.credentials.dig(:aws,:response_queue_url), auto_delete: true

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