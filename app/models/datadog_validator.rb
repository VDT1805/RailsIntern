class DatadogValidator < ActiveModel::Validator
  def validate(record)
      if record.api_key.present? && record.application_key.present? && record.subdomain.present?
        begin
          DatadogServices::ListUsers.new.call(
            api_key: record.api_key,
            application_key: record.application_key,
            subdomain: record.subdomain,
            pagesize: 1,
            page: 0
          )
        rescue StandardError
            record.errors.add :base, "Invalid credentials, please try another one"
        end
      end
  end
end
