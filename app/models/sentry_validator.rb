class SentryValidator < ActiveModel::Validator
  def validate(record)
      if record.api_token.present? && record.organization_id.present?
            conn = Faraday.new(
              url: "https://us.sentry.io",
            )
            response = conn.get do |req|
              req.url "/api/0/organizations/#{record.organization_id}/members/"
              req.headers["Content-Type"] = "application/json"
              req.headers["Authorization"] = "Bearer #{record.api_token}"
            end
            if response.status != 200
              record.errors.add :base, "Invalid credentials, please try another one"
            end
      end
  end
end
