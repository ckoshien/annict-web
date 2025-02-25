# frozen_string_literal: true

module V4::AnimeSidebarDisplayable
  def load_vod_channel_entities(anime:, anime_entity:)
    result = Rails.cache.fetch(anime_detail_vod_channels_cache_key(anime), expires_in: 3.hours) do
      V4::AnimePage::VodChannelsRepository.new(graphql_client: graphql_client).execute(anime_entity: anime_entity)
    end

    @vod_channel_entities = result.vod_channel_entities
    @existing_vod_channel_entities = @vod_channel_entities.select { |vod_channel| vod_channel.programs.first.present? }
  end

  private

  def anime_detail_vod_channels_cache_key(anime)
    [
      "anime-detail",
      "vod-channels",
      anime.id,
      anime.updated_at.rfc3339
    ].freeze
  end
end
