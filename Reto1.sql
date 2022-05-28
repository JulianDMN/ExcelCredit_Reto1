--Se crea una consulta a la tabla con las siguientes subconsultas
WITH 
--Relaciona departamento y municipio
mun AS(
	SELECT 
		DISTINCT municipio, 
		departamento
	FROM hurtos
),
--Relaciona los municipios y la cantidad de hurtos en estos
cantidad_hurtos AS (
	SELECT 
		municipio, 
		COUNT(cantidad) as hurtos_municipio
	FROM hurtos GROUP BY municipio
),
--Relaciona los departamentos y la cantidad de hurtos en estos
cantidad_hurtos_departamento AS(
	SELECT
		departamento,
		COUNT(cantidad) as hurtos_departamento
	FROM hurtos GROUP BY departamento
),
--Calcula los hurtos totales en el país
cantidad_hurtos_totales AS(
	SELECT
		COUNT(*) AS hurtos_totales
	FROM hurtos
)

--Muestra el query obtenido
SELECT mun.departamento,
	ch.municipio,
	ch.hurtos_municipio,
	hd.hurtos_departamento,
	ht.hurtos_totales,
	CAST (ch.hurtos_municipio AS REAL)/CAST (hd.hurtos_departamento AS REAL) * 100 as porcentaje_municipio_departamento,
	CAST (hd.hurtos_departamento AS REAL)/CAST (ht.hurtos_totales AS REAL) * 100 as porcentaje_departamento_total
FROM cantidad_hurtos ch

--Combina los registros
LEFT JOIN mun
	ON ch.municipio = mun.municipio
LEFT JOIN cantidad_hurtos_departamento hd
	ON mun.departamento = hd.departamento
JOIN cantidad_hurtos_totales ht
	on mun.departamento = mun.departamento
ORDER BY mun.departamento, mun.municipio