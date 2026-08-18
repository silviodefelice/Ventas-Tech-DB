USE Ventas_Tech_DB;
GO

-- ============================================================
-- M5 - BUSINESS SQL QUERIES
-- Ventas_Tech_DB
-- TechStore - Coderhouse Data Analytics
-- ============================================================


-- ============================================================
-- QUERY 1: BASE PROJECT VIEW
-- ============================================================

SELECT
    v.fecha_venta AS fecha,
    c.nombre_cliente AS nombre_cliente,
    c.segmento AS segmento,
    t.region AS region,
    p.nombre_producto AS nombre_producto,
    p.categoria AS categoria,
    v.cantidad AS cantidad,
    v.precio_unitario AS precio_unitario,
    v.total_venta AS total_venta,
    v.canal AS canal
FROM dbo.ventas AS v
INNER JOIN dbo.clientes AS c
    ON v.id_cliente = c.id_cliente
INNER JOIN dbo.productos AS p
    ON v.id_producto = p.id_producto
LEFT JOIN dbo.territorios AS t
    ON c.id_territorio = t.id_territorio;

-- ============================================================
-- QUERY 2: CUSTOMERS WITHOUT SALES
-- ============================================================

SELECT
    c.nombre_cliente AS nombre_cliente,
    c.email AS email,
    c.fecha_registro AS fecha_registro
FROM dbo.clientes AS c
LEFT JOIN dbo.ventas AS v
    ON c.id_cliente = v.id_cliente
WHERE v.id_cliente IS NULL;

-- ============================================================
-- QUERY 3: PRODUCTS WITHOUT SALES
-- ============================================================

SELECT
    p.nombre_producto AS nombre_producto,
    p.categoria AS categoria,
    p.precio AS precio
FROM dbo.productos AS p
LEFT JOIN dbo.ventas AS v
    ON p.id_producto = v.id_producto
WHERE v.id_producto IS NULL;

-- ============================================================
-- QUERY 4: SALES CONSOLIDATED BY CHANNEL
-- ============================================================

SELECT
    canal,
    SUM(total_venta) AS total_facturado
FROM
(
    SELECT
        total_venta,
        'Online' AS canal
    FROM dbo.ventas
    WHERE canal = 'Online'

    UNION ALL

    SELECT
        total_venta,
        'Presencial' AS canal
    FROM dbo.ventas
    WHERE canal = 'Presencial'
) AS ventas_por_canal
GROUP BY canal
ORDER BY canal;

-- ============================================================
-- KEY FINDINGS
-- ============================================================

-- 1. Online sales generated the highest total revenue,
--    with 34,567.50 compared with 13,010.50 for Presencial sales.

-- 2. Roberto Díaz is the only registered customer
--    with no recorded sales.

-- 3. Pad Mouse XL is the only product in the catalog
--    with no recorded sales.

