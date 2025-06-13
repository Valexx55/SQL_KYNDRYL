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


DELIMITER $$

CREATE FUNCTION convertir_peso_a_notacion_coma_cast (peso DECIMAL(4,1))
RETURNS VARCHAR(5) -- indicamos el tipo devuelto
DETERMINISTIC -- indicamos el comportamiento: ante un mismo valor de entrada, el valor de salida es igual
CONTAINS SQL -- usamos sql PERO no accedemos a tablas
BEGIN
	    DECLARE peso_convertido VARCHAR(5);
		-- SET peso_convertido = REPLACE(CONCAT(peso, ''), '.', ',');
        SET peso_convertido = REPLACE(CAST(peso AS CHAR), '.', ',');
        RETURN peso_convertido;
END $$

DELIMITER ;

SELECT nombre, convertir_peso_a_notacion_coma_cast (peso) FROM pacientes;


/**
DISPARADORES
*/

DELIMITER $$
CREATE TRIGGER trg_calcular_imc
AFTER INSERT ON pacientes -- evento bajo el que se dispara esta función
FOR EACH ROW
BEGIN
	DECLARE imc_val DECIMAL(5,2);
    -- calculo = peso / altura * altura
    -- validación peso y altura no sean null ni cero
    IF NEW.peso IS NOT NULL AND NEW.altura IS NOT NULL AND NEW.altura >0 THEN
		SET imc_val = NEW.peso / (NEW.altura*NEW.altura);
	ELSE
		SET imc_val = NULL;
	END IF;
    
	IF imc_val IS NOT NULL THEN
		INSERT INTO imc_pacientes(paciente_id, imc)
        VALUES (NEW.paciente_id, imc_val);
	END IF;

END $$
DELIMITER ;

INSERT INTO pacientes (nombre, apellido, peso, altura) VALUES ('Juan', 'Pérez', 75, 1.70);

-- REGISTRAMOS OTRO DISPARADOR CUANDO SE ACTUALICE UN PACIENTE, QUE SE ACTUALICE TAMBIÉN SU IMC

DELIMITER $$
CREATE TRIGGER trg_actualizar_imc
AFTER UPDATE ON pacientes -- evento bajo el que se dispara esta función
FOR EACH ROW
BEGIN
	
    DECLARE imc_val DECIMAL(5,2);
	
    IF (NEW.peso <> OLD.peso OR NEW.altura <> OLD.altura)
    AND (NEW.peso IS NOT NULL AND NEW.altura IS NOT NULL AND NEW.altura >0)
    THEN
    	SET imc_val = NEW.peso / (NEW.altura*NEW.altura);
        
        -- ACTUALIZAMOS EL IMC_PACIENTES
        UPDATE imc_pacientes
        SET imc = imc_val, fecha_registro= CURRENT_TIMESTAMP 
        WHERE paciente_id = NEW.paciente_id;
        
        -- el update anterior, puede no tener efecto, por se un paciente modificado, que no contaba con cálculo de imc
        -- esto ocurre si el disparador se definió después de crear la tabla pacientes
        IF ROW_COUNT()=0 THEN -- debemos insertar el registros en imc_pacientes por el ser el primero
			INSERT INTO imc_pacientes (paciente_id, imc)
            VALUES (NEW.paciente_id, imc_val);
		END IF; -- SI INSERT EN VEZ DE UPDATE IMC_PACIENTES
	END IF; -- SI DATOS CORRECTOS O NUEVOS
		
    
END $$
DELIMITER ;

UPDATE pacientes 
SET peso = 80
WHERE paciente_id = 11;

-- ESCRIBIR OTRO DISPARADOR PARA QUE CUANDO SE BORRE UN PACIENTE, SE BORRE TAMBIÉN SU REGISTRO EN IMC_PACIENTES


DELIMITER $$
CREATE TRIGGER trg_eliminar_imc
BEFORE DELETE ON pacientes -- evento bajo el que se dispara esta función
FOR EACH ROW
BEGIN
	DELETE FROM imc_pacientes WHERE paciente_id = OLD.paciente_id;
END $$
DELIMITER ;

DELETE FROM pacientes WHERE paciente_id = 11;



-- TODO. hacemos un procedimiento para insertar una admisión (SUPONEMOS QUE EL PACIENTE EXISTE)



DELIMITER $$
CREATE PROCEDURE insertar_admision (IN p_diagnostico VARCHAR(50), IN id_paciente INT, IN id_doctor INT)
BEGIN
	INSERT INTO admisiones (fecha_admision, fecha_alta, diagnostico, paciente_id, doctor_id)
    VALUES (NOW(), NULL, p_diagnostico, id_paciente, id_doctor);
END $$
DELIMITER ;

call insertar_admision ('En observación', 1, 1);

-- VAMOS A HACER UN DISPARADOR, PARA VERIFICAR UNA NORMA DE NEGOCIO: A UN DOCTOR NO LE PODEMOS ASIGNAR MÁS DE DOS PACIENTES EN UN DÍA

DELIMITER $$
CREATE TRIGGER trg_limitar_asignaciones_doctor
BEFORE INSERT ON admisiones -- evento bajo el que se dispara esta función
FOR EACH ROW
BEGIN
	
    DECLARE num_admisiones_doctor INT;
    -- contabilzamos el número de admisiones en la fecha de admsión (hoy) para ese NEW.doctorid, hoy
    IF NEW.doctor_id IS NOT NULL THEN
		SELECT COUNT(*) INTO num_admisiones_doctor
		FROM admisiones
		WHERE doctor_id = NEW.doctor_id
		AND DATE(fecha_admision) = DATE(NEW.fecha_admision);
        
    -- si esas admisiones, son >= 2 "lanzamos una excepción" - emitr una señal 
		IF (num_admisiones_doctor >= 2) THEN
			SIGNAL SQLSTATE '45000' -- UN CÓDIGO DE ERROR PROPIO
            SET MESSAGE_TEXT = 'Error. El doctor ya tiene asignados a 2 pacientes en esa fecha';
		END IF;
	END IF;
    
END $$
DELIMITER ;

call insertar_admision ('En observación', 2, 1);

call insertar_admision ('En observación', 3, 1); -- debería saltar el fallo por la comprobación de negocio en el disparador
-- Error Code: 1644. Error. El doctor ya tiene asignados a 2 pacientes en esa fecha

-- todo GESTIONAR TRANASCCIÓN EN MÉTODO INSERTAR_ADMISIÓN 

SET autocommit = 1; -- modo por defecto 

SET autocommit = 0; -- DESACTIVO la confirmación automática, gestionar la transacción TX
START TRANSACTION;
INSERT INTO pacientes (nombre, apellido, peso, altura) VALUES ('Juan', 'Pérez', 75, 1.70);
INSERT INTO pacientes (nombre, apellido, peso, altura) VALUES ('Juan', 'Pérez', 75, 1.70);
INSERT INTO pacientes (nombre, apellido, peso, altura) VALUES ('Juan', 'Pérez', 75, 1.70);
ROLLBACK;  -- DESHAGO todas las operaciones desde el inicio de la TX
-- COMMIT; -- guardo los datos de verdad



DELIMITER $$
CREATE PROCEDURE insertar_admision_tx (IN p_diagnostico VARCHAR(50), IN id_paciente INT, IN id_doctor INT, OUT mensaje_salida VARCHAR(255))
BEGIN
	
    DECLARE codigo_error INT DEFAULT 0;
    DECLARE vsqlstate CHAR(5) DEFAULT '00000';
    DECLARE mensaje_error VARCHAR(255) DEFAULT '';

    -- SECCIÓN DE CAPTURA/TRATAMIENTO ERROR/EXCEPCIÓN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		
        GET DIAGNOSTICS CONDITION 1 -- obtengo información sobre el último error registrado (2, penúlitmo 3, ante..)
			codigo_error = MYSQL_ERRNO, -- COD error bd
            vsqlstate = RETURNED_SQLSTATE, -- MENASAJE propio
            mensaje_error = MESSAGE_TEXT; -- COD propio
            
            SET mensaje_salida = CONCAT('ERROR ', codigo_error, ' ' , mensaje_error, ' ' , vsqlstate); 
    
		ROLLBACK;
	END;
	
    START TRANSACTION; -- desactiva el autocommit 

	INSERT INTO admisiones (fecha_admision, fecha_alta, diagnostico, paciente_id, doctor_id)
    VALUES (NOW(), NULL, p_diagnostico, id_paciente, id_doctor);
    
    SET mensaje_salida = 'Inserción exitosa :)';
    
    COMMIT; -- CONFIRMO todas las modificaciones desde START tx
END $$
DELIMITER ;



SET @mensaje = '';
call insertar_admision_tx ('En observación', 2, 4, @mensaje);
SELECT @mensaje;


SET @mensaje = '';
call insertar_admision_tx ('En observación', 2, 1, @mensaje);
SELECT @mensaje;




EXPLAIN ANALYZE SELECT 
    COUNT(*) AS num_pacientes_grupo,
    FLOOR(peso / 10) * 10 AS grupo_peso -- CUANDO TENGO un índice que se usa dentro de una f(), Mysql no lo usa
FROM
    pacientes
GROUP BY grupo_peso;

-- 1) OPTIMIZO, PRECALCUPAR EL GRUPO_PESO . add un columna EXTRA, dato agregado

ALTER TABLE pacientes ADD COLUMN grupo_peso INT GENERATED ALWAYS AS (FLOOR(peso / 10) * 10) STORED;

-- 2) CREAR UN ÍNDICE SOBRE ESE DATO AGREGADO

CREATE INDEX idx_grupo_peso ON pacientes(grupo_peso);

-- 3) REFORMULAR LA CONSULTA

SELECT 
    COUNT(*) AS num_pacientes_grupo, grupo_peso -- CUANDO TENGO un índice que se usa dentro de una f(), Mysql no lo usa
FROM
    pacientes
GROUP BY grupo_peso;



EXPLAIN ANALYZE SELECT 
    COUNT(*) AS num_pacientes_grupo, grupo_peso -- CUANDO TENGO un índice que se usa dentro de una f(), Mysql no lo usa
FROM
    pacientes
GROUP BY grupo_peso;


EXPLAIN SELECT 
    COUNT(*) AS num_pacientes_grupo,
    FLOOR(peso / 10) * 10 AS grupo_peso
FROM
    pacientes
GROUP BY grupo_peso;



-- OPTIMIZACIÓN "ALERGIA MÁS CÓMUN"

SELECT 
    alergias.nombre, 
    COUNT(*) AS num_pacientes
FROM
    pacientes_alergias
JOIN
    alergias ON pacientes_alergias.alergia_id = alergias.alergias_id
GROUP BY 
    alergias.nombre
ORDER BY 
    num_pacientes DESC
LIMIT 1;



EXPLAIN SELECT 
    alergias.nombre, 
    COUNT(*) AS num_pacientes
FROM
    pacientes_alergias
JOIN
    alergias ON pacientes_alergias.alergia_id = alergias.alergias_id
GROUP BY 
     alergias.nombre
ORDER BY 
    num_pacientes DESC
LIMIT 1;

-- 1 OPTIMIZO UN POCO SI AGRURPO POR LA Pk
-- AGRUPAR EN SUBONSULTAS - 1º AGRUPO Y 2 ORDENO



EXPLAIN SELECT nombre, num_pacientes
FROM (
    SELECT 
        a.alergias_id,
        a.nombre, 
        COUNT(*) AS num_pacientes
    FROM pacientes_alergias pa
    JOIN alergias a ON pa.alergia_id = a.alergias_id
    GROUP BY a.alergias_id, a.nombre -- 1 agrupa
) AS sub
ORDER BY num_pacientes DESC -- 2 ordena
LIMIT 1;










