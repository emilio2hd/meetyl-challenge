class CreateMeetings < ActiveRecord::Migration[5.0]
  def change
    create_table :meetings do |t|
      t.string :place, null: false, limit: 255
      t.date :date, null: false
      t.time :time, null: false
      t.integer :creator_id, references: :users, foreign_key: true, null: false
    end
  end
end
