class AddAuthorIdToQuestion < ActiveRecord::Migration[5.2]
  def change
    add_reference(:questions, :author)
    add_foreign_key(:questions, :users, column: :author_id)
  end
end
