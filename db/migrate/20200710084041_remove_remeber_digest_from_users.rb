class RemoveRemeberDigestFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :remeber_digest, :string
  end
end
