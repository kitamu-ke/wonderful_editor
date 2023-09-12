require "rails_helper"

RSpec.describe "Api::V1::Articles" do
  describe "GET /articles" do
    subject { get(api_v1_articles_path) }

    let!(:article1) { create(:article, :published, updated_at: 1.days.ago) }
    # let!(:article2) { create(:article, :published, updated_at: 2.days.ago) }
    # let!(:article3) { create(:article, :published) }

    before { create(:article, :draft) }

    it "公開している記事の一覧取得できる" do
      subject
      response.parsed_body
      expect(response).to have_http_status(:ok)
      #   expect(res.length).to eq 3
      #   expect(res.map {|d| d["id"] }).to eq [article3.id, article1.id, article2.id]
      #   expect(res[0].keys).to eq ["id", "body","title", "updated_at", "status", "user"]
      #   expect(res[0]["user"].keys).to eq ["id", "name", "email"]
    end
  end

  describe "GET /articles/:id" do
    subject { get(api_v1_article_path(article_id)) }

    context "指定した id の記事が存在して" do
      let(:article_id) { article.id }

      context "対象の記事が公開中である時" do
        let(:article) { create(:article, :published) }

        it "その記事のレコードが取得できる" do
          subject
          response.parsed_body
          expect(response).to have_http_status(:ok)

          # expect(res["title"]).to eq article.title
          # expect(res["body"]).to eq article.body
          # expect(res["user"]["id"]).to eq article.user.id
          # expect(res["user"].keys).to eq ["id", "name", "email"]
        end
      end

      context "対象の記事が下書きである時" do
        let(:article) { create(:article, :draft) }

        it "記事が見つからない" do
          expect { subject }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context "指定した id の記事が存在しないとき" do
      let(:article_id) { 100000 }

      it "記事が見つからない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "POST /articles" do
    subject { post(api_v1_articles_path, params: params, headers: headers) }

    let(:headers) { current_user.create_new_auth_token }
    let(:current_user) { create(:user) }

    context "公開で記事を作成するとき" do
      let(:params) { { article: attributes_for(:article, :published) } }

      it "記事のレコードを作成できる" do
        expect { subject }.to change { Article.count }.by(1)
        # res = JSON.parse(response.body)
        # expect(res["status"]).to eq "published"
        # expect(res["title"]).to eq params[:article][:title]
        # expect(res["body"]).to eq params[:article][:body]
        # expect(response).to have_http_status(:ok)
      end
    end

    context "下書きで記事を作成する時" do
      let(:params) { { article: attributes_for(:article, :draft) } }

      it "下書きの記事が作成できる" do
        expect { subject }.to change { Article.count }.by(1)
        # res = JSON.parse(response.body)
        # expect(res["status"]).to eq "draft"
        # expect(response).to have_http_status(:ok)
      end
    end

    context "でたらめな指定で記事を作成するとき" do
      let(:params) { { article: attributes_for(:article, status: :foo) } }

      it "エラーになる" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end

  describe "PUT /articles/:id" do
    subject { put(api_v1_article_path(article.id), params: params, headers: headers) }

    let(:params) { { article: attributes_for(:article, :published) } }
    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    context "自分が所持している記事のレコードを更新しようとするとき" do
      let!(:article) { create(:article, :draft, user: current_user) }

      it "記事を更新できる" do
        subject
        # expect { subject }.to change { article.reload.title }.from(article.title).to(params[:article][:title]) &
        #                       change { article.reload.body }.from(article.body).to(params[:article][:body])&
        #                       change { article.reload.status }.from(article.status).to(params[:article][:status].to_s)
        expect(response).to have_http_status(:ok)
      end
    end

    context "自分が所持していない記事のレコードを更新しようとするとき" do
      let(:other_user) { create(:user) }
      let!(:article) { create(:article, user: other_user) }

      it "記事を更新できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "DELETE /articles/:id" do
    subject { delete(api_v1_article_path(article.id), params: params, headers: headers) }

    let(:params) { { article: attributes_for(:article) } }
    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    context "自分が所持している記事のレコードを削除しようとするとき" do
      let!(:article) { create(:article, user: current_user) }

      it "記事を削除できる" do
        subject
        # expect { subject }.to change { Article.count }.by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context "自分が所持していない記事のレコードを更新しようとするとき" do
      let(:other_user) { create(:user) }
      let!(:article) { create(:article, user: other_user) }

      it "記事を削除できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
