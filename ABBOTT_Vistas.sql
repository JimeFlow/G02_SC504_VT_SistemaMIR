/*CREADO POR: Grupo 2
FECHA: 20/03/2025
PROYECTO FINAL: Avance 02 con el Esquema ABBOTT*/

--================================== VISTAS ==================================--

-- 1. Vista para mostrar materiales por estado
CREATE OR REPLACE VIEW VISTA_MATERIALES_ESTADO AS
SELECT 
    m.Id_Material,
    m.Nombre,
    m.Fecha_Vencimiento,
    m.Cantidad_Disponible,
    e.Descripcion AS Estado
FROM 
    MATERIALES m
JOIN 
    ESTADO e ON m.Estado_Id = e.Estado_Id;

-- Para verla SELECT * FROM VISTA_MATERIALES_ESTADO;



-- 2. Vista para mostrar ingresos recientes
CREATE OR REPLACE VIEW VISTA_INGRESOS_RECIENTES AS
SELECT 
    i.Id_Ingreso,
    m.Nombre AS Material,
    i.Cantidad_Recibida,
    i.Fecha_Ingreso
FROM 
    INGRESOS i
JOIN 
    MATERIALES m ON i.Id_Material = m.Id_Material
WHERE 
    i.Fecha_Ingreso > SYSDATE - 30;  -- Filtramos los ingresos de los últimos 30 días

-- Para verla SELECT * FROM VISTA_INGRESOS_RECIENTES;



-- 3. Vista para mostrar reportes por usuario
CREATE OR REPLACE VIEW VISTA_REPORTES_USUARIO AS
SELECT 
    r.Id_Reporte,
    u.Nombre AS Usuario,
    r.Descripcion AS Reporte_Descripcion,
    e.Descripcion AS Estado
FROM 
    REPORTES r
JOIN 
    Personal u ON r.Id_Usuario = u.Id_Usuario
JOIN 
    ESTADO e ON r.Estado_Id = e.Estado_Id;

-- Para verla SELECT * FROM VISTA_REPORTES_USUARIO;



-- 4. Vista para mostrar tareas pendientes
CREATE OR REPLACE VIEW VISTA_TAREAS_PENDIENTES AS
SELECT 
    t.Id_Tarea,
    t.Nombre,
    t.Fecha_Recibido,
    e.Descripcion AS Estado
FROM 
    TAREAS t
JOIN 
    ESTADO e ON t.Estado_Id = e.Estado_Id
WHERE 
    e.Descripcion <> 'Completado';  -- Filtramos solo tareas que no estén completadas

--Para verla SELECT * FROM VISTA_TAREAS_PENDIENTES;



-- 5. Vista para mostrar ingresos por material
CREATE OR REPLACE VIEW VISTA_INGRESOS_POR_MATERIAL AS
SELECT 
    m.Nombre AS Material,
    i.Cantidad_Recibida,
    i.Fecha_Ingreso
FROM 
    INGRESOS i
JOIN 
    MATERIALES m ON i.Id_Material = m.Id_Material;

-- Para verla SELECT * FROM VISTA_INGRESOS_POR_MATERIAL;



-- 6. Vista para mostrar materiales con cantidad disponible y solicitada
CREATE OR REPLACE VIEW VISTA_MATERIALES_CANTIDAD AS
SELECT 
    m.Nombre AS Material,
    m.Cantidad_Disponible,
    m.Cantidad_Solicitada
FROM 
    MATERIALES m;


-- Para verla SELECT * FROM VISTA_MATERIALES_CANTIDAD;



-- 7. Vista para mostrar reportes por estado
CREATE OR REPLACE VIEW VISTA_REPORTES_ESTADO AS
SELECT 
    r.Id_Reporte,
    r.Descripcion AS Reporte_Descripcion,
    e.Descripcion AS Estado
FROM 
    REPORTES r
JOIN 
    ESTADO e ON r.Estado_Id = e.Estado_Id;

-- Para verla SELECT * FROM VISTA_REPORTES_ESTADO;



-- 8. Vista para mostrar materiales próximos a vencerse
CREATE OR REPLACE VIEW VISTA_MATERIALES_VENCIMIENTO AS
SELECT 
    m.Nombre AS Material,
    m.Fecha_Vencimiento,
    CASE 
        WHEN m.Fecha_Vencimiento < SYSDATE THEN 'Vencido'
        WHEN m.Fecha_Vencimiento BETWEEN SYSDATE AND SYSDATE + 30 THEN 'Próximo a Vencer'
        ELSE 'Válido'
    END AS Estado_Vencimiento
FROM 
    MATERIALES m;

-- Para verla SELECT * FROM VISTA_MATERIALES_VENCIMIENTO;



-- 9. Vista para mostrar tareas recibidas por usuario
CREATE OR REPLACE VIEW VISTA_TAREAS_POR_USUARIO AS
SELECT 
    t.Id_Tarea,
    t.Nombre AS Tarea,
    t.Fecha_Recibido,
    u.Nombre AS Usuario,
    e.Descripcion AS Estado
FROM 
    TAREAS t
JOIN 
    Personal u ON t.UPI = u.UPI
JOIN 
    ESTADO e ON t.Estado_Id = e.Estado_Id;


-- Para verla SELECT * FROM VISTA_TAREAS_POR_USUARIO;



-- 10. Vista para mostrar materiales con baja cantidad disponible
CREATE OR REPLACE VIEW VISTA_MATERIALES_BAJA_CANTIDAD AS
SELECT 
    m.Nombre AS Material,
    m.Cantidad_Disponible
FROM 
    MATERIALES m
WHERE 
    m.Cantidad_Disponible < 10;  -- Umbral de 10 unidades

-- Para verla SELECT * FROM VISTA_MATERIALES_BAJA_CANTIDAD;



-- 11. Vista para mostrar tareas completadas
CREATE OR REPLACE VIEW VISTA_TAREAS_COMPLETADAS AS
SELECT 
    t.Id_Tarea,
    t.Nombre AS Tarea,
    t.Fecha_Recibido,
    e.Descripcion AS Estado
FROM 
    TAREAS t
JOIN 
    ESTADO e ON t.Estado_Id = e.Estado_Id
WHERE 
    e.Descripcion = 'Completado';  -- Filtra solo las tareas con estado 'Completado'

-- Para verla SELECT * FROM VISTA_TAREAS_COMPLETADAS;



-- 12. Vista para mostrar materiales con su estado
CREATE OR REPLACE VIEW VISTA_MATERIALES_ESTADO AS
SELECT 
    m.Nombre AS Nombre_Material,
    e.Descripcion AS Estado_Material
FROM 
    MATERIALES m
JOIN 
    ESTADO e ON m.Estado_Id = e.Estado_Id;

-- Para verla SELECT * FROM VISTA_MATERIALES_ESTADO;



