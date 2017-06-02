class AddRecurrentToInvitations < ActiveRecord::Migration[5.0]
  def change
    add_column :invitations, :recurrent, :boolean, null: false, default: false
  end
end
