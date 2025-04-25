/*CREADO POR: Grupo 2
FECHA: 25/04/2025
PROYECTO FINAL: Avance 03 con el Esquema ABBOTT*/

--=============================== MAIN PACKAGE ===============================--
CREATE OR REPLACE PACKAGE FIDE_PROYECTO_FINAL_PKG AS

--================================ FUNCIONES =================================--
  -- FUNCION CON ESTADO
  FUNCTION FIDE_ESTADO_TB_Obtener_Descripcion_Estado_FN (
    P_Estado_Id IN FIDE_ESTADO_TB.Estado_Id%TYPE
  ) RETURN VARCHAR2;

  -- FUNCIONES CON MATERIALES Y BODEGAS
  FUNCTION FIDE_MATERIALES_TB_Obtener_Nombre_Material_FN (
    P_Id_Material IN FIDE_MATERIALES_TB.Id_Material%TYPE
  ) RETURN VARCHAR2;

  FUNCTION FIDE_MATERIALES_TB_Calcular_Total_Materiales_Disponible_FN
  RETURN NUMBER;

  FUNCTION FIDE_BODEGAS_TB_Contar_Materiales_Bodega_FN (
    P_Bodega_Id IN FIDE_BODEGAS_TB.Bodega_Id%TYPE
  ) RETURN NUMBER;

  FUNCTION FIDE_BODEGA_MATERIAL_TB_Material_Disponible_Bodega_FN (
    P_Bodega_Id IN FIDE_BODEGAS_TB.Bodega_Id%TYPE,
    P_Id_Material IN FIDE_MATERIALES_TB.Id_Material%TYPE
  ) RETURN BOOLEAN;

  FUNCTION FIDE_BODEGAS_TB_Obtener_Nombre_Bodega_FN (
    P_Bodega_Id IN FIDE_BODEGAS_TB.Bodega_Id%TYPE
  ) RETURN VARCHAR2;

  FUNCTION FIDE_BODEGAS_TB_Calcular_Stock_Total_Bodega_FN (
    P_Bodega_Id IN FIDE_BODEGAS_TB.Bodega_Id%TYPE
  ) RETURN NUMBER;

  -- FUNCIONES CON PERSONAL Y TAREAS
  FUNCTION FIDE_PERSONAL_TB_Obtener_Nombre_Empleado_FN (
    P_UPI IN FIDE_PERSONAL_TB.UPI%TYPE
  ) RETURN VARCHAR2;

  FUNCTION FIDE_TAREAS_TB_Contar_Tareas_Pendientes_FN (
    P_UPI IN FIDE_TAREAS_TB.UPI%TYPE
  ) RETURN NUMBER;

  FUNCTION FIDE_INVENTARIO_TB_Obtener_Responsable_Inventario_FN (
    P_Id_Inventario IN FIDE_INVENTARIO_TB.Id_Inventario%TYPE
  ) RETURN VARCHAR2;

  -- FUNCIONES CON ENTREGAS E INGRESOS
  FUNCTION FIDE_ENTREGAS_TB_Calcular_Cantidad_Restante_Entregas_FN (
    P_Id_Entrega IN FIDE_ENTREGAS_TB.Id_Entrega%TYPE
  ) RETURN NUMBER;

  FUNCTION FIDE_DATOS_ENTREGAS_TB_Obtener_FechaHora_Entrega_FN (
    P_Dato_Entrega_Id IN FIDE_DATOS_ENTREGAS_TB.Dato_Entrega_Id%TYPE
  ) RETURN TIMESTAMP;

  FUNCTION FIDE_INGRESOS_TB_Obtener_Fecha_Ingreso_Material_FN (
    P_Id_Ingreso IN FIDE_INGRESOS_TB.Id_Ingreso%TYPE
  ) RETURN DATE;

  -- FUNCIONES CON ROLES Y AREAS
  FUNCTION FIDE_ROLES_TB_Obtener_TipoRol_Personal_FN (
    P_Id_Rol IN FIDE_ROLES_TB.Id_Rol%TYPE
  ) RETURN VARCHAR2;

  FUNCTION FIDE_AREAS_TB_Obtener_Nombre_Area_FN (
    P_Area_Id IN FIDE_AREAS_TB.Area_Id%TYPE
  ) RETURN VARCHAR2;



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
  );

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
  );

  -- 3. Registrar un nuevo ingreso de material
  PROCEDURE FIDE_INGRESOS_TB_Registrar_Ingreso_SP (
    P_Id_Ingreso        IN  NUMBER,
    P_Id_Material       IN  NUMBER,
    P_UPI               IN  NUMBER,
    P_Estado_Id         IN  NUMBER,
    P_Cantidad_Recibida IN  NUMBER,
    P_Fecha_Ingreso     IN  DATE
  );

  -- 4. Registrar un nuevo reporte
  PROCEDURE FIDE_REPORTES_TB_Registrar_Reporte_SP (
    P_Id_Reporte    IN  NUMBER,
    P_Id_Usuario    IN  NUMBER,
    P_Id_Inventario IN  NUMBER,
    P_Id_Registro   IN  NUMBER,
    P_Estado_Id     IN  NUMBER,
    P_Descripcion   IN  VARCHAR2
  );

  -- READ / MOSTRAR / LISTAR
  -- 5. Mostrar material por ID
  PROCEDURE FIDE_MATERIALES_TB_Mostrar_Material_SP (
    P_id_material       IN   NUMBER,
    P_nombre            OUT  VARCHAR2,
    P_fecha_vencimiento OUT  DATE,
    P_cantidad_disponible OUT  NUMBER,
    P_cantidad_solicitada OUT  NUMBER
  );

  -- 6. Procedimiento para verificar si hay suficiente material ingresado
  PROCEDURE FIDE_INGRESOS_TB_Verificar_Material_Suficiente_SP (
    P_id_material    IN   INT,
    P_ultima_cantidad IN   INT,
    P_suficiente     OUT  VARCHAR2
  );

  -- 7. Mostrar los datos de una tarea por Id
  PROCEDURE FIDE_TAREAS_TB_Mostrar_Tarea_SP (
    P_id_tarea       IN   NUMBER,
    P_upi            OUT  NUMBER,
    P_nombre         OUT  VARCHAR2,
    P_fecha_recibido OUT  DATE,
    P_descripcion    OUT  VARCHAR2
  );

  -- UPDATE / MODIFICAR / ACTUALIZAR
  /* 8. Procedimiento que permite aumentar la cantidad disponible de un material específico.
     - Se utiliza para actualizar el stock cuando se recibe nuevo material. */
  PROCEDURE FIDE_MATERIALES_TB_Aumentar_Cantidad_Material_SP (
    P_id_material       IN  INT,
    P_cantidad_a_agregar IN  INT
  );

  -- 9. Procedimiento para actualizar el stock de una bodega en la tabla BODEGAS
  -- Recibe el ID de la bodega y el nuevo valor de stock
  PROCEDURE FIDE_BODEGAS_TB_Actualizar_Stock_Bodega_SP (
    P_bodega_id    IN  FIDE_BODEGAS_TB.bodega_id%TYPE,
    P_nuevo_stock  IN  FIDE_BODEGAS_TB.stock%TYPE
  );

  -- 10. Actualizar datos de contacto de un empleado
  PROCEDURE FIDE_PERSONAL_TB_Actualizar_Rol_Empleado_SP (
    P_upi          IN  NUMBER,
    P_nuevo_rol_id IN  NUMBER
  );

  -- 11. Actualizar el horario del empleado
  PROCEDURE FIDE_PERSONAL_TB_Actualizar_Horario_Empleado_SP (
    P_id_personal    IN  NUMBER,
    P_nuevo_horario_id IN  NUMBER
  );

  -- 12. Actualizar estado de los ingresos
  PROCEDURE FIDE_INGRESOS_TB_Actualizar_Estado_Ingreso_SP (
    P_id_ingreso    IN  NUMBER,
    P_nuevo_estado_id IN  NUMBER
  );

  -- 13. Actualizar descripcion de un reporte
  PROCEDURE FIDE_REPORTES_TB_Actualizar_Descripcion_Reporte_SP (
    P_id_reporte      IN  NUMBER,
    P_nueva_descripcion IN  VARCHAR2
  );

  -- 14. Actualizar estado del reporte
  PROCEDURE FIDE_REPORTES_TB_Actualizar_Estado_Reporte_SP (
    P_id_reporte      IN  NUMBER,
    P_nuevo_estado_id IN  NUMBER
  );

  -- DELETE / ELIMINAR
  -- 15. Eliminar un Material por Id
  PROCEDURE FIDE_MATERIALES_TB_Eliminar_Material_SP (
    P_id_material IN NUMBER
  );

  -- 16. Eliminar una tarea por Id
  PROCEDURE FIDE_TAREAS_TB_Eliminar_Tarea_SP (
    P_id_tarea IN NUMBER
  );


--======================= PROCEDIMIENTOS CON CURSORES ========================--

  -- CREATE / INSERT / REGISTRAR
  -- 17. Insercion de un nuevo registro diario
  PROCEDURE FIDE_REGISTRO_DIARIO_TB_Insertar_Registro_Diario_SP (
    P_id_entrega  IN  FIDE_REGISTRO_DIARIO_TB.id_entrega%TYPE,
    P_id_ingreso  IN  FIDE_REGISTRO_DIARIO_TB.id_ingreso%TYPE,
    P_id_tarea    IN  FIDE_REGISTRO_DIARIO_TB.id_tarea%TYPE,
    P_estado_id   IN  FIDE_REGISTRO_DIARIO_TB.estado_id%TYPE
  );

  -- READ / MOSTRAR / LISTAR
  -- 18. Listar los empleados
  PROCEDURE FIDE_PERSONAL_TB_Listar_Empleados_SP;

  /*
  -- 19. Mostrar los materiales con stock bajo
    - Procedimiento que recorre los materiales con bajo stock (<=10 unidades) usando
    un cursor explícito para mostrar Id_Material, Nombre y Cantidad_Disponible
  */
  PROCEDURE FIDE_MATERIALES_TB_Mostrar_Materiales_Bajo_Stock_SP;

  -- 20. Procedimiento para recorrer todas las tareas con un estado específico
  PROCEDURE FIDE_TAREAS_TB_Procesar_Tareas_Estado_SP (
    P_estado_id IN INT
  );

  /* 21. Procedimiento que recorre todas las tareas pendientes (Estado_Id = 1) usando
          un cursor explícito y muestra su información básica. */
  PROCEDURE FIDE_TAREAS_TB_Mostrar_Tareas_Pendientes_SP;

  -- 22. Mostrar las tareas de los empleados
  PROCEDURE FIDE_TAREAS_TB_Listar_Tareas_Por_Empleado_SP (
    P_upi IN NUMBER
  );

  -- 23. Listar las entregas por destinatario
  PROCEDURE FIDE_ENTREGAS_TB_Listar_Entregas_Por_Destinatario_SP (
    P_destinatario IN VARCHAR2
  );

  -- 24. Listar ingresos por fechas
  PROCEDURE FIDE_INGRESOS_TB_Listar_Ingresos_Por_Fecha_SP (
    P_fecha_inicio  IN  DATE,
    P_fecha_fin     IN  DATE
  );

  -- 25. Procedimiento que recorre los reportes de un estado específico y muestra su información
  PROCEDURE FIDE_REPORTES_TB_Mostrar_Reportes_Por_Estado_SP (
    P_estado_id IN INT
  );

  -- UPDATE / MODIFICAR / ACTUALIZAR
  -- 26. Actualizar datos de contacto del personal
  PROCEDURE FIDE_PERSONAL_TB_Actualizar_Contacto_Personal_SP (
    p_tipo                    IN  VARCHAR2,
    p_nuevos_datos_contacto IN  VARCHAR2
  );

  -- 27. Actualizar el estado de las tareas a 'EN PROCESO'
  PROCEDURE FIDE_TAREAS_TB_Actualizar_Tareas_En_Proceso_SP;

  -- 28. Actualizar el estado de las tareas a 'COMPLETADA'
  PROCEDURE FIDE_TAREAS_TB_Actualizar_Tareas_Completadas_SP;

  -- 29. Actualizar el estado del material con stock bajo
  PROCEDURE FIDE_MATERIALES_TB_Actualizar_Estado_Material_Bajo_Stock_SP;

  -- GENERAR
  -- 30. Generacion de alertas de stock bajo
  PROCEDURE FIDE_INVENTARIO_TB_Generar_Alertas_Stock_SP;

  -- ASIGNAR
  -- 31. Asignacion de las tareas pendientes a los empleados segun la linea de trabajo
  PROCEDURE FIDE_TAREAS_TB_Asignar_Tareas_Empleados_SP;

  -- 32. Asignacion de un material a una bodega en especifico
  PROCEDURE FIDE_BODEGA_MATERIAL_TB_Asignar_Material_Bodega_SP (
    p_bodega_id   IN  FIDE_BODEGA_MATERIAL_TB.bodega_id%TYPE,
    p_id_material IN  FIDE_BODEGA_MATERIAL_TB.id_material%TYPE
  );


END FIDE_PROYECTO_FINAL_PKG;
/
