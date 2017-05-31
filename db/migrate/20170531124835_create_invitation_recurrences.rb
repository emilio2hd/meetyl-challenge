class CreateInvitationRecurrences < ActiveRecord::Migration[5.0]
  def change
    create_table :invitation_recurrences do |t|
      t.integer :creator_id, references: :users, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.text :rule
    end
  end
end
