class CreateInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :invitations do |t|
      t.references :meeting, foreign_key: true, null: false
      t.integer :invitee_id, references: :users, foreign_key: true, null: false
      t.string :access_code, null: false, limit: 255
    end

    add_index :invitations, [:meeting_id, :access_code]
  end
end
