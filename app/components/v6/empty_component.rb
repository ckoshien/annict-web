# frozen_string_literal: true

module V6
  class EmptyComponent < V6::ApplicationComponent
    def initialize(view_context, text:)
      super view_context
      @text = text
    end

    def render
      build_html do |h|
        h.tag :div, class: "c-empty p-4 text-center" do
          h.tag :i, class: "far fa-meh display-4"

          h.tag :div, class: "h2 mt-3" do
            h.text @text
          end

          if block_given?
            h.tag :div do
              h.html yield
            end
          end
        end
      end
    end
  end
end
