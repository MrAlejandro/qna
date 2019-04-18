class AddAuthorIdToAnswers < ActiveRecord::Migration[5.2]
  def change
    add_reference(:answers, :author)
    add_foreign_key(:answers, :users, column: :author_id)
  end
end
