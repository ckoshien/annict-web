# frozen_string_literal: true

module V4::Db
  class ApplicationController < ActionController::Base
    include Pundit

    include V6::PageCategorizable
    include V6::SentryLoadable
    include V6::Loggable
    include V6::Localizable

    layout "v4/db_default"

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    before_action :set_search_params
    around_action :set_locale

    private

    def set_search_params
      @search = SearchService.new(params[:q], scope: :all)
    end

    def user_not_authorized
      flash[:alert] = t "messages._common.you_can_not_access_there"
      redirect_to(request.referrer || db_root_path)
    end
  end
end
