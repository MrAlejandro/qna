class AddAuthorIdToAnswers < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :author_id, :integer
  end
end
