class GoogleWorkspace < ApplicationRecord
  include Credable

  encrypts :refresh_token

  validates :refresh_token, presence: true
  after_save_commit do
    region = Rails.application.credentials.dig(:aws,:region)
    request_queue_name = Rails.application.credentials.dig(:aws,:request_queue_name)
    message_body = {
      org_id: Current.user.org.id,
      client_id: Rails.application.credentials.dig(:google, :client_id),
      client_secret: Rails.application.credentials.dig(:google, :client_secret),
      refresh_token: self.refresh_token
    }
    request_queue_url = "http://sqs.#{region}.localhost.localstack.cloud:4566/000000000000/#{request_queue_name}"
    sqs_client = Aws::SQS::Client.new(region: region)

    if message_sent?(sqs_client, request_queue_url, message_body)
      puts 'Message sent.'
    else
      puts 'Message not sent.'
    end
  end


  private 
  def message_sent?(sqs_client, queue_url, message_body)
    sqs_client.send_message(
      queue_url: queue_url,
      message_body: message_body.to_json
    )
    true
  rescue StandardError => e
    puts "Error sending message: #{e.message}"
    false
  end
end
