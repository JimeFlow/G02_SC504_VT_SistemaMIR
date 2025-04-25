/*CREADO POR: Grupo 2
FECHA: 25/04/2025
PROYECTO FINAL: Avance 03 con el Esquema ABBOTT*/

--=============================== PACKAGE BODY ===============================--
CREATE OR REPLACE PACKAGE BODY FIDE_PROYECTO_FINAL_PKG AS

--================================ FUNCIONES =================================--
  -- FUNCION CON ESTADO
  FUNCTION FIDE_ESTADO_TB_Obtener_Descripcion_Estado_FN (
    P_Estado_Id IN FIDE_ESTADO_TB.Estado_Id%TYPE
  ) RETURN VARCHAR2 AS
    V_Descripcion_Estado VARCHAR2(50);
  BEGIN
    SELECT Descripcion
    INTO V_Descripcion_Estado
    FROM FIDE_ESTADO_TB
    WHERE Estado_Id = P_Estado_Id;
    RETURN V_Descripcion_Estado;
  END FIDE_ESTADO_TB_Obtener_Descripcion_Estado_FN;

  -- FUNCIONES CON MATERIALES Y BODEGAS
  FUNCTION FIDE_MATERIALES_TB_Obtener_Nombre_Material_FN (
    P_Id_Material IN FIDE_MATERIALES_TB.Id_Material%TYPE
  ) RETURN VARCHAR2 AS
    V_Nombre_Material VARCHAR2(100);
  BEGIN
    SELECT Nombre
    INTO V_Nombre_Material
    FROM FIDE_MATERIALES_TB
    WHERE Id_Material = P_Id_Material;
    RETURN V_Nombre_Material;
  END FIDE_MATERIALES_TB_Obtener_Nombre_Material_FN;

  FUNCTION FIDE_MATERIALES_TB_Calcular_Total_Materiales_Disponible_FN
  RETURN NUMBER AS
    V_Total_Materiales NUMBER;
  BEGIN
    SELECT SUM(Cantidad_Disponible)
    INTO V_Total_Materiales
    FROM FIDE_MATERIALES_TB;
    RETURN V_Total_Materiales;
  END FIDE_MATERIALES_TB_Calcular_Total_Materiales_Disponible_FN;

  FUNCTION FIDE_BODEGAS_TB_Contar_Materiales_Bodega_FN (
    P_Bodega_Id IN FIDE_BODEGAS_TB.Bodega_Id%TYPE
  ) RETURN NUMBER AS
    V_Num_Materiales NUMBER;
  BEGIN
    SELECT COUNT(*)
    INTO V_Num_Materiales
    FROM FIDE_BODEGAS_TB WHERE Bodega_Id = P_Bodega_Id;
    RETURN V_Num_Materiales;
  END FIDE_BODEGAS_TB_Contar_Materiales_Bodega_FN;

  FUNCTION FIDE_BODEGA_MATERIAL_TB_Material_Disponible_Bodega_FN (
    P_Bodega_Id IN FIDE_BODEGAS_TB.Bodega_Id%TYPE,
    P_Id_Material IN FIDE_MATERIALES_TB.Id_Material%TYPE
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
      RETURN FALSE; -- Added a return value for the exception case
    WHEN TOO_MANY_ROWS THEN
      DBMS_OUTPUT.PUT_LINE('Se encontro mas de un registro para el dato seleccionado');
      RETURN FALSE; -- Added a return value for the exception case
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('ERROR ' || SQLERRM);
      RETURN FALSE; -- Added a return value for the exception case
  END FIDE_BODEGA_MATERIAL_TB_Material_Disponible_Bodega_FN;

  FUNCTION FIDE_BODEGAS_TB_Obtener_Nombre_Bodega_FN (
    P_Bodega_Id IN FIDE_BODEGAS_TB.Bodega_Id%TYPE
  ) RETURN VARCHAR2 AS
    V_Nombre_Bodega VARCHAR2(100);
  BEGIN
    SELECT Sucursal
    INTO V_Nombre_Bodega
    FROM FIDE_BODEGAS_TB
    WHERE Bodega_Id = P_Bodega_Id;
    RETURN V_Nombre_Bodega;
  END FIDE_BODEGAS_TB_Obtener_Nombre_Bodega_FN;

  FUNCTION FIDE_BODEGAS_TB_Calcular_Stock_Total_Bodega_FN (
    P_Bodega_Id IN FIDE_BODEGAS_TB.Bodega_Id%TYPE
  ) RETURN NUMBER AS
    V_Stock_Total NUMBER;
  BEGIN
    SELECT Stock
    INTO V_Stock_Total
    FROM FIDE_BODEGAS_TB
    WHERE Bodega_Id = P_Bodega_Id;
    RETURN V_Stock_Total;
  END FIDE_BODEGAS_TB_Calcular_Stock_Total_Bodega_FN;

  -- FUNCIONES CON PERSONAL Y TAREAS
  FUNCTION FIDE_PERSONAL_TB_Obtener_Nombre_Empleado_FN (
    P_UPI IN FIDE_PERSONAL_TB.UPI%TYPE
  ) RETURN VARCHAR2 AS
    V_Nombre_Empleado VARCHAR2(200);
  BEGIN
    SELECT Nombre || ' ' || Apellidos
    INTO V_Nombre_Empleado
    FROM FIDE_PERSONAL_TB
    WHERE UPI = P_UPI;
    RETURN V_Nombre_Empleado ;
  END FIDE_PERSONAL_TB_Obtener_Nombre_Empleado_FN;

  FUNCTION FIDE_TAREAS_TB_Contar_Tareas_Pendientes_FN (
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
  END FIDE_TAREAS_TB_Contar_Tareas_Pendientes_FN;

  FUNCTION FIDE_INVENTARIO_TB_Obtener_Responsable_Inventario_FN (
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
  END FIDE_INVENTARIO_TB_Obtener_Responsable_Inventario_FN;

  -- FUNCIONES CON ENTREGAS E INGRESOS
  FUNCTION FIDE_ENTREGAS_TB_Calcular_Cantidad_Restante_Entregas_FN (
    P_Id_Entrega IN FIDE_ENTREGAS_TB.Id_Entrega%TYPE
  ) RETURN NUMBER AS
    V_Cantidad_Restante NUMBER;
  BEGIN
    SELECT Cantidad_Restante
    INTO V_Cantidad_Restante
    FROM FIDE_ENTREGAS_TB
    WHERE Id_Entrega = P_Id_Entrega;
    RETURN V_Cantidad_Restante;
  END FIDE_ENTREGAS_TB_Calcular_Cantidad_Restante_Entregas_FN;

  FUNCTION FIDE_DATOS_ENTREGAS_TB_Obtener_FechaHora_Entrega_FN (
    P_Dato_Entrega_Id IN FIDE_DATOS_ENTREGAS_TB.Dato_Entrega_Id%TYPE
  ) RETURN TIMESTAMP AS
    V_Fecha_Hora_Entrega TIMESTAMP;
  BEGIN
    SELECT TO_CHAR(Fecha, 'YYYY-MM-DD') || ' ' || TO_CHAR(Hora, 'HH24:MI:SS')
    INTO V_Fecha_Hora_Entrega
    FROM FIDE_DATOS_ENTREGAS_TB
    WHERE Dato_Entrega_Id = P_Dato_Entrega_Id;
    RETURN V_Fecha_Hora_Entrega;
  END FIDE_DATOS_ENTREGAS_TB_Obtener_FechaHora_Entrega_FN;

  FUNCTION FIDE_INGRESOS_TB_Obtener_Fecha_Ingreso_Material_FN (
    P_Id_Ingreso IN FIDE_INGRESOS_TB.Id_Ingreso%TYPE)
  RETURN DATE AS
    V_Fecha_Ingreso DATE;
  BEGIN
    SELECT Fecha_Ingreso
    INTO V_Fecha_Ingreso
    FROM FIDE_INGRESOS_TB
    WHERE Id_Ingreso = P_Id_Ingreso;
    RETURN V_Fecha_Ingreso;
  END FIDE_INGRESOS_TB_Obtener_Fecha_Ingreso_Material_FN;

  -- FUNCIONES CON ROLES Y AREAS
  FUNCTION FIDE_ROLES_TB_Obtener_TipoRol_Personal_FN (
    P_Id_Rol IN FIDE_ROLES_TB.Id_Rol%TYPE
  ) RETURN VARCHAR2 AS
    V_Tipo_Rol VARCHAR2(50);
  BEGIN
    SELECT tr.Nombre_Rol
    INTO V_Tipo_Rol
    FROM FIDE_ROLES_TB r
    JOIN FIDE_TIPOS_ROL_TB tr ON r.TipoRol_Id = tr.TipoRol_Id
    WHERE r.Id_Rol = P_Id_Rol;
    RETURN V_Tipo_Rol;
  END FIDE_ROLES_TB_Obtener_TipoRol_Personal_FN;

  FUNCTION FIDE_AREAS_TB_Obtener_Nombre_Area_FN (
    P_Area_Id IN FIDE_AREAS_TB.Area_Id%TYPE
  ) RETURN VARCHAR2 AS
    V_Nombre_Area VARCHAR2(100);
  BEGIN
    SELECT Nombre
    INTO V_Nombre_Area
    FROM FIDE_AREAS_TB
    WHERE Area_Id = P_Area_Id;
    RETURN V_Nombre_Area;
  END FIDE_AREAS_TB_Obtener_Nombre_Area_FN;



--============================== PROCEDIMIENTOS ==============================--

  -- CREATE / INSERT / REGISTRAR
  -- 1. Registrar un nuevo personal
  PROCEDURE FIDE_PERSONAL_TB_Registrar_Personal_SP (
    P_Id_Personal      IN  NUMBER,
    P_Id_Rol           IN  NUMBER,
    P_Id_Entrega       IN  NUMBER,
    P_Horario_Id       IN  NUMBER,
    P_Estado_Id        IN  NUMBER,
    P_Tipo_Personal    IN  VARCHAR2,
    P_Nombre           IN  VARCHAR2,
    P_Apellidos        IN  VARCHAR2,
    P_Datos_Contacto   IN  VARCHAR2,
    P_Linea_Trabajo    IN  VARCHAR2,
    P_Id_Usuario       IN  NUMBER DEFAULT NULL,
    P_UPI              IN  NUMBER DEFAULT NULL
  ) IS
  BEGIN
    INSERT INTO FIDE_PERSONAL_TB (
      Id_Personal, Id_Rol, Id_Entrega, Horario_Id, Estado_Id,
      Tipo_Personal, Nombre, Apellidos, Datos_Contacto, Linea_Trabajo,
      Id_Usuario, UPI
    ) VALUES (
      P_Id_Personal, P_Id_Rol, P_Id_Entrega, P_Horario_Id, P_Estado_Id,
      P_Tipo_Personal, P_Nombre, P_Apellidos, P_Datos_Contacto, P_Linea_Trabajo,
      P_Id_Usuario, P_UPI
    );
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Personal registrado con Id_Personal ' || P_Id_Personal);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error al registrar personal ' || SQLERRM);
  END FIDE_PERSONAL_TB_Registrar_Personal_SP;

  /* 2. Insertar una nueva tarea en la tabla TAREAS.
     - Recibe como parámetros los valores de cada columna de la tabla TAREAS y realiza
     la inserción correspondiente, asignando la fecha de recepción actual.*/
  PROCEDURE FIDE_TAREAS_TB_Insertar_Tarea_SP (
    P_Id_Tarea       IN  INT,
    P_UPI            IN  NUMBER,
    P_Estado_Id      IN  INT,
    P_Nombre         IN  VARCHAR2,
    P_Fecha_Recibido IN  DATE,
    P_Descripcion    IN  VARCHAR2
  ) AS
  BEGIN
    INSERT INTO FIDE_TAREAS_TB (
      Id_Tarea, UPI, Estado_Id, Nombre, Fecha_Recibido, Descripcion
    ) VALUES (
      P_Id_Tarea, P_UPI, P_Estado_Id, P_Nombre, P_Fecha_Recibido, P_Descripcion
    );
    COMMIT;
  END FIDE_TAREAS_TB_Insertar_Tarea_SP;

  -- 3. Registrar un nuevo ingreso de material
  PROCEDURE FIDE_INGRESOS_TB_Registrar_Ingreso_SP (
    P_Id_Ingreso        IN  NUMBER,
    P_Id_Material       IN  NUMBER,
    P_UPI               IN  NUMBER,
    P_Estado_Id         IN  NUMBER,
    P_Cantidad_Recibida IN  NUMBER,
    P_Fecha_Ingreso     IN  DATE
  ) IS
  BEGIN
    INSERT INTO FIDE_INGRESOS_TB (
      Id_Ingreso, Id_Material, UPI, Estado_Id, Cantidad_Recibida, Fecha_Ingreso
    ) VALUES (
      P_Id_Ingreso, P_Id_Material, P_UPI, P_Estado_Id, P_Cantidad_Recibida, P_Fecha_Ingreso
    );
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Ingreso registrado con Id_Ingreso ' || P_Id_Ingreso);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error al registrar ingreso ' || SQLERRM);
  END FIDE_INGRESOS_TB_Registrar_Ingreso_SP;

  -- 4. Registrar un nuevo reporte
  PROCEDURE FIDE_REPORTES_TB_Registrar_Reporte_SP (
    P_Id_Reporte    IN  NUMBER,
    P_Id_Usuario    IN  NUMBER,
    P_Id_Inventario IN  NUMBER,
    P_Id_Registro   IN  NUMBER,
    P_Estado_Id     IN  NUMBER,
    P_Descripcion   IN  VARCHAR2
  ) IS
  BEGIN
    INSERT INTO FIDE_REPORTES_TB (
      Id_Reporte, Id_Usuario, Id_Inventario, Id_Registro, Estado_Id, Descripcion
    ) VALUES (
      P_Id_Reporte, P_Id_Usuario, P_Id_Inventario, P_Id_Registro, P_Estado_Id, P_Descripcion
    );
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Reporte registrado con Id_Reporte ' || P_Id_Reporte);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error al registrar reporte ' || SQLERRM);
  END FIDE_REPORTES_TB_Registrar_Reporte_SP;

  -- READ / MOSTRAR / LISTAR
  -- 5. Mostrar material por ID
  PROCEDURE FIDE_MATERIALES_TB_Mostrar_Material_SP (
    P_id_material       IN   NUMBER,
    P_nombre            OUT  VARCHAR2,
    P_fecha_vencimiento OUT  DATE,
    P_cantidad_disponible OUT  NUMBER,
    P_cantidad_solicitada OUT  NUMBER
  ) IS
  BEGIN
    SELECT nombre, fecha_vencimiento, cantidad_disponible, cantidad_solicitada
    INTO P_nombre, P_fecha_vencimiento, P_cantidad_disponible, P_cantidad_solicitada
    FROM FIDE_MATERIALES_TB
    WHERE id_material = P_id_material;
  EXCEPTION
    WHEN no_data_found THEN
      dbms_output.put_line('Material con Id_Material ' || P_id_material || ' no encontrado.');
    WHEN OTHERS THEN
      dbms_output.put_line('Error al mostrar material: ' || sqlerrm);
  END FIDE_MATERIALES_TB_Mostrar_Material_SP;

  -- 6. Procedimiento para verificar si hay suficiente material ingresado
  PROCEDURE FIDE_INGRESOS_TB_Verificar_Material_Suficiente_SP (
    P_id_material    IN   INT,
    P_ultima_cantidad IN   INT,
    P_suficiente     OUT  VARCHAR2
  ) IS
    V_cantidad_recibida INT;
  BEGIN
    SELECT SUM(cantidad_recibida)
    INTO V_cantidad_recibida
    FROM FIDE_INGRESOS_TB
    WHERE id_material = P_id_material;

    IF V_cantidad_recibida >= P_ultima_cantidad THEN
      P_suficiente := 'Suficiente';
    ELSE
      P_suficiente := 'No Suficiente';
    END IF;
  END FIDE_INGRESOS_TB_Verificar_Material_Suficiente_SP;

  -- 7. Mostrar los datos de una tarea por Id
  PROCEDURE FIDE_TAREAS_TB_Mostrar_Tarea_SP (
    P_id_tarea       IN   NUMBER,
    P_upi            OUT  NUMBER,
    P_nombre         OUT  VARCHAR2,
    P_fecha_recibido OUT  DATE,
    P_descripcion    OUT  VARCHAR2
  ) IS
  BEGIN
    SELECT upi, nombre, fecha_recibido, descripcion
    INTO P_upi, P_nombre, P_fecha_recibido, P_descripcion
    FROM FIDE_TAREAS_TB
    WHERE id_tarea = P_id_tarea;
  EXCEPTION
    WHEN no_data_found THEN
      dbms_output.put_line('Tarea con Id_Tarea ' || P_id_tarea || ' no encontrada.');
    WHEN OTHERS THEN
      dbms_output.put_line('Error al mostrar tarea ' || sqlerrm);
  END FIDE_TAREAS_TB_Mostrar_Tarea_SP;

  -- UPDATE / MODIFICAR / ACTUALIZAR
  /* 8. Procedimiento que permite aumentar la cantidad disponible de un material específico.
     - Se utiliza para actualizar el stock cuando se recibe nuevo material. */
  PROCEDURE FIDE_MATERIALES_TB_Aumentar_Cantidad_Material_SP (
    P_id_material       IN  INT,
    P_cantidad_a_agregar IN  INT
  ) IS
  BEGIN
    UPDATE FIDE_MATERIALES_TB
    SET cantidad_disponible = cantidad_disponible + P_cantidad_a_agregar
    WHERE id_material = P_id_material;
    dbms_output.put_line('Se ha actualizado el stock del material con ID ' || P_id_material);
  EXCEPTION
    WHEN no_data_found THEN
      dbms_output.put_line('Material no encontrado');
    WHEN OTHERS THEN
      dbms_output.put_line('Error al actualizar el stock ' || sqlerrm);
  END FIDE_MATERIALES_TB_Aumentar_Cantidad_Material_SP;

  -- 9. Procedimiento para actualizar el stock de una bodega en la tabla BODEGAS
  -- Recibe el ID de la bodega y el nuevo valor de stock
  PROCEDURE FIDE_BODEGAS_TB_Actualizar_Stock_Bodega_SP (
    P_bodega_id    IN  FIDE_BODEGAS_TB.bodega_id%TYPE,
    P_nuevo_stock  IN  FIDE_BODEGAS_TB.stock%TYPE
  ) IS
  BEGIN
    UPDATE FIDE_BODEGAS_TB
    SET stock = P_nuevo_stock
    WHERE bodega_id = P_bodega_id;
    dbms_output.put_line('Stock actualizado correctamente para la bodega ' || P_bodega_id);
  EXCEPTION
    WHEN OTHERS THEN
      dbms_output.put_line('Error al actualizar el stock ' || sqlerrm);
  END FIDE_BODEGAS_TB_Actualizar_Stock_Bodega_SP;

  -- 10. Actualizar datos de contacto de un empleado
  PROCEDURE FIDE_PERSONAL_TB_Actualizar_Rol_Empleado_SP (
    P_upi          IN  NUMBER,
    P_nuevo_rol_id IN  NUMBER
  ) IS
  BEGIN
    UPDATE FIDE_PERSONAL_TB
    SET id_rol = P_nuevo_rol_id
    WHERE upi = P_upi;  -- Asumiendo que la columna para el UPI es 'upi'
    COMMIT;
    dbms_output.put_line('Rol de empleado ' || P_upi || ' actualizado.');
  EXCEPTION
    WHEN no_data_found THEN
      dbms_output.put_line('Empleado con UPI ' || P_upi || ' no encontrado.');
    WHEN OTHERS THEN
      dbms_output.put_line('Error al actualizar rol: ' || sqlerrm);
  END FIDE_PERSONAL_TB_Actualizar_Rol_Empleado_SP;

  -- 11. Actualizar el horario del empleado
  PROCEDURE FIDE_PERSONAL_TB_Actualizar_Horario_Empleado_SP (
    P_id_personal    IN  NUMBER,
    P_nuevo_horario_id IN  NUMBER
  ) IS
  BEGIN
    UPDATE FIDE_PERSONAL_TB
    SET horario_id = P_nuevo_horario_id
    WHERE id_personal = P_id_personal;
    COMMIT;
    dbms_output.put_line('Horario de empleado ' || P_id_personal || ' actualizado.');
  EXCEPTION
    WHEN no_data_found THEN
      dbms_output.put_line('Empleado con Id ' || P_id_personal || ' no encontrado.');
    WHEN OTHERS THEN
      dbms_output.put_line('Error al actualizar horario ' || sqlerrm);
  END FIDE_PERSONAL_TB_Actualizar_Horario_Empleado_SP;

  -- 12. Actualizar estado de los ingresos
  PROCEDURE FIDE_INGRESOS_TB_Actualizar_Estado_Ingreso_SP (
    P_id_ingreso    IN  NUMBER,
    P_nuevo_estado_id IN  NUMBER
  ) IS
  BEGIN
    UPDATE FIDE_INGRESOS_TB
    SET estado_id = P_nuevo_estado_id
    WHERE id_ingreso = P_id_ingreso;
    COMMIT;
    dbms_output.put_line('Estado de ingreso ' || P_id_ingreso || ' actualizado.');
  EXCEPTION
    WHEN no_data_found THEN
      dbms_output.put_line('Ingreso con Id_Ingreso ' || P_id_ingreso || ' no encontrado.');
    WHEN OTHERS THEN
      dbms_output.put_line('Error al actualizar estado ' || sqlerrm);
  END FIDE_INGRESOS_TB_Actualizar_Estado_Ingreso_SP;

  -- 13. Actualizar descripcion de un reporte
  PROCEDURE FIDE_REPORTES_TB_Actualizar_Descripcion_Reporte_SP (
    P_id_reporte      IN  NUMBER,
    P_nueva_descripcion IN  VARCHAR2
  ) IS
  BEGIN
    UPDATE FIDE_REPORTES_TB
    SET descripcion = P_nueva_descripcion
    WHERE id_reporte = P_id_reporte;
    COMMIT;
    dbms_output.put_line('Descripción de reporte ' || P_id_reporte || ' actualizada.');
  EXCEPTION
    WHEN no_data_found THEN
      dbms_output.put_line('Reporte con Id_Reporte ' || P_id_reporte || ' no encontrado.');
    WHEN OTHERS THEN
      dbms_output.put_line('Error al actualizar descripción ' || sqlerrm);
  END FIDE_REPORTES_TB_Actualizar_Descripcion_Reporte_SP;

  -- 14. Actualizar estado del reporte
  PROCEDURE FIDE_REPORTES_TB_Actualizar_Estado_Reporte_SP (
    P_id_reporte      IN  NUMBER,
    P_nuevo_estado_id IN  NUMBER
  ) IS
  BEGIN
    UPDATE FIDE_REPORTES_TB
    SET estado_id = P_nuevo_estado_id
    WHERE id_reporte = P_id_reporte;
    COMMIT;
    dbms_output.put_line('Estado de reporte '
                         || P_id_reporte
                         || ' actualizado a '
                         || P_nuevo_estado_id);
  EXCEPTION
    WHEN no_data_found THEN
      dbms_output.put_line('Reporte con Id ' || P_id_reporte || ' no encontrado.');
    WHEN OTHERS THEN
      dbms_output.put_line('Error al actualizar estado de reporte ' || sqlerrm);
  END FIDE_REPORTES_TB_Actualizar_Estado_Reporte_SP;

  -- DELETE / ELIMINAR
  -- 15. Eliminar un Material por Id
  PROCEDURE FIDE_MATERIALES_TB_Eliminar_Material_SP (
    P_id_material IN NUMBER
  ) IS
  BEGIN
    DELETE FROM FIDE_MATERIALES_TB
    WHERE id_material = P_id_material;
    COMMIT;
    dbms_output.put_line('Material con Id_Material ' || P_id_material || ' eliminado.');
  EXCEPTION
    WHEN no_data_found THEN
      dbms_output.put_line('Material con Id_Material ' || p_id_material || ' no encontrado.');
    WHEN OTHERS THEN
      dbms_output.put_line('Error al eliminar material ' || sqlerrm);
  END FIDE_MATERIALES_TB_Eliminar_Material_SP;

  -- 16. Eliminar una tarea por Id
  PROCEDURE FIDE_TAREAS_TB_Eliminar_Tarea_SP (
    P_id_tarea IN NUMBER
  ) IS
  BEGIN
    DELETE FROM FIDE_TAREAS_TB
    WHERE id_tarea = P_id_tarea;
    COMMIT;
    dbms_output.put_line('Tarea con Id_Tarea ' || P_id_tarea || ' eliminada.');
  EXCEPTION
    WHEN no_data_found THEN
      dbms_output.put_line('Tarea con Id_Tarea ' || p_id_tarea || ' no encontrada.');
    WHEN OTHERS THEN
      dbms_output.put_line('Error al eliminar tarea ' || sqlerrm);
  END FIDE_TAREAS_TB_Eliminar_Tarea_SP;


--======================= PROCEDIMIENTOS CON CURSORES ========================--

  -- CREATE / INSERT / REGISTRAR
  -- 17. Insercion de un nuevo registro diario
  PROCEDURE FIDE_REGISTRO_DIARIO_TB_Insertar_Registro_Diario_SP (
    P_id_entrega  IN  FIDE_REGISTRO_DIARIO_TB.id_entrega%TYPE,
    P_id_ingreso  IN  FIDE_REGISTRO_DIARIO_TB.id_ingreso%TYPE,
    P_id_tarea    IN  FIDE_REGISTRO_DIARIO_TB.id_tarea%TYPE,
    P_estado_id   IN  FIDE_REGISTRO_DIARIO_TB.estado_id%TYPE
  ) AS
    V_max_id NUMBER;
    CURSOR c_max_id IS
    SELECT
      nvl(MAX(id_registro), 0) + 1
    FROM
      FIDE_REGISTRO_DIARIO_TB;
  BEGIN
    OPEN c_max_id;
    FETCH c_max_id INTO v_max_id;
    CLOSE c_max_id;
    INSERT INTO FIDE_REGISTRO_DIARIO_TB (
      id_registro,
      id_entrega,
      id_ingreso,
      id_tarea,
      estado_id
    ) VALUES (
      V_max_id,
      P_id_entrega,
      P_id_ingreso,
      P_id_tarea,
      P_estado_id
    );
    COMMIT;

  EXCEPTION
    WHEN no_data_found THEN
      dbms_output.put_line('No se encontraron datos');
    WHEN too_many_rows THEN
      dbms_output.put_line('Se encontro mas de un registro para el dato seleccionado');
    WHEN OTHERS THEN
      dbms_output.put_line('Ha tenido un error' || sqlerrm);
  END FIDE_REGISTRO_DIARIO_TB_Insertar_Registro_Diario_SP;

  -- READ / MOSTRAR / LISTAR
  -- 18. Listar los empleados
  PROCEDURE FIDE_PERSONAL_TB_Listar_Empleados_SP IS
    CURSOR c_empleados IS
    SELECT
      id_personal,
      nombre,
      apellidos,
      datos_contacto,
      tipo_personal
    FROM
      FIDE_PERSONAL_TB;

    V_empleado c_empleados%rowtype;

  BEGIN
    dbms_output.put_line('Lista de Empleados:');
    OPEN c_empleados;
    LOOP
      FETCH c_empleados INTO v_empleado;
      EXIT WHEN c_empleados%notfound;
      dbms_output.put_line('- ID: '
                           || V_empleado.id_personal
                           || ' - Nombre: '
                           || V_empleado.nombre
                           || ' '
                           || V_empleado.apellidos
                           || ' - Contacto: '
                           || V_empleado.datos_contacto
                           || ', Tipo: '
                           || V_empleado.tipo_personal);

    END LOOP;

    CLOSE c_empleados;

  EXCEPTION
    WHEN OTHERS THEN
      dbms_output.put_line('Error al listar empleados ' || sqlerrm);
  END FIDE_PERSONAL_TB_Listar_Empleados_SP;

  /*
  -- 19. Mostrar los materiales con stock bajo
    - Procedimiento que recorre los materiales con bajo stock (<=10 unidades) usando
    un cursor explícito para mostrar Id_Material, Nombre y Cantidad_Disponible
  */
  PROCEDURE FIDE_MATERIALES_TB_Mostrar_Materiales_Bajo_Stock_SP IS
    -- Declaración del cursor
    CURSOR c_materiales_bajo_stock IS
    SELECT
      id_material,
      nombre,
      cantidad_disponible
    FROM
      FIDE_MATERIALES_TB
    WHERE
      cantidad_disponible <= 10;

    -- Variables para almacenar datos del cursor
    V_id_material  FIDE_MATERIALES_TB.id_material%TYPE;
    V_nombre       FIDE_MATERIALES_TB.nombre%TYPE;
    V_cantidad     FIDE_MATERIALES_TB.cantidad_disponible%TYPE;

  BEGIN
    -- Abrimos el cursor
    OPEN c_materiales_bajo_stock;

    -- Recorremos cada fila del cursor
    LOOP
      FETCH c_materiales_bajo_stock INTO
        V_id_material,
        V_nombre,
        V_cantidad;
      EXIT WHEN c_materiales_bajo_stock%notfound;

      -- Mostramos la información con DBMS_OUTPUT
      dbms_output.put_line('ID Material: '
                           || V_id_material
                           || ' | Nombre: '
                           || V_nombre
                           || ' | Cantidad Disponible: '
                           || V_cantidad);

    END LOOP;

    -- Cerramos el cursor
    CLOSE c_materiales_bajo_stock;

  EXCEPTION
    WHEN OTHERS THEN
      dbms_output.put_line('Error en procedimiento ' || sqlerrm);
  END FIDE_MATERIALES_TB_Mostrar_Materiales_Bajo_Stock_SP;


  -- 20. Procedimiento para recorrer todas las tareas con un estado específico
  PROCEDURE FIDE_TAREAS_TB_Procesar_Tareas_Estado_SP (
    P_estado_id IN INT
  ) IS
    -- Declaramos el cursor que seleccionará las tareas de un estado específico
    CURSOR c_tareas IS
    SELECT
      id_tarea,
      nombre,
      descripcion
    FROM
      FIDE_TAREAS_TB
    WHERE
      estado_id = P_estado_id;  -- Filtramos por el estado proporcionado

    -- Declaramos las variables que almacenarán los valores extraídos del cursor
    V_id_tarea    FIDE_TAREAS_TB.id_tarea%TYPE;
    V_nombre      FIDE_TAREAS_TB.nombre%TYPE;
    V_descripcion FIDE_TAREAS_TB.descripcion%TYPE;

  BEGIN
    -- Abrimos el cursor para empezar a procesar las filas
    OPEN c_tareas;

    -- Bucle para recorrer las filas del cursor
    LOOP
      -- Extraemos los datos de la siguiente fila del cursor y los almacenamos en las variables
      FETCH c_tareas INTO
        V_id_tarea,
        V_nombre,
        V_descripcion;

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
  END FIDE_TAREAS_TB_Procesar_Tareas_Estado_SP;


  /* 21. Procedimiento que recorre todas las tareas pendientes (Estado_Id = 1) usando
          un cursor explícito y muestra su información básica. */
  PROCEDURE FIDE_TAREAS_TB_Mostrar_Tareas_Pendientes_SP IS
    -- Declaración del cursor para seleccionar tareas en estado pendiente
    CURSOR c_tareas_pendientes IS
    SELECT
      id_tarea,
      nombre,
      fecha_recibido
    FROM
      FIDE_TAREAS_TB
    WHERE
      estado_id = 1;

    -- Variables para almacenar temporalmente los valores del cursor
    V_id_tarea  FIDE_TAREAS_TB.id_tarea%TYPE;
    V_nombre    FIDE_TAREAS_TB.nombre%TYPE;
    V_fecha     FIDE_TAREAS_TB.fecha_recibido%TYPE;

  BEGIN
    -- Abrimos el cursor
    OPEN c_tareas_pendientes;

    -- Recorremos cada fila del cursor
    LOOP
      FETCH c_tareas_pendientes INTO
        V_id_tarea,
        V_nombre,
        V_fecha;
      EXIT WHEN c_tareas_pendientes%notfound;

      -- Mostramos la información con DBMS_OUTPUT
      dbms_output.put_line('Tarea ID: '
                           || V_id_tarea
                           || ' | Nombre: '
                           || V_nombre
                           || ' | Fecha Recibido: '
                           || V_fecha);

    END LOOP;

    -- Cerramos el cursor
    CLOSE c_tareas_pendientes;

  EXCEPTION
    WHEN OTHERS THEN
      dbms_output.put_line('Error en procedimiento ' || sqlerrm);
  END FIDE_TAREAS_TB_Mostrar_Tareas_Pendientes_SP;


  -- 22. Mostrar las tareas de los empleados
  PROCEDURE FIDE_TAREAS_TB_Listar_Tareas_Por_Empleado_SP (
    P_upi IN NUMBER
  ) IS
    CURSOR c_tareas (
      upi NUMBER
    ) IS
    SELECT
      nombre,
      descripcion,
      fecha_recibido
    FROM
      FIDE_TAREAS_TB
    WHERE
      upi = upi;

    V_tareas c_tareas%rowtype;

  BEGIN
    dbms_output.put_line('Tareas del empleado UPI: ' || P_upi);
    dbms_output.put_line('--------------------------');
    FOR V_tareas IN c_tareas(p_upi) LOOP
      dbms_output.put_line('Nombre: '
                           || V_tareas.nombre
                           || ', Descripción: '
                           || V_tareas.descripcion
                           || ', Fecha: '
                           || V_tareas.fecha_recibido);
    END LOOP;

  END FIDE_TAREAS_TB_Listar_Tareas_Por_Empleado_SP;


  -- 23. Listar las entregas por destinatario
  PROCEDURE FIDE_ENTREGAS_TB_Listar_Entregas_Por_Destinatario_SP (
    P_destinatario IN VARCHAR2
  ) IS
    CURSOR c_entregas IS
    SELECT
      m.nombre AS material,
      e.cantidad_restante,
      de.fecha
    FROM
      FIDE_ENTREGAS_TB e
      JOIN FIDE_MATERIALES_TB m ON e.id_material = m.id_material
      JOIN FIDE_DATOS_ENTREGAS_TB de ON e.dato_entrega_id = de.dato_entrega_id
    WHERE
      e.destinatario = P_destinatario;

  BEGIN
    dbms_output.put_line('Entregas a: ' || P_destinatario);
    dbms_output.put_line('--------------------------');
    FOR V_entregas IN c_entregas LOOP
      dbms_output.put_line('Material: '
                           || V_entregas.material
                           || ', Cantidad: '
                           || V_entregas.cantidad_restante
                           || ', Fecha: '
                           || V_entregas.fecha);
    END LOOP;

  END FIDE_ENTREGAS_TB_Listar_Entregas_Por_Destinatario_SP;


  -- 24. Listar ingresos por fechas
  PROCEDURE FIDE_INGRESOS_TB_Listar_Ingresos_Por_Fecha_SP (
    P_fecha_inicio  IN  DATE,
    P_fecha_fin     IN  DATE
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
      FIDE_INGRESOS_TB i
      JOIN FIDE_MATERIALES_TB m ON i.id_material = m.id_material
    WHERE
      i.fecha_ingreso BETWEEN fecha_inicio AND fecha_fin;

  BEGIN
    dbms_output.put_line('Ingresos entre '
                         || TO_CHAR(p_fecha_inicio, 'DD-MM-YYYY')
                         || ' y '
                         || TO_CHAR(p_fecha_fin, 'DD-MM-YYYY'));
    dbms_output.put_line('--------------------------');
    FOR V_ingresos IN c_ingresos(P_fecha_inicio, P_fecha_fin) LOOP
      dbms_output.put_line('Material: '
                           || V_ingresos.material
                           || ', Cantidad: '
                           || V_ingresos.cantidad_recibida
                           || ', Fecha: '
                           || TO_CHAR(V_ingresos.fecha_ingreso, 'DD-MM-YYYY'));
    END LOOP;

  END FIDE_INGRESOS_TB_Listar_Ingresos_Por_Fecha_SP;


  -- 25. Procedimiento que recorre los reportes de un estado específico y muestra su información
  PROCEDURE FIDE_REPORTES_TB_Mostrar_Reportes_Por_Estado_SP (
    P_estado_id IN INT
  ) IS
    -- Cursor que obtiene los reportes con el Estado_Id proporcionado
    CURSOR c_reportes IS
    SELECT
      id_reporte,
      descripcion,
      id_usuario
    FROM
      FIDE_REPORTES_TB
    WHERE
      estado_id = P_estado_id;

    -- Variables para almacenar los datos del cursor
    V_id_reporte   FIDE_REPORTES_TB.id_reporte%TYPE;
    V_descripcion  FIDE_REPORTES_TB.descripcion%TYPE;
    V_id_usuario   FIDE_REPORTES_TB.id_usuario%TYPE;

  BEGIN
    -- Abrimos el cursor
    OPEN c_reportes;

    -- Recorremos los resultados del cursor
    LOOP
      FETCH c_reportes INTO
        V_id_reporte,
        V_descripcion,
        V_id_usuario;
      EXIT WHEN c_reportes%notfound;

      -- Mostramos la información por consola (DBMS_OUTPUT)
      dbms_output.put_line('Reporte ID: '
                           || V_id_reporte
                           || ' | Usuario ID: '
                           || V_id_usuario
                           || ' | Descripción: '
                           || V_descripcion);

    END LOOP;

    -- Cerramos el cursor
    CLOSE c_reportes;
  END FIDE_REPORTES_TB_Mostrar_Reportes_Por_Estado_SP;



  -- UPDATE / MODIFICAR / ACTUALIZAR
  -- 26. Actualizar datos de contacto del personal
  PROCEDURE FIDE_PERSONAL_TB_Actualizar_Contacto_Personal_SP (
    p_tipo                    IN  VARCHAR2,
    p_nuevos_datos_contacto IN  VARCHAR2
  ) IS
    -- Cursor explícito con FOR UPDATE para bloquear filas antes de actualizarlas
    CURSOR c_personal IS
    SELECT
      id_personal,
      datos_contacto
    FROM
      FIDE_PERSONAL_TB
    WHERE
      tipo_personal = p_tipo
    FOR UPDATE;

  BEGIN
    -- Bucle implícito para recorrer el cursor (más limpio que abrir/cerrar manualmente)
    FOR v_personal IN c_personal LOOP
      UPDATE FIDE_PERSONAL_TB
      SET datos_contacto = p_nuevos_datos_contacto
      WHERE id_personal = v_personal.id_personal;

      dbms_output.put_line('Contacto actualizado para Id_Personal ' || v_personal.id_personal);
    END LOOP;

    COMMIT;
  END FIDE_PERSONAL_TB_Actualizar_Contacto_Personal_SP;


  -- 27. Actualizar el estado de las tareas a 'EN PROCESO'
  PROCEDURE FIDE_TAREAS_TB_Actualizar_Tareas_En_Proceso_SP IS
    -- Declarar variables
    v_estado_en_proceso  NUMBER;
    v_fecha_limite       DATE := SYSDATE - 7;

    -- Declarar cursor directamente usando la variable v_fecha_limite
    CURSOR c_tareas IS
      SELECT id_tarea
      FROM FIDE_TAREAS_TB
      WHERE fecha_recibido >= v_fecha_limite
        AND estado_id != (
          SELECT estado_id
          FROM FIDE_ESTADO_TB
          WHERE descripcion = 'En Proceso'
        )
      FOR UPDATE;

    v_tarea c_tareas%ROWTYPE;

  BEGIN
    -- Obtener el ID del estado 'En Proceso'
    SELECT estado_id
    INTO v_estado_en_proceso
    FROM FIDE_ESTADO_TB
    WHERE descripcion = 'En Proceso';

    -- Abrir cursor y procesar tareas
    OPEN c_tareas;
    LOOP
      FETCH c_tareas INTO v_tarea;
      EXIT WHEN c_tareas%NOTFOUND;

      UPDATE FIDE_TAREAS_TB
      SET estado_id = v_estado_en_proceso
      WHERE id_tarea = v_tarea.id_tarea;

      DBMS_OUTPUT.PUT_LINE('Tarea ' || v_tarea.id_tarea || ' marcada como EN PROCESO.');
    END LOOP;
    CLOSE c_tareas;

    COMMIT;
  END FIDE_TAREAS_TB_Actualizar_Tareas_En_Proceso_SP;


  -- 28. Actualizar el estado de las tareas a 'COMPLETADA'
  PROCEDURE FIDE_TAREAS_TB_Actualizar_Tareas_Completadas_SP IS
    v_estado_completada  NUMBER;
    v_fecha_limite DATE := SYSDATE - 7;
  BEGIN
    -- Obtener el Estado_Id para 'Completada'
    SELECT estado_id
    INTO v_estado_completada
    FROM FIDE_ESTADO_TB
    WHERE descripcion = 'Completada';

    -- Recorremos directamente sin declarar cursor externo
    FOR v_tarea IN (
      SELECT id_tarea
      FROM FIDE_TAREAS_TB
      WHERE fecha_recibido < v_fecha_limite
        AND estado_id != v_estado_completada
      FOR UPDATE
    ) LOOP
      UPDATE FIDE_TAREAS_TB
      SET estado_id = v_estado_completada
      WHERE id_tarea = v_tarea.id_tarea;

      DBMS_OUTPUT.PUT_LINE('Tarea ' || v_tarea.id_tarea || ' marcada como COMPLETADA.');
    END LOOP;

    COMMIT;
  END FIDE_TAREAS_TB_Actualizar_Tareas_Completadas_SP;


  -- 29. Actualizar el estado del material con stock bajo
  PROCEDURE FIDE_MATERIALES_TB_Actualizar_Estado_Material_Bajo_Stock_SP IS
    CURSOR c_materiales IS
    SELECT
      id_material,
      cantidad_disponible,
      estado_id
    FROM
      FIDE_MATERIALES_TB
    WHERE
      cantidad_disponible < 10;  -- Suponemos que si la cantidad disponible es menor a 10, es bajo stock

    v_id_material          FIDE_MATERIALES_TB.id_material%TYPE;
    v_cantidad_disponible  FIDE_MATERIALES_TB.cantidad_disponible%TYPE;
    v_estado_id            FIDE_MATERIALES_TB.estado_id%TYPE;

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
      UPDATE FIDE_MATERIALES_TB
      SET
        estado_id = 2  -- Suponemos que el Estado_Id = 2 es "Bajo Stock"
      WHERE
        id_material = v_id_material;

      -- Mostramos un mensaje indicando que el material fue actualizado
      dbms_output.put_line('Material con ID ' || v_id_material
                           || ' actualizado a estado "Bajo Stock".');
    END LOOP;

    -- Cerrando el cursor
    CLOSE c_materiales;

    -- Confirmación de la ejecución del procedimiento
    dbms_output.put_line('El proceso de actualización de materiales con bajo stock ha finalizado.');

  EXCEPTION
    -- Manejo de errores
    WHEN OTHERS THEN
      dbms_output.put_line('Ocurrió un error ' || sqlerrm);
      -- Cerramos el cursor en caso de error
      IF c_materiales%isopen THEN
        CLOSE c_materiales;
      END IF;
  END FIDE_MATERIALES_TB_Actualizar_Estado_Material_Bajo_Stock_SP;



  -- GENERAR
  -- 30. Generacion de alertas de stock bajo
  PROCEDURE FIDE_INVENTARIO_TB_Generar_Alertas_Stock_SP AS
    CURSOR c_inventario IS
    SELECT
      id_inventario,
      id_material
    FROM
      FIDE_INVENTARIO_TB
    WHERE
      (
        SELECT
          cantidad_disponible
        FROM
          FIDE_MATERIALES_TB
        WHERE
          id_material = FIDE_INVENTARIO_TB.id_material
      ) < 10;

  BEGIN
    FOR inv_rec IN c_inventario LOOP
      UPDATE FIDE_INVENTARIO_TB
      SET
        alertas_stock = 'Stock bajo para material '
                        || (
                          SELECT
                            nombre
                          FROM
                            FIDE_MATERIALES_TB
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
      dbms_output.put_line('Ha tenido un error' || sqlerrm);
  END FIDE_INVENTARIO_TB_Generar_Alertas_Stock_SP;


  -- ASIGNAR
  -- 31. Asignacion de las tareas pendientes a los empleados segun la linea de trabajo
  PROCEDURE FIDE_TAREAS_TB_Asignar_Tareas_Empleados_SP AS
    CURSOR c_tareas IS
    SELECT
      id_tarea,
      nombre,
      descripcion
    FROM
      FIDE_TAREAS_TB
    WHERE
      upi IS NULL
      AND estado_id = (
        SELECT
          estado_id
        FROM
          FIDE_ESTADO_TB
        WHERE
          descripcion = 'Pendiente'
      );

    CURSOR c_empleados (
      p_linea_trabajo VARCHAR2
    ) IS
    SELECT
      upi
    FROM
      FIDE_PERSONAL_TB
    WHERE
      linea_trabajo = p_linea_trabajo;

    v_linea_trabajo VARCHAR2(100); -- Variable para almacenar la línea de trabajo

  BEGIN
    -- Obtener la línea de trabajo del primer empleado disponible
    SELECT
      linea_trabajo
    INTO v_linea_trabajo
    FROM
      FIDE_PERSONAL_TB
    WHERE
      ROWNUM = 1;

    FOR tarea_rec IN c_tareas LOOP
      FOR empleado_rec IN c_empleados(v_linea_trabajo) LOOP -- Pasar la variable como parámetro
        UPDATE FIDE_TAREAS_TB
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
      dbms_output.put_line('Ha tenido un error' || sqlerrm);
  END FIDE_TAREAS_TB_Asignar_Tareas_Empleados_SP;


  -- 32. Asignacion de un material a una bodega en especifico
  PROCEDURE FIDE_BODEGA_MATERIAL_TB_Asignar_Material_Bodega_SP (
    p_bodega_id   IN  FIDE_BODEGA_MATERIAL_TB.bodega_id%TYPE,
    p_id_material IN  FIDE_BODEGA_MATERIAL_TB.id_material%TYPE
  ) AS
    v_max_id NUMBER;
    CURSOR c_max_id IS
    SELECT
      nvl(MAX(bodega_material_id), 0) + 1
    FROM
      FIDE_BODEGA_MATERIAL_TB;

  BEGIN
    OPEN c_max_id;
    FETCH c_max_id INTO v_max_id;
    CLOSE c_max_id;
    INSERT INTO FIDE_BODEGA_MATERIAL_TB (
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
      dbms_output.put_line('Ha tenido un error' || sqlerrm);
  END FIDE_BODEGA_MATERIAL_TB_Asignar_Material_Bodega_SP;


END FIDE_PROYECTO_FINAL_PKG;
/