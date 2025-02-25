# frozen_string_literal: true

module V6::Activities
  class RecordActivityComponent < V6::ApplicationComponent
    def initialize(view_context, activity_group:)
      super view_context
      @activity_group = activity_group
      @user = activity_group.user.decorate
    end

    def render
      build_html do |h|
        h.tag :div, class: "card" do
          h.tag :div, class: "card-body" do
            h.tag :div, class: "mb-3" do
              h.tag :a, href: view_context.profile_path(@user.username) do
                h.html V6::Pictures::AvatarPictureComponent.new(view_context,
                  user: @user,
                  width: 32,
                  mb_width: 32).render
              end

              h.tag :span, class: "c-timeline__user-name ms-3" do
                h.tag :a, href: view_context.profile_path(@user.username), class: "text-body fw-bold" do
                  h.text @user.name
                end
              end

              h.tag :small, class: "ms-1" do
                h.text t("messages._components.activities.episode_record.created")
              end

              h.html V6::RelativeTimeComponent.new(
                view_context,
                time: @activity_group.created_at.iso8601,
                class_name: "ms-1 small text-muted"
              ).render
            end

            if @activity_group.single?
              record = @activity_group.first_item

              if record.episode_record?
                h.html V6::Contents::EpisodeRecordContentComponent.new(view_context, record: record).render
              else
                h.html V6::Contents::AnimeRecordContentComponent.new(view_context, record: record).render
              end
            else
              h.tag :turbo_frame, id: view_context.dom_id(@activity_group) do
                record = @activity_group.first_item

                if record.episode_record?
                  h.html V6::Contents::EpisodeRecordContentComponent.new(view_context, record: record).render
                else
                  h.html V6::Contents::AnimeRecordContentComponent.new(view_context, record: record).render
                end

                if @activity_group.activities_count > 1
                  h.tag :div, class: "text-center" do
                    h.tag :a, {
                      class: "py-1 small",
                      href: view_context.fragment_activity_item_list_path(@activity_group, page_category: page_category)
                    } do
                      h.tag :i, class: "fal fa-chevron-double-down me-1"
                      h.text t("messages._components.activities.episode_record.more", n: @activity_group.activities_count - 1)
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
