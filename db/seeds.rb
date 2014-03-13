# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
faculty_params = [
  {name: "Sains dan Teknologi", website: "http://wwww.fst.uinjkt.ac.id"}
]
faculty_params.each do |faculty|
  Faculty.find_or_initialize_by(name: faculty[:name]).tap do |t|
    t.website = faculty[:website]
    t.save!
  end
end
f = Faculty.find_by_name("Sains dan Teknologi")

department_params = [
  {name: "Teknik Informatika", website: "", faculty_id: f.id}
]

department_params.each do |department|
  Department.find_or_initialize_by(name: department[:name]).tap do |t|
    t.website = department[:website]
    t.faculty_id = department[:faculty_id]
    t.save!
  end
end
d = Department.find_by_name("Teknik Informatika")

concentration_params = [
  {name: "Software Engineering", department_id: d.id},
  {name: "Networking", department_id: d.id},
  {name: "Multimedia", department_id: d.id},
]
concentration_params.each do |concentration|
  Concentration.find_or_initialize_by(name: concentration[:name]).tap do |t|
    t.department_id = concentration[:department_id]
    t.save!
  end
end

assessment_params = [
  {aspect: "Persiapan Seminar", percentage: 15, category: "Seminar", department_id: d.id},
  {aspect: "Sistematika Penyajian", percentage: 20, category: "Seminar", department_id: d.id},
  {aspect: "Kejelasan dalam memberikan tanggapan terhadap pertanyaan, kritik dan saran", percentage: "20", category: "Seminar", department_id: d.id},
  {aspect: "Penggunaan Alat Peraga", percentage: 15, category: "Seminar", department_id: d.id},
  {aspect: "Penampilan", percentage: 15, category: "Seminar", department_id: d.id},
  {aspect: "Sikap dalam menyajikan argumentasi", percentage: 15, category: "Seminar", department_id: d.id},
  {aspect: "Proposal penilitian dan pelaksana penelitian", percentage: 20, category: "Sidang", department_id: d.id},
  {aspect: "Skripsi", percentage: 30, category: "Sidang", department_id: d.id},
  {aspect: "Sistematika Presentasi", percentage: 15, category: "Sidang", department_id: d.id},
  {aspect: "Kejelasan dalam memberikan tanggapan terhadap pertanyaan, kritik dan saran", percentage: 15, category: "Sidang", department_id: d.id},
  {aspect: "Penggunaan Alat Peraga", percentage: 10, category: "Sidang", department_id: d.id},
  {aspect: "Penampilan dan Sikap dalam menyajikan argumentasi", percentage: 10, category: "Sidang", department_id: d.id},
]

assessment_params.each do |assessment|
  Assessment.find_or_initialize_by(aspect: assessment[:aspect], category: assessment[:category], department_id: assessment[:department_id]).tap do |t|
    t.percentage = assessment[:percentage]
    t.save!
  end
end



students = [
  {nim: "109091000132", full_name: "Fauzan Qadri", address: "Some text address", born: "1991-04-07", student_since: "2009-08-16", department_id: d.id,},
  {nim: "109091000122", full_name: "Zidni Mubarok", address: "Some text address", born: "1988-02-19", student_since: "2009-08-16", department_id: d.id },
  {nim: "109091000097", full_name: "Azhar Amir", address: "Some text address", born: "1990-01-11", student_since: "2009-08-16", department_id: d.id }
]
students.each do |student|
  Student.find_or_initialize_by(nim: student[:nim]).tap do |t|
    t.full_name = student[:full_name]
    t.address = student[:address]
    t.born = student[:born]
    t.student_since = student[:student_since]
    t.department_id = student[:department_id]
    t.save!
  end
end

lecturers = [
  {full_name: "Andrew Fiade", back_title: "M.Kom", department_id: d.id, born: "1960-01-01", level: "Lektor", is_admin: false, front_title: ""},
  {full_name: "Anif Hanifa Setia Ningrum", back_title: "M.Si", department_id: d.id, born: "1960-01-01", level: "Lektor", is_admin: false, front_title: ""},
  {full_name: "Defiana Arnaldy", back_title: "S.Tp.M.Si", department_id: d.id, born: "1960-01-01", level: "Lektor", is_admin: false, front_title: ""},
  {full_name: "Dewi Khairani", back_title: "M.Sc", department_id: d.id, born: "1960-01-01", level: "Lektor", is_admin: false, front_title: ""},
  {full_name: "Fadhillah Mathar", back_title: "M.Pd", department_id: d.id, born: "1960-01-01", level: "Lektor", is_admin: false, front_title: ""},
  {full_name: "Fenty Eka Muzzayyana", back_title: "M.Kom", department_id: d.id, born: "1960-01-01", level: "Lektor", is_admin: false, front_title: ""},
  {full_name: "Feri Fahrianto", back_title: "M.Sc", department_id: d.id, born: "1960-01-01", level: "Lektor", is_admin: false, front_title: ""},
  {full_name: "Fitri Mintarsih", back_title: "M.Kom", department_id: d.id, born: "1960-01-01", level: "Lektor", is_admin: false, front_title: ""},
  {full_name: "Hatta Maulana", back_title: "MTI", department_id: d.id, born: "1960-01-01", level: "Lektor", is_admin: false, front_title: ""},
  {full_name: "Hendra Bayu Suseno", back_title: "M.Kom", department_id: d.id, born: "1960-01-01", level: "Lektor", is_admin: true, front_title: ""},
  {full_name: "Herlino Nanang", back_title: "MT", department_id: d.id, born: "1960-01-01", level: "Lektor", is_admin: false, front_title: ""},
  {full_name: "Husni Teja Sukmana", back_title: "Ph.D", department_id: d.id, born: "1960-01-01", level: "Lektor", is_admin: false, front_title: ""},
  {full_name: "Imam Marzuki Shofi", back_title: "MT", department_id: d.id, born: "1960-01-01", level: "Lektor", is_admin: false, front_title: ""},
  {full_name: "Khodijah Hulliyah", back_title: "M.Si", department_id: d.id, born: "1960-01-01", level: "Lektor", is_admin: false, front_title: ""},
  {full_name: "Muhammad Choiril Anwar", back_title: "M.Sc", department_id: d.id, born: "1960-01-01", level: "Lektor", is_admin: false, front_title: ""},
  {full_name: "Muhammad Fauzi Murtadlo", back_title: "MTI", department_id: d.id, born: "1960-01-01", level: "Lektor", is_admin: false, front_title: ""},
  {full_name: "Muhammad Tabah Rosyadi", back_title: "MA", department_id: d.id, born: "1960-01-01", level: "Lektor", is_admin: false, front_title: ""},
  {full_name: "Nasrul Hakim", back_title: "MT", department_id: d.id, born: "1960-01-01", level: "Lektor", is_admin: false, front_title: ""},
  {full_name: "Nenny Anggraini", back_title: "S.Kom, MT", department_id: d.id, born: "1960-01-01", level: "Lektor", is_admin: false, front_title: ""},
  {full_name: "Nurhayati", back_title: "MT", department_id: d.id, born: "1960-01-01", level: "Lektor", is_admin: true, front_title: ""},
  {full_name: "Nurul Faizah Rozy", back_title: "MTI", department_id: d.id, born: "1960-01-01", level: "Lektor", is_admin: false, front_title: ""},
  {full_name: "Rayi Pradono Iswara", back_title: "M.Sc", department_id: d.id, born: "1960-01-01", level: "Lektor", is_admin: false, front_title: ""},
  {full_name: "Ria Hari Gusmita", back_title: "M.Kom", department_id: d.id, born: "1960-01-01", level: "Lektor", is_admin: false, front_title: ""},
  {full_name: "Rizal Bahawarez", back_title: "M.Kom", department_id: d.id, born: "1960-01-01", level: "Lektor", is_admin: false, front_title: ""},
  {full_name: "Siti Ummi Masruroh", back_title: "M.Sc", department_id: d.id, born: "1960-01-01", level: "Lektor", is_admin: false, front_title: ""},
  {full_name: "Syafedi Safei", front_title: "Dr", department_id: d.id, born: "1960-01-01", level: "Lektor", is_admin: false, back_title: ""},
  {full_name: "Victor Amrizal", back_title: "M.Kom", department_id: d.id, born: "1960-01-01", level: "Lektor", is_admin: false, front_title: ""},
  {full_name: "Viva Arivin", back_title: "MMSI", department_id: d.id, born: "1960-01-01", level: "Lektor", is_admin: false, front_title: ""},
  {full_name: "Yusuf Durrachman", back_title: "MIT, M.Sc", department_id: d.id, born: "1960-01-01", level: "Lektor", is_admin: false, front_title: ""},
]

lecturers.each do |lecturer|
  Lecturer.find_or_initialize_by(full_name: lecturer[:full_name]).tap do |t|
    t.back_title = lecturer[:back_title]
    t.front_title = lecturer[:front_title]
    t.department_id = lecturer[:department_id]
    t.born = lecturer[:born]
    t.level = lecturer[:level]
    t.is_admin = lecturer[:is_admin]
    t.save!
  end
end

staffs = [
  {full_name: "Muhammad Adzimy", address: "Some text address", born: "01-01-1986", faculty_id: f.id},
  {full_name: "Al Fayad", address: "Some text address", born: "01-01-1986", faculty_id: f.id}
]
staffs.each do |staff|
  Staff.find_or_initialize_by(full_name: staff[:full_name]).tap do |t|
    t.address = staff[:address]
    t.born = staff[:born]
    t.faculty_id = staff[:faculty_id]
    t.save!
  end
end
