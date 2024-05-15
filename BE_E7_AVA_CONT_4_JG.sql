use evaluacion_continua; 
-- AUTOR: JORDI GALI MANUEL
-- Consultes

-- 1. Total de Ventas por Producto:
-- Calcula el total de ventas para cada producto, ordenado de mayor a menor.
SELECT P.nombre AS producto, SUM(DP.cantidad * Pr.precio) AS total_ventas FROM Detalles_Pedidos DP 
-- construeix una taula amb nom producte i el total de vendes que es el preu del producte x la quantitat d'unitats venudes del producte
INNER JOIN Productos P ON DP.id_producto = P.id_producto -- junta la taula de detalles_pedidos amb taula Producto per id_producto
INNER JOIN Productos Pr ON DP.id_producto = Pr.id_producto -- junta la taula de detalles_pedidos amb taula Producto per id_producto
GROUP BY DP.id_producto, P.nombre ORDER BY total_ventas DESC; -- agrupa per id_oroducte i ordena per euros total de vendes de major a menor

-- 2. Último Pedido de Cada Cliente:
-- Identifica el último pedido realizado por cada cliente.
SELECT C.id_cliente, C.nombre AS nombre_cliente, P.id_pedido, P.fecha_pedido -- Construeix una taula amb id_client, nom_client, id_pedido i fecha_pedido
FROM Pedidos P INNER JOIN Clientes C ON P.id_cliente = C.id_cliente -- junta les taules de pedidos i de client per id_cliente
WHERE (P.id_cliente, P.fecha_pedido) IN (SELECT id_cliente, MAX(fecha_pedido) FROM Pedidos GROUP BY id_cliente) -- busca la data més recent de pedido per client
ORDER BY P.fecha_pedido DESC; -- Ordena per data de pedido de més recent a menys

-- 3. Número de Pedidos por Ciudad:
-- Determina el número total de pedidos realizados por clientes en cada ciudad.
SELECT C.ciudad, COUNT(P.id_pedido) AS total_pedidos FROM Clientes C -- Selecciona la Ciutat i conta les comandes de cada client
INNER JOIN Pedidos P ON C.id_cliente = P.id_cliente -- Junta les taules Clientes amb taula Pedidos per id_cliente
GROUP BY C.ciudad; -- agrupa per ciutat

-- 4. Productos que Nunca se Han Vendido:
-- Lista todos los productos que nunca han sido parte de un pedido.
SELECT P.nombre AS nombre_producto FROM productos P -- Selecciona el nom del prodcute de la taula productes
LEFT JOIN Detalles_Pedidos DP -- Fa una taula left join de productes amb detalles pedidos 
ON P.id_producto = DP.id_producto -- junta per id_producto (tots els productes menys els que estiguin en una comanda)
WHERE DP.id_producto IS NULL; -- selecciona els id_producte que no hi son a la taula detalles Pedidos

-- 5. Productos Más Vendidos por Cantidad:
-- Encuentra los productos más vendidos en términos de cantidad total vendida.
SELECT P.nombre, SUM(DP.cantidad) AS cantidad_total_vendida FROM Detalles_Pedidos DP -- Selecciona el nom del producte i suma la quantitat d'unitats de cada comanda
INNER JOIN Productos P ON DP.id_producto = P.id_producto -- junta les taules Detalles Pedidos amb Productos per id_producte
GROUP BY DP.id_producto, P.nombre ORDER BY cantidad_total_vendida DESC; -- Agrupa per nom producte i ordena de més quantitat venuda a menys

-- 6. Clientes con Compras en Múltiples Categorías:
-- Identifica a los clientes que han realizado compras en más de una categoría de producto.
SELECT id_cliente, nombre AS nombre_cliente -- Selecciona el client per id i nom de la taula clientes
FROM Clientes 
WHERE id_cliente IN -- fa una subconsulta 
	(SELECT P.id_cliente FROM Pedidos P -- Selecciona client de la taula pedidos
	INNER JOIN detalles_pedidos DP ON P.id_pedido = DP.id_pedido -- junta la taula pedidos amb la taula detalles pedidos per id_pedido
	INNER JOIN productos PR ON DP.id_producto = PR.id_producto -- junta la taula resultant amb la taula productos per id_producto
    GROUP BY P.id_cliente -- agrupa per id_cliente
    HAVING COUNT(DISTINCT PR.categoría) >1); -- selecciona les categories que apareixen més d'una vegada
-- M'agradaria imprimir quines categories o quantes categories diferents han comprat els clients

-- 7. Ventas Totales por Mes:
-- Muestra las ventas totales agrupadas por mes y año.
SELECT DATE_FORMAT(P.fecha_pedido, '%Y-%m') AS año_mes, -- Munta una taula amb l'any i el mes
SUM(DP.cantidad * Pr.precio) AS total_ventas FROM Pedidos P -- Prepara la suma dels imports de les comandes multiplicant el preu per la quantitat del producte
INNER JOIN detalles_pedidos DP ON P.id_pedido = DP.id_pedido -- junta la taula pedidos amb la taula detalles pedidos per id_pedido
INNER JOIN Productos Pr ON DP.id_producto = Pr.id_producto -- junta la taula resultant amb la taula productes per id_producto
GROUP BY DATE_FORMAT(P.fecha_pedido, '%Y-%m'), P.fecha_pedido -- agrupa les dates de les comandes per any i mes
ORDER BY P.fecha_pedido DESC; -- ordena per data de més recent a menys

-- 8. Promedio de Productos por Pedido:
-- Calcula la cantidad promedio de productos por pedido.

-- 9. Tasa de Retención de Clientes:
-- Determina cuántos clientes han realizado pedidos en más de una ocasión. 

-- 10. Tiempo Promedio entre Pedidos:
-- Calcula el tiempo promedio que pasa entre pedidos para cada cliente.
