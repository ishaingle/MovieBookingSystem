class CreateShowtimes < ActiveRecord::Migration[7.0]
  def change
    create_table :showtimes do |t|
      t.references :movie, null: false, foreign_key: true
      t.datetime :time
      t.integer :available_seats

      t.timestamps
    end
  end
end
