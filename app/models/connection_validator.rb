class ConnectionValidator < ActiveModel::Validator
  def validate(record)
    if record.cred.sendgrid
      record.errors.add :base, record.cred.sendgrid.api_key
    end

    if record.cred.datadog
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

      if response.status == 403
        record.errors.add :base, "Invalid Datadog Credentials, please try another one"
      end
    end
  end
end
