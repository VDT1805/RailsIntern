class DatadogValidator < ActiveModel::Validator
  def validate(record)
      if record.api_key.present? && record.application_key.present? && record.subdomain.present?
            conn = Faraday.new(
              url: "https://api.datadoghq.com",
            )
            response = conn.get do |req|
              req.url "/api/v1/users"
              req.headers["Content-Type"] = "application/json"
              req.headers["DD_API_KEY"] = "#{record.api_key}"
              req.headers["DD_APPLICATION_KEY"] = "#{record.application_key}"
              req.headers["DD_SITE"] = "#{record.subdomain}"
            end

            if response.status != 200
              record.errors.add :base, "Invalid credentials, please try another one"
            end
      end
  end
end
