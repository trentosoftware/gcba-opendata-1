# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20121111150049) do

  create_table "autocomplete_search", :force => true do |t|
    t.integer "results"
    t.string  "text"
  end

  add_index "autocomplete_search", ["results"], :name => "index_autocomplete_search_on_results"
  add_index "autocomplete_search", ["text"], :name => "index_autocomplete_search_on_text"

  create_table "barrios_geometries", :force => true do |t|
    t.integer "gid"
    t.string  "barrio"
    t.decimal "perimetro"
    t.decimal "area"
    t.integer "comuna"
    t.spatial "geometry",  :limit => {:srid=>4326, :type=>"multi_polygon"}
  end

  create_table "manzanas_geometries", :force => true do |t|
    t.integer "gid"
    t.string  "sec"
    t.string  "manz"
    t.string  "sm"
    t.string  "obs2"
    t.string  "sourcethm"
    t.decimal "area_feet"
    t.decimal "perimeter_"
    t.decimal "acres"
    t.decimal "hectares"
    t.decimal "area_feet__9"
    t.decimal "perimeter___10"
    t.decimal "area_feet__11"
    t.decimal "perimeter___12"
    t.decimal "area"
    t.decimal "perimeter"
    t.spatial "geometry",       :limit => {:srid=>4326, :type=>"multi_polygon"}
  end

  add_index "manzanas_geometries", ["manz"], :name => "index_manzanas_geometries_on_manz"

  create_table "parcelas_data", :force => true do |t|
    t.string   "fecha"
    t.string   "barrio"
    t.string   "seccion"
    t.string   "manzana"
    t.string   "parcela"
    t.string   "smp"
    t.string   "calle"
    t.string   "nro"
    t.string   "calle2"
    t.string   "chapa_visible"
    t.string   "tipo1"
    t.string   "tipo2"
    t.string   "pisos"
    t.string   "nombre"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "parcelas_data", ["manzana"], :name => "index_parcelas_data_on_manzana"
  add_index "parcelas_data", ["smp"], :name => "index_parcelas_data_on_smp"

  create_table "parcelas_geometries", :force => true do |t|
    t.string  "seccion"
    t.string  "manzana"
    t.string  "parcela"
    t.string  "obs"
    t.string  "weblink"
    t.string  "parc_esq"
    t.string  "rot_par"
    t.string  "rot_sec"
    t.string  "sm"
    t.string  "partida"
    t.string  "smp"
    t.spatial "geometry", :limit => {:srid=>4326, :type=>"multi_polygon"}
  end

  add_index "parcelas_geometries", ["geometry"], :name => "index_parcelas_geometries_on_geometry", :spatial => true

end
