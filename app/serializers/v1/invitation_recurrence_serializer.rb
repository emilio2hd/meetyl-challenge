module V1
  class InvitationRecurrenceSerializer < ActiveModel::Serializer
    attributes :target_user, :rule_description

    def target_user
      object.user.name
    end

    def rule_description
      start_time = object.rule.try(:start_time)

      starting = start_time ? "Starting at #{I18n.localize(start_time, format: '%Y-%m-%d')}, " : ''

      "#{starting}#{object.rule.to_s}"
    end
  end
end