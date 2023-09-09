# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  allow_password_change  :boolean          default(FALSE), not null
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  image                  :string
#  name                   :string
#  provider               :string           default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  tokens                 :json
#  uid                    :string           default(""), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#
require "rails_helper"

RSpec.describe User do
  context "名前があるとき" do
    it "ユーザーが作られる" do
      user = build(:user)
      expect(user.valid?).to be true
    end
  end

  context "名前がないとき" do
    it "ユーザー作成に失敗する" do
      user = User.new(email: "foo@example.com", password: "foo")
      expect(user.valid?).to be false
    end
  end

  context "パスワードが５文字以下のとき" do
    it "ユーザー作成に失敗する" do
      user = User.new(name: "foo", email: "foo@example.com", password: "foo")
      expect(user.valid?).to be false
    end
  end

  context "メールの形をしていないとき" do
    it "ユーザー作成に失敗する" do
      user = User.new(name: "foo", email: "@example.com", password: "foo")
      expect(user.valid?).to be false
    end
  end
end
