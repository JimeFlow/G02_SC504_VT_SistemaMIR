/*CREADO POR: Grupo 2
FECHA: 20/03/2025
PROYECTO FINAL: Avance 02 con el Esquema ABBOTT*/

--================================ FUNCIONES ================================--

-- FUNCION CON ESTADO
-- 1. Obtener la descripcion de un estado por su ID
CREATE OR REPLACE FUNCTION Obtener_Descripcion_Estado (
    p_Estado_Id IN Estado.Estado_Id%TYPE) 
    RETURN VARCHAR2 AS 
        descripcion_estado VARCHAR2(50);
    
BEGIN
    SELECT Descripcion INTO descripcion_estado 
    FROM Estado WHERE Estado_Id = p_Estado_Id;
    
    RETURN descripcion_estado;
END;
/
    
    
    
-- FUNCIONES CON MATERIALES Y BODEGAS
-- 2. Obtener el nombre de un material por su ID
CREATE OR REPLACE FUNCTION Obtener_Nombre_Material (
    p_Id_Material IN Materiales.Id_Material%TYPE) 
    RETURN VARCHAR2 AS 
        nombre_material VARCHAR2(100);
    
BEGIN
    SELECT Nombre INTO nombre_material 
    FROM Materiales WHERE Id_Material = p_Id_Material;
    
    RETURN nombre_material;
END;
/


-- 3. Calcular el total de los materiales que quedan disponibles
CREATE OR REPLACE FUNCTION Calcular_Total_Materiales 
    RETURN NUMBER AS 
        total_materiales NUMBER;
    
BEGIN
    SELECT SUM(Cantidad_Disponible) INTO total_materiales FROM Materiales;
    RETURN total_materiales;
END;
/


-- 4. Calcular el numero de materiales en una bodega
CREATE OR REPLACE FUNCTION Contar_Materiales_Bodega (
    p_Bodega_Id IN BODEGAS.Bodega_Id%TYPE) 
    RETURN NUMBER AS 
        num_materiales NUMBER;

BEGIN
    SELECT COUNT(*) INTO num_materiales 
    FROM BODEGA_MATERIAL WHERE Bodega_Id = p_Bodega_Id;
    
    RETURN num_materiales;
END;
/


-- 5. Verificar si un material esta disponible en alguna bodega -- REVISAR
SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION Material_Disponible_Bodega (
    p_Bodega_Id IN BODEGAS.Bodega_Id%TYPE,
    p_Id_Material IN Materiales.Id_Material%TYPE) 
    
    RETURN BOOLEAN AS
        cantidad_disponible NUMBER;
BEGIN
    SELECT COUNT(*) INTO cantidad_disponible FROM BODEGA_Material
    WHERE Bodega_Id = p_Bodega_Id AND Id_Material = p_Id_Material;
        IF cantidad_disponible > 0 THEN
            RETURN TRUE;
        ELSE
            RETURN FALSE;
        END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron datos');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Se encontro mas de un registro para el dato seleccionado');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR, CONTACTE AQUI ' || SQLERRM);
END;
/


-- 6. Obtener el nombre de una bodega por su ID
CREATE OR REPLACE FUNCTION Obtener_Nombre_Bodega (
    p_Bodega_Id IN BODEGAS.Bodega_Id%TYPE) 
    RETURN VARCHAR2 AS 
        nombre_bodega VARCHAR2(100);
    
BEGIN
    SELECT Sucursal INTO nombre_bodega 
    FROM BODEGAS WHERE Bodega_Id = p_Bodega_Id;
    
    RETURN nombre_bodega;
END;
/


-- 7. Calcular el total del stock en una bodega
CREATE OR REPLACE FUNCTION Calcular_Stock_Total_Bodega (
    p_Bodega_Id IN BODEGAS.Bodega_Id%TYPE) 
    RETURN NUMBER AS 
        stock_total NUMBER;
    
BEGIN
    SELECT Stock INTO stock_total FROM BODEGAS WHERE Bodega_Id = p_Bodega_Id;
    RETURN stock_total;
END;
/


    
-- FUNCIONES CON PERSONAL Y TAREAS
-- 8. Obtener el nombre de un empleado por su UPI
CREATE OR REPLACE FUNCTION Obtener_Nombre_Empleado (
    p_UPI IN Personal.UPI%TYPE) 
    RETURN VARCHAR2 AS 
        nombre_empleado VARCHAR2(200);
    
BEGIN
    SELECT Nombre || ' ' || Apellidos INTO nombre_empleado 
    FROM Personal WHERE UPI = p_UPI;
    
    RETURN nombre_empleado;
END;
/

    
-- 9. Contar la cantidad de tareas pendientes para un empleado
CREATE OR REPLACE FUNCTION Contar_Tareas_Pendientes (
    p_UPI IN TAREAS.UPI%TYPE) 
    RETURN NUMBER AS 
        num_tareas NUMBER;
    
BEGIN
    SELECT COUNT(*) INTO num_tareas FROM TAREAS 
    WHERE UPI = p_UPI AND Estado_Id = (SELECT Estado_Id 
                                       FROM Estado 
                                       WHERE Descripcion = 'Pendiente');
    RETURN num_tareas;
END;
/
    

-- 10. Obtener el nombre del usuario o empleado responsable de un inventario
CREATE OR REPLACE FUNCTION Obtener_Responsable_Inventario (
    p_Id_Inventario IN INVENTARIO.Id_Inventario%TYPE) 
    RETURN VARCHAR2 AS 
        responsable VARCHAR2(200);

BEGIN
    SELECT
        CASE
            WHEN p.Id_Usuario IS NOT NULL THEN (SELECT Nombre || ' ' || Apellidos 
                                                FROM Personal 
                                                WHERE Id_Usuario = p.Id_Usuario)
            WHEN p.UPI IS NOT NULL THEN (SELECT Nombre || ' ' || Apellidos 
                                                FROM Personal 
                                                WHERE UPI = p.UPI)
        END INTO responsable
        
    FROM INVENTARIO p
    WHERE Id_Inventario = p_Id_Inventario;
    
    RETURN responsable;
END;
/



-- FUNCIONES CON ENTREGAS E INGRESOS
-- 11. Calcular la cantidad restante de un material en una entrega
CREATE OR REPLACE FUNCTION Calcular_Cantidad_Restante_Entrega (
    p_Id_Entrega IN Entregas.Id_Entrega%TYPE) 
    RETURN NUMBER AS 
        cantidad_restante NUMBER;
    
BEGIN
    SELECT Cantidad_Restante INTO cantidad_restante 
    FROM Entregas WHERE Id_Entrega = p_Id_Entrega;
    
    RETURN cantidad_restante;
END;
/

    
-- 12. Obtener la fecha y hora de una entrega
CREATE OR REPLACE FUNCTION Obtener_FechaHora_Entrega (
    p_Dato_Entrega_Id IN Datos_Entregas.Dato_Entrega_Id%TYPE) 
    RETURN TIMESTAMP AS 
        fecha_hora_entrega TIMESTAMP;
        
BEGIN
    SELECT Hora INTO fecha_hora_entrega 
    FROM Datos_Entregas WHERE Dato_Entrega_Id = p_Dato_Entrega_Id;
    
    RETURN fecha_hora_entrega;
END;
/
    

-- 13. Obtener la fecha de ingreso de un material
CREATE OR REPLACE FUNCTION Obtener_Fecha_Ingreso_Material (
    p_Id_Ingreso IN INGRESOS.Id_Ingreso%TYPE) 
    RETURN DATE AS 
        fecha_ingreso DATE;
        
BEGIN
    SELECT Fecha_Ingreso INTO fecha_ingreso 
    FROM INGRESOS WHERE Id_Ingreso = p_Id_Ingreso;
    
    RETURN fecha_ingreso;
END;
/



-- FUNCIONES CON ROLES Y AREAS
-- 14. Obtener el tipo de rol de un personal por su Id_Rol
CREATE OR REPLACE FUNCTION Obtener_TipoRol_Personal (
    p_Id_Rol IN Roles.Id_Rol%TYPE) 
    RETURN VARCHAR2 AS
        tipo_rol VARCHAR2(50);
        
BEGIN
    SELECT tr.Nombre_Rol INTO tipo_rol 
    FROM Roles r JOIN Tipos_Rol tr ON r.TipoRol_Id = tr.TipoRol_Id 
    WHERE r.Id_Rol = p_Id_Rol;
    
    RETURN tipo_rol;
END;
/
   
    
-- 15. Obtener el nombre de un area por su Id_Area
CREATE OR REPLACE FUNCTION Obtener_Nombre_Area (
    p_Area_Id IN Areas.Area_Id%TYPE) 
    RETURN VARCHAR2 AS
        nombre_area VARCHAR2(100);
        
BEGIN
    SELECT Nombre INTO nombre_area FROM Areas WHERE Area_Id = p_Area_Id;
    RETURN nombre_area;
END;
/



    
    
    
    
    
    
    
    
    
    
    