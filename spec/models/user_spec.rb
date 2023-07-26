require 'rails_helper'

RSpec.describe User, type: :model do
  context "名前があるとき" do
    it "ユーザーが作られる" do
      user = FactoryBot.build(:user)
      binding.pry
      expect(user.valid?).to eq true
    end
  end

  context "名前がないとき" do
    it "ユーザー作成に失敗する" do
      user = User.new(email:"foo@example.com", password:"foo")
      expect(user.valid?).to eq false
    end
  end

  context "パスワードが５文字以下のとき" do
    it "ユーザー作成に失敗する" do
      user = User.new(name:"foo", email:"foo@example.com", password:"foo")
      expect(user.valid?).to eq false
    end
  end

  context "メールの形をしていないとき" do
    it "ユーザー作成に失敗する" do
      user = User.new(name:"foo", email:"@example.com", password:"foo")
      expect(user.valid?).to eq false
    end
  end
end
