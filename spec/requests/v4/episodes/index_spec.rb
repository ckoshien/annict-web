# frozen_string_literal: true

describe "GET /works/:anime_id/episodes", type: :request do
  context "ログインしていないとき" do
    let!(:anime) { create(:work) }
    let!(:episode) { create(:episode, work: anime) }

    it "エピソード一覧ページが表示されること" do
      get "/works/#{anime.id}/episodes"

      expect(response.status).to eq(200)
      expect(response.body).to include(episode.title)
    end
  end

  context "ログインしているとき" do
    let!(:user) { create(:registered_user) }
    let!(:anime) { create(:work) }
    let!(:episode) { create(:episode, work: anime) }

    before do
      login_as(user, scope: :user)
    end

    it "エピソード一覧ページが表示されること" do
      get "/works/#{anime.id}/episodes"

      expect(response.status).to eq(200)
      expect(response.body).to include(anime.title)
    end
  end
end
