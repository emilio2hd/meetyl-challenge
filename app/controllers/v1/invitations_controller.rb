require 'invitation/action_locator'

module V1
  class InvitationsController < ApplicationController
    include V1::InvitationsModule

    before_action :set_invitation, only: [:show, :check_status, :execute]

    def index
      invitations = Invitation.includes(:meeting).where(invitee_id: params[:user_id])
      render json: invitations, each_serializer: V1::InvitationSerializer
    end

    def show
      render json: @invitation, serializer: V1::InvitationSerializer
    end

    def check_status
      render json: @invitation, serializer: V1::InvitationStatusSerializer
    end

    def execute
      result = form = InvitationActionForm.new(action_params)

      if form.valid?
        action_result = Invitation::ActionLocator.lookup(form.action).execute!(@invitation)

        return render json: action_result.result, serializer: V1::InvitationStatusSerializer unless action_result.error?

        result = action_result.result
      end

      render json: result, status: :bad_request, adapter: :attributes, serializer: V1::ErrorSerializer
    end

    private

    def action_params
      params.require(:invitation).permit(:action)
    end

    def set_invitation
      @invitation = Invitation.includes(:meeting).find_by!(id: params[:id], invitee_id: params[:user_id])
    end
  end
end
