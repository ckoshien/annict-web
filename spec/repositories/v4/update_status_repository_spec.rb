# frozen_string_literal: true

describe V4::UpdateStatusRepository, type: :repository do
  include V4::GraphqlRunnable

  context "when user does not add work to library entry" do
    let(:user) { create :registered_user }
    let(:work) { create :work }

    it "creates status" do
      expect(Status.count).to eq 0
      expect(ActivityGroup.count).to eq 0
      expect(Activity.count).to eq 0
      expect(LibraryEntry.count).to eq 0

      V4::UpdateStatusRepository.new(
        graphql_client: graphql_client(viewer: user)
      ).execute(anime: work, kind: :watching)

      expect(Status.count).to eq 1
      expect(ActivityGroup.count).to eq 1
      expect(Activity.count).to eq 1
      expect(LibraryEntry.count).to eq 1

      status = user.statuses.first
      activity_group = user.activity_groups.first
      activity = user.activities.first
      library_entry = user.library_entries.first

      expect(status.kind).to eq "watching"
      expect(status.work_id).to eq work.id

      expect(activity_group.itemable_type).to eq "Status"
      expect(activity_group.single).to eq false

      expect(activity.itemable).to eq status
      expect(activity.activity_group_id).to eq activity_group.id

      expect(library_entry.status_id).to eq status.id
      expect(library_entry.work_id).to eq work.id
    end
  end

  context "when user has added work to library entry" do
    let(:user) { create :registered_user }
    let(:episode) { create(:episode) }
    let(:work) { episode.work }
    let(:status) { create(:status, user: user, work: work, kind: :wanna_watch) }
    let!(:activity_group) { create(:activity_group, user: user, itemable_type: "Status", single: false) }
    let!(:activity) { create(:activity, user: user, itemable: status, activity_group: activity_group) }
    let!(:library_entry) { create(:library_entry, user: user, work: work, status: status) }

    it "creates status" do
      expect(Status.count).to eq 1
      expect(ActivityGroup.count).to eq 1
      expect(Activity.count).to eq 1
      expect(LibraryEntry.count).to eq 1
      expect(library_entry.status.kind).to eq "wanna_watch"

      V4::UpdateStatusRepository.new(
        graphql_client: graphql_client(viewer: user)
      ).execute(anime: work, kind: :watching)

      expect(Status.count).to eq 2
      expect(ActivityGroup.count).to eq 1
      expect(Activity.count).to eq 2
      expect(LibraryEntry.count).to eq 1

      status = user.statuses.last
      activity_group = user.activity_groups.first
      activity1 = user.activities.first
      activity2 = user.activities.last
      library_entry = user.library_entries.first

      expect(status.kind).to eq "watching"
      expect(status.work_id).to eq work.id

      expect(activity_group.itemable_type).to eq "Status"
      expect(activity_group.single).to eq false

      expect(activity1.activity_group_id).to eq activity_group.id

      expect(activity2.itemable).to eq status
      expect(activity2.activity_group_id).to eq activity_group.id

      expect(library_entry.status_id).to eq status.id
      expect(library_entry.work_id).to eq work.id
    end
  end

  context "when user has added work to library entry and set no_select" do
    let(:user) { create :registered_user }
    let(:work) { create :work }
    let(:status) { create(:status, user: user, work: work, kind: :wanna_watch) }
    let!(:activity_group) { create(:activity_group, user: user, itemable_type: "Status", single: false) }
    let!(:activity) { create(:activity, user: user, itemable: status, activity_group: activity_group) }
    let!(:library_entry) { create(:library_entry, user: user, work: work, status: status) }

    it "resets status in library entry" do
      expect(Status.count).to eq 1
      expect(ActivityGroup.count).to eq 1
      expect(Activity.count).to eq 1
      expect(LibraryEntry.count).to eq 1
      expect(library_entry.status.kind).to eq "wanna_watch"

      V4::UpdateStatusRepository.new(
        graphql_client: graphql_client(viewer: user)
      ).execute(anime: work, kind: :no_select)

      expect(Status.count).to eq 1
      expect(ActivityGroup.count).to eq 1
      expect(Activity.count).to eq 1
      expect(LibraryEntry.count).to eq 1

      library_entry = user.library_entries.first

      expect(library_entry.status).to be_nil
      expect(library_entry.work_id).to eq work.id
    end
  end
end
