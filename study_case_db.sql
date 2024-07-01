CREATE TABLE teachers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    subject VARCHAR(50)
);

INSERT INTO teachers (name, subject) VALUES ('Pak Anton', 'Matematika');
INSERT INTO teachers (name, subject) VALUES ('Bu Dina', 'Bahasa Indonesia');
INSERT INTO teachers (name, subject) VALUES ('Pak Eko', 'Biologi');

CREATE TABLE classes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    teacher_id INT,
    FOREIGN KEY (teacher_id) REFERENCES teachers(id)
);

INSERT INTO classes (name, teacher_id) VALUES ('Kelas 10A', 1); 
INSERT INTO classes (name, teacher_id) VALUES ('Kelas 11B', 2); 
INSERT INTO classes (name, teacher_id) VALUES ('Kelas 12C', 3);

CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    class_id INT,
    FOREIGN KEY (class_id) REFERENCES classes(id)
);

INSERT INTO students (name, age, class_id) VALUES ('Budi', 16, 1); 
INSERT INTO students (name, age, class_id) VALUES ('Ani', 17, 2); 
INSERT INTO students (name, age, class_id) VALUES ('Candra', 18, 3);

--1. Tampilkan daftar siswa beserta kelas dan guru yang mengajar kelas tersebut.
SELECT s.name AS student_name, c.name AS class_name, t.name AS teacher_name
FROM students s
JOIN classes c ON s.class_id = c.id
JOIN teachers t ON c.teacher_id = t.id;

--2. Tampilkan daftar kelas yang diajar oleh guru yang sama.
SELECT c.name AS class_name, t.name AS teacher_name
FROM classes c
JOIN teachers t ON c.teacher_id = t.id
WHERE t.id = 1;

--3. buat query view untuk siswa, kelas, dan guru yang mengajar.
DROP VIEW IF EXISTS student_class_teacher;

CREATE VIEW student_class_teacher AS
SELECT s.name AS student_name, c.name AS class_name, t.name AS teacher_name
FROM students s
JOIN classes c ON s.class_id = c.id
JOIN teachers t ON c.teacher_id = t.id;

--4. buat query yang sama tapi menggunakan store_procedure.
CREATE OR REPLACE FUNCTION get_student_class_teacher()
RETURNS TABLE (student_name VARCHAR(100), class_name VARCHAR(50), teacher_name VARCHAR(100))
AS $$
BEGIN
    RETURN QUERY
    SELECT s.name AS student_name, c.name AS class_name, t.name AS teacher_name
    FROM students s
    JOIN classes c ON s.class_id = c.id
    JOIN teachers t ON c.teacher_id = t.id;
END;
$$ LANGUAGE plpgsql;


--5. buat query input, yang akan memberikan warning error jika ada data yang sama pernah masuk.

-- Contoh penggunaan ON CONFLICT untuk menangani konflik jika ada siswa dengan nama yang sama dalam satu kelas
INSERT INTO students (name, age, class_id)
VALUES ('Budi', 17, 1)
ON CONFLICT (name, class_id) DO NOTHING;
