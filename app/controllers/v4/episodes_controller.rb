# frozen_string_literal: true

module V4
  class EpisodesController < V4::ApplicationController
    include V4::AnimeSidebarDisplayable

    def index
      set_page_category PageCategory::EPISODE_LIST

      anime = Work.only_kept.find(params[:anime_id])
      raise ActionController::RoutingError, "Not Found" if anime.no_episodes?

      result = V4::EpisodeListPage::AnimeRepository.new(graphql_client: graphql_client).execute(
        database_id: anime.id,
        pagination: Annict::V4::Pagination.new(before: params[:before], after: params[:after], per: 500)
      )
      @anime_entity = result.anime_entity
      @page_info_entity = result.page_info_entity
      load_vod_channel_entities(anime: anime, anime_entity: @anime_entity)
    end
  end
end
