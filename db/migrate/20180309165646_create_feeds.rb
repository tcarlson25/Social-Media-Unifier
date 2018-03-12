class CreateFeeds < ActiveRecord::Migration[5.1]
  def change
    create_table :feeds do |t|
      t.belongs_to :user, index: true
      t.string :username
      
      t.timestamps
    end
  end
end
