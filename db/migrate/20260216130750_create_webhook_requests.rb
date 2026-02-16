class CreateWebhookRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :webhook_requests do |t|
      t.references :endpoint, null: false, foreign_key: true
      t.string :http_method
      t.jsonb :headers
      t.text :body
      t.jsonb :query_params
      t.string :content_type
      t.string :source_ip

      t.timestamps
    end
  end
end
