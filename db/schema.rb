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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140322175255) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assessments", force: true do |t|
    t.text     "aspect",        null: false
    t.integer  "percentage",    null: false
    t.string   "category",      null: false
    t.integer  "department_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "avatars", force: true do |t|
    t.string   "userable_type",      null: false
    t.integer  "userable_id",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "concentrations", force: true do |t|
    t.string   "name"
    t.integer  "department_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "concentrations", ["department_id"], name: "index_concentrations_on_department_id", using: :btree

  create_table "conference_logs", force: true do |t|
    t.integer  "conference_id",                 null: false
    t.integer  "supervisor_id",                 null: false
    t.boolean  "approved",      default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conferences", force: true do |t|
    t.string   "local"
    t.datetime "start"
    t.datetime "end"
    t.integer  "skripsi_id",                                   null: false
    t.string   "type",                                         null: false
    t.integer  "userable_id",                                  null: false
    t.string   "userable_type",                                null: false
    t.boolean  "supervisor_approval",          default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "department_director_approval", default: false
  end

  create_table "consultations", force: true do |t|
    t.text     "content",          null: false
    t.datetime "next_consult"
    t.integer  "course_id",        null: false
    t.integer  "consultable_id",   null: false
    t.string   "consultable_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", force: true do |t|
    t.string   "title",             default: "",    null: false
    t.text     "description"
    t.integer  "concentration_id"
    t.integer  "student_id",                        null: false
    t.string   "type",              default: "",    null: false
    t.integer  "supervisors_count", default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "feedbacks_count",   default: 0,     null: false
    t.boolean  "is_finish",         default: false
    t.integer  "reports_count"
  end

  create_table "departments", force: true do |t|
    t.string   "name"
    t.text     "website"
    t.integer  "faculty_id",                                         null: false
    t.integer  "students_count",                     default: 0
    t.integer  "lecturers_count",                    default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "concentrations_count",               default: 0
    t.boolean  "director_manage_seminar_scheduling", default: true,  null: false
    t.boolean  "director_manage_sidang_scheduling",  default: false, null: false
    t.boolean  "director_set_local_seminar",         default: false, null: false
    t.boolean  "director_set_local_sidang",          default: false, null: false
  end

  add_index "departments", ["faculty_id"], name: "index_departments_on_faculty_id", using: :btree

  create_table "examiners", force: true do |t|
    t.integer  "sidang_id",   null: false
    t.integer  "lecturer_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "faculties", force: true do |t|
    t.string   "name"
    t.string   "website"
    t.integer  "departments_count", default: 0
    t.integer  "staffs_count",      default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feedbacks", force: true do |t|
    t.text     "content",       null: false
    t.integer  "course_id",     null: false
    t.integer  "userable_id",   null: false
    t.string   "userable_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "imports", force: true do |t|
    t.string   "klass_action"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "package_file_name"
    t.string   "package_content_type"
    t.integer  "package_file_size"
    t.datetime "package_updated_at"
    t.integer  "total_row",                  default: 0,             null: false
    t.string   "status",                     default: "on progress", null: false
    t.integer  "department_id"
    t.integer  "userable_id"
    t.string   "userable_type"
    t.string   "package_original_file_name", default: "",            null: false
  end

  create_table "lecturers", force: true do |t|
    t.string   "nip"
    t.string   "nid"
    t.string   "full_name",                 default: "",       null: false
    t.text     "address"
    t.date     "born"
    t.string   "level",                     default: "Lektor", null: false
    t.string   "front_title"
    t.string   "back_title"
    t.boolean  "is_admin",                  default: false
    t.integer  "department_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "supervisors_count",         default: 0,        null: false
    t.integer  "supervisors_pkl_count",     default: 0,        null: false
    t.integer  "supervisors_skripsi_count", default: 0,        null: false
  end

  add_index "lecturers", ["department_id"], name: "index_lecturers_on_department_id", using: :btree
  add_index "lecturers", ["nid"], name: "index_lecturers_on_nid", using: :btree
  add_index "lecturers", ["nip"], name: "index_lecturers_on_nip", using: :btree

  create_table "papers", force: true do |t|
    t.string   "name",                default: "", null: false
    t.integer  "course_id",                        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bundle_file_name"
    t.string   "bundle_content_type"
    t.integer  "bundle_file_size"
    t.datetime "bundle_updated_at"
  end

  create_table "reports", force: true do |t|
    t.string   "name",                    null: false
    t.integer  "course_id",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
  end

  create_table "settings", force: true do |t|
    t.integer  "supervisor_skripsi_amount",            default: 2,                      null: false
    t.integer  "supervisor_pkl_amount",                default: 1,                      null: false
    t.integer  "examiner_amount",                      default: 2,                      null: false
    t.integer  "maximum_lecturer_lektor_skripsi_lead", default: 10,                     null: false
    t.integer  "maximum_lecturer_aa_skripsi_lead",     default: 10,                     null: false
    t.integer  "allow_remove_supervisor_duration",     default: 3,                      null: false
    t.string   "lecturer_lead_skripsi_rule",           default: "lektor_first_then_aa", null: false
    t.string   "lecturer_lead_pkl_rule",               default: "free",                 null: false
    t.boolean  "allow_student_create_pkl",             default: true,                   null: false
    t.integer  "department_id",                                                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "maximum_lecturer_lektor_pkl_lead",     default: 0,                      null: false
    t.integer  "maximum_lecturer_aa_pkl_lead",         default: 0,                      null: false
    t.integer  "department_director"
    t.integer  "department_secretary"
  end

  create_table "staffs", force: true do |t|
    t.string   "full_name"
    t.text     "address"
    t.date     "born"
    t.date     "staff_since"
    t.integer  "faculty_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "staffs", ["faculty_id"], name: "index_staffs_on_faculty_id", using: :btree

  create_table "students", force: true do |t|
    t.string   "nim",                      default: "", null: false
    t.string   "full_name",                default: "", null: false
    t.text     "address"
    t.date     "born"
    t.integer  "department_id",            default: 0,  null: false
    t.integer  "pkls_count",               default: 0
    t.integer  "skripsis_count",           default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "student_since"
    t.string   "sex",            limit: 2
    t.string   "home_number"
    t.string   "phone_number"
    t.integer  "import_id"
  end

  add_index "students", ["department_id"], name: "index_students_on_department_id", using: :btree
  add_index "students", ["nim"], name: "index_students_on_nim", unique: true, using: :btree

  create_table "supervisors", force: true do |t|
    t.integer  "course_id",                     null: false
    t.integer  "lecturer_id",                   null: false
    t.boolean  "approved",      default: false, null: false
    t.string   "userable_type", default: "",    null: false
    t.integer  "userable_id",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "approved_time"
  end

  create_table "surceases", force: true do |t|
    t.integer  "course_id",                       null: false
    t.string   "provenable_type",                 null: false
    t.integer  "provenable_id",                   null: false
    t.boolean  "is_finish",       default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                    default: "", null: false
    t.string   "username",                 default: "", null: false
    t.string   "primary_identification"
    t.string   "secondary_identification"
    t.string   "encrypted_password",       default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "userable_type",            default: "", null: false
    t.integer  "userable_id",                           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "socket_identifier",        default: "", null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["primary_identification"], name: "index_users_on_primary_identification", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["userable_id"], name: "index_users_on_userable_id", using: :btree
  add_index "users", ["userable_type"], name: "index_users_on_userable_type", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
