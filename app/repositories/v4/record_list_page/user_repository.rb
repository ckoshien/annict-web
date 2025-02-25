# frozen_string_literal: true

module V4::RecordListPage
  class UserRepository < V4::ApplicationRepository
    class RepositoryResult < Result
      attr_accessor :user_entity
    end

    def execute(username:)
      data = query(variables: {username: username})
      user_node = data.to_h.dig("data", "user")

      result.user_entity = V4::UserEntity.from_node(user_node)

      result
    end

    private

    def result_class
      RepositoryResult
    end
  end
end
