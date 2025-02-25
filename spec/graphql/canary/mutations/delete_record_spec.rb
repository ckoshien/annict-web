# frozen_string_literal: true

describe Canary::Mutations::DeleteRecord do
  let!(:user) { create :registered_user }
  let!(:anime) { create :work }
  let!(:episode) { create :episode, work: anime }
  let!(:record) { create :record, user: user, work: anime }
  let!(:episode_record) { create(:episode_record, user: user, record: record, work: anime, episode: episode) }
  let!(:activity_group) { create(:activity_group, user: user, itemable_type: "EpisodeRecord") }
  let!(:activity) { create(:activity, user: user, activity_group: activity_group, itemable: episode_record) }
  let!(:library_entry) { create(:library_entry, user: user, work: anime, watched_episode_ids: [episode.id]) }
  let!(:token) { create(:oauth_access_token) }
  let!(:context) { {viewer: user, doorkeeper_token: token, writable: true} }
  let!(:record_id) { Canary::AnnictSchema.id_from_object(record, record.class) }
  let!(:query) do
    <<~GRAPHQL
      mutation($recordId: ID!) {
        deleteRecord(input: { recordId: $recordId }) {
          user {
            username
          }
        }
      }
    GRAPHQL
  end

  context "正常系" do
    let(:variables) { {recordId: record_id} }

    it "記録が削除されること" do
      expect(ActivityGroup.count).to eq 1
      expect(Activity.count).to eq 1
      expect(Record.count).to eq 1
      expect(EpisodeRecord.count).to eq 1
      expect(LibraryEntry.count).to eq 1
      expect(library_entry.watched_episode_ids).to eq [episode.id]

      Canary::AnnictSchema.execute(query, variables: variables, context: context)

      expect(ActivityGroup.count).to eq 0
      expect(Activity.count).to eq 0
      expect(Record.count).to eq 0
      expect(EpisodeRecord.count).to eq 0
      expect(LibraryEntry.count).to eq 1
      expect(library_entry.reload.watched_episode_ids).to eq []
    end
  end
end
