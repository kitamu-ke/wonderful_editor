require "rails_helper"

RSpec.describe "Articles" do
  describe "GET /articles" do
    subject { get(api_v1_articles_path) }

    before { create_list(:article, 3) }
    # before {3.times{create(:article)}}
    # let!(:article1) { create(:article, updated_at: 1.days.ago) }
    # let!(:article2) { create(:article, updated_at: 2.days.ago) }
    # let!(:article3) { create(:article) }

    it "記事の一覧が取得できる" do
      subject
      response.parsed_body

      expect(response).to have_http_status(:ok)
      # expect(res.length).to eq 3
      # expect(res.map {|d| d["id"] }).to eq [article3.id, article1.id, article2.id]
      # expect(res[0].keys).to eq ["id", "body", "title", "updated_at", "user"]
      # expect(res[0]["user"].keys).to eq ["id", "name", "email"]
    end
  end
end