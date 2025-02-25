# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include BatchDestroyable

  self.abstract_class = true

  LOCALES = %i[en ja other].freeze

  def self.find_by_graphql_id(graphql_id)
    type_name, item_id = GraphQL::Schema::UniqueWithinType.decode(graphql_id)
    type_name = case type_name
    when "Anime" then "Work"
    else
      type_name
    end

    raise Annict::Errors::ModelMismatchError if Object.const_get(type_name) != self

    find item_id
  end

  def root_resource?
    false
  end

  def likeable?
    false
  end

  def decorate
    ActiveDecorator::Decorator.instance.decorate(self)
  end

  def method_missing(method_name, *arguments, &block)
    return super if method_name.blank?
    return super unless method_name.to_s.start_with?("local_")

    _local_property(method_name.to_s.sub("local_", ""), *arguments)
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.start_with?("local_") || super
  end

  private

  def _local_property(property_name, fallback: true)
    property_ja = send(property_name.to_sym)
    property_en = send("#{property_name}_en".to_sym)

    return property_ja if I18n.locale == :ja
    return property_en if property_en.present?

    property_ja if fallback
  end
end
