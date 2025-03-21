/*CREADO POR: Grupo 2
FECHA: 20/03/2025
PROYECTO FINAL: Avance 02 con el Esquema ABBOTT*/

-- CORREGIR NOMBRES APLICANDO LA NOMENCLATURA

--============================== PROCEDIMIENTOS ==============================--
-- CREATE / INSERT / REGISTRAR
-- 1. Registrar un nuevo personal
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE registrar_personal (
    p_id_personal     IN  NUMBER,
    p_id_rol          IN  NUMBER,
    p_id_entrega      IN  NUMBER,
    p_horario_id      IN  NUMBER,
    p_estado_id       IN  NUMBER,
    p_tipo_personal   IN  VARCHAR2,
    p_nombre          IN  VARCHAR2,
    p_apellidos       IN  VARCHAR2,
    p_datos_contacto  IN  VARCHAR2,
    p_linea_trabajo   IN  VARCHAR2,
    p_id_usuario      IN  NUMBER DEFAULT NULL,
    p_upi             IN  NUMBER DEFAULT NULL
) IS
BEGIN
    INSERT INTO personal (
        id_personal,
        id_rol,
        id_entrega,
        horario_id,
        estado_id,
        tipo_personal,
        nombre,
        apellidos,
        datos_contacto,
        linea_trabajo,
        id_usuario,
        upi
    ) VALUES (
        p_id_personal,
        p_id_rol,
        p_id_entrega,
        p_horario_id,
        p_estado_id,
        p_tipo_personal,
        p_nombre,
        p_apellidos,
        p_datos_contacto,
        p_linea_trabajo,
        p_id_usuario,
        p_upi
    );

    COMMIT;
    dbms_output.put_line('Personal registrado con Id_Personal: ' || p_id_personal);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error al registrar personal: ' || sqlerrm);
END;
/

/* 2. Insertar una nueva tarea en la tabla TAREAS.
    - Recibe como parámetros los valores de cada columna de la tabla TAREAS y realiza 
    la inserción correspondiente, asignando la fecha de recepción actual.*/
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE insertar_tarea (
    p_id_tarea        IN  INT,
    p_upi             IN  NUMBER,
    p_estado_id       IN  INT,
    p_nombre          IN  VARCHAR2,
    p_fecha_recibido  IN  DATE,
    p_descripcion     IN  VARCHAR2
) AS
BEGIN
    INSERT INTO tareas (
        id_tarea,
        upi,
        estado_id,
        nombre,
        fecha_recibido,
        descripcion
    ) VALUES (
        p_id_tarea,
        p_upi,
        p_estado_id,
        p_nombre,
        p_fecha_recibido,
        p_descripcion
    );

    COMMIT;
END insertar_tarea;

-- 3. Registrar un nuevo ingreso de material
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE registrar_ingreso (
    p_id_ingreso         IN  NUMBER,
    p_id_material        IN  NUMBER,
    p_upi                IN  NUMBER,
    p_estado_id          IN  NUMBER,
    p_cantidad_recibida  IN  NUMBER,
    p_fecha_ingreso      IN  DATE
) IS
BEGIN
    INSERT INTO ingresos (
        id_ingreso,
        id_material,
        upi,
        estado_id,
        cantidad_recibida,
        fecha_ingreso
    ) VALUES (
        p_id_ingreso,
        p_id_material,
        p_upi,
        p_estado_id,
        p_cantidad_recibida,
        p_fecha_ingreso
    );

    COMMIT;
    dbms_output.put_line('Ingreso registrado con Id_Ingreso: ' || p_id_ingreso);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error al registrar ingreso: ' || sqlerrm);
END;
/

-- 4. Registrar un nuevo reporte
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE registrar_reporte (
    p_id_reporte     IN  NUMBER,
    p_id_usuario     IN  NUMBER,
    p_id_inventario  IN  NUMBER,
    p_id_registro    IN  NUMBER,
    p_estado_id      IN  NUMBER,
    p_descripcion    IN  VARCHAR2
) IS
BEGIN
    INSERT INTO reportes (
        id_reporte,
        id_usuario,
        id_inventario,
        id_registro,
        estado_id,
        descripcion
    ) VALUES (
        p_id_reporte,
        p_id_usuario,
        p_id_inventario,
        p_id_registro,
        p_estado_id,
        p_descripcion
    );

    COMMIT;
    dbms_output.put_line('Reporte registrado con Id_Reporte: ' || p_id_reporte);

EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error al registrar reporte: ' || sqlerrm);
END;
/


-- READ / MOSTRAR / LISTAR
-- 5. Mostrar material por ID
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE mostrar_material (
    p_id_material          IN   NUMBER,
    p_nombre               OUT  VARCHAR2,
    p_fecha_vencimiento    OUT  DATE,
    p_cantidad_disponible  OUT  NUMBER,
    p_cantidad_solicitada  OUT  NUMBER
) IS
BEGIN
    SELECT
        nombre,
        fecha_vencimiento,
        cantidad_disponible,
        cantidad_solicitada
    INTO
        p_nombre,
        p_fecha_vencimiento,
        p_cantidad_disponible,
        p_cantidad_solicitada
    FROM
        materiales
    WHERE
        id_material = p_id_material;

EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('Material con Id_Material '
                             || p_id_material
                             || ' no encontrado.');
    WHEN OTHERS THEN
        dbms_output.put_line('Error al mostrar material: ' || sqlerrm);
END;
/
/* Prueba
 DECLARE
   v_Nombre VARCHAR2(100);
   v_Fecha_Vencimiento DATE;
   v_Cantidad_Disponible NUMBER;
   v_Cantidad_Solicitada NUMBER;
 BEGIN
   Mostrar_Material(101, v_Nombre, v_Fecha_Vencimiento, v_Cantidad_Disponible, v_Cantidad_Solicitada);
   DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_Nombre);
   DBMS_OUTPUT.PUT_LINE('Fecha de Vencimiento: ' || v_Fecha_Vencimiento);
   DBMS_OUTPUT.PUT_LINE('Cantidad Disponible: ' || v_Cantidad_Disponible);
   DBMS_OUTPUT.PUT_LINE('Cantidad Solicitada: ' || v_Cantidad_Solicitada);
 END;
-- */

-- 6. Procedimiento para verificar si hay suficiente material ingresado
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE verificar_material_suficiente (
    p_id_material      IN   INT,
    p_ultima_cantidad  IN   INT,
    out_p_suficiente   OUT  VARCHAR2
) IS
    v_cantidad_recibida INT;
BEGIN
    -- Obtener el total de material ingresado
    SELECT
        SUM(cantidad_recibida)
    INTO v_cantidad_recibida
    FROM
        ingresos
    WHERE
        id_material = p_id_material;

    -- Verificar si la cantidad total supera la cantidad requerida
    IF v_cantidad_recibida >= p_ultima_cantidad THEN
        dbms_output.put_line('Suficiente');
    ELSE
        dbms_output.put_line('No Suficiente');
    END IF;

END;
/
/*Para ejecutar*/
-- EXEC Verificar_Material_Suficiente(101, 100);

-- 7. Mostrar los datos de una tarea por Id
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE mostrar_tarea (
    p_id_tarea        IN   NUMBER,
    p_upi             OUT  NUMBER,
    p_nombre          OUT  VARCHAR2,
    p_fecha_recibido  OUT  DATE,
    p_descripcion     OUT  VARCHAR2
) IS
BEGIN
    SELECT
        upi,
        nombre,
        fecha_recibido,
        descripcion
    INTO
        p_upi,
        p_nombre,
        p_fecha_recibido,
        p_descripcion
    FROM
        tareas
    WHERE
        id_tarea = p_id_tarea;

EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('Tarea con Id_Tarea '
                             || p_id_tarea
                             || ' no encontrada.');
    WHEN OTHERS THEN
        dbms_output.put_line('Error al mostrar tarea: ' || sqlerrm);
END;
/
/* Prueba
DECLARE
   v_UPI NUMBER;
   v_Nombre VARCHAR2(100);
   v_Fecha_Recibido DATE;
   v_Descripcion VARCHAR2(200);
 BEGIN
   Mostrar_Tarea(101, v_UPI, v_Nombre, v_Fecha_Recibido, v_Descripcion);
   DBMS_OUTPUT.PUT_LINE('UPI: ' || v_UPI);
   DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_Nombre);
   DBMS_OUTPUT.PUT_LINE('Fecha Recibido: ' || v_Fecha_Recibido);
   DBMS_OUTPUT.PUT_LINE('Descripción: ' || v_Descripcion);
 END;
*/


-- UPDATE / MODIFICAR / ACTUALIZAR
/* 8. Procedimiento que permite aumentar la cantidad disponible de un material específico.
    - Se utiliza para actualizar el stock cuando se recibe nuevo material. */
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE aumentar_cantidad_material (
    p_id_material         IN  INT,
    p_cantidad_a_agregar  IN  INT
) IS
BEGIN
    UPDATE materiales
    SET
        cantidad_disponible = cantidad_disponible + p_cantidad_a_agregar
    WHERE
        id_material = p_id_material;

    dbms_output.put_line('Se ha actualizado el stock del material con ID: ' || p_id_material);
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('Material no encontrado.');
    WHEN OTHERS THEN
        dbms_output.put_line('Error al actualizar el stock: ' || sqlerrm);
END;
/
/*Para ejecutar*/
--EXEC AUMENTAR_CANTIDAD_MATERIAL(101, 25);


-- 9. Procedimiento para actualizar el stock de una bodega en la tabla BODEGAS
-- Recibe el ID de la bodega y el nuevo valor de stock
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE actualizar_stock_bodega (
    p_bodega_id    IN  bodegas.bodega_id%TYPE,
    p_nuevo_stock  IN  bodegas.stock%TYPE
) IS
BEGIN
    UPDATE bodegas
    SET
        stock = p_nuevo_stock
    WHERE
        bodega_id = p_bodega_id;

    dbms_output.put_line('Stock actualizado correctamente para la bodega ' || p_bodega_id);
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error al actualizar el stock: ' || sqlerrm);
END;
/
/*Para ejecutar*/
-- EXEC ACTUALIZAR_STOCK_BODEGA(1, 250);


-- 10. Actualizar datos de contacto de un empleado
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE actualizar_rol_empleado (
    p_id_personal   IN  NUMBER,
    p_nuevo_rol_id  IN  NUMBER
) IS
BEGIN
    UPDATE personal
    SET
        id_rol = p_nuevo_rol_id
    WHERE
        id_personal = p_id_personal;

    COMMIT;
    dbms_output.put_line('Rol de empleado '
                         || p_id_personal
                         || ' actualizado.');
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('Empleado con Id_Personal '
                             || p_id_personal
                             || ' no encontrado.');
    WHEN OTHERS THEN
        dbms_output.put_line('Error al actualizar rol: ' || sqlerrm);
END;
/
-- Prueba EXECUTE Actualizar_Rol_Empleado(101, 3);

-- 11. Actualizar el horario del empleado
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE actualizar_horario_empleado (
    p_id_personal       IN  NUMBER,
    p_nuevo_horario_id  IN  NUMBER
) IS
BEGIN
    UPDATE personal
    SET
        horario_id = p_nuevo_horario_id
    WHERE
        id_personal = p_id_personal;

    COMMIT;
    dbms_output.put_line('Horario de empleado '
                         || p_id_personal
                         || ' actualizado.');
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('Empleado con Id '
                             || p_id_personal
                             || ' no encontrado.');
    WHEN OTHERS THEN
        dbms_output.put_line('Error al actualizar horario: ' || sqlerrm);
END;
/
-- Prueba EXECUTE Actualizar_Horario_Empleado(101, 2);

-- 12. Actualizar estado de los ingresos
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE actualizar_estado_ingreso (
    p_id_ingreso       IN  NUMBER,
    p_nuevo_estado_id  IN  NUMBER
) IS
BEGIN
    UPDATE ingresos
    SET
        estado_id = p_nuevo_estado_id
    WHERE
        id_ingreso = p_id_ingreso;

    COMMIT;
    dbms_output.put_line('Estado de ingreso '
                         || p_id_ingreso
                         || ' actualizado.');
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('Ingreso con Id_Ingreso '
                             || p_id_ingreso
                             || ' no encontrado.');
    WHEN OTHERS THEN
        dbms_output.put_line('Error al actualizar estado: ' || sqlerrm);
END;
/
-- Prueba EXECUTE Actualizar_Estado_Ingreso(101, 2);

-- 13. Actualizar descripcion de un reporte
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE actualizar_descripcion_reporte (
    p_id_reporte         IN  NUMBER,
    p_nueva_descripcion  IN  VARCHAR2
) IS
BEGIN
    UPDATE reportes
    SET
        descripcion = p_nueva_descripcion
    WHERE
        id_reporte = p_id_reporte;

    COMMIT;
    dbms_output.put_line('Descripción de reporte '
                         || p_id_reporte
                         || ' actualizada.');
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('Reporte con Id_Reporte '
                             || p_id_reporte
                             || ' no encontrado.');
    WHEN OTHERS THEN
        dbms_output.put_line('Error al actualizar descripción: ' || sqlerrm);
END;
/
-- Prueba EXECUTE Actualizar_Descripcion_Reporte(101, 'Nueva descripción del reporte.');

-- 14. Actualizar estado del reporte
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE actualizar_estado_reporte (
    p_id_reporte       IN  NUMBER,
    p_nuevo_estado_id  IN  NUMBER
) IS
BEGIN
    UPDATE reportes
    SET
        estado_id = p_nuevo_estado_id
    WHERE
        id_reporte = p_id_reporte;

    COMMIT;
    dbms_output.put_line('Estado de reporte '
                         || p_id_reporte
                         || ' actualizado a '
                         || p_nuevo_estado_id);
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('Reporte con Id '
                             || p_id_reporte
                             || ' no encontrado.');
    WHEN OTHERS THEN
        dbms_output.put_line('Error al actualizar estado de reporte: ' || sqlerrm);
END;
/
-- Prueba EXECUTE Actualizar_Estado_Reporte(101, 1);



-- DELETE / ELIMINAR
-- 15. Eliminar un Material por Id
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE eliminar_material (
    p_id_material IN NUMBER
) IS
BEGIN
    DELETE FROM materiales
    WHERE
        id_material = p_id_material;

    COMMIT;
    dbms_output.put_line('Material con Id_Material '
                         || p_id_material
                         || ' eliminado.');
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('Material con Id_Material '
                             || p_id_material
                             || ' no encontrado.');
    WHEN OTHERS THEN
        dbms_output.put_line('Error al eliminar material: ' || sqlerrm);
END;
/
-- Prueba EXECUTE Eliminar_Material(101);

-- 16. Eliminar una tarea por Id
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE eliminar_tarea (
    p_id_tarea IN NUMBER
) IS
BEGIN
    DELETE FROM tareas
    WHERE
        id_tarea = p_id_tarea;

    COMMIT;
    dbms_output.put_line('Tarea con Id_Tarea '
                         || p_id_tarea
                         || ' eliminada.');
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('Tarea con Id_Tarea '
                             || p_id_tarea
                             || ' no encontrada.');
    WHEN OTHERS THEN
        dbms_output.put_line('Error al eliminar tarea: ' || sqlerrm);
END;
/
-- Prueba EXECUTE Eliminar_Tarea(101);

--================================= CURSORES =================================--
-- CREATE / INSERT / REGISTRAR
-- 17. Insercion de un nuevo registro diario
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE insertar_registro_diario (
    p_id_entrega  IN  registro_diario.id_entrega%TYPE,
    p_id_ingreso  IN  registro_diario.id_ingreso%TYPE,
    p_id_tarea    IN  registro_diario.id_tarea%TYPE,
    p_estado_id   IN  registro_diario.estado_id%TYPE
) AS

    v_max_id NUMBER;
    CURSOR c_max_id IS
    SELECT
        nvl(MAX(id_registro), 0) + 1
    FROM
        registro_diario;

BEGIN
    OPEN c_max_id;
    FETCH c_max_id INTO v_max_id;
    CLOSE c_max_id;
    INSERT INTO registro_diario (
        id_registro,
        id_entrega,
        id_ingreso,
        id_tarea,
        estado_id
    ) VALUES (
        v_max_id,
        p_id_entrega,
        p_id_ingreso,
        p_id_tarea,
        p_estado_id
    );

    COMMIT;
    
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('No se encontraron datos');
    WHEN too_many_rows THEN
        dbms_output.put_line('Se encontro mas de un registro para el dato seleccionado');
    WHEN OTHERS THEN
        dbms_output.put_line('Ha tenido un error, contacte aqui' || sqlerrm);
END;
/ 



-- READ / MOSTRAR / LISTAR
-- 18. Listar los empleados
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE listar_empleados IS

    CURSOR c_empleados IS
    SELECT
        id_personal,
        nombre,
        apellidos,
        datos_contacto,
        tipo_personal
    FROM
        personal;

    v_empleado c_empleados%rowtype;
BEGIN
    dbms_output.put_line('Lista de Empleados:');
    OPEN c_empleados;
    LOOP
        FETCH c_empleados INTO v_empleado;
        EXIT WHEN c_empleados%notfound;
        dbms_output.put_line('- ID: '
                             || v_empleado.id_personal
                             || ' - Nombre: '
                             || v_empleado.nombre
                             || ' '
                             || v_empleado.apellidos
                             || ' - Contacto: '
                             || v_empleado.datos_contacto
                             || ', Tipo: '
                             || v_empleado.tipo_personal);

    END LOOP;

    CLOSE c_empleados;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error al listar empleados: ' || sqlerrm);
END;
/
-- Prueba - EXECUTE Listar_Empleados;


/*
-- 19. Mostrar los materiales con stock bajo
    - Procedimiento que recorre los materiales con bajo stock (<=10 unidades) usando 
    un cursor explícito para mostrar Id_Material, Nombre y Cantidad_Disponible
*/
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE mostrar_materiales_bajo_stock IS
    -- Declaración del cursor
    CURSOR c_materiales_bajo_stock IS
    SELECT
        id_material,
        nombre,
        cantidad_disponible
    FROM
        materiales
    WHERE
        cantidad_disponible <= 10;

    -- Variables para almacenar datos del cursor
    v_id_material  materiales.id_material%TYPE;
    v_nombre       materiales.nombre%TYPE;
    v_cantidad     materiales.cantidad_disponible%TYPE;
BEGIN
    -- Abrimos el cursor
    OPEN c_materiales_bajo_stock;

    -- Recorremos cada fila del cursor
    LOOP
        FETCH c_materiales_bajo_stock INTO
            v_id_material,
            v_nombre,
            v_cantidad;
        EXIT WHEN c_materiales_bajo_stock%notfound;

        -- Mostramos la información con DBMS_OUTPUT
        dbms_output.put_line('ID Material: '
                             || v_id_material
                             || ' | Nombre: '
                             || v_nombre
                             || ' | Cantidad Disponible: '
                             || v_cantidad);

    END LOOP;

    -- Cerramos el cursor
    CLOSE c_materiales_bajo_stock;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error en procedimiento: ' || sqlerrm);
END;
/
/*Para ejecutar*/
-- EXEC MOSTRAR_MATERIALES_BAJO_STOCK;


-- 20. Procedimiento para recorrer todas las tareas con un estado específico
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE procesar_tareas_estado (
    p_estado_id IN INT
) IS
    -- Declaramos el cursor que seleccionará las tareas de un estado específico
    CURSOR c_tareas IS
    SELECT
        id_tarea,
        nombre,
        descripcion
    FROM
        tareas
    WHERE
        estado_id = p_estado_id;  -- Filtramos por el estado proporcionado
    
    -- Declaramos las variables que almacenarán los valores extraídos del cursor
    v_id_tarea     tareas.id_tarea%TYPE;
    v_nombre       tareas.nombre%TYPE;
    v_descripcion  tareas.descripcion%TYPE;
BEGIN
    -- Abrimos el cursor para empezar a procesar las filas
    OPEN c_tareas;

    -- Bucle para recorrer las filas del cursor
    LOOP
        -- Extraemos los datos de la siguiente fila del cursor y los almacenamos en las variables
        FETCH c_tareas INTO
            v_id_tarea,
            v_nombre,
            v_descripcion;

        -- Salimos del bucle cuando no hay más filas en el cursor
        EXIT WHEN c_tareas%notfound;

        -- Realizamos alguna acción con los datos obtenidos, en este caso, simplemente los imprimimos
        dbms_output.put_line('ID Tarea: '
                             || v_id_tarea
                             || ', Nombre: '
                             || v_nombre
                             || ', Descripción: '
                             || v_descripcion);

    END LOOP;

    -- Cerramos el cursor después de usarlo para liberar recursos
    CLOSE c_tareas;
END;
/
/*Para ejecutar*/
-- EXEC PROCESAR_TAREAS_ESTADO(1);  -- Procesa todas las tareas con Estado_Id = 1


/* 21. Procedimiento que recorre todas las tareas pendientes (Estado_Id = 1) usando 
       un cursor explícito y muestra su información básica. */
CREATE OR REPLACE PROCEDURE mostrar_tareas_pendientes IS
    -- Declaración del cursor para seleccionar tareas en estado pendiente
    CURSOR c_tareas_pendientes IS
    SELECT
        id_tarea,
        nombre,
        fecha_recibido
    FROM
        tareas
    WHERE
        estado_id = 1;

    -- Variables para almacenar temporalmente los valores del cursor
    v_id_tarea  tareas.id_tarea%TYPE;
    v_nombre    tareas.nombre%TYPE;
    v_fecha     tareas.fecha_recibido%TYPE;
BEGIN
    -- Abrimos el cursor
    OPEN c_tareas_pendientes;

    -- Recorremos cada fila del cursor
    LOOP
        FETCH c_tareas_pendientes INTO
            v_id_tarea,
            v_nombre,
            v_fecha;
        EXIT WHEN c_tareas_pendientes%notfound;

        -- Mostramos la información con DBMS_OUTPUT
        dbms_output.put_line('Tarea ID: '
                             || v_id_tarea
                             || ' | Nombre: '
                             || v_nombre
                             || ' | Fecha Recibido: '
                             || v_fecha);

    END LOOP;

    -- Cerramos el cursor
    CLOSE c_tareas_pendientes;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error en procedimiento: ' || sqlerrm);
END;
/
/*Para ejecutar*/
-- EXEC MOSTRAR_TAREAS_PENDIENTES;


-- 22. Mostrar las tareas de los empleados
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE listar_tareas_por_empleado (
    p_upi IN NUMBER
) IS

    CURSOR c_tareas (
        upi NUMBER
    ) IS
    SELECT
        nombre,
        descripcion,
        fecha_recibido
    FROM
        tareas
    WHERE
        upi = upi;

    v_tareas c_tareas%rowtype;
BEGIN
    dbms_output.put_line('Tareas del empleado UPI: ' || p_upi);
    dbms_output.put_line('--------------------------');
    FOR v_tareas IN c_tareas(p_upi) LOOP
        dbms_output.put_line('Nombre: '
                             || v_tareas.nombre
                             || ', Descripción: '
                             || v_tareas.descripcion
                             || ', Fecha: '
                             || v_tareas.fecha_recibido);
    END LOOP;

END;
/
-- Prueba EXECUTE listar_tareas_por_empleado(101);


-- 23. Listar las entregas por destinatario
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE listar_entregas_por_destinatario (
    p_destinatario IN VARCHAR2
) IS

    CURSOR c_entregas IS
    SELECT
        m.nombre AS material,
        e.cantidad_restante,
        de.fecha
    FROM
             entregas e
        JOIN materiales      m ON e.id_material = m.id_material
        JOIN datos_entregas  de ON e.dato_entrega_id = de.dato_entrega_id
    WHERE
        e.destinatario = p_destinatario;

    v_entregas c_entregas%rowtype;
BEGIN
    dbms_output.put_line('Entregas a: ' || p_destinatario);
    dbms_output.put_line('--------------------------');
    FOR v_entregas IN c_entregas LOOP
        dbms_output.put_line('Material: '
                             || v_entregas.material
                             || ', Cantidad: '
                             || v_entregas.cantidad_restante
                             || ', Fecha: '
                             || v_entregas.fecha);
    END LOOP;

END;
/
-- EXECUTE listar_entregas_por_destinatario('');


-- 24. Listar ingresos por fechas
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE listar_ingresos_por_fecha (
    p_fecha_inicio  IN  DATE,
    p_fecha_fin     IN  DATE
) IS

    CURSOR c_ingresos (
        fecha_inicio  DATE,
        fecha_fin     DATE
    ) IS
    SELECT
        m.nombre AS material,
        i.cantidad_recibida,
        i.fecha_ingreso
    FROM
             ingresos i
        JOIN materiales m ON i.id_material = m.id_material
    WHERE
        i.fecha_ingreso BETWEEN fecha_inicio AND fecha_fin;

    v_ingresos c_ingresos%rowtype;
BEGIN
    dbms_output.put_line('Ingresos entre '
                         || p_fecha_inicio
                         || ' y '
                         || p_fecha_fin);
    dbms_output.put_line('--------------------------');
    FOR v_ingresos IN c_ingresos(p_fecha_inicio, p_fecha_fin) LOOP
        dbms_output.put_line('Material: '
                             || v_ingresos.material
                             || ', Cantidad: '
                             || v_ingresos.cantidad_recibida
                             || ', Fecha: '
                             || v_ingresos.fecha_ingreso);
    END LOOP;

END;
/
-- Prueba EXECUTE listar_ingresos_por_fecha('15-ENE-2025', '20-MAR-2025');


-- 25. Procedimiento que recorre los reportes de un estado específico y muestra su información
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE mostrar_reportes_por_estado (
    p_estado_id IN INT
) IS

    -- Cursor que obtiene los reportes con el Estado_Id proporcionado
    CURSOR c_reportes IS
    SELECT
        id_reporte,
        descripcion,
        id_usuario
    FROM
        reportes
    WHERE
        estado_id = p_estado_id;

    -- Variables para almacenar los datos del cursor
    v_id_reporte   reportes.id_reporte%TYPE;
    v_descripcion  reportes.descripcion%TYPE;
    v_id_usuario   reportes.id_usuario%TYPE;
BEGIN
    -- Abrimos el cursor
    OPEN c_reportes;

    -- Recorremos los resultados del cursor
    LOOP
        FETCH c_reportes INTO
            v_id_reporte,
            v_descripcion,
            v_id_usuario;
        EXIT WHEN c_reportes%notfound;

        -- Mostramos la información por consola (DBMS_OUTPUT)
        dbms_output.put_line('Reporte ID: '
                             || v_id_reporte
                             || ' | Usuario ID: '
                             || v_id_usuario
                             || ' | Descripción: '
                             || v_descripcion);

    END LOOP;

    -- Cerramos el cursor
    CLOSE c_reportes;
END;
/



-- UPDATE / MODIFICAR / ACTUALIZAR
-- 26. Actualizar datos de contacto del personal
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE actualizar_contacto_personal (
    p_tipo                   IN  VARCHAR2,
    p_nuevos_datos_contacto  IN  VARCHAR2
) IS

    CURSOR c_personal IS
    SELECT
        id_personal,
        datos_contacto
    FROM
        personal
    WHERE
        tipo_personal = p_tipo
    FOR UPDATE; -- Importante para el bloqueo de filas
    v_personal c_personal%rowtype;
BEGIN
    OPEN c_personal;
    LOOP
        FETCH c_personal INTO v_personal;
        EXIT WHEN c_personal%notfound;
        UPDATE personal
        SET
            datos_contacto = p_nuevos_datos_contacto
        WHERE
            id_personal = v_personal.id_personal;

        dbms_output.put_line('Contacto actualizado para Id_Personal: ' || v_personal.id_personal);
    END LOOP;

    CLOSE c_personal;
    COMMIT;
END;
/
-- Prueba EXECUTE actualizar_contacto_personal('Empleado', 'nuevos_contacto@email.com');


-- 27. Actualizar el estado de las tareas a 'En Proceso'
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE actualizar_tareas_en_proceso IS

    CURSOR c_tareas (
        fecha_limite DATE
    ) IS
    SELECT
        id_tarea
    FROM
        tareas
    WHERE
            fecha_recibido >= fecha_limite
        AND estado_id != (
            SELECT
                estado_id
            FROM
                estado
            WHERE
                descripcion = 'En Proceso'
        )
    FOR UPDATE;

    v_tarea              c_tareas%rowtype;
    v_estado_en_proceso  NUMBER;
BEGIN
  -- Obtener el Estado_Id para "En Proceso"
    SELECT
        estado_id
    INTO v_estado_en_proceso
    FROM
        estado
    WHERE
        descripcion = 'En Proceso';

  -- Calcular la fecha límite (una semana atrás)
    DECLARE
        fecha_limite DATE := sysdate - 7;
    BEGIN
        OPEN c_tareas(fecha_limite);
        LOOP
            FETCH c_tareas INTO v_tarea;
            EXIT WHEN c_tareas%notfound;
            UPDATE tareas
            SET
                estado_id = v_estado_en_proceso
            WHERE
                id_tarea = v_tarea.id_tarea;

            dbms_output.put_line('Tarea '
                                 || v_tarea.id_tarea
                                 || ' marcada como En Proceso.');
        END LOOP;

        CLOSE c_tareas;
        COMMIT;
    END;

END;
/
-- Prueba EXECUTE actualizar_tareas_en_proceso;


-- 28. Actualizar el estado de las tareas a 'COMPLETADA'
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE actualizar_tareas_completadas IS

    CURSOR c_tareas (
        fecha_limite DATE
    ) IS
    SELECT
        id_tarea
    FROM
        tareas
    WHERE
            fecha_recibido < fecha_limite
        AND estado_id != (
            SELECT
                estado_id
            FROM
                estado
            WHERE
                descripcion = 'Completada'
        )
    FOR UPDATE;

    v_tarea              c_tareas%rowtype;
    v_estado_completada  NUMBER;
BEGIN
  -- Obtener el Estado_Id para "Completada"
    SELECT
        estado_id
    INTO v_estado_completada
    FROM
        estado
    WHERE
        descripcion = 'Completada';

  -- Calcular la fecha límite (una semana atrás)
    DECLARE
        fecha_limite DATE := sysdate - 7;
    BEGIN
        OPEN c_tareas(fecha_limite);
        LOOP
            FETCH c_tareas INTO v_tarea;
            EXIT WHEN c_tareas%notfound;
            UPDATE tareas
            SET
                estado_id = v_estado_completada
            WHERE
                id_tarea = v_tarea.id_tarea;

            dbms_output.put_line('Tarea '
                                 || v_tarea.id_tarea
                                 || ' marcada como Completada.');
        END LOOP;

        CLOSE c_tareas;
        COMMIT;
    END;

END;
/
-- Prueba EXECUTE actualizar_tareas_completadas;


-- 29. Actualizar el estado del material con stock bajo
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE actualizar_estado_material_bajo_stock IS

    CURSOR c_materiales IS
    SELECT
        id_material,
        cantidad_disponible,
        estado_id
    FROM
        materiales
    WHERE
        cantidad_disponible < 10;  -- Suponemos que si la cantidad disponible es menor a 10, es bajo stock

    v_id_material          materiales.id_material%TYPE;
    v_cantidad_disponible  materiales.cantidad_disponible%TYPE;
    v_estado_id            materiales.estado_id%TYPE;
BEGIN
    -- Abriendo el cursor
    OPEN c_materiales;
    
    -- Bucle para recorrer todos los materiales con bajo stock
    LOOP
        FETCH c_materiales INTO
            v_id_material,
            v_cantidad_disponible,
            v_estado_id;
        EXIT WHEN c_materiales%notfound;
        
        -- Actualizando el estado de los materiales con bajo stock
        UPDATE materiales
        SET
            estado_id = 2  -- Suponemos que el Estado_Id = 2 es "Bajo Stock"
        WHERE
            id_material = v_id_material;
        
        -- Mostramos un mensaje indicando que el material fue actualizado
        dbms_output.put_line('Material con ID '
                             || v_id_material
                             || ' actualizado a estado "Bajo Stock".');
    END LOOP;

    -- Cerrando el cursor
    CLOSE c_materiales;
    
    -- Confirmación de la ejecución del procedimiento
    dbms_output.put_line('El proceso de actualización de materiales con bajo stock ha finalizado.');
EXCEPTION
    -- Manejo de errores
    WHEN OTHERS THEN
        dbms_output.put_line('Ocurrió un error: ' || sqlerrm);
        -- Cerramos el cursor en caso de error
        IF c_materiales%isopen THEN
            CLOSE c_materiales;
        END IF;
END;
/
/*Para ejecutar*/
-- EXEC ACTUALIZAR_ESTADO_MATERIAL_BAJO_STOCK;



-- GENERAR
-- 30. Generacion de alertas de stock bajo
CREATE OR REPLACE PROCEDURE generar_alertas_stock AS

    CURSOR c_inventario IS
    SELECT
        id_inventario,
        id_material
    FROM
        inventario
    WHERE
        (
            SELECT
                cantidad_disponible
            FROM
                materiales
            WHERE
                id_material = inventario.id_material
        ) < 10; -- Ejemplo de umbral
BEGIN
    FOR inv_rec IN c_inventario LOOP
        UPDATE inventario
        SET
            alertas_stock = 'Stock bajo para material '
                            || (
                SELECT
                    nombre
                FROM
                    materiales
                WHERE
                    id_material = inv_rec.id_material
            )
        WHERE
            id_inventario = inv_rec.id_inventario;

    END LOOP;

    COMMIT;
    
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('No se encontraron datos');
    WHEN OTHERS THEN
        dbms_output.put_line('Ha tenido un error, contacte aqui' || sqlerrm);
END;
/

    
-- ASIGNAR
-- 31. Asignacion de las tareas pendientes a los empleados segun la linea de trabajo
CREATE OR REPLACE PROCEDURE asignar_tareas_empleados AS

    CURSOR c_tareas IS
    SELECT
        id_tarea,
        nombre,
        descripcion
    FROM
        tareas
    WHERE
        upi IS NULL
        AND estado_id = (
            SELECT
                estado_id
            FROM
                estado
            WHERE
                descripcion = 'Pendiente'
        );

    CURSOR c_empleados (
        p_linea_trabajo VARCHAR2
    ) IS
    SELECT
        upi
    FROM
        personal
    WHERE
        linea_trabajo = p_linea_trabajo;

    v_linea_trabajo VARCHAR2(100); -- Variable para almacenar la línea de trabajo

BEGIN
    -- Obtener la línea de trabajo del primer empleado disponible
    SELECT
        linea_trabajo
    INTO v_linea_trabajo
    FROM
        personal
    WHERE
        ROWNUM = 1;

    FOR tarea_rec IN c_tareas LOOP
        FOR empleado_rec IN c_empleados(v_linea_trabajo) LOOP -- Pasar la variable como parámetro
            UPDATE tareas
            SET
                upi = empleado_rec.upi
            WHERE
                id_tarea = tarea_rec.id_tarea;

            EXIT; -- Asigna la tarea al primer empleado disponible
        END LOOP;
    END LOOP;

    COMMIT;
    
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('No se encontraron datos');
    WHEN OTHERS THEN
        dbms_output.put_line('Ha tenido un error, contacte aqui ' || sqlerrm);
END;
/
    
    
-- 32. Asignacion de un material a una bodega en especifico
CREATE OR REPLACE PROCEDURE asignar_material_bodega (
    p_bodega_id    IN  bodega_material.bodega_id%TYPE,
    p_id_material  IN  bodega_material.id_material%TYPE
) AS

    v_max_id NUMBER;
    CURSOR c_max_id IS
    SELECT
        nvl(MAX(bodega_material_id), 0) + 1
    FROM
        bodega_material;

BEGIN
    OPEN c_max_id;
    FETCH c_max_id INTO v_max_id;
    CLOSE c_max_id;
    INSERT INTO bodega_material (
        bodega_material_id,
        bodega_id,
        id_material
    ) VALUES (
        v_max_id,
        p_bodega_id,
        p_id_material
    );

    COMMIT;
    
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('No se encontraron datos');
    WHEN OTHERS THEN
        dbms_output.put_line('Ha tenido un error, contacte aqui' || sqlerrm);
END;
/

    

    
    
    
