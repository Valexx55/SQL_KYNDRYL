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
	
-- NOMBRE DE LOS PACIENTES QUE TIENEN ALERGIA, USANDO UN RIGHT JOIN

SELECT DISTINCT
    p.nombre
FROM
    pacientes p -- tabla A
        RIGHT JOIN
    pacientes_alergias pa ON p.paciente_id = pa.paciente_id; -- tabla B
    
-- mostrar el número total de pacientes, de hombres y de mujeres (3 columnas), usando COUNT y SUM

-- TODO ANALIZAR LA OPTIMALIDAD DE ESTA CONSULTA, COMPARADA CON LA SIGUENTE
SELECT 
  count(*) AS TOTAL_PACIENTES,
  (SELECT COUNT(*) FROM pacientes WHERE genero = "M") AS TOTAL_HOMBRES,
  (SELECT COUNT(*) FROM pacientes WHERE genero = "F") AS TOTAL_MUJERES
FROM
  pacientes;


SELECT 
  COUNT(*) AS total_pacientes,
  SUM(CASE WHEN genero = 'M' THEN 1 ELSE 0 END)  AS total_pacientes,
  SUM(CASE WHEN genero = 'F' THEN 1 ELSE 0 END) AS total_pacientes
FROM
  pacientes;
  
-- listado de alergias agrupado por el nombre y el número de pacinetes que la tienen

-- 1 QUÉ DATOS ME PIDE
-- 2 de qué tablas
-- 3 los agrupo (SI HE COMBINADO f() agregación con un dato NO agregado)

SELECT 
    alergias.nombre, COUNT(*) AS num_pacientes
FROM
    pacientes_alergias
        JOIN
    alergias ON pacientes_alergias.alergia_id = alergias.alergias_id; -- sin el GROUP BY, no tiene sentido. Deshabilitado por defecto
    
SELECT 
    alergias.nombre, COUNT(*) AS num_pacientes
FROM
    pacientes_alergias
        JOIN
    alergias ON pacientes_alergias.alergia_id = alergias.alergias_id
GROUP BY alergias.nombre;
    
-- Error Code: 1140. In aggregated query without GROUP BY, expression #1 of SELECT list contains nonaggregated column 'hospital_kyndryl.alergias.nombre'; this is incompatible with sql_mode=only_full_group_by

SELECT @@sql_mode;

-- deshabilito la restrcción del GROUP BY al combinar datos agregados con no
SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));


-- QUÉ PROVINCIAS (nombre) TENGO CON MÁS DE DOS PACIENTES
-- 1 QUÉ DATOS
-- 2 DE QUÉ TABLAS
-- 3 CÓMO LOS AGRUPO
-- 4 ORDENAR
-- 5 FILTRO (HAVING/LIMIT)

SELECT 
    provincias.nombre, COUNT(*) AS num_pacientes
FROM
    provincias
        JOIN
    poblaciones ON provincias.provincia_id = poblaciones.poblacion_id
        JOIN
    pacientes ON pacientes.poblacion_id = poblaciones.poblacion_id
GROUP BY provincias.nombre
HAVING num_pacientes > 2;




-- Dado un id de paciente (como parámetros) haced una consulta que me diga cuántas admisiones ha tenido ese paciente en el último mes
-- PISTA_ COUNT, DATE_SUB (restar fechas) CURDATE (fecha actual)


SET @idpaciente :=1;
SELECT 
    COUNT(*) AS ingresos_ultimo_mes
FROM
    admisiones
WHERE
    (admisiones.paciente_id = @idpaciente)
        AND (admisiones.fecha_admision >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)); -- admision ultimo es si fecha admision >= fecha actual, menos 1 mes
	
-- Jorge Dómine 11/06/2025 10:36 • 

SET @ID := 1;
SELECT 
    COUNT(fecha_admision) AS ingresos_ultimo_mes_to_days
FROM
    admisiones a
WHERE
    a.paciente_id = @ID
        AND TO_DAYS(CURDATE()) - TO_DAYS(fecha_admision) <= 30; -- ojo que estamos entendiendo 1 mes como 30 días
        
SELECT (CURDATE() - '2024-05-20');

-- mostrar el id, la altura y peso de un paciente, informando además si tiene sobrepeso con un flag/booleano 0-1
-- entendmos que alguien tiene sobrepeso si su IMC es >= 25 índice de masa coporal = PESO (kg) / ALTURA(m) * ALTURA(m)
-- DATO AGREGADO

SELECT 
    paciente_id, 
    altura, 
    peso,
	(peso / (POWER(altura, 2))) >= 25 AS sobrepeso
FROM
    pacientes;
    
SELECT 
    paciente_id,
    altura,
    peso,
    (CASE
        WHEN (peso / POWER(altura, 2) >= 25) THEN 1
        ELSE 0
    END) AS sobrepeso
FROM
    pacientes
ORDER BY sobrepeso DESC; -- me salen primero los de sobrepeso = 1 -- ASC;


SELECT 
    paciente_id,
    altura,
    peso,
    IF(peso / POWER(altura, 2) >= 25, 'SÍ', 'NO') AS sobrepeso
FROM
    pacientes
ORDER BY sobrepeso DESC; -- me salen primero los de sobrepeso = 1 -- ASC;

/** listar los pacientes agrupados en el rango de peso de en 10 en 10 y de menor a mayor
 P EJ: 3 pacientes 50 kg (50-59)
       5 pacientes 60 kg (60-69)
       ...
**/

-- Jorge Dómine 11/06/2025 12:18 • 
SELECT 
    COUNT(*),
    CASE
        WHEN p.peso < 50 THEN '1 MENOR DE 50Kg'
        WHEN p.peso >= 50 AND p.peso < 60 THEN '2 ENTRE 50Kg y 60Kg'
        WHEN p.peso >= 60 AND p.peso < 70 THEN '3 ENTRE 60Kg y 70Kg'
        WHEN p.peso >= 70 AND p.peso < 80 THEN '4 ENTRE 70Kg y 80Kg'
        WHEN p.peso >= 80 AND p.peso < 90 THEN '5 ENTRE 80Kg y 90Kg'
        ELSE '6 MAYOR DE 90Kg'
    END AS GRUPO
FROM
    pacientes p
GROUP BY GRUPO
ORDER BY GRUPO;

-- Victor Manuel Martin Rodriguez 11/06/2025 12:23 • 
SELECT 
  paciente_id, 
  nombre, 
  altura, 
  peso,
  CASE
WHEN peso BETWEEN 50 AND 59 THEN '50-59'
WHEN peso BETWEEN 60 AND 69 THEN '60-69'
WHEN peso BETWEEN 70 AND 80 THEN '70-80'
    ELSE 'Otro'
  END AS rango_peso
FROM pacientes
WHERE peso BETWEEN 50 AND 80
ORDER BY peso ASC;


-- Pablo Muñoz Medina 11/06/2025 12:17 • 
SELECT 
	COUNT(*) AS total_pacientes,
    FLOOR(p.peso / 10) * 10 AS rango_peso -- hace que todos los pacientes de la misma decena, se queden el mismo grupo 5X -> 50 / 6X -> 60, etc
FROM
    pacientes p
GROUP BY rango_peso
ORDER BY rango_peso;


/**
-- 1 QUÉ DATOS
-- 2 DE QUÉ TABLAS - JOIN
-- 3 CÓMO LOS AGRUPO
-- 4 ORDENAR
-- 5 FILTRO (HAVING/LIMIT)*/

-- BASÁNDONOS EN ESTA CONSULTA: las alerigas, agrupadas por su frecuencia de aparición
-- SACAMOS LA ALERGIA MÁS COMÚN

SELECT 
    alergias.nombre, COUNT(*) AS num_pacientes
FROM
    pacientes_alergias
        JOIN
    alergias ON pacientes_alergias.alergia_id = alergias.alergias_id
GROUP BY alergias.nombre
ORDER BY num_pacientes DESC
LIMIT 1;

-- ALERGIA MENOS COMÚN

SELECT 
    alergias.nombre, COUNT(*) AS num_pacientes
FROM
    pacientes_alergias
        JOIN
    alergias ON pacientes_alergias.alergia_id = alergias.alergias_id
GROUP BY alergias.nombre
ORDER BY num_pacientes ASC
LIMIT 1; -- funciona pero en caso de empate, me da solo el primero / el mayor o el menor

-- EL NÚMERO DE ADMISIONES POR PROVINCIA, ORDENADOR POR EL NÚMERO DE ADMISIONES y el NOMBRE DE LA PROVINCIA
/*
1) QUÉ DATOS QUIERO (AGREGADOS)
2) DE QUÉ TABLAS (JOINS)
3) CÓMO AGRUPO
4) CÓMO ORDENO
5) FILTRO (no aplica)
*/

-- Jorge Dómine 11/06/2025 12:48 • 
SELECT 
    pr.nombre AS PROVINCIA, 
    COUNT(*) AS NUM_ADMISIONES
FROM
    admisiones ad
        JOIN
    pacientes pa ON pa.paciente_id = ad.paciente_id
        JOIN
    poblaciones po ON po.poblacion_id = pa.poblacion_id
        JOIN
    provincias pr ON pr.provincia_id = po.provincia_id
GROUP BY pr.nombre
ORDER BY NUM_ADMISIONES DESC, PROVINCIA ASC;



-- PLANTEAMOS LA ALERGIA MÁS COMÚN (RESOLVIENDO EL CASO DE EMPATE) - SUBCONSULTAS


-- SUBCONSULTA 1: las veces que aparece una alergia - necesito identificarlas con un alias
-- SUBCONSULTA 2: las máxima frecuencia de una alergia - - necesito identificarlas con un alias
-- NOS QUEDAMOS CON LOS RESULTADOS DE LA SUBCONSULTA 1 CUYO NÚMERO DE VECES SEA IGUAL AL DATO EN LA SUBCONSULTA 2


-- SUBCONSULTA 1: las veces que aparece una alergia - necesito identificarlas con un alias
SELECT alergias.nombre, COUNT(*) AS cantidad
FROM alergias
JOIN pacientes_alergias ON alergias.alergias_id = pacientes_alergias.alergia_id
GROUP BY alergias.nombre, pacientes_alergias.alergia_id;

-- SUBCONSULTA 2: las máxima frecuencia de una alergia - - necesito identificarlas con un alias
SELECT 
    MAX(cantidad)
FROM
    (SELECT 
        COUNT(*) AS cantidad
    FROM
        pacientes_alergias
    GROUP BY alergia_id) AS subconsulta2;



-- 
SELECT 
		alergia_id,
        COUNT(*) AS cantidad
    FROM
        pacientes_alergias
    GROUP BY alergia_id;


SELECT 
    nombre, cantidad
FROM
    (SELECT 
        alergias.nombre, COUNT(*) AS cantidad
    FROM
        alergias
    JOIN pacientes_alergias ON alergias.alergias_id = pacientes_alergias.alergia_id
    GROUP BY alergias.nombre , pacientes_alergias.alergia_id) AS subonconsulta1
WHERE
    cantidad = (SELECT 
            MAX(cantidad)
        FROM
            (SELECT 
                COUNT(*) AS cantidad
            FROM
                pacientes_alergias
            GROUP BY alergia_id) AS subconsulta2);

-- misma solución anterior pero con CTE - Common Table Expressions - "CONSULTAS COMO TABLAS TEMPORALES"

WITH conteo_alergias AS (
	SELECT -- SUBCONSULTA 1: SABEMOS LA ALERGIA Y EL NÚMERO DE VECES QUE SE PADECE
		a.nombre,
		COUNT(*) AS cantidad
	FROM pacientes_alergias pa
    JOIN alergias a ON a.alergias_id = pa.alergia_id
    GROUP BY a.nombre
), cantidad_maxima AS ( -- SUBCONSULTA 2: SABER EL MÁXIMO DE VECES QUE APARECE UNA ALERGIA (LA QUE SEA)
	SELECT MAX(cantidad) AS max_cantidad
    FROM conteo_alergias
)
SELECT -- PARTE 3, FILTRO Y DIGO: QUÉDATE DE LA SUBCONSULTA 1 LOS REGISTROS (LAS ALAERGIAS)  QUE CUMPLAN LA SUBCONSULTA 2 (QUE APARECEN EL MÁXIMO DE VECES)
	ca.nombre,
    ca.cantidad
FROM conteo_alergias
JOIN cantidad_maxima cm ON cm.max_cantidad = ca.cantidad;


-- qué paciente (id, noMbre y apellido) y los días que ha estado ingresado un paciente. Nos quedamos con el máximo
-- 1 SIN CTES

/**
Jorge Dómine 11/06/2025 14:23 • datediff(COALESCE(ad.fecha_alta, curdate()), ad.fecha_admision)
*/

SELECT 
    p.paciente_id,
    p.nombre,
    p.apellido,
    SUM(DATEDIFF(IF(a.fecha_alta IS NOT NULL,
                        a.fecha_alta,
                        CURDATE()),
                    a.fecha_admision)) AS dias_totales
FROM
    admisiones a
        JOIN
    pacientes p ON a.paciente_id = p.paciente_id
GROUP BY p.paciente_id , p.nombre , p.apellido
ORDER BY dias_totales DESC
LIMIT 1; -- todo: MEJORAR EL CASO DE EMPATES (cts) Y probar la función COALESCE - para trabajo condicional con nulos
    



-- 2 CTES
-- 1 saco el maximo de dias
-- 2 saco los pacientes y su días
-- 3 filtro los pacientes de 2, que cumplen el 1



