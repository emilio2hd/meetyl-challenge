require 'invitation/action_locator'

module V1
  class InvitationsController < ApplicationController
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
      form = InvitationActionForm.new(action_params)
      if form.valid?
        result = Invitation::ActionLocator.lookup(form.action).execute!(@invitation)
        render json: result, serializer: V1::InvitationStatusSerializer
      else
        render json: { errors: form.errors }, status: :bad_request
      end
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
