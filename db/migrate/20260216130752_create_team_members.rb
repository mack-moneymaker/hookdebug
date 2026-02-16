class CreateTeamMembers < ActiveRecord::Migration[8.1]
  def change
    create_table :team_members do |t|
      t.references :endpoint, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :role, default: "viewer"

      t.timestamps
    end
  end
end
