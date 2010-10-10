# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101010192919) do

  create_table "routes", :force => true do |t|
    t.string "uid"
    t.string "name"
  end

  add_index "routes", ["uid"], :name => "index_routes_on_uid"

  create_table "stops", :force => true do |t|
    t.string  "uid"
    t.string  "name"
    t.string  "times"
    t.string  "direction"
    t.float   "x"
    t.float   "y"
    t.integer "route_id"
  end

  add_index "stops", ["route_id"], :name => "index_stops_on_route_id"
  add_index "stops", ["x", "y"], :name => "index_stops_on_x_and_y"

end
