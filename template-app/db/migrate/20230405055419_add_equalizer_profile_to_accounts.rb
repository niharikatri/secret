class AddEqualizerProfileToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :equalizer_profile, :jsonb, default: {pitch: 0, bass: 0, mid: 0, treble: 0}
  end
end
