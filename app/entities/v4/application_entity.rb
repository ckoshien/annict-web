# frozen_string_literal: true

module V4
  class ApplicationEntity < Dry::Struct
    schema schema.strict

    module Types
      include Dry.Types(default: :strict)

      ActivityResourceKinds = Types::String.enum("record", "status")
      AnimeMediaKinds = Types::String.enum("tv", "ova", "movie", "web", "other")
      SeasonKinds = Types::String.enum("winter", "spring", "summer", "autumn")
      StatusKinds = Types::String.enum("plan_to_watch", "watching", "completed", "on_hold", "dropped", "no_status")
      RecordRatingState = Types::String.enum("great", "good", "average", "bad")
    end

    class << self
      private

      def local_attributes(*names)
        names.each do |name|
          define_method "local_#{name}" do
            value = send(name.to_sym)

            return send("#{name}_en".to_sym).presence || value if I18n.locale == :en

            value
          end
        end
      end
    end
  end
end
