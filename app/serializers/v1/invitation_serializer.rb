module V1
  class InvitationSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers

    attributes :invitee, :meeting_link

    def invitee
      object.invitee.name
    end

    def meeting_link
      v1_meeting_access_url(object.meeting_id, object.access_code)
    end
  end
end