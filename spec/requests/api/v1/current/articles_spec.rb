require "rails_helper"

RSpec.describe "Api::V1::Currents::Articles" do
  let(:headers) { current_user.create_new_auth_token }
  let(:current_user) { create(:user) }

  describe "GET /currents/articles" do
    subject { get(api_v1_current_articles_path, headers: headers) }

    let!(:article1) { create(:article, :published, user: current_user) }
    # let!(:article2) { create(:article, :published) }

    before { create(:article, :draft, user: current_user) }

    it "ログインユーザーの記事を取得できる" do
      subject
      response.parsed_body
      expect(response).to have_http_status(:ok)
      # expect(res.length).to eq 1
      # expect(res.pluck("id")).to eq [article1.id]
      # expect(res[0].keys).to eq ["id", "body", "title", "updated_at", "status", "user"]
      # expect(res[0]["user"].keys).to eq ["id", "name", "email"]
    end
  end
end
