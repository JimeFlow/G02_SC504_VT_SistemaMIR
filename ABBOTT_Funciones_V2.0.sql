/*CREADO POR: Grupo 2
FECHA: 20/03/2025
PROYECTO FINAL: Avance 02 con el Esquema ABBOTT*/

--================================ FUNCIONES ================================--

-- FUNCION CON ESTADO
-- 1. Obtener la descripcion de un estado por su ID
CREATE OR REPLACE FUNCTION FIDE_ESTADO_TB_Obtener_Descripcion_Estado_FN (
    P_Estado_Id IN FIDE_ESTADO_TB.Estado_Id%TYPE
    ) RETURN VARCHAR2 AS 
        V_Descripcion_Estado VARCHAR2(50);
    
BEGIN
    SELECT Descripcion 
    INTO V_Descripcion_Estado 
    FROM FIDE_ESTADO_TB
    WHERE Estado_Id = P_Estado_Id;
    
    RETURN V_Descripcion_Estado;
END;
/
    
    
    
-- FUNCIONES CON MATERIALES Y BODEGAS
-- 2. Obtener el nombre de un material por su ID
CREATE OR REPLACE FUNCTION FIDE_MATERIALES_TB_Obtener_Nombre_Material_FN (
    P_Id_Material IN FIDE_MATERIALES_TB.Id_Material%TYPE
    ) RETURN VARCHAR2 AS 
        V_Nombre_Material VARCHAR2(100);
    
BEGIN
    SELECT Nombre 
    INTO V_Nombre_Material
    FROM FIDE_MATERIALES_TB 
    WHERE Id_Material = P_Id_Material;
    
    RETURN V_Nombre_Material;
END;
/


-- 3. Calcular el total de los materiales que quedan disponibles
CREATE OR REPLACE FUNCTION FIDE_MATERIALES_TB_Calcular_Total_Materiales_Disponible_FN 
    RETURN NUMBER AS 
        V_Total_Materiales NUMBER;
    
BEGIN
    SELECT SUM(Cantidad_Disponible) 
    INTO V_Total_Materiales 
    FROM FIDE_MATERIALES_TB;
    
    RETURN V_Total_Materiales;
END;
/


-- 4. Calcular el numero de materiales en una bodega
CREATE OR REPLACE FUNCTION FIDE_BODEGAS_TB_Contar_Materiales_Bodega_FN (
    P_Bodega_Id IN FIDE_BODEGAS_TB.Bodega_Id%TYPE
    ) RETURN NUMBER AS 
        V_Num_Materiales NUMBER;

BEGIN
    SELECT COUNT(*) 
    INTO V_Num_Materiales 
    FROM FIDE_BODEGAS_TB WHERE Bodega_Id = P_Bodega_Id;
    
    RETURN V_Num_Materiales;
END;
/


-- 5. Verificar si un material esta disponible en alguna bodega
SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION FIDE_BODEGA_MATERIAL_TB_Material_Disponible_Bodega_FN (
    P_Bodega_Id IN FIDE_BODEGA_TB.Bodega_Id%TYPE,
    P_Id_Material IN FIDE_MATERIAL_TB.Id_Material%TYPE
    ) 
    
    RETURN BOOLEAN AS
        V_Cantidad_Disponible NUMBER;

BEGIN
    SELECT COUNT(*) 
    INTO V_Cantidad_Disponible 
    FROM FIDE_BODEGA_MATERIAL_TB
    WHERE Bodega_Id = P_Bodega_Id AND Id_Material = P_Id_Material;
        IF V_Cantidad_Disponible > 0 THEN
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
        DBMS_OUTPUT.PUT_LINE('ERROR ' || SQLERRM);
END;
/


-- 6. Obtener el nombre de una bodega por su ID
CREATE OR REPLACE FUNCTION FIDE_BODEGAS_TB_Obtener_Nombre_Bodega_FN (
    P_Bodega_Id IN FIDE_BODEGAS_TB.Bodega_Id%TYPE
    ) RETURN VARCHAR2 AS 
        V_Nombre_Bodega VARCHAR2(100);
    
BEGIN
    SELECT Sucursal 
    INTO V_Nombre_Bodega
    FROM FIDE_BODEGAS_TB 
    WHERE Bodega_Id = P_Bodega_Id;
    
    RETURN V_Nombre_Bodega;
END;
/


-- 7. Calcular el total del stock en una bodega
CREATE OR REPLACE FUNCTION FIDE_BODEGAS_TB_Calcular_Stock_Total_Bodega_FN (
    P_Bodega_Id IN FIDE_BODEGAS_TB.Bodega_Id%TYPE
    ) RETURN NUMBER AS 
        V_Stock_Total NUMBER;
    
BEGIN
    SELECT Stock 
    INTO V_Stock_Total 
    FROM FIDE_BODEGAS_TB 
    WHERE Bodega_Id = P_Bodega_Id;
    
    RETURN V_Stock_Total;
END;
/


    
-- FUNCIONES CON PERSONAL Y TAREAS
-- 8. Obtener el nombre de un empleado por su UPI
CREATE OR REPLACE FUNCTION FIDE_PERSONAL_TB_Obtener_Nombre_Empleado_FN (
    P_UPI IN FIDE_PERSONAL_TB.UPI%TYPE
    ) RETURN VARCHAR2 AS 
        V_Nombre_Empleado VARCHAR2(200);
    
BEGIN
    SELECT Nombre || ' ' || Apellidos 
    INTO V_Nombre_Empleado 
    FROM FIDE_PERSONAL_TB 
    WHERE UPI = P_UPI;
    
    RETURN V_Nombre_Empleado ;
END;
/

    
-- 9. Contar la cantidad de tareas pendientes para un empleado
CREATE OR REPLACE FUNCTION FIDE_TAREAS_TB_Contar_Tareas_Pendientes_FN (
    P_UPI IN FIDE_TAREAS_TB.UPI%TYPE
    ) RETURN NUMBER AS 
        V_Num_Tareas NUMBER;
    
BEGIN
    SELECT COUNT(*) 
    INTO V_Num_Tareas 
    FROM FIDE_TAREAS_TB
    WHERE UPI = P_UPI AND Estado_Id = (SELECT Estado_Id 
                                       FROM FIDE_ESTADO_TB 
                                       WHERE Descripcion = 'Pendiente');
    RETURN V_Num_Tareas;
END;
/
    

-- 10. Obtener el nombre del usuario o empleado responsable de un inventario
CREATE OR REPLACE FUNCTION FIDE_INVENTARIO_TB_Obtener_Responsable_Inventario_FN (
    P_Id_Inventario IN FIDE_INVENTARIO_TB.Id_Inventario%TYPE
    ) RETURN VARCHAR2 AS 
        V_Responsable VARCHAR2(200);

BEGIN
    SELECT
        CASE
            WHEN P.Id_Usuario IS NOT NULL THEN (SELECT Nombre || ' ' || Apellidos 
                                                FROM FIDE_PERSONAL_TB 
                                                WHERE Id_Usuario = P.Id_Usuario)
            WHEN P.UPI IS NOT NULL THEN (SELECT Nombre || ' ' || Apellidos 
                                                FROM FIDE_PERSONAL_TB 
                                                WHERE UPI = P.UPI)
        END INTO V_Responsable
        
    FROM FIDE_INVENTARIO_TB p
    WHERE Id_Inventario = P_Id_Inventario;
    
    RETURN V_Responsable;
END;
/



-- FUNCIONES CON ENTREGAS E INGRESOS
-- 11. Calcular la cantidad restante de un material en una entrega
CREATE OR REPLACE FUNCTION FIDE_ENTREGAS_TB_Calcular_Cantidad_Restante_Entregas_FN (
    P_Id_Entrega IN FIDE_ENTREGAS_TB.Id_Entrega%TYPE
    ) RETURN NUMBER AS 
        V_Cantidad_Restante NUMBER;
    
BEGIN
    SELECT Cantidad_Restante 
    INTO V_Cantidad_Restante 
    FROM FIDE_ENTREGAS_TB 
    WHERE Id_Entrega = P_Id_Entrega;
    
    RETURN V_Cantidad_Restante;
END;
/

    
-- 12. Obtener la fecha y hora de una entrega
CREATE OR REPLACE FUNCTION FIDE_DATOS_ENTREGAS_TB_Obtener_FechaHora_Entrega_FN (
    P_Dato_Entrega_Id IN FIDE_DATOS_ENTREGAS_TB.Dato_Entrega_Id%TYPE
    ) RETURN TIMESTAMP AS 
        V_Fecha_Hora_Entrega TIMESTAMP;
        
BEGIN
    SELECT Fecha || ' - ' || Hora 
    INTO V_Fecha_Hora_Entrega
    FROM FIDE_DATOS_ENTREGAS_TB
    WHERE Dato_Entrega_Id = P_Dato_Entrega_Id;
    
    RETURN V_Fecha_Hora_Entrega;
END;
/
    

-- 13. Obtener la fecha de ingreso de un material
CREATE OR REPLACE FUNCTION FIDE_INGRESOS_TB_Obtener_Fecha_Ingreso_Material_FN (
    P_Id_Ingreso IN FIDE_INGRESOS_TB.Id_Ingreso%TYPE) 
    RETURN DATE AS 
        V_Fecha_Ingreso DATE;
        
BEGIN
    SELECT Fecha_Ingreso 
    INTO V_Fecha_Ingreso
    FROM FIDE_INGRESOS_TB
    WHERE Id_Ingreso = P_Id_Ingreso;
    
    RETURN V_Fecha_Ingreso;
END;
/



-- FUNCIONES CON ROLES Y AREAS
-- 14. Obtener el tipo de rol de un personal por su Id_Rol
CREATE OR REPLACE FUNCTION FIDE_ROLES_TB_Obtener_TipoRol_Personal_FN (
    P_Id_Rol IN FIDE_ROLES_TB.Id_Rol%TYPE
    ) RETURN VARCHAR2 AS
        V_Tipo_Rol VARCHAR2(50);
        
BEGIN
    SELECT tr.Nombre_Rol 
    INTO V_Tipo_Rol 
    FROM FIDE_ROLES_TB r 
    JOIN Tipos_Rol tr ON r.TipoRol_Id = tr.TipoRol_Id 
    WHERE r.Id_Rol = P_Id_Rol;
    
    RETURN V_Tipo_Rol;
END;
/
   
    
-- 15. Obtener el nombre de un area por su Id_Area
CREATE OR REPLACE FUNCTION FIDE_AREAS_TB_Obtener_Nombre_Area_FN (
    P_Area_Id IN FIDE_AREAS_TB.Area_Id%TYPE
    ) RETURN VARCHAR2 AS
        V_Nombre_Area VARCHAR2(100);
        
BEGIN
    SELECT Nombre 
    INTO V_Nombre_Area
    FROM FIDE_AREAS_TB 
    WHERE Area_Id = P_Area_Id;
    
    RETURN V_Nombre_Area;
END;
/



    
    
    
    
    
    
    
    
    
    
    