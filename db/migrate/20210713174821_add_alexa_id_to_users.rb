class AddAlexaIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :alexa_id, :string
    add_index :users, :alexa_id
  end
end
