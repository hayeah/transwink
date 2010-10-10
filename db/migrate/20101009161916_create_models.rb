class CreateModels < ActiveRecord::Migration
  def self.up
    create_table(:stops) do |t|
      t.string :uid
      t.string :name
      t.string :times
      t.string :direction
      t.float :x
      t.float :y
      t.integer :route_id
    end

    create_table(:routes) do |t|
      t.string :uid
      t.string :name
    end
  end

  def self.down
    drop_table(:stops)
    drop_table(:routes)
  end
end
