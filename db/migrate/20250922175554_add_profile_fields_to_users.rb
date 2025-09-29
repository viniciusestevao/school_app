class AddProfileFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :name, :string
    add_column :users, :code, :string
    add_column :users, :birthday_at, :date
    add_column :users, :phone_number, :string
    add_column :users, :gender, :string
    add_column :users, :role, :integer, null: false, default: 0
    add_column :users, :status, :integer
    add_column :users, :address, :string
    add_column :users, :number, :string
    add_column :users, :neighborhood, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :postal_code, :string
    add_column :users, :complement, :string

    add_index :users, :code, unique: true
  end
end
