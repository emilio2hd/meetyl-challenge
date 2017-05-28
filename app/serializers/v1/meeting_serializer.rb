module V1
  class MeetingSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers

    attributes :id, :place, :date, :time, :links
    has_one :creator

    def time
      I18n.localize(object.time, format: :very_short)
    end

    def links
      { self: v1_user_meeting_path(object.creator, object.id) }
    end
  end
end