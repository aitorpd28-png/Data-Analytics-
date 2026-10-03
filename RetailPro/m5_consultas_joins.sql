USE Ventas_Tech_DB;
GO

-- =============================================
-- M5 - CONSULTAS CON JOINS
-- Proyecto RetailPro
-- =============================================


-- =============================================
-- CONSULTA 1: VISTA BASE DEL PROYECTO
-- =============================================

SELECT
    v.fecha_venta,
    v.id_cliente,
    c.nombre AS nombre_cliente,
    c.ciudad,
    v.id_producto,
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta
FROM ventas AS v
INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos AS p
    ON v.id_producto = p.id_producto
INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta;

-- =============================================
-- CONSULTA 2: CLIENTES SIN VENTAS
-- =============================================

SELECT
    c.nombre AS nombre_cliente,
    c.email,
    c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- =============================================
-- CONSULTA 3: PRODUCTOS SIN VENTAS
-- =============================================

SELECT
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos AS p
LEFT JOIN ventas AS v
    ON p.id_producto = v.id_producto
INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria
WHERE v.id_venta IS NULL;

-- =============================================
-- CONSULTA 4: CONSOLIDADO POR CANAL
-- =============================================

SELECT
    canal,
    COUNT(*) AS cantidad_ventas,
    SUM(total_venta) AS total_facturado
FROM (
    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total_venta,
        'Tramo 1' AS canal
    FROM ventas
    WHERE fecha_venta <= '2024-03-10'

    UNION ALL

    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total_venta,
        'Tramo 2' AS canal
    FROM ventas
    WHERE fecha_venta > '2024-03-10'
) AS ventas_por_canal
GROUP BY canal
ORDER BY canal;