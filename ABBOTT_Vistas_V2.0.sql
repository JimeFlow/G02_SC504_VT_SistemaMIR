/*CREADO POR: Grupo 2
FECHA: 20/03/2025
PROYECTO FINAL: Avance 02 con el Esquema ABBOTT*/

--================================== VISTAS ==================================--

-- 1. Vista para mostrar materiales por estado
CREATE OR REPLACE VIEW FIDE_MATERIALES_ESTADO_V AS
SELECT 
    m.Id_Material,
    m.Nombre,
    m.Fecha_Vencimiento,
    m.Cantidad_Disponible,
    e.Descripcion AS Estado
FROM 
    FIDE_MATERIALES_TB m
JOIN 
    FIDE_ESTADO_TB e ON m.Estado_Id = e.Estado_Id;



-- 2. Vista para mostrar ingresos recientes
CREATE OR REPLACE VIEW FIDE_INGRESOS_RECIENTES_V AS
SELECT 
    i.Id_Ingreso,
    m.Nombre AS Material,
    i.Cantidad_Recibida,
    i.Fecha_Ingreso
FROM 
    FIDE_INGRESOS_TB i
JOIN 
    FIDE_MATERIALES_TB m ON i.Id_Material = m.Id_Material
WHERE 
    i.Fecha_Ingreso > SYSDATE - 30;  -- Filtramos los ingresos de los últimos 30 días



-- 3. Vista para mostrar reportes por usuario
CREATE OR REPLACE VIEW FIDE_REPORTES_USUARIO_V AS
SELECT 
    r.Id_Reporte,
    u.Nombre AS Usuario,
    r.Descripcion AS Reporte_Descripcion,
    e.Descripcion AS Estado
FROM 
    FIDE_REPORTES_TB r
JOIN 
    FIDE_PERSONAL_TB u ON r.Id_Usuario = u.Id_Usuario
JOIN 
    FIDE_ESTADO_TB e ON r.Estado_Id = e.Estado_Id;



-- 4. Vista para mostrar tareas pendientes
CREATE OR REPLACE VIEW FIDE_TAREAS_PENDIENTES_V AS
SELECT 
    t.Id_Tarea,
    t.Nombre,
    t.Fecha_Recibido,
    e.Descripcion AS Estado
FROM 
    FIDE_TAREAS_TB t
JOIN 
    FIDE_ESTADO_TB e ON t.Estado_Id = e.Estado_Id
WHERE 
    e.Descripcion <> 'Completado';  -- Filtramos solo tareas que no estén completadas



-- 5. Vista para mostrar ingresos por material
CREATE OR REPLACE VIEW FIDE_INGRESOS_POR_MATERIAL_V AS
SELECT 
    m.Nombre AS Material,
    i.Cantidad_Recibida,
    i.Fecha_Ingreso
FROM 
    FIDE_INGRESOS_TB i
JOIN 
    FIDE_MATERIALES_TB m ON i.Id_Material = m.Id_Material;



-- 6. Vista para mostrar materiales con cantidad disponible y solicitada
CREATE OR REPLACE VIEW FIDE_CANTIDAD_MATERIALES_V AS
SELECT 
    m.Nombre AS Material,
    m.Cantidad_Disponible,
    m.Cantidad_Solicitada
FROM 
    FIDE_MATERIALES_TB m;



-- 7. Vista para mostrar reportes por estado
CREATE OR REPLACE VIEW FIDE_REPORTES_ESTADO_V AS
SELECT 
    r.Id_Reporte,
    r.Descripcion AS Reporte_Descripcion,
    e.Descripcion AS Estado
FROM 
    FIDE_REPORTES_TB r
JOIN 
    FIDE_ESTADO_TB e ON r.Estado_Id = e.Estado_Id;



-- 8. Vista para mostrar materiales próximos a vencerse
CREATE OR REPLACE VIEW FIDE_MATERIALES_VENCIMIENTO_V AS
SELECT 
    m.Nombre AS Material,
    m.Fecha_Vencimiento,
    CASE 
        WHEN m.Fecha_Vencimiento < SYSDATE THEN 'Vencido'
        WHEN m.Fecha_Vencimiento BETWEEN SYSDATE AND SYSDATE + 30 THEN 'Próximo a Vencer'
        ELSE 'Válido'
    END AS Estado_Vencimiento
FROM 
    FIDE_MATERIALES_TB m;



-- 9. Vista para mostrar tareas recibidas por usuario
CREATE OR REPLACE VIEW FIDE_TAREAS_POR_USUARIO_V AS
SELECT 
    t.Id_Tarea,
    t.Nombre AS Tarea,
    t.Fecha_Recibido,
    u.Nombre AS Usuario,
    e.Descripcion AS Estado
FROM 
    FIDE_TAREAS_TB t
JOIN 
    FIDE_PERSONAL_TB u ON t.UPI = u.UPI
JOIN 
    FIDE_ESTADO_TB e ON t.Estado_Id = e.Estado_Id;



-- 10. Vista para mostrar materiales con baja cantidad disponible
CREATE OR REPLACE VIEW FIDE_MATERIALES_BAJA_CANTIDAD_V AS
SELECT 
    m.Nombre AS Material,
    m.Cantidad_Disponible
FROM 
    FIDE_MATERIALES_TB m
WHERE 
    m.Cantidad_Disponible < 10;  -- Umbral de 10 unidades



-- 11. Vista para mostrar tareas completadas
CREATE OR REPLACE VIEW FIDE_TAREAS_COMPLETADAS_V AS
SELECT 
    t.Id_Tarea,
    t.Nombre AS Tarea,
    t.Fecha_Recibido,
    e.Descripcion AS Estado
FROM 
    FIDE_TAREAS_TB t
JOIN 
    FIDE_ESTADO_TB e ON t.Estado_Id = e.Estado_Id
WHERE 
    e.Descripcion = 'Completado';  -- Filtra solo las tareas con estado 'Completado'



-- 12. Vista para mostrar materiales con su estado
CREATE OR REPLACE VIEW FIDE_MATERIALES_ESTADO_V AS
SELECT 
    m.Nombre AS Nombre_Material,
    e.Descripcion AS Estado_Material
FROM 
    FIDE_MATERIALES_TB m
JOIN 
    FIDE_ESTADO_TB e ON m.Estado_Id = e.Estado_Id;


