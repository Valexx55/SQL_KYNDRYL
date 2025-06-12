-- CREAR UNA VISTA PARA MOSTRAR LOS PACIENTES Y ALERGIAS (vista con datos NO actualizables JOIN, DATOS AGREGADOS - NO UPDATE)
CREATE VIEW vista_pacientes_alergias AS
SELECT 
	p.paciente_id,
	p.nombre AS nombre_paciente,
    p.apellido,
    a.nombre AS nombre_alergia
FROM pacientes p
JOIN pacientes_alergias pa ON p.paciente_id = pa.paciente_id
JOIN alergias a ON pa.alergia_id = a.alergias_id;

-- CREAR UNA VISTA SIMPLIFICADA DE la tabla pacientes QUE OMITA LAS COLUMNAS DE GÉNERO Y FECHA DE NACIMIENTO
-- Los datos de la vista en este caso son actualizables (UPDATE pacientes vía UPDATE vista)
DROP VIEW vista_simplificada_clientes;
CREATE OR REPLACE VIEW vista_simplificada_pacientes AS
SELECT 
	paciente_id,
    nombre,
    apellido,
    peso, 
    altura,
    poblacion_id
FROM pacientes;

UPDATE vista_simplificada_clientes
SET peso = 200
WHERE paciente_id = 1;

-- CREAMOS UNA VISTA, PARA QUE ME DÉ EL DETALLE DE CUÁNDO HA SIDO ADMITIDO UN PACIENTE, SU NOMBRE, QUÉ DOCTOR LE HA ATENDIDO Y EL DIAGNOSITCO


CREATE OR REPLACE VIEW vista_admisiones_pacientes AS
    SELECT 
        p.nombre AS nombre_paciente,
        ad.fecha_admision,
        d.nombre AS nombre_doctor,
        ad.diagnostico
    FROM
        pacientes p
            JOIN
        admisiones ad ON ad.paciente_id = p.paciente_id
JOIN doctores d ON d.doctor_id = ad.doctor_id;

-- TODO. revisar por qué me permite la actualzación cuando es una vista con JOINS
SET SQL_SAFE_UPDATES = 0;
UPDATE vista_admisiones_pacientes
SET nombre_doctor = 'PACO'; -- si toco un sólo campo de una tabla, sí me deja
SET SQL_SAFE_UPDATES = 1;


SET SQL_SAFE_UPDATES = 0;
UPDATE vista_admisiones_pacientes
SET diagnostico = 'Indeterminado', nombre_doctor = 'PACO'; -- si modifico campos de distintas tablas o uso GROUP BY O DISTINCT, NO
SET SQL_SAFE_UPDATES = 1;
-- Error Code: 1393. Can not modify more than one base table through a join view 'hospital_kyndryl.vista_admisiones_pacientes'



/**
PROCEDURES
*/

-- haced un procedimiento, que dado un prefijo de apellido, me de los pacientes que empiezan por ese prefijo dado
DELIMITER $$

CREATE PROCEDURE buscar_pacientes_por_apellido (IN prefijo VARCHAR(10)) -- cabecera / parámetros formales
BEGIN
	-- instrucciones SQL ; 
	SELECT 
		*
	FROM
		pacientes
	WHERE
		apellido LIKE CONCAT(prefijo, '%');

END $$

DELIMITER ;

call hospital_kyndryl.buscar_pacientes_por_apellido('p'); -- llamada / parámetros actuales - CORRESPONDENCIA ENTRE NÚMERO, TIPO Y ORDEN
call hospital_kyndryl.buscar_pacientes_por_apellido('r');


-- v1  HACED un procedimiento, que dado un ID del paciente, me diga cuántas ADMISIONES HA TENIDO

-- Jorge Dómine 12/06/2025 12:26 •

DELIMITER $$

CREATE PROCEDURE contar_admisiones (IN ID_PACIENTE INT)
BEGIN
  -- instrucciones SQL ; 
  SELECT 
    COUNT(*)
  FROM
    admisiones
  WHERE
    paciente_id = ID_PACIENTE;

END $$

DELIMITER ;

call hospital_kyndryl.contar_admisiones(2);
call hospital_kyndryl.contar_admisiones(0);



-- Jorge Dómine 12/06/2025 12:30 • 

-- v2 HACED un procedimiento, que dado un ID del paciente, me diga cuántas ADMISIONES HA TENIDO y además EL NOMBRE COMPLETO (NOMBRE+APELLIDO)

DELIMITER $$


CREATE PROCEDURE contar_admisiones_v2 (IN ID_PACIENTE INT)
BEGIN
  -- instrucciones SQL ; 
  SELECT 
COUNT(*), p.nombre, p.apellido
  FROM
    admisiones a
JOIN pacientes p ON p.paciente_id = a.paciente_id
  WHERE
a.paciente_id = ID_PACIENTE
GROUP BY p.nombre, p.apellido;

END $$

DELIMITER ;

call contar_admisiones_v2(1);
call contar_admisiones_v2(0);

-- v alt usando parámetros de salida


DELIMITER $$


CREATE PROCEDURE contar_admisiones_valt (IN id_paciente INT, OUT num_admisiones INT, OUT nombre_completo VARCHAR(60))
BEGIN
  -- instrucciones SQL ; 
	SELECT COUNT(*) INTO num_admisiones
    FROM admisiones
    WHERE paciente_id = id_paciente;
    
    SELECT CONCAT(nombre, ' ' ,apellido) AS nombre_completo INTO nombre_completo
    FROM pacientes
    WHERE paciente_id = id_paciente;

END $$

DELIMITER ;

SET @num_admisiones = 0;
SET @nombre_completo = '';

call contar_admisiones_valt (1, @num_admisiones, @nombre_completo);

SELECT @num_admisiones AS num_admisiones, @nombre_completo AS nombre;

/* FUNCIONES
*/

-- PROGRAMOS UNA F() QUE NOS CALCULE LA EDAD DADA UNA FECHA DE NACIMIENTO

DELIMITER $$

CREATE FUNCTION calcular_edad (fecha_nacimiento DATE)
RETURNS INT -- indicamos el tipo devuelto
DETERMINISTIC -- indicamos el comportamiento: ante un mismo valor de entrada, el valor de salida es igual
BEGIN
	RETURN TIMESTAMPDIFF(YEAR,fecha_nacimiento,CURDATE());
END $$

DELIMITER ;

SELECT 
    nombre, apellido, CALCULAR_EDAD(fecha_nacimiento) AS edad
FROM
    pacientes 
ORDER BY edad ASC;

-- FUNCIÓN QUE DADO UN ID DE PACIENTE, DEVUELVA SU NOMBRE COMPLETO CONCATERNADO (NOMBRE+APELLIDO)

DELIMITER $$

CREATE FUNCTION obtener_nombre_completo (id_paciente INT)
RETURNS VARCHAR(100) -- indicamos el tipo devuelto
DETERMINISTIC -- indicamos el comportamiento: ante un mismo valor de entrada, el valor de salida es igual
READS SQL DATA -- cuando se accede a tablas
BEGIN
	DECLARE nombre_completo VARCHAR(100); -- declaro variable local
    
    SELECT CONCAT(nombre, ' ', apellido) INTO nombre_completo -- cálculo
    FROM pacientes
    WHERE paciente_id = id_paciente;
    
    RETURN nombre_completo;
END $$

DELIMITER ;

SELECT obtener_nombre_completo(paciente_id) AS nombre_completo, calcular_edad(fecha_nacimiento) FROM pacientes;

-- HACED UNA FUNCIÓN QUE CONVIERTA EL PESO DE UN PACIENTE DE NOTACIÓN KG.G A KG,G

DELIMITER $$

CREATE FUNCTION convertir_peso_a_notacion_coma (peso DECIMAL(4,1))
RETURNS VARCHAR(5) -- indicamos el tipo devuelto
DETERMINISTIC -- indicamos el comportamiento: ante un mismo valor de entrada, el valor de salida es igual
CONTAINS SQL -- usamos sql PERO no accedemos a tablas
BEGIN
	  -- DECLARE peso_convertido VARCHAR(5);
		RETURN REPLACE(CAST(peso AS CHAR), '.', ',');
END $$

DELIMITER ;

SELECT nombre, convertir_peso_a_notacion_coma(peso) FROM pacientes;
