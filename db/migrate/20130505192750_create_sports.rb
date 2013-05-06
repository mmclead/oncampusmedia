class CreateSports < ActiveRecord::Migration
  def change
    create_table :sports do |t|
      t.references :school
      t.boolean :ncaa_basketball_div_i
      t.boolean :ncaa_basketball_div_ii
      t.boolean :ncaa_basketball_div_iii
      t.boolean :naia_basketball_div_i_and_ii
      t.boolean :ncaa_football_div_i
      t.boolean :ncaa_football_div_ii
      t.boolean :ncaa_football_div_iii
      t.boolean :naia_football_div_i_and_ii
      t.boolean :ncaa_baseball_div_i
      t.boolean :ncaa_baseball_div_ii
      t.boolean :ncaa_baseball_div_iii
      t.boolean :naia_baseball_div_i_and_ii
      t.boolean :ncaa_naia_track_cross_country
      t.boolean :njcaa_football_div_i
      t.boolean :njcaa_baseball_div_i
      t.boolean :njcaa_basketball_div_i
      t.string :conference

      t.timestamps
    end
    add_index :sports, :school_id
  end
end
