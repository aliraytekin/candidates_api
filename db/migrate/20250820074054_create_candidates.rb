class CreateCandidates < ActiveRecord::Migration[7.1]
  def change
    create_table :candidates do |t|
      t.string :name
      t.string :title
      t.string :location
      t.string :availability
      t.integer :salary_expectation_eur
      t.integer :years_exp
      t.text :skills, array: true, default: []
      t.text :languages, array: true, default: []

      t.timestamps
    end
  end
end
