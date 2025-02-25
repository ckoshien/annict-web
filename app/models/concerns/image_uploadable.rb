# frozen_string_literal: true

module ImageUploadable
  extend ActiveSupport::Concern

  included do
    def uploaded_file(field, size: :master)
      send(field).instance_of?(Hash) ? send(field)[size] : send(field)
    end

    def uploaded_file_path(field)
      id = uploaded_file(field)&.id
      path = id ? "shrine/#{id}" : ""
      path.presence || "no-image.jpg"
    end
  end
end
