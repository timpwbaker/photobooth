class CreateShoots < ActiveRecord::Migration[5.1]
  def change
    create_table :shoots do |t|
      t.references :event, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
