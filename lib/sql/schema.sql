-- USE emee_app;

-- CREATE TABLE users (
--   user_id integer AUTO_INCREMENT PRIMARY KEY,
--   email VARCHAR(100) NOT NULL UNIQUE,
--   password VARCHAR(255) NOT NULL,
--   created_at TIMESTAMP NOT NULL DEFAULT NOW()
-- );

-- CREATE TABLE users_info (
--   info_id integer AUTO_INCREMENT PRIMARY KEY,
--   user_id integer NOT NULL,
--   first_name VARCHAR(100) NOT NULL,
--   last_name VARCHAR(100) NOT NULL,
--   gender VARCHAR(50),
--   birth_date DATE,
--   phone_number VARCHAR(50),

--   FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
-- );

-- CREATE TABLE medical_notes (
--   id integer AUTO_INCREMENT PRIMARY KEY,
--   user_id integer NOT NULL,
--   title VARCHAR(50) NOT NULL,
--   notes VARCHAR(255) NOT NULL,

--   FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
-- );

-- CREATE TABLE emergency_contacts (
--   id integer AUTO_INCREMENT PRIMARY KEY,
--   user_id integer NOT NULL,
--   contact_name VARCHAR(50) NOT NULL,
--   phone_number VARCHAR(50) NOT NULL,

--   FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
-- )

CREATE TABLE services (
  service_id integer AUTO_INCREMENT PRIMARY KEY,
  service_name VARCHAR(50) NOT NULL,
  service_tag VARCHAR(100) NOT NULL
);

CREATE TABLE reports (
  report_id integer AUTO_INCREMENT PRIMARY KEY,
  user_id integer NOT NULL,
  service_id integer NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
  ended_at TIMESTAMP NULL,

  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (service_id) REFERENCES services(service_id)
)

CREATE TABLE firedept_reports (
  report_id integer AUTO_INCREMENT PRIMARY KEY,
  user_id integer NOT NULL,
  service_id integer NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()

  FOREIGN KEY (report_id) REFERENCES reports(report_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (service_id) REFERENCES services(service_id)
);

CREATE TABLE medic_reports (
  report_id integer AUTO_INCREMENT PRIMARY KEY,
  user_id integer NOT NULL,
  service_id integer NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()

  FOREIGN KEY (report_id) REFERENCES reports(report_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (service_id) REFERENCES services(service_id)
);

CREATE TABLE messages (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id integer NOT NULL,
  report_id integer NOT NULL,
  service_id integer NOT NULL,
  message_type ENUM('text', 'image', 'audio') NOT NULL,
  text_content TEXT NULL,
  file_url VARCHAR(500) NULL,
  fire_duration integer NULL,
  file_size integer NULL,
  file_mime VARCHAR(50),
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  sender integer NOT NULL

  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (report_id) REFERENCES reports(report_id),
  FOREIGN KEY (service_id) REFERENCES services(service_id)
);

CREATE INDEX idx_chat_query
  ON messages (report_id, user_id, created_at);

INSERT INTO services (service_name, service_tag) VALUES ('Medic', 'For Medical Emergencies');
INSERT INTO services (service_name, service_tag) VALUES ('Fire Dept', 'For Emergency Assistance');

CREATE TABLE assesment (
  id integer AUTO_INCREMENT PRIMARY KEY,
  service_id integer NOT NULL,
  victim integer NOt NULL,
  victim_amount integer NOT NULL, 
  deskripsi VARCHAR(50) NOT NULL,

  FOREIGN KEY (service_id) REFERENCES services(service_id)
)

CREATE TABLE assesment_questions (
  id integer AUTO_INCREMENT PRIMARY KEY,
  assesment_id integer NOT NULL,
  question_text VARCHAR (255) NOT NULL,

  FOREIGN KEY (assesment_id) REFERENCES assement(id)
)

CREATE TABLE assesment_answers (
  id integer AUTO_INCREMENT PRIMARY KEY,
  assesment_id integer NOT NULL,
  question_id integer NOT NULL,
  answer_text VARCHAR (255) NOT NULL,

  FOREIGN KEY (question_id) REFERENCES assesment_questions(id),
  FOREIGN KEY (assesment_id) REFERENCES assement(id)
)

CREATE TABLE user_answers (
  id integer AUTO_INCREMENT PRIMARY KEY,
  user_id integer NOT NULL,
  report_id integer NOT NULL,
  assesment_id integer NOT NULL,
  question_id integer NOT NULL,
  answer_id integer NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (report_id) REFERENCES reports(report_id),
  FOREIGN KEY (assesment_id) REFERENCES assement(id),
  FOREIGN KEY (question_id) REFERENCES assesment_questions(id),
  FOREIGN KEY (answer_id) REFERENCES assesment_answers(id)
)

-- Assesment Types
INSERT INTO assesment (service_id, victim, victim_amount, deskripsi) VALUES(1, 0, 1, "MEDIC : Pelapor adalah pasien"); --1
INSERT INTO assesment (service_id, victim, victim_amount, deskripsi) VALUES(1, 0, 2, "MEDIC : Lebih dari 1 pasien, pelapor termasuk"); --2
INSERT INTO assesment (service_id, victim, victim_amount, deskripsi) VALUES(1, 1, 1, "MEDIC : Pelapor bukan pasien"); --3
INSERT INTO assesment (service_id, victim, victim_amount, deskripsi) VALUES(1, 1, 2, "MEDIC : Lebih dari 1 pasien, pelapor bukan pasien"); --4

-- Asessment 1
INSERT INTO assesment_questions (assesment_id, question_text) VALUES(1, 1,  "Kondisi Anda sekarang?"); -- 1
INSERT INTO assesment_questions (assesment_id, question_text) VALUES(1, 1,  "Apa yang terjadi?"); -- 2
INSERT INTO assesment_questions (assesment_id, question_text) VALUES(1, 1,  "Tingkat keparahan cedera Anda?");-- 3
INSERT INTO assesment_questions (assesment_id, question_text) VALUES(1, 1,  "Apakah Anda bisa bergerak?"); -- 4
INSERT INTO assesment_questions (assesment_id, question_text) VALUES(1, 1,  "Apakah Anda sendiri?"); -- 5

-- Answer Question 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(1, "Saya sadar dan berpikir jernih"); -- 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(1, "Saya sadar dan merasa bingung"); -- 2
INSERT INTO assesment_answers (question_id, answer_text) VALUES(1, "Saya merasa akan tidak sadar diri"); -- 3

-- Answer Question 2
INSERT INTO assesment_answers (question_id, answer_text) VALUES(2, "Kecelakaan lalu lintas"); -- 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(2, "Luka"); -- 2
INSERT INTO assesment_answers (question_id, answer_text) VALUES(2, "Jatuh"); -- 3
INSERT INTO assesment_answers (question_id, answer_text) VALUES(2, "Kesulitan bernafas"); -- 4
INSERT INTO assesment_answers (question_id, answer_text) VALUES(2, "Nyeri dada"); -- 5
INSERT INTO assesment_answers (question_id, answer_text) VALUES(2, "Lainnya"); -- 6

-- Answer Question 3
INSERT INTO assesment_answers (question_id, answer_text) VALUES(3, "Parah"); -- 4
INSERT INTO assesment_answers (question_id, answer_text) VALUES(3, "Ringan"); -- 2
INSERT INTO assesment_answers (question_id, answer_text) VALUES(3, "Sedang"); -- 3
INSERT INTO assesment_answers (question_id, answer_text) VALUES(3, "Tidak yakin"); -- 1

-- Answer Question 4
INSERT INTO assesment_answers (question_id, answer_text) VALUES(4, "Bisa"); -- 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(4, "Sedikit"); -- 2
INSERT INTO assesment_answers (question_id, answer_text) VALUES(4, "Tidak yakin"); -- 3
INSERT INTO assesment_answers (question_id, answer_text) VALUES(4, "Saya terjebak"); -- 4

-- Answer Question 5
INSERT INTO assesment_answers (question_id, answer_text) VALUES(5, "Ya"); -- 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(5, "Tidak"); -- 2


-- Assesment 2
INSERT INTO assesment_questions (assesment_id, question_text) VALUES(2,  "Apa yang terjadi?"); -- 1
INSERT INTO assesment_questions (assesment_id, question_text) VALUES(2,  "Total korban?"); -- 2
INSERT INTO assesment_questions (assesment_id, question_text) VALUES(2,  "Kondisi Anda sekarang?"); -- 3
INSERT INTO assesment_questions (assesment_id, question_text) VALUES(2,  "Kondisi korban lain?"); -- 4
INSERT INTO assesment_questions (assesment_id, question_text) VALUES(2,  "Apakah Anda bisa bergerak?"); -- 5
INSERT INTO assesment_questions (assesment_id, question_text) VALUES(2,  "Apakah lokasi aman?"); -- 6

-- Answer Question 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(6, "Kecelakaan lalu lintas"); -- 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(6, "Runtuhan/Ambruk"); -- 2
INSERT INTO assesment_answers (question_id, answer_text) VALUES(6, "Kebakaran"); -- 3
INSERT INTO assesment_answers (question_id, answer_text) VALUES(6, "Kekerasan"); -- 4
INSERT INTO assesment_answers (question_id, answer_text) VALUES(6, "Kejadian medis"); -- 5
INSERT INTO assesment_answers (question_id, answer_text) VALUES(6, "Lainnya"); -- 6

-- Answer Question 2
INSERT INTO assesment_answers (question_id, answer_text) VALUES(7, "2"); -- 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(7, "3 - 5"); -- 2
INSERT INTO assesment_answers (question_id, answer_text) VALUES(7, "Lebih dari 5"); -- 3
INSERT INTO assesment_answers (question_id, answer_text) VALUES(7, "Korban Massal"); -- 4

-- Answer Question 3
INSERT INTO assesment_answers (question_id, answer_text) VALUES(8, "Saya sadar dan berpikir jernih"); -- 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(8, "Saya sadar dan merasa bingung"); -- 2
INSERT INTO assesment_answers (question_id, answer_text) VALUES(8, "Saya merasa akan tidak sadar diri"); -- 3

-- Answer Question 4
INSERT INTO assesment_answers (question_id, answer_text) VALUES(9, "Cedera ringan"); -- 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(9, "Cedera sedang"); -- 2
INSERT INTO assesment_answers (question_id, answer_text) VALUES(9, "Cedera berat"); -- 3

-- Answer Question 5
INSERT INTO assesment_answers (question_id, answer_text) VALUES(10, "Bisa"); -- 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(10, "Sedikit"); -- 2
INSERT INTO assesment_answers (question_id, answer_text) VALUES(10, "Tidak yakin"); -- 3
INSERT INTO assesment_answers (question_id, answer_text) VALUES(10, "Saya terjebak"); -- 4

-- Answer Question 6
INSERT INTO assesment_answers (question_id, answer_text) VALUES(11, "Ya"); -- 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(11, "Tidak"); -- 2
INSERT INTO assesment_answers (question_id, answer_text) VALUES(11, "Tidak Yakin"); -- 3


-- Asessment 3
INSERT INTO assesment_questions (assesment_id, question_text) VALUES(3,  "Apa yaang terjadi?"); -- 1
INSERT INTO assesment_questions (assesment_id, question_text) VALUES(3,  "Bagaimana kondisi pasien?"); -- 2
INSERT INTO assesment_questions (assesment_id, question_text) VALUES(3,  "Usia korban?"); -- 3
INSERT INTO assesment_questions (assesment_id, question_text) VALUES(3,  "Kondisi Pendarahan?"); -- 4
INSERT INTO assesment_questions (assesment_id, question_text) VALUES(3,  "Kondisi Pernafasan?"); -- 5
INSERT INTO assesment_questions (assesment_id, question_text) VALUES(3,  "Korban punya riwayat penyakit?"); -- 6
INSERT INTO assesment_questions (assesment_id, question_text) VALUES(3,  "Relasi dengan Korban?"); -- 7
 
-- Answer Question 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(12, "Kecelakaan lalu lintas"); -- 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(12, "Kejadian medis darurat"); -- 2
INSERT INTO assesment_answers (question_id, answer_text) VALUES(12, "Kekerasan"); -- 3
INSERT INTO assesment_answers (question_id, answer_text) VALUES(12, "Lainnya"); -- 4

-- Answer Question 2 (AVPU)
INSERT INTO assesment_answers (question_id, answer_text) VALUES(13, "Sadar, merespons normal"); -- 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(13, "Sadar, hanya merespons suara"); -- 2
INSERT INTO assesment_answers (question_id, answer_text) VALUES(13, "Sadar minim, hanya merespons nyeri"); -- 3
INSERT INTO assesment_answers (question_id, answer_text) VALUES(13, "Tidak sadar, tidak merespons"); -- 4

-- Answer Question 3 
INSERT INTO assesment_answers (question_id, answer_text) VALUES(14, "Bayi"); -- 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(14, "Anak - anak"); -- 2
INSERT INTO assesment_answers (question_id, answer_text) VALUES(14, "Remaja"); -- 3
INSERT INTO assesment_answers (question_id, answer_text) VALUES(14, "Dewasa"); -- 4
INSERT INTO assesment_answers (question_id, answer_text) VALUES(14, "Lansia"); -- 5

-- Answer Question 4
INSERT INTO assesment_answers (question_id, answer_text) VALUES(15, "Tidak ada pendarahan"); -- 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(15, "Pendarahan ringan"); -- 2
INSERT INTO assesment_answers (question_id, answer_text) VALUES(15, "Pendarahan berat"); -- 3
INSERT INTO assesment_answers (question_id, answer_text) VALUES(15, "Pendarahan tidak terlihat tapi dicurigai"); -- 4

-- Answer Question 5
INSERT INTO assesment_answers (question_id, answer_text) VALUES(16, "Normal"); -- 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(16, "Cepat/Lambat"); -- 2
INSERT INTO assesment_answers (question_id, answer_text) VALUES(16, "Sulit bernafas"); -- 3
INSERT INTO assesment_answers (question_id, answer_text) VALUES(16, "Tidak bernafas"); -- 3

-- Answer Question 6
INSERT INTO assesment_answers (question_id, answer_text) VALUES(17, "Ya"); -- 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(17, "Tidak"); -- 2
INSERT INTO assesment_answers (question_id, answer_text) VALUES(17, "Tidak Tahu"); -- 3

-- Answer Question 7
INSERT INTO assesment_answers (question_id, answer_text) VALUES(18, "Keluarga"); -- 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(18, "Teman"); -- 2
INSERT INTO assesment_answers (question_id, answer_text) VALUES(18, "Tidak Kenal Korban"); -- 3


-- Assesment 4
INSERT INTO assesment_questions (assesment_id, question_text) VALUES(4,  "Apa ypang terjadi?"); -- 1
INSERT INTO assesment_questions (assesment_id, question_text) VALUES(4,  "Total korban?"); -- 2
INSERT INTO assesment_questions (assesment_id, question_text) VALUES(4,  "Jumlah korban dengan kondisi kritis/parah?"); -- 3
INSERT INTO assesment_questions (assesment_id, question_text) VALUES(4,  "Apakah lokasi aman?"); -- 4
INSERT INTO assesment_questions (assesment_id, question_text) VALUES(4,  "Relasi dengan korban?"); -- 5

-- Answer Question 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(19, "Runtuhan/Ambruk"); -- 2
INSERT INTO assesment_answers (question_id, answer_text) VALUES(19, "Kecelakaan lalu lintas"); -- 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(19, "Kebakaran"); -- 3
INSERT INTO assesment_answers (question_id, answer_text) VALUES(19, "Kekerasan"); -- 4
INSERT INTO assesment_answers (question_id, answer_text) VALUES(19, "Kejadian medis"); -- 4
INSERT INTO assesment_answers (question_id, answer_text) VALUES(19, "Lainnya"); -- 5

-- Answer Question 2
INSERT INTO assesment_answers (question_id, answer_text) VALUES(20, "2"); -- 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(20, "3 - 5"); -- 2
INSERT INTO assesment_answers (question_id, answer_text) VALUES(20, "Lebih dari 5"); -- 3
INSERT INTO assesment_answers (question_id, answer_text) VALUES(20, "Korban Massal"); -- 4

-- Answer Question 3
INSERT INTO assesment_answers (question_id, answer_text) VALUES(21, "Lebih dari 2"); -- 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(21, "2"); -- 2
INSERT INTO assesment_answers (question_id, answer_text) VALUES(21, "1"); -- 3
INSERT INTO assesment_answers (question_id, answer_text) VALUES(21, "Tidak Ada"); -- 3

-- Answer Question 4
INSERT INTO assesment_answers (question_id, answer_text) VALUES(22, "Ya"); -- 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(22, "Tidak"); -- 2
INSERT INTO assesment_answers (question_id, answer_text) VALUES(22, "Tidak Yakin"); -- 3

-- Answer Question 5
INSERT INTO assesment_answers (question_id, answer_text) VALUES(23, "Keluarga"); -- 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(23, "Teman"); -- 2
INSERT INTO assesment_answers (question_id, answer_text) VALUES(23, "Tidak Kenal Korban"); -- 3


-- Assesment Types
INSERT INTO assesment (service_id, victim, victim_amount, deskripsi) VALUES(2, 0, 1, "FIRE DEPT : Pelapor adalah pasien"); --1
INSERT INTO assesment (service_id, victim, victim_amount, deskripsi) VALUES(2, 0, 2, "FIRE DEPT : Lebih dari 1 pasien, pelapor termasuk"); --2
INSERT INTO assesment (service_id, victim, victim_amount, deskripsi) VALUES(2, 1, 1, "FIRE DEPT : Pelapor bukan pasien"); --3
INSERT INTO assesment (service_id, victim, victim_amount, deskripsi) VALUES(2, 1, 2, "FIRE DEPT : Lebih dari 1, pelapor bukan pasien"); -- 4

-- Asessment 1
INSERT INTO assesment_questions (assesment_id, question_text) VALUES(5, 1,  "Apa yang terjadi?"); -- 1
INSERT INTO assesment_questions (assesment_id, question_text) VALUES(5, 1,  "Dimana Anda?"); -- 2
INSERT INTO assesment_questions (assesment_id, question_text) VALUES(5, 1,  "Kondisi Anda saat ini?");-- 3
INSERT INTO assesment_questions (assesment_id, question_text) VALUES(5, 1,  "Seberapa tebal asap di sekitar Anda?"); -- 4
INSERT INTO assesment_questions (assesment_id, question_text) VALUES(5, 1,  "Seberapa besar api di sekitar Anda?"); -- 5
INSERT INTO assesment_questions (assesment_id, question_text) VALUES(5, 1,  "Apakah Anda bisa keluar dari lokasi?"); -- 6

-- Answer Question 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(24, "Kebakaran bangunan"); -- 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(24, "Kebakaran kendaraan"); -- 2
INSERT INTO assesment_answers (question_id, answer_text) VALUES(24, "Kebakaran objek lain"); -- 3
INSERT INTO assesment_answers (question_id, answer_text) VALUES(24, "Lainnya"); -- 4

-- Answer Question 2
INSERT INTO assesment_answers (question_id, answer_text) VALUES(25, "Di dalam kebakaran"); -- 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(25, "Di luar kebakaran"); -- 2

-- Answer Question 3
INSERT INTO assesment_answers (question_id, answer_text) VALUES(26, "Terluka, bisa bernafas"); -- 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(26, "Terluka, sesak nafas"); -- 2
INSERT INTO assesment_answers (question_id, answer_text) VALUES(26, "Tidak Terluka, bisa bernafas"); -- 3
INSERT INTO assesment_answers (question_id, answer_text) VALUES(26, "Tidak Terluka, sesak nafas"); -- 4

-- Answer Question 4
INSERT INTO assesment_answers (question_id, answer_text) VALUES(27, "Tebal"); -- 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(27, "Sedang"); -- 2
INSERT INTO assesment_answers (question_id, answer_text) VALUES(27, "Tipis"); -- 3
INSERT INTO assesment_answers (question_id, answer_text) VALUES(27, "Tidak ada asap"); -- 4

-- Answer Question 5
INSERT INTO assesment_answers (question_id, answer_text) VALUES(28, "Besar"); -- 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(28, "Sedang"); -- 2
INSERT INTO assesment_answers (question_id, answer_text) VALUES(28, "Kecil"); -- 3
INSERT INTO assesment_answers (question_id, answer_text) VALUES(28, "Tidak ada api/Api tidak terlihat"); -- 4

-- Answer Question 6
INSERT INTO assesment_answers (question_id, answer_text) VALUES(29, "Bisa"); -- 1
INSERT INTO assesment_answers (question_id, answer_text) VALUES(29, "Sulit keluar"); -- 2
INSERT INTO assesment_answers (question_id, answer_text) VALUES(29, "Tidak bisa"); -- 3