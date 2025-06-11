/*
CONSULTAS BÁSICAS
*/
USE hospital_kyndryl;

-- SELECCIONO TODOS LOS CAMPOS DE TODOS LOS REGISTROS
SELECT 
    *
FROM
    pacientes;

-- selecciono el nombre, el id el género de los pacientes
SELECT 
    paciente_id, nombre, genero
FROM
    pacientes;

-- SELECCIONO todos los atributos de TODOS LOS PACIENTES QUE SEAN HOMBRES
SELECT 
    *
FROM
    pacientes
WHERE
    genero = 'M';
    
-- SELECCIONO todos los atributos de TODOS LOS PACIENTES cuyo nombre empiece por la letra C 

SELECT 
    *
FROM
    pacientes
WHERE
    nombre LIKE 'C%'; -- '%a%'; para los que contenga a
    
SELECT 
    *
FROM
    pacientes
WHERE
    substr(nombre, 1, 1)='C';

-- Error Code: 1146. Table 'hospital_kyndryl.pacienetes' doesn't exist

-- SELECCIONAR LOS PACIENTES CUYO PESO ESTÉ ENTRE 70 Y 90 KG

-- Pablo Muñoz Medina 10/06/2025 10:59 • 
SELECT 
    *
FROM
    pacientes
WHERE
    peso BETWEEN 70 AND 90;
    
SELECT 
    *
FROM
    pacientes
WHERE
    peso >= 70 AND peso <= 90;

-- seleccionar el nombre y apellido de los pacientes, bajo un mismo campo llamado nombre completo
SELECT 
    CONCAT(nombre, ' ' ,apellido) AS nombre_completo -- alias
FROM
    pacientes;
    
SELECT @@sql_mode; -- EL MODO una serie de parámetros que condicionan el funcionamiento de la base de datos

-- 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION'

-- si quiero que la concatenación funcione como el otros SGBDR puedo modificar el modo, añadiendo PIPES_AS_CONCAT
SET sql_mode = CONCAT(@@sql_mode, ',PIPES_AS_CONCAT');

-- SI QUISIERA configurar un modo/ configuración predeterminada, podría modificiar el fichero /etc/mysql/mysql.conf.d/mysql.cnf ( en Windows en my.ini)
/**
[mysqld]
sql_mode=PIPES_AS_CONCAT,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION
*/


SELECT 
    nombre || ' ' || apellido AS nombre_completo -- por defecto esta alternativa no fucniona
FROM
    pacientes;

-- seleccionar todos los pacientes nacidos en 1980. Dejar el año como parámetro

SET @anio := 1980;
SELECT 
    *
FROM
    pacientes
WHERE
    YEAR(fecha_nacimiento) = @anio;
    
-- queremos saber cuántos han nacido en el 2000 o más jóvenes

SET @anio := 2000;
SELECT 
    COUNT(*) AS num_millenials
FROM
    pacientes
WHERE
    YEAR(fecha_nacimiento) >= @anio;
    
SET @anio := 2000;
SELECT 
    COUNT(*) AS num_millenials
FROM
    pacientes
WHERE
    SUBSTRING(fecha_nacimiento, 1, 4) >= @anio;




-- FUNCIONES DE AGREGACIÓN

-- hacemos una consulta para saber cuántas especialidades ofrecen los doctores de mi hospital
SELECT 
    COUNT(especialidad) AS num_especialidades_repetidas
FROM
    doctores;

SELECT 
    COUNT(DISTINCT especialidad) AS num_especialidades_sin_repeticion
FROM
    doctores;

-- HACED UNA CONSULTA QUE ME DIGA EL PESO MEDIO DE LOS PACIENTES (CON 1 DECIMAL)    

-- Ana Galán 10/06/2025 12:43 • 
SELECT 
    ROUND(AVG(peso), 1) AS peso_medio
FROM
    pacientes;
    
-- Jorge Dómine 10/06/2025 12:44 • 
SELECT 
    CAST(AVG(peso) AS DECIMAL (3 , 1 )) AS PESO_MEDIO,
    CAST(AVG(altura) AS DECIMAL (3 , 1 )) AS ALTURA_MEDIA
FROM
    pacientes;    

-- HACED UNA CONSULTA QUE ME DIGA LA ESTATURA MEDIA DE LOS PACIENTES EN CM (CON 1 DECIMAL)

SELECT 
    ROUND(AVG(altura) * 100, 1) AS estatura_media_en_cm
FROM
    pacientes;


-- obtener la diferencia mayor entre el peso máximo y mínimo de los pacientes

SELECT 
    MAX(peso) - MIN(peso)
FROM
    pacientes;
    
    
    
-- SELECCIONAMOS EL NOMBRE Y EL ID DE LOS PACIENTES QUE SEAN DE GETAFE

-- 1) selecciono el id de la poblacion de getafe
-- 2) selecciono los pacinentes cuyo id de población, sea el de 1)

SELECT 
    pa.paciente_id, pa.nombre
FROM
    pacientes pa
WHERE
    pa.poblacion_id = (SELECT  -- uso = si sé que la subconsulta me da un solo valor
            poblacion_id
        FROM
            poblaciones pob
        WHERE
            pob.nombre = 'Getafe');
            
-- SELECCIONAMOS EL NOMBRE Y EL ID DE LOS PACIENTES QUE SEAN DE GETAFE o de MISLATA

-- 1) selecciono los ids de la poblacion de getafe  y mislata
-- 2) selecciono los pacinentes cuyo id de población, estén en el 1)

SELECT 
    pa.paciente_id, pa.nombre
FROM
    pacientes pa
WHERE
    pa.poblacion_id IN (SELECT -- si tengo varios valores en la subconsulta
            poblacion_id
        FROM
            poblaciones pob
        WHERE
            pob.nombre = 'Getafe' OR pob.nombre = 'Mislata');


-- JOINS

-- SELECCIONAMOS LOS NOMBRES DE LOS PACIENTES Y SU ID DE ALERGIA (EN CASO QUE TENGAN ALGUNA)
-- SI EL PACIENTE NO TIENE ALERGIA, NO DEBE APARECER. USAD ALGÚN TIPO DE JOIN

SELECT 
    p.nombre, pa.pacientes_alergias_id
FROM
    pacientes p
       JOIN -- INNER JOIN es idéntico
    pacientes_alergias pa ON p.paciente_id = pa.paciente_id;
    
SELECT 
    p.nombre, pa.pacientes_alergias_id
FROM
    pacientes p
        INNER JOIN -- IGUAL QUE PONER JOIN SOLO
    pacientes_alergias pa ON p.paciente_id = pa.paciente_id;
    
SELECT 
    p.nombre, pa.pacientes_alergias_id
FROM
    pacientes p
        LEFT JOIN 
    pacientes_alergias pa ON p.paciente_id = pa.paciente_id;
    
SELECT 
    p.paciente_id, p.nombre
FROM
    pacientes p
WHERE
    p.paciente_id NOT IN (SELECT 
            DISTINCT pa.paciente_id
        FROM
            pacientes_alergias pa);
            
-- 	QUIERO LOS PACIENTES, QUE NO TIENE ALERGIA. HACEDLO CON JOIN

SELECT 
    p.nombre
FROM
    pacientes p
        LEFT JOIN
    pacientes_alergias pa ON p.paciente_id = pa.paciente_id
WHERE
    pa.paciente_id IS NULL;
    
-- SELECCIONAMOS LOS NOMBRES DE LOS PACIENTES Y EL NOMBRE DE SUS ALERGIAS

SELECT 
    p.nombre, a.nombre 
FROM
    pacientes p
       JOIN -- INNER JOIN es idéntico
    pacientes_alergias pa ON p.paciente_id = pa.paciente_id
		JOIN
	alergias a ON pa.alergia_id = a.alergias_id;
