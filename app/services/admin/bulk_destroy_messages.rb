# frozen_string_literal: true

class Admin::BulkDestroyMessages
  class InvalidSelection < StandardError; end

  def initialize(resource, context)
    @resource = resource
    @context = context
  end

  def call(ids)
    raise InvalidSelection unless @resource.messages? && ids.is_a?(Array) && ids.size.between?(1, 100)
    raise InvalidSelection unless ids.all? { |id| id.is_a?(String) && id.match?(/\A[1-9]\d*\z/) }
    raise InvalidSelection unless ids.uniq.size == ids.size

    @resource.model.transaction do
      records = @resource.scope.where(id: ids).order(id: :desc).lock.to_a
      visible_ids = @resource.scope.order(id: :desc).page(@context["page"]).per(@context.fetch("per_page", 25)).pluck(:id)
      raise InvalidSelection unless records.size == ids.size && (records.map(&:id) - visible_ids).empty?

      records.each(&:destroy!)
      records.size
    end
  end
end
