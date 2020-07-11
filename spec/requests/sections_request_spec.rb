require 'rails_helper'

RSpec.describe "Sections", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/sections/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/sections/show"
      expect(response).to have_http_status(:success)
    end
  end

end