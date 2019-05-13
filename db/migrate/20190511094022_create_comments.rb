class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :body
      t.belongs_to :commentable, polymorphic: true
      t.references :author, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
