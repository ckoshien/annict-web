# frozen_string_literal: true

module V6
  class SpoilerGuardComponent < V6::ApplicationComponent
    def initialize(view_context, record:)
      super view_context
      @record = record
    end

    def render
      build_html do |h|
        h.tag :div,
          class: "c-spoiler-guard",
          data_controller: "spoiler-guard2",
          data_action: "click->spoiler-guard2#hide",
          data_spoiler_guard2_init_is_spoiler_value: init_is_spoiler do
            yield h
          end
      end
    end

    def init_is_spoiler
      return false unless current_user

      current_user.hide_record_body? && @record.is_spoiler
    end
  end
end
