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

ActiveRecord::Schema.define(:version => 20121111174634) do

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

  create_table "biblio_geometries", :primary_key => "gid", :force => true do |t|
    t.integer "id2"
    t.string  "nombre",    :limit => 42
    t.string  "tipo",      :limit => 22
    t.string  "domicilio", :limit => 56
    t.string  "telefono",  :limit => 19
    t.string  "nom_mapa",  :limit => 42
    t.string  "barrios",   :limit => 17
    t.integer "comuna"
    t.string  "correo",    :limit => 43
    t.spatial "geometry",  :limit => {:srid=>4326, :type=>"point"}
  end

  add_index "biblio_geometries", ["geometry"], :name => "biblio_geometries_geometry_gist", :spatial => true

  create_table "comisarias_geometries", :primary_key => "gid", :force => true do |t|
    t.integer "id",         :limit => 2
    t.string  "nombre",     :limit => 20
    t.string  "direccion",  :limit => 80
    t.string  "comuna",     :limit => 12
    t.string  "barrio",     :limit => 50
    t.string  "circunscri", :limit => 50
    t.spatial "geometry",   :limit => {:srid=>4326, :type=>"point"}
  end

  add_index "comisarias_geometries", ["geometry"], :name => "comisarias_geometries_geometry_gist", :spatial => true

  create_table "edu_priv_geometries", :primary_key => "gid", :force => true do |t|
    t.string  "dom_edific", :limit => 139
    t.string  "otras_entr", :limit => 106
    t.string  "nombre_est", :limit => 92
    t.string  "nomb_abrev", :limit => 42
    t.string  "telefono",   :limit => 66
    t.string  "correo_web", :limit => 66
    t.string  "nivtip",     :limit => 80
    t.string  "depfun",     :limit => 27
    t.spatial "geometry",   :limit => {:srid=>4326, :type=>"point"}
  end

  add_index "edu_priv_geometries", ["geometry"], :name => "edu_priv_geometries_geometry_gist", :spatial => true

  create_table "edu_pub_geometries", :primary_key => "gid", :force => true do |t|
    t.string  "dom_edific", :limit => 139
    t.string  "otras_entr", :limit => 106
    t.string  "nombre_est", :limit => 92
    t.string  "nomb_abrev", :limit => 42
    t.string  "telefono",   :limit => 66
    t.string  "correo_web", :limit => 66
    t.string  "nivtip",     :limit => 80
    t.string  "depfun",     :limit => 27
    t.spatial "geometry",   :limit => {:srid=>4326, :type=>"point"}
  end

  add_index "edu_pub_geometries", ["geometry"], :name => "edu_pub_geometries_geometry_gist", :spatial => true

  create_table "espverdes_data", :primary_key => "gid", :force => true do |t|
    t.string  "espacio1",   :limit => 18
    t.string  "tipo",       :limit => 20
    t.string  "tipomin",    :limit => 12
    t.string  "nom_origin", :limit => 36
    t.string  "nombre",     :limit => 26
    t.string  "nomplcpu",   :limit => 36
    t.string  "decreto",    :limit => 9
    t.string  "ordenaza",   :limit => 11
    t.string  "boletin",    :limit => 12
    t.string  "fecha_decr", :limit => 15
    t.string  "fecha_orde", :limit => 12
    t.string  "fecha_bole", :limit => 12
    t.string  "fuente",     :limit => 22
    t.string  "observacio", :limit => 14
    t.float   "seccion"
    t.float   "area"
    t.float   "perimeter"
    t.float   "acres"
    t.float   "hectares"
    t.spatial "geometry",   :limit => {:srid=>4326, :type=>"multi_polygon"}
  end

  add_index "espverdes_data", ["geometry"], :name => "espverdes_data_geometry_gist", :spatial => true

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

  add_index "manzanas_geometries", ["geometry"], :name => "manzanas_geometries_geometry_gist", :spatial => true
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
  add_index "parcelas_geometries", ["geometry"], :name => "parcelas_geometries_geometry_gist", :spatial => true

  create_table "subte_geometries", :primary_key => "gid", :force => true do |t|
    t.float   "id"
    t.string  "estacion", :limit => 30
    t.string  "linea",    :limit => 2
    t.spatial "geometry", :limit => {:srid=>4326, :type=>"point"}
  end

  add_index "subte_geometries", ["geometry"], :name => "subte_geometries_geometry_gist", :spatial => true

end
