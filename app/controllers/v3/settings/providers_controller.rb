# frozen_string_literal: true

module V3::Settings
  class ProvidersController < V3::ApplicationController
    before_action :authenticate_user!

    def destroy
      provider = current_user.providers.find(params[:id])

      ActiveRecord::Base.transaction do
        case provider.name
        when "twitter"
          provider.user.setting.update_column(:share_record_to_twitter, false)
        end

        provider.destroy
      end

      flash[:notice] = t("messages.providers.removed")
      redirect_back fallback_location: settings_provider_list_path
    end
  end
end
