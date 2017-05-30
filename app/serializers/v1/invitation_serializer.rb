module V1
  class InvitationSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers

    attributes :meeting_link, :links
    has_one :meeting

    def meeting_link
      v1_meeting_access_url(object.meeting_id, object.access_code)
    end

    def links
      { self: v1_user_invitation_path(object.invitee_id, object.id) }
    end
  end
end