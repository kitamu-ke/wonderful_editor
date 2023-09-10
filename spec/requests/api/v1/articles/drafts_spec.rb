require "rails_helper"

RSpec.describe "Api::V1::Articles" do
  let(:headers) { current_user.create_new_auth_token }
  let(:current_user) { create(:user) }

  describe "GET /articles /drafts" do
    subject { get(api_v1_articles_drafts_path, headers: headers) }

    let!(:article1) { create(:article, :draft, user: current_user) }
    # let!(:article2) { create(:article, :draft) }

    it "ログインユーザーの下書きが取得できる" do
      subject
      response.parsed_body
      expect(response).to have_http_status(:ok)
      #   expect(res.length).to eq 1
      #   expect(res.pluck("id")).to eq [article1.id]
      #   expect(res[0].keys).to eq ["id", "body", "title", "updated_at", "status", "user"]
      #   expect(res[0]["user"].keys).to eq ["id", "name", "email"]
    end
  end

  describe "GET /articles/drafts/:id" do
    subject { get(api_v1_articles_draft_path(article_id), headers: headers) }

    context "指定した id の記事が存在して" do
      let(:article_id) { article.id }

      context "ログインユーザーの下書きである時" do
        let(:article) { create(:article, :draft, user: current_user) }

        it "下書きの記事が取得できる" do
          subject
          response.parsed_body
          expect(response).to have_http_status(:ok)
          # expect(res["title"]).to eq article.title
          # expect(res["body"]).to eq article.body
          # expect(res["user"]["id"]).to eq article.user.id
          # expect(res["user"].keys).to eq ["id", "name", "email"]
        end
      end

      context "ログインユーザー以外の下書きである時" do
        let(:article) { create(:article, :draft) }

        it "記事が見つからない" do
          expect { subject }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end
end
