# frozen_string_literal: true

class Admin::Reorder
  class InvalidMove < StandardError; end

  def initialize(resource)
    @resource = resource
  end

  def call(id:, movement:, position: nil, target_id: nil)
    raise InvalidMove, "此模块不支持排序" unless @resource.ordered?

    @resource.model.transaction do
      # Lock in ID order so simultaneous moves cannot overwrite one another.
      # Include unpublished records and records outside the current filter/page.
      rows = @resource.scope.reorder(:id).lock.pluck(:id, :position)
      rows.sort_by! { |record_id, value| [value.nil? ? 1 : 0, value || 0, record_id] }
      ids = rows.map(&:first)
      source = ids.index(positive_integer(id))
      raise ActiveRecord::RecordNotFound unless source

      destination = case movement
      when "top" then 0
      when "bottom" then ids.length - 1
      when "up" then [source - 1, 0].max
      when "down" then [source + 1, ids.length - 1].min
      when "position"
        rank = positive_integer(position)
        raise InvalidMove, "请输入 1 到 #{ids.length} 之间的排序序号" unless rank && rank <= ids.length
        rank - 1
      when "before", "after"
        target = positive_integer(target_id)
        raise InvalidMove, "请输入此模块中其他记录的 ID" unless target && target != ids[source] && ids.include?(target)
        remaining = ids.reject { |record_id| record_id == ids[source] }
        remaining.index(target) + ((movement == "after") ? 1 : 0)
      else
        raise InvalidMove, "请选择有效的移动方式"
      end

      ids.insert(destination, ids.delete_at(source))
      positions = rows.to_h
      # Repair legacy duplicate/gapped positions while preserving relative order.
      # Only ordering changes: do not trigger uploads, translations or timestamps.
      ids.each_with_index do |record_id, index|
        @resource.scope.where(id: record_id).update_all(position: index) unless positions[record_id] == index
      end
    end
  end

  private

  def positive_integer(value)
    text = value.to_s
    text.to_i if text.match?(/\A[1-9]\d*\z/)
  end
end
