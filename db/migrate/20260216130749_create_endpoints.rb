class CreateEndpoints < ActiveRecord::Migration[8.1]
  def change
    create_table :endpoints do |t|
      t.string :token, null: false
      t.string :name
      t.integer :response_status_code, default: 200
      t.text :response_body, default: '{"ok": true}'
      t.string :response_content_type, default: "application/json"
      t.datetime :expires_at
      t.references :user, foreign_key: true, null: true

      t.timestamps
    end
    add_index :endpoints, :token, unique: true
  end
end
