# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
#  status     :string           default("draft")
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

# RSpec.describe Article do
#   context "名前があるとき" do
#     it "記事が作られる" do
#       build(:article)
#       expect(article.valid?).to be true
#     end
#   end
# end

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

RSpec.describe Article do
  context "記事を保存した時" do
    let(:article) { build(:article) }

    it "下書き記事を保存できる" do
      expect(article).to be_valid
      # expect(article.status).to eq "draft"
    end
  end

  context "下書きとして記事を保存した時" do
    let(:article) { build(:article, :draft) }

    it "下書き記事を保存できる" do
      expect(article).to be_valid
      # expect(article.status).to eq "draft"
    end
  end

  context "公開で記事を保存した時" do
    let(:article) { build(:article, :published) }

    it "公開記事を保存できる" do
      expect(article).to be_valid
      # expect(article.status).to eq "published"
    end
  end
end
