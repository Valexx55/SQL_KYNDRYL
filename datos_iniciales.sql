-- SET FOREIGN_KEY_CHECKS = 0; -- deshabilitamos el control sobre las claves ajenas

INSERT INTO provincias (nombre) VALUES
('Madrid'),
('Barcelona'),
('Valencia');

INSERT INTO provincias (nombre) VALUES
('Sevilla'),
('Zaragoza');

INSERT INTO poblaciones (nombre, provincia_id) VALUES
('Alcalá de Henares', 1),
('Cornellà de Llobregat', 2),
('Torrent', 3);

INSERT INTO poblaciones (nombre, provincia_id) VALUES
('Dos Hermanas', 4),
('Utebo', 5),
('Mislata', 3),
('Getafe', 1);


INSERT INTO doctores (nombre, apellido, especialidad) VALUES
('Ana', 'García', 'Cardiología'),
('Luis', 'Martínez', 'Pediatría'),
('Marta', 'López', 'Traumatología');

INSERT INTO doctores (nombre, apellido, especialidad) VALUES
('Pedro', 'Fernández', 'Dermatología'),
('Sara', 'Jiménez', 'Neurología'),
('Tomás', 'Ortega', 'Oncología');


INSERT INTO pacientes (nombre, apellido, genero, fecha_nacimiento, peso, altura, poblacion_id) VALUES
('Carlos', 'Sánchez', 'M', '1985-04-23', 80.5, 1.80, 1),
('Lucía', 'Pérez', 'F', '1992-11-15', 65.2, 1.65, 2),
('Javier', 'Ruiz', 'M', '1978-07-09', 90.0, 1.75, 3);

INSERT INTO pacientes (nombre, apellido, genero, fecha_nacimiento, peso, altura, poblacion_id) VALUES
('María', 'Gómez', 'F', '2000-02-20', 54.0, 1.60, 4),
('Elena', 'Moreno', 'F', '1988-09-12', 70.3, 1.70, 5),
('David', 'Navarro', 'M', '1975-01-30', 85.7, 1.78, 6),
('Sofía', 'Romero', 'F', '2010-05-25', 42.5, 1.50, 7),
('Miguel', 'Castro', 'M', '1965-12-15', 77.2, 1.69, 2);


INSERT INTO alergias (nombre) VALUES
('Penicilina'),
('Polen'),
('Lácteos');

INSERT INTO alergias (nombre) VALUES
('Gluten'),
('Ácaros'),
('Mariscos'),
('Aspirina');

INSERT INTO pacientes_alergias (paciente_id, alergia_id) VALUES
(1, 1), -- Carlos es alérgico a Penicilina
(2, 2), -- Lucía es alérgica al Polen
(3, 3), -- Javier es alérgico a Lácteos
(2, 1); -- Lucía también es alérgica a Penicilina


INSERT INTO pacientes_alergias (paciente_id, alergia_id) VALUES
(4, 4), -- María es alérgica a Gluten
(5, 5), -- Elena es alérgica a Ácaros
(6, 6), -- David es alérgico a Mariscos
(7, 2), -- Sofía es alérgica a Polen
(8, 7), -- Miguel es alérgico a Aspirina
(4, 2), -- María también es alérgica a Polen
(5, 1), -- Elena también es alérgica a Penicilina
(6, 3); -- David también es alérgico a Lácteos


INSERT INTO admisiones (fecha_admision, fecha_alta, diagnostico, doctor_id, paciente_id) VALUES
('2024-05-01 10:00:00', '2024-05-05 15:00:00', 'Neumonía', 1, 1),
('2024-06-03 08:30:00', '2024-06-10 12:00:00', 'Fractura', 3, 3),
('2024-06-09 09:00:00', NULL, 'Alergia aguda', 2, 2);

INSERT INTO admisiones (fecha_admision, fecha_alta, diagnostico, doctor_id, paciente_id) VALUES
('2025-01-10 11:00:00', '2025-01-12 09:00:00', 'Migraña', 5, 5),
('2025-02-15 14:30:00', NULL, 'Dermatitis', 4, 4),
('2025-03-05 16:00:00', '2025-03-10 13:00:00', 'Intoxicación alimentaria', 6, 6),
('2025-04-20 09:15:00', NULL, 'Alergia respiratoria', 2, 7),
('2025-05-01 10:00:00', '2025-05-03 18:00:00', 'Chequeo general', 1, 8);



-- SET FOREIGN_KEY_CHECKS = 1; -- habilito el control sobre las claves ajenas



