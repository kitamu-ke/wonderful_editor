require "rails_helper"

RSpec.describe "V1::Auth::Registrations" do
  describe "POST /v1/auth" do
    subject { post(api_v1_user_registration_path, params: params) }

    context "適切なパラメーターを送信したとき" do
      let(:params) { attributes_for(:user) }

      it "ユーザーのレコードを作成できる" do
        expect { subject }.to change { User.count }.by(1)
        # res = response.parsed_body
        # expect(response).to have_http_status(:ok)
        # expect(res["data"]["email"]).to eq(User.last.email)
      end

      it "header 情報を取得することができる" do
        subject
        header = response.header
        expect(header["access-token"]).to be_present
        # expect(header["client"]).to be_present
        # expect(header["expiry"]).to be_present
        # expect(header["uid"]).to be_present
        # expect(header["token-type"]).to be_present
      end
    end

    # ここから下は異常系テスト
    context "名前がnil" do
      let(:params) { attributes_for(:user, name: nil) }

      it "エラーが起きる" do
        expect { subject }.not_to change { User.count }
        # res = response.parsed_body
        # expect(response).to have_http_status(:unprocessable_entity)
        # expect(res["errors"]["name"]).to include "can't be blank"
      end
    end

    context "メールがnil" do
      let(:params) { attributes_for(:user, email: nil) }

      it "エラーが起きる" do
        expect { subject }.not_to change { User.count }
        # res = response.parsed_body
        # expect(response).to have_http_status(:unprocessable_entity)
        # expect(res["errors"]["email"]).to include "can't be blank"
      end
    end

    context "パスワードがnil" do
      let(:params) { attributes_for(:user, password: nil) }

      it "エラーが起きる" do
        expect { subject }.not_to change { User.count }
        # res = response.parsed_body
        # expect(response).to have_http_status(:unprocessable_entity)
        # expect(res["errors"]["password"]).to include "can't be blank"
      end
    end
  end

  describe "POST /v1/auth/sign_in" do
    subject { post(api_v1_user_session_path(params)) }

    context "適切なパラメーターを送信したとき" do
      before { create(:user, email: "test@expemle.com", password: "password") }

      let(:params) { { email: "test@expemle.com", password: "password" } }

      it "ログインできる" do
        subject
        expect(response).to have_http_status(:ok)
      end
    end

    context "間違ったパラメーターを送信したとき" do
      before { create(:user, email: "test@expemle.com", password: "password") }

      let(:params) { { email: "test@expemle.com", password: "pass" } }

      it "ログインできない" do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /v1/auth/sign_out" do
    subject { delete(destroy_api_v1_user_session_path, headers: headers) }

    context "" do
      let(:user) { create(:user) }
      let(:headers) { user.create_new_auth_token }

      it "ログアウトできる" do
        subject
        expect(response).to have_http_status(:ok)
      end
    end

    context "間違ったパラメーターを送信したとき" do
      let(:user) { create(:user) }
      let(:headers) { nil }

      it "ログインできない" do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
