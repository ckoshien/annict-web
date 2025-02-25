# frozen_string_literal: true

module V4
  class CreateAnimeRecordRepository < V4::ApplicationRepository
    class RepositoryResult < Result
      attr_accessor :record_entity
    end

    def execute(form:)
      data = mutate(
        variables: {
          animeId: Canary::AnnictSchema.id_from_object(form.anime, form.anime.class),
          comment: form.comment,
          ratingOverall: form.rating_overall&.upcase.presence,
          ratingAnimation: form.rating_animation&.upcase.presence,
          ratingMusic: form.rating_music&.upcase.presence,
          ratingStory: form.rating_story&.upcase.presence,
          ratingCharacter: form.rating_character&.upcase.presence,
          shareToTwitter: form.share_to_twitter
        }
      )
      result = validate(data)

      if result.success?
        record_node = data.dig("data", "createAnimeRecord", "record")
        result.record_entity = V4::RecordEntity.from_node(record_node)
      end

      result
    end

    private

    def result_class
      RepositoryResult
    end
  end
end
