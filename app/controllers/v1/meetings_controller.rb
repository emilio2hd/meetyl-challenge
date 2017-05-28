module V1
  class MeetingsController < ApplicationController
    before_action :set_meeting, only: [:show, :update]

    def index
      meetings = Meeting.includes(:creator).all

      render json: meetings, each_serializer: V1::MeetingSerializer
    end

    def show
      render json: @meeting, serializer: V1::MeetingSerializer
    end

    def create
      meeting = Meeting.new(meeting_params.merge(creator_id: params[:user_id]))

      if meeting.save
        render json: meeting, status: :created, serializer: V1::MeetingSerializer
      else
        render json: { errors: meeting.errors }, status: :bad_request
      end
    end

    def update
      if @meeting.update(meeting_params)
        render json: @meeting, serializer: V1::MeetingSerializer
      else
        render json: { errors: @meeting.errors }, status: :bad_request
      end
    end

    private

    def set_meeting
      @meeting = Meeting.find(params[:id])
    end

    def meeting_params
      params.require(:meeting).permit(:place, :date, :time, :user_id)
    end
  end
end