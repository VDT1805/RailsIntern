require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/apps", type: :request do
  
  # This should return the minimal set of attributes required to create a valid
  # App. As you add validations to App, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    # skip("Add a hash of attributes valid for your model")
    {
        name: "Datadog Test"
    }
  }

  # let(:invalid_attributes) {
  #   skip("Add a hash of attributes invalid for your model")
  # }

  describe "GET /index" do
    it "renders a successful response" do
      App.create! valid_attributes
      get apps_url
      expect(response).to be_successful
    end

    it "returns app with Datadog Test name" do
      App.create! valid_attributes
      get apps_url
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Datadog Test")
    end
  end

end
