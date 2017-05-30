class AddMaximumParticipantsToMeetings < ActiveRecord::Migration[5.0]
  def change
    add_column :meetings, :maximum_participants, :integer, default: 0, null: false
    add_column :meetings, :participants_count, :integer, default: 0, null: false
  end
end
