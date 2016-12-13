class RemoveReferencesFromAnswerImage < ActiveRecord::Migration[5.0]
  def change
    remove_reference :answer_images, :image, index: true
  end
end
