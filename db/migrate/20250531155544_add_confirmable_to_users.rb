class AddConfirmableToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :confirmation_token,   :string
    add_column :users, :confirmed_at,         :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email,    :string

    add_index :users, :confirmation_token, unique: true

    reversible do |dir|
      dir.up { execute("UPDATE users SET confirmed_at = CURRENT_TIMESTAMP WHERE confirmed_at IS NULL") }
    end
  end
end