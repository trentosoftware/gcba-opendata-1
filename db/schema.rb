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

ActiveRecord::Schema.define(:version => 20120916191326) do

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
    t.string   "geometry"
  end

end
