# frozen_string_literal: true

describe "GET /@:username/records/:record_id", type: :request do
  let(:user) { create(:registered_user) }

  context "ログインしているとき" do
    before do
      login_as(user, scope: :user)
    end

    context "アニメへの記録を参照するとき" do
      let!(:anime) { create(:work) }
      let!(:record) { create(:record, user: user, work: anime) }
      let!(:anime_record) { create(:work_record, user: user, record: record, work: anime, body: "最高") }

      it "記録が表示されること" do
        get "/@#{user.username}/records/#{record.id}"

        expect(response.status).to eq(200)
        expect(response.body).to include(user.profile.name)
        expect(response.body).to include(anime.title)
        expect(response.body).to include("最高")
      end
    end

    context "エピソードへの記録を参照するとき" do
      let!(:anime) { create(:work) }
      let!(:episode) { create(:episode, work: anime) }
      let!(:record) { create(:record, user: user, work: anime) }
      let!(:episode_record) { create(:episode_record, record: record, work: anime, episode: episode, user: user, body: "楽しかった") }

      it "記録が表示されること" do
        get "/@#{user.username}/records/#{record.id}"

        expect(response.status).to eq(200)
        expect(response.body).to include(user.profile.name)
        expect(response.body).to include(anime.title)
        expect(response.body).to include(episode.number)
        expect(response.body).to include("楽しかった")
      end
    end
  end

  context "ログインしていないとき" do
    context "アニメへの記録を参照したとき" do
      let!(:anime) { create(:work) }
      let!(:record) { create(:record, user: user, work: anime) }
      let!(:anime_record) { create(:work_record, user: user, record: record, work: anime, body: "最高") }

      it "記録が表示されること" do
        get "/@#{user.username}/records/#{record.id}"

        expect(response.status).to eq(200)
        expect(response.body).to include(user.profile.name)
        expect(response.body).to include(anime.title)
        expect(response.body).to include("最高")
      end
    end

    context "エピソードへの記録を参照したとき" do
      let!(:anime) { create(:work) }
      let!(:episode) { create(:episode, work: anime) }
      let!(:record) { create(:record, user: user, work: anime) }
      let!(:episode_record) { create(:episode_record, record: record, work: anime, episode: episode, user: user, body: "楽しかった") }

      it "記録が表示されること" do
        get "/@#{user.username}/records/#{record.id}"

        expect(response.status).to eq(200)
        expect(response.body).to include(user.profile.name)
        expect(response.body).to include(anime.title)
        expect(response.body).to include(episode.number)
        expect(response.body).to include("楽しかった")
      end
    end
  end
end
