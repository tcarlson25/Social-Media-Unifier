class RemoveUsernameFromFeed < ActiveRecord::Migration[5.2]
  def change
    remove_column :feeds, :username, :string
  end
end
