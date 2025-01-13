class AddSpamScoreToGuestMessage < ActiveRecord::Migration[7.1]
  def change
    add_column :guest_messages, :spam_score, :integer
  end
end
