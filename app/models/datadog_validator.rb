class DatadogValidator < ActiveModel::Validator
  def validate(record)
      if record.api_key.present? && record.application_key.present? && record.subdomain.present?
        begin
          DatadogServices::ListUsers.new(record).call(pagesize: 1,page: 0)
        rescue StandardError
            record.errors.add :base, "Invalid credentials, please try another one"
        end
      end
  end
end
