USE Ventas_Tech_DB;
GO

-- ============================================================
-- M4 - BUSINESS SQL QUERIES
-- Ventas_Tech_DB
-- TechStore - Coderhouse Data Analytics
-- ============================================================


-- ============================================================
-- QUERY 1: EXECUTIVE MONTHLY SUMMARY
-- ============================================================

SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) / COUNT(*) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY MONTH(fecha_venta);


-- ============================================================
-- QUERY 2: PRODUCT RANKING
-- ============================================================

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;


-- ============================================================
-- QUERY 3: RECURRING CUSTOMERS
-- ============================================================

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY cantidad_pedidos DESC;


-- ============================================================
-- QUERY 4: MONTHS ABOVE/BELOW AVERAGE
-- ============================================================

WITH resumen_mensual AS (
    SELECT
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado > AVG(total_facturado) OVER ()
            THEN 'Por encima'
        WHEN total_facturado < AVG(total_facturado) OVER ()
            THEN 'Por debajo'
        ELSE 'Igual al promedio'
    END AS comparacion_promedio
FROM resumen_mensual
ORDER BY mes;


-- ============================================================
-- KEY FINDINGS
-- ============================================================

-- 1. Total invoiced sales for March amounted to 6,444.00.

-- 2. Product 1 generated the highest total invoiced amount,
--    with 3,600.00.

-- 3. Product 2 had the highest number of units sold, with 13 units,
--    but generated only 364.00 in total invoiced sales.