module V1
  class InvitationRecurrencesController < ApplicationController
    api :GET, '/users/:user_id/invitation_recurrences', 'List all user\'s recurrence, as creator'
    def index
      recurrences = InvitationRecurrence.includes(:user).all_from(params[:user_id])
      render json: recurrences, each_serializer: V1::InvitationRecurrenceSerializer
    end
  end
end
