class DatadogValidator < ActiveModel::Validator
  def validate(record)
      if record.cred.datadog.api_key.present? && record.cred.datadog.application_key.present? && record.cred.datadog.subdomain.present?
            conn = Faraday.new(
              url: "https://api.datadoghq.com",
            )
            response = conn.get do |req|
              req.url "/api/v1/validate"
              req.headers["Content-Type"] = "application/json"
              req.headers["DD_API_KEY"] = "#{record.cred.datadog.api_key}"
              req.headers["DD_APP_KEY"] = "#{record.cred.datadog.application_key}"
              req.headers["DD_SITE"] = "#{record.cred.datadog.subdomain}"
            end
      
            if response.status != 200
              record.errors.add :base, "Invalid credentials, please try another one"
          end
      end
  end
end