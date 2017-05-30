module V1
  class MeetingsController < ApplicationController
    before_action :set_meeting, only: [:update, :invite]

    def index
      meetings = Meeting.of_user(params[:user_id])

      render json: meetings, each_serializer: V1::MeetingSerializer
    end

    def show
      meeting = Meeting.of_user(params[:user_id]).take!
      render json: meeting, serializer: V1::MeetingSerializer
    end

    def create
      meeting = Meeting.new(meeting_params.merge(creator_id: params[:user_id]))

      if meeting.save
        render json: meeting, status: :created, serializer: V1::MeetingSerializer
      else
        render json: meeting, status: :bad_request, adapter: :attributes, serializer: V1::ErrorSerializer
      end
    end

    def update
      if @meeting.update(meeting_params)
        render json: @meeting, serializer: V1::MeetingSerializer
      else
        render json: @meeting, status: :bad_request, adapter: :attributes, serializer: V1::ErrorSerializer
      end
    end

    def invite
      invitation = Invitation.new(invitation_params)
      invitation.meeting = @meeting

      if invitation.save
        render json: invitation, status: :created, serializer: V1::UserInvitationSerializer
      else
        render json: invitation, status: :bad_request, adapter: :attributes, serializer: V1::ErrorSerializer
      end
    end

    def access
      invitation = Invitation.joins(:meeting)
                             .find_by!(meeting_id: params[:id], access_code: params[:access_code])

      unless invitation.accepted?
        return render json: { error: I18n.translate('meeting.invitation_not_accepted') }, status: :bad_request
      end

      render json: { message: I18n.translate('meeting.welcome', name: invitation.invitee.name) }
    end

    private

    def set_meeting
      @meeting = Meeting.find_by(creator_id: params[:user_id], id: params[:id])
    end

    def invitation_params
      params.require(:invitation).permit(:invitee_id)
    end

    def meeting_params
      params.require(:meeting).permit(:place, :date, :time, :user_id)
    end
  end
end