/*CREADO POR: Grupo 2
FECHA: 20/03/2025
PROYECTO FINAL: Avance 02 con el Esquema ABBOTT*/



-- Procedimiento para insertar una nueva tarea en la tabla TAREAS.
-- Recibe como parámetros los valores de cada columna de la tabla TAREAS 
-- y realiza la inserción correspondiente, asignando la fecha de recepción actual.

CREATE OR REPLACE PROCEDURE insertar_tarea (
    P_Id_Tarea IN INT,
    P_UPI IN NUMBER,
    P_Estado_Id IN INT,
    P_Nombre IN VARCHAR2,
    P_Fecha_Recibido IN DATE,
    P_Descripcion IN VARCHAR2
)
AS
BEGIN
    INSERT INTO TAREAS (
        Id_Tarea, 
        UPI, 
        Estado_Id, 
        Nombre, 
        Fecha_Recibido, 
        Descripcion
    )
    VALUES (
        P_Id_Tarea, 
        P_UPI, 
        P_Estado_Id, 
        P_Nombre, 
        P_Fecha_Recibido, 
        P_Descripcion
    );
    
    COMMIT;
END insertar_tarea;
/

/*Para ejecutar*/
--EXEC insertar_tarea(1, 12345, 2, 'Tarea de prueba', SYSDATE, 'Descripción de la tarea');



-- Procedimiento para verificar si hay suficiente material ingresado
CREATE OR REPLACE PROCEDURE Verificar_Suficiencia_Material (
    P_Id_Material IN INT,
    P_Ultima_Cantidad IN INT,
    OUT_P_Suficiente OUT VARCHAR2
)
IS
    V_Cantidad_Recibida INT;
BEGIN
    -- Obtener el total de material ingresado
    SELECT SUM(Cantidad_Recibida) INTO V_Cantidad_Recibida
    FROM INGRESOS
    WHERE Id_Material = P_Id_Material;

    -- Verificar si la cantidad total supera la cantidad requerida
    IF V_Cantidad_Recibida >= P_Ultima_Cantidad THEN
        OUT_P_Suficiente := 'Suficiente';
    ELSE
        OUT_P_Suficiente := 'No Suficiente';
    END IF;
END;

/*Para ejecutar*/
--EXEC VERIFICAR_SUFICIENCIA_MATERIAL(101, 100);



/*Este procedimiento insertará un nuevo material en la tabla Materiales*/
CREATE OR REPLACE PROCEDURE INSERTAR_MATERIAL (
    P_ID_MATERIAL IN INT,
    P_ESTADO_ID IN INT,
    P_NOMBRE IN VARCHAR2,
    P_FECHA_VENCIMIENTO IN DATE,
    P_CANTIDAD_DISPONIBLE IN INT,
    P_CANTIDAD_SOLICITADA IN INT
) IS
BEGIN
    INSERT INTO Materiales (Id_Material, Estado_Id, Nombre, Fecha_Vencimiento, Cantidad_Disponible, Cantidad_Solicitada)
    VALUES (P_ID_MATERIAL, P_ESTADO_ID, P_NOMBRE, P_FECHA_VENCIMIENTO, P_CANTIDAD_DISPONIBLE, P_CANTIDAD_SOLICITADA);
    COMMIT;
END INSERTAR_MATERIAL;

/*Para ejecutar*/
--EXEC INSERTAR_MATERIAL(1001, 1, 'Material A', TO_DATE('2025-12-31', 'YYYY-MM-DD'), 500, 300);




-- Procedimiento para recorrer todas las tareas con un estado específico
CREATE OR REPLACE PROCEDURE PROCESAR_TAREAS_ESTADO(p_estado_id IN INT) IS
    -- Declaramos el cursor que seleccionará las tareas de un estado específico
    CURSOR c_tareas IS
        SELECT Id_Tarea, Nombre, Descripcion
        FROM TAREAS
        WHERE Estado_Id = p_estado_id;  -- Filtramos por el estado proporcionado
    
    -- Declaramos las variables que almacenarán los valores extraídos del cursor
    v_id_tarea TAREAS.Id_Tarea%TYPE;
    v_nombre TAREAS.Nombre%TYPE;
    v_descripcion TAREAS.Descripcion%TYPE;
BEGIN
    -- Abrimos el cursor para empezar a procesar las filas
    OPEN c_tareas;

    -- Bucle para recorrer las filas del cursor
    LOOP
        -- Extraemos los datos de la siguiente fila del cursor y los almacenamos en las variables
        FETCH c_tareas INTO v_id_tarea, v_nombre, v_descripcion;

        -- Salimos del bucle cuando no hay más filas en el cursor
        EXIT WHEN c_tareas%NOTFOUND;

        -- Realizamos alguna acción con los datos obtenidos, en este caso, simplemente los imprimimos
        DBMS_OUTPUT.PUT_LINE('ID Tarea: ' || v_id_tarea || ', Nombre: ' || v_nombre || ', Descripción: ' || v_descripcion);
    END LOOP;

    -- Cerramos el cursor después de usarlo para liberar recursos
    CLOSE c_tareas;
END;

/*Para ejecutar*/
--EXEC PROCESAR_TAREAS_ESTADO(1);  -- Procesa todas las tareas con Estado_Id = 1




-- Procedimiento que recorre los reportes de un estado específico y muestra su información
CREATE OR REPLACE PROCEDURE MOSTRAR_REPORTES_POR_ESTADO(p_estado_id IN INT) IS

    -- Cursor que obtiene los reportes con el Estado_Id proporcionado
    CURSOR c_reportes IS
        SELECT Id_Reporte, Descripcion, Id_Usuario
        FROM REPORTES
        WHERE Estado_Id = p_estado_id;

    -- Variables para almacenar los datos del cursor
    v_id_reporte   REPORTES.Id_Reporte%TYPE;
    v_descripcion  REPORTES.Descripcion%TYPE;
    v_id_usuario   REPORTES.Id_Usuario%TYPE;

BEGIN
    -- Abrimos el cursor
    OPEN c_reportes;

    -- Recorremos los resultados del cursor
    LOOP
        FETCH c_reportes INTO v_id_reporte, v_descripcion, v_id_usuario;
        EXIT WHEN c_reportes%NOTFOUND;

        -- Mostramos la información por consola (DBMS_OUTPUT)
        DBMS_OUTPUT.PUT_LINE('Reporte ID: ' || v_id_reporte || ' | Usuario ID: ' || v_id_usuario || ' | Descripción: ' || v_descripcion);
    END LOOP;

    -- Cerramos el cursor
    CLOSE c_reportes;

END;
/

/*Para ejecutar*/
--EXEC MOSTRAR_REPORTES_POR_ESTADO(1);




-- Procedimiento que actualiza la cantidad solicitada de un material específico
CREATE OR REPLACE PROCEDURE ACTUALIZAR_CANTIDAD_SOLICITADA(
    p_id_material IN INT,
    p_nueva_cantidad IN INT
) IS
BEGIN
    -- Actualizamos la cantidad solicitada
    UPDATE MATERIALES
    SET Cantidad_Solicitada = p_nueva_cantidad
    WHERE Id_Material = p_id_material;

    -- Confirmamos la actualización
    DBMS_OUTPUT.PUT_LINE('Cantidad solicitada actualizada correctamente para el material ID: ' || p_id_material);
END;
/

/*Para ejecutar*/
--EXEC ACTUALIZAR_CANTIDAD_SOLICITADA(3, 150);




-- Procedimiento que utiliza un cursor para mostrar los materiales con bajo stock
CREATE OR REPLACE PROCEDURE MOSTRAR_MATERIALES_BAJO_STOCK(
    p_stock_minimo IN INT
) IS
    -- Definición del cursor
    CURSOR cur_materiales IS
        SELECT Id_Material, Nombre, Cantidad_Disponible
        FROM MATERIALES
        WHERE Cantidad_Disponible < p_stock_minimo;

    -- Variables para almacenar datos del cursor
    v_id_material MATERIALES.Id_Material%TYPE;
    v_nombre MATERIALES.Nombre%TYPE;
    v_cantidad MATERIALES.Cantidad_Disponible%TYPE;

BEGIN
    -- Abrimos el cursor
    OPEN cur_materiales;

    -- Recorremos los registros
    LOOP
        FETCH cur_materiales INTO v_id_material, v_nombre, v_cantidad;
        EXIT WHEN cur_materiales%NOTFOUND;

        -- Mostramos los datos del material
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_id_material || ' | Nombre: ' || v_nombre || ' | Disponible: ' || v_cantidad);
    END LOOP;

    -- Cerramos el cursor
    CLOSE cur_materiales;
END;
/

/*Para ejecutar*/
--EXEC MOSTRAR_MATERIALES_BAJO_STOCK(50);




-- Procedimiento que permite aumentar la cantidad disponible de un material específico.
-- Se utiliza para actualizar el stock cuando se recibe nuevo material.
CREATE OR REPLACE PROCEDURE AUMENTAR_CANTIDAD_MATERIAL(
    p_id_material IN INT,
    p_cantidad_a_agregar IN INT
) IS
BEGIN
    UPDATE MATERIALES
    SET Cantidad_Disponible = Cantidad_Disponible + p_cantidad_a_agregar
    WHERE Id_Material = p_id_material;

    DBMS_OUTPUT.PUT_LINE('Se ha actualizado el stock del material con ID: ' || p_id_material);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Material no encontrado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al actualizar el stock: ' || SQLERRM);
END;
/

/*Para ejecutar*/
--EXEC AUMENTAR_CANTIDAD_MATERIAL(101, 25);




-- Procedimiento que recorre todas las tareas pendientes (Estado_Id = 1)
-- usando un cursor explícito y muestra su información básica.
CREATE OR REPLACE PROCEDURE MOSTRAR_TAREAS_PENDIENTES IS
    -- Declaración del cursor para seleccionar tareas en estado pendiente
    CURSOR c_tareas_pendientes IS
        SELECT Id_Tarea, Nombre, Fecha_Recibido
        FROM TAREAS
        WHERE Estado_Id = 1;

    -- Variables para almacenar temporalmente los valores del cursor
    v_id_tarea TAREAS.Id_Tarea%TYPE;
    v_nombre TAREAS.Nombre%TYPE;
    v_fecha TAREAS.Fecha_Recibido%TYPE;
BEGIN
    -- Abrimos el cursor
    OPEN c_tareas_pendientes;

    -- Recorremos cada fila del cursor
    LOOP
        FETCH c_tareas_pendientes INTO v_id_tarea, v_nombre, v_fecha;
        EXIT WHEN c_tareas_pendientes%NOTFOUND;

        -- Mostramos la información con DBMS_OUTPUT
        DBMS_OUTPUT.PUT_LINE('Tarea ID: ' || v_id_tarea || ' | Nombre: ' || v_nombre || ' | Fecha Recibido: ' || v_fecha);
    END LOOP;

    -- Cerramos el cursor
    CLOSE c_tareas_pendientes;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error en procedimiento: ' || SQLERRM);
END;
/
/*Para ejecutar*/
--EXEC MOSTRAR_TAREAS_PENDIENTES;




-- Procedimiento que recorre los materiales con bajo stock (<=10 unidades)
-- usando un cursor explícito para mostrar Id_Material, Nombre y Cantidad_Disponible
CREATE OR REPLACE PROCEDURE MOSTRAR_MATERIALES_BAJO_STOCK IS
    -- Declaración del cursor
    CURSOR c_materiales_bajo_stock IS
        SELECT Id_Material, Nombre, Cantidad_Disponible
        FROM MATERIALES
        WHERE Cantidad_Disponible <= 10;

    -- Variables para almacenar datos del cursor
    v_id_material MATERIALES.Id_Material%TYPE;
    v_nombre MATERIALES.Nombre%TYPE;
    v_cantidad MATERIALES.Cantidad_Disponible%TYPE;
BEGIN
    -- Abrimos el cursor
    OPEN c_materiales_bajo_stock;

    -- Recorremos cada fila del cursor
    LOOP
        FETCH c_materiales_bajo_stock INTO v_id_material, v_nombre, v_cantidad;
        EXIT WHEN c_materiales_bajo_stock%NOTFOUND;

        -- Mostramos la información con DBMS_OUTPUT
        DBMS_OUTPUT.PUT_LINE('ID Material: ' || v_id_material || ' | Nombre: ' || v_nombre || ' | Cantidad Disponible: ' || v_cantidad);
    END LOOP;

    -- Cerramos el cursor
    CLOSE c_materiales_bajo_stock;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error en procedimiento: ' || SQLERRM);
END;
/
/*Para ejecutar*/
--EXEC MOSTRAR_MATERIALES_BAJO_STOCK;




-- Procedimiento para actualizar el stock de una bodega en la tabla BODEGAS
-- Recibe el ID de la bodega y el nuevo valor de stock
CREATE OR REPLACE PROCEDURE ACTUALIZAR_STOCK_BODEGA(
    p_Bodega_Id   IN BODEGAS.Bodega_Id%TYPE,
    p_Nuevo_Stock IN BODEGAS.Stock%TYPE
) IS
BEGIN
    UPDATE BODEGAS
    SET Stock = p_Nuevo_Stock
    WHERE Bodega_Id = p_Bodega_Id;

    DBMS_OUTPUT.PUT_LINE('? Stock actualizado correctamente para la bodega ' || p_Bodega_Id);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('? Error al actualizar el stock: ' || SQLERRM);
END;
/
/*Para ejecutar*/
--EXEC ACTUALIZAR_STOCK_BODEGA(1, 250);




-- Procedimiento para registrar un nuevo material en la tabla MATERIALES
CREATE OR REPLACE PROCEDURE REGISTRAR_NUEVO_MATERIAL(
    P_Id_Material IN INT,  -- ID único del material
    P_Estado_Id IN INT,    -- ID del estado del material (referencia a la tabla ESTADO)
    P_Nombre IN VARCHAR2,  -- Nombre del material
    P_Fecha_Vencimiento IN DATE, -- Fecha de vencimiento del material
    P_Cantidad_Disponible IN INT, -- Cantidad disponible del material
    P_Cantidad_Solicitada IN INT  -- Cantidad solicitada del material
)
IS
BEGIN
    -- Inserta un nuevo material en la tabla MATERIALES
    INSERT INTO MATERIALES (Id_Material, Estado_Id, Nombre, Fecha_Vencimiento, Cantidad_Disponible, Cantidad_Solicitada)
    VALUES (P_Id_Material, P_Estado_Id, P_Nombre, P_Fecha_Vencimiento, P_Cantidad_Disponible, P_Cantidad_Solicitada);

    -- Mensaje para confirmar que el material fue registrado
    DBMS_OUTPUT.PUT_LINE('El material con ID ' || P_Id_Material || ' ha sido registrado con éxito.');
    
EXCEPTION
    -- Manejo de excepciones en caso de que ocurra un error
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error al registrar el material: ' || SQLERRM);
END;
/

/*Para ejecutar*/
--EXEC REGISTRAR_NUEVO_MATERIAL(1002, 1, 'Material de Prueba', TO_DATE('2026-12-31', 'YYYY-MM-DD'), 100, 50);




-- Procedimiento para actualizar el estado de materiales con bajo stock (cantidad disponible < 10)
CREATE OR REPLACE PROCEDURE ACTUALIZAR_ESTADO_MATERIAL_BAJO_STOCK
IS
    CURSOR c_materiales IS
        SELECT Id_Material, Cantidad_Disponible, Estado_Id
        FROM MATERIALES
        WHERE Cantidad_Disponible < 10;  -- Suponemos que si la cantidad disponible es menor a 10, es bajo stock

    v_Id_Material MATERIALES.Id_Material%TYPE;
    v_Cantidad_Disponible MATERIALES.Cantidad_Disponible%TYPE;
    v_Estado_Id MATERIALES.Estado_Id%TYPE;
BEGIN
    -- Abriendo el cursor
    OPEN c_materiales;
    
    -- Bucle para recorrer todos los materiales con bajo stock
    LOOP
        FETCH c_materiales INTO v_Id_Material, v_Cantidad_Disponible, v_Estado_Id;
        EXIT WHEN c_materiales%NOTFOUND;
        
        -- Actualizando el estado de los materiales con bajo stock
        UPDATE MATERIALES
        SET Estado_Id = 2  -- Suponemos que el Estado_Id = 2 es "Bajo Stock"
        WHERE Id_Material = v_Id_Material;
        
        -- Mostramos un mensaje indicando que el material fue actualizado
        DBMS_OUTPUT.PUT_LINE('Material con ID ' || v_Id_Material || ' actualizado a estado "Bajo Stock".');
    END LOOP;

    -- Cerrando el cursor
    CLOSE c_materiales;
    
    -- Confirmación de la ejecución del procedimiento
    DBMS_OUTPUT.PUT_LINE('El proceso de actualización de materiales con bajo stock ha finalizado.');
EXCEPTION
    -- Manejo de errores
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error: ' || SQLERRM);
        -- Cerramos el cursor en caso de error
        IF c_materiales%ISOPEN THEN
            CLOSE c_materiales;
        END IF;
END;
/

/*Para ejecutar*/
--EXEC ACTUALIZAR_ESTADO_MATERIAL_BAJO_STOCK;



                                 /*Vistas*/

-- Vista para mostrar materiales por estado
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

--para verla
--SELECT * FROM VISTA_MATERIALES_ESTADO;



-- Vista para mostrar ingresos recientes
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

--Para verla
--SELECT * FROM VISTA_INGRESOS_RECIENTES;



-- Vista para mostrar reportes por usuario
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

--Para verla
--SELECT * FROM VISTA_REPORTES_USUARIO;




-- Vista para mostrar tareas pendientes
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

--Para verla
--SELECT * FROM VISTA_TAREAS_PENDIENTES;



-- Vista para mostrar ingresos por material
CREATE OR REPLACE VIEW VISTA_INGRESOS_POR_MATERIAL AS
SELECT 
    m.Nombre AS Material,
    i.Cantidad_Recibida,
    i.Fecha_Ingreso
FROM 
    INGRESOS i
JOIN 
    MATERIALES m ON i.Id_Material = m.Id_Material;

--para verla
--SELECT * FROM VISTA_INGRESOS_POR_MATERIAL;



-- Vista para mostrar materiales con cantidad disponible y solicitada
CREATE OR REPLACE VIEW VISTA_MATERIALES_CANTIDAD AS
SELECT 
    m.Nombre AS Material,
    m.Cantidad_Disponible,
    m.Cantidad_Solicitada
FROM 
    MATERIALES m;


--Para verla
--SELECT * FROM VISTA_MATERIALES_CANTIDAD;



-- Vista para mostrar reportes por estado
CREATE OR REPLACE VIEW VISTA_REPORTES_ESTADO AS
SELECT 
    r.Id_Reporte,
    r.Descripcion AS Reporte_Descripcion,
    e.Descripcion AS Estado
FROM 
    REPORTES r
JOIN 
    ESTADO e ON r.Estado_Id = e.Estado_Id;

--Para verla
--SELECT * FROM VISTA_REPORTES_ESTADO;



-- Vista para mostrar materiales próximos a vencerse
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

--Para verla
--SELECT * FROM VISTA_MATERIALES_VENCIMIENTO;



-- Vista para mostrar tareas recibidas por usuario
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


--Para verla
--SELECT * FROM VISTA_TAREAS_POR_USUARIO;



-- Vista para mostrar materiales con baja cantidad disponible
CREATE OR REPLACE VIEW VISTA_MATERIALES_BAJA_CANTIDAD AS
SELECT 
    m.Nombre AS Material,
    m.Cantidad_Disponible
FROM 
    MATERIALES m
WHERE 
    m.Cantidad_Disponible < 10;  -- Umbral de 10 unidades

--Para verla
--SELECT * FROM VISTA_MATERIALES_BAJA_CANTIDAD;



-- Vista para mostrar tareas completadas
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

--Para verla
--SELECT * FROM VISTA_TAREAS_COMPLETADAS;



-- Vista para mostrar materiales con su estado
CREATE OR REPLACE VIEW VISTA_MATERIALES_ESTADO AS
SELECT 
    m.Nombre AS Nombre_Material,
    e.Descripcion AS Estado_Material
FROM 
    MATERIALES m
JOIN 
    ESTADO e ON m.Estado_Id = e.Estado_Id;

--Para verla
--SELECT * FROM VISTA_MATERIALES_ESTADO;






