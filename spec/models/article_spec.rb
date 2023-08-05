require "rails_helper"

RSpec.describe Article do
  context "名前があるとき" do
    it "記事が作られる" do
      build(:article)
      expect(user.valid?).to be true
    end
  end
end
