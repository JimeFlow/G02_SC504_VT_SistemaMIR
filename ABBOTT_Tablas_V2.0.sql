/*CREADO POR: Grupo 2
FECHA: 20/03/2025
PROYECTO FINAL: Avance 02 con el Esquema ABBOTT*/ 

/*Creacion de Tablas Parte 01*/

-- TABLA ESTADO
CREATE TABLE FIDE_ESTADO_TB (
    ESTADO_ID NUMBER CONSTRAINT FIDE_ESTADO_TB_ESTADO_ID_PK PRIMARY KEY,
    DESCRIPCION VARCHAR2(50) -- Activo / Inactivo - Pendiente / En Proceso / Completada
);


--============================== ROLES Y AREAS ==============================--

-- TABLA TIPOS ROL
CREATE TABLE FIDE_TIPOS_ROL_TB (
    TIPOROL_ID NUMBER CONSTRAINT FIDE_TIPOS_ROL_TB_TIPOROL_ID_PK PRIMARY KEY,
    NOMBRE_ROL VARCHAR2(50) -- Administrador / Supervisor / Operador (Empleado)
);


-- TABLA ROLES
CREATE TABLE FIDE_ROLES_TB (
    ID_ROL NUMBER CONSTRAINT FIDE_ROLES_TB_ID_ROL_PK PRIMARY KEY,
    TIPOROL_ID NUMBER CONSTRAINT FIDE_ROLES_TB_TIPOROL_ID_FK REFERENCES FIDE_TIPOS_ROL_TB(TIPOROL_ID), -- FK Tabla Tipo Rol
    ESTADO_ID NUMBER CONSTRAINT FIDE_ROLES_TB_ESTADO_ID_FK REFERENCES FIDE_ESTADO_TB(ESTADO_ID) -- FK Tabla Estado
);


 -- TABLA FIDE_AREAS_TB
CREATE TABLE FIDE_AREAS_TB (
    AREA_ID NUMBER CONSTRAINT FIDE_AREAS_TB_ID_PK PRIMARY KEY, -- Clave primaria
    NOMBRE VARCHAR2(100),
    DESCRIPCION_TAREA VARCHAR2(200)
);


-- TABLA FIDE_AREA_ROL_TB
CREATE TABLE FIDE_AREA_ROL_TB (
    ID_ROL NUMBER CONSTRAINT FIDE_AREA_ROL_TB_ID_ROL_FK REFERENCES FIDE_ROLES_TB(ID_ROL),
    AREA_ID NUMBER CONSTRAINT FIDE_AREA_ROL_TB_AREA_ID_FK REFERENCES FIDE_AREAS_TB(AREA_ID),
    CONSTRAINT FIDE_AREA_ROL_TB_PK PRIMARY KEY (ID_ROL, AREA_ID) -- Llave primaria compuesta
);

DROP TABLE FIDE_AREA_ROL_TB CASCADE CONSTRAINTS;

--======================= DATOS DE MATERIALES Y BODEGAS ======================--

-- TABLA FIDE_BODEGAS_TB
CREATE TABLE FIDE_BODEGAS_TB (
    Bodega_Id INT CONSTRAINT FIDE_BODEGAS_TB_BODEGA_ID_PK PRIMARY KEY, 
    Estado_Id INT,
    Sucursal VARCHAR2(100),
    Stock NUMBER,
    CONSTRAINT FIDE_BODEGAS_TB_ESTADO_ID_FK FOREIGN KEY (Estado_Id) REFERENCES FIDE_ESTADO_TB(Estado_Id)
);


-- TABLA PERSONAL MATERIALES
CREATE TABLE FIDE_MATERIALES_TB (
    Id_Material INT CONSTRAINT FIDE_MATERIALES_TB_Id_Material_PK PRIMARY KEY,
    Estado_Id INT,
    Nombre VARCHAR2(100),
    Fecha_Vencimiento DATE,
    Cantidad_Disponible INT,
    Cantidad_Solicitada INT,
    CONSTRAINT FIDE_MATERIALES_TB_Estado_Id_FK FOREIGN KEY (Estado_Id) REFERENCES FIDE_ESTADO_TB(Estado_Id)
);


-- TABLA FIDE_BODEGA_MATERIAL_TB
CREATE TABLE FIDE_BODEGA_MATERIAL_TB (
    Bodega_Material_Id INT CONSTRAINT FIDE_BODEGA_MATERIAL_TB_Bodega_Material_Id_PK PRIMARY KEY,
    Bodega_Id INT,
    Id_Material INT,
    CONSTRAINT FIDE_BODEGA_MATERIAL_TB_Bodega_Id_FK FOREIGN KEY (Bodega_Id) REFERENCES FIDE_BODEGAS_TB(Bodega_Id),
    CONSTRAINT FIDE_BODEGA_MATERIAL_TB_Id_Material_FK FOREIGN KEY (Id_Material) REFERENCES FIDE_MATERIALES_TB(Id_Material)
);



--======================= DATOS DE ENTREGAS E INGRESOS =======================--

-- TABLA FIDE_DATOS_ENTREGAS_TB
CREATE TABLE FIDE_DATOS_ENTREGAS_TB (
    Dato_Entrega_Id NUMBER CONSTRAINT FIDE_DATOS_ENTREGAS_TB_Dato_Entrega_Id_PK PRIMARY KEY,
    Estado_Id NUMBER,
    Fecha DATE,
    Hora TIMESTAMP,
    CONSTRAINT FIDE_DATOS_ENTREGAS_TB_Estado_Id_FK FOREIGN KEY (Estado_Id) REFERENCES FIDE_ESTADO_TB(Estado_Id)
);


-- TABLA FIDE_ENTREGAS_TB
CREATE TABLE FIDE_ENTREGAS_TB (
    Id_Entrega NUMBER CONSTRAINT FIDE_ENTREGAS_TB_Id_Entrega_PK PRIMARY KEY,
    Id_Material NUMBER,
    Dato_Entrega_Id NUMBER,
    Estado_Id NUMBER,
    Destinatario VARCHAR2(100),
    Cantidad_Restante NUMBER,
    CONSTRAINT FIDE_ENTREGAS_TB_Id_Material_FK FOREIGN KEY (Id_Material) REFERENCES FIDE_MATERIALES_TB(Id_Material),
    CONSTRAINT FIDE_ENTREGAS_TB_Dato_Entrega_Id_FK FOREIGN KEY (Dato_Entrega_Id) REFERENCES FIDE_DATOS_ENTREGAS_TB(Dato_Entrega_Id),
    CONSTRAINT FIDE_ENTREGAS_TB_Estado_Id_FK FOREIGN KEY (Estado_Id) REFERENCES FIDE_ESTADO_TB(Estado_Id)
);



--========================== PERSONAL DE LA EMPRESA ==========================--

-- TABLA FIDE_HORARIO_TB
CREATE TABLE FIDE_HORARIO_TB (
    Horario_Id NUMBER CONSTRAINT FIDE_HORARIO_TB_Horario_Id_PK PRIMARY KEY,
    Estado_Id NUMBER,
    Descripcion VARCHAR2(255),
    CONSTRAINT FIDE_HORARIO_TB_Estado_Id_FK FOREIGN KEY (Estado_Id) REFERENCES FIDE_ESTADO_TB(Estado_Id)
);


-- TABLA FIDE_USUARIOS_TB
CREATE TABLE FIDE_USUARIOS_TB (
    Id_Usuario NUMBER CONSTRAINT FIDE_USUARIOS_TB_Id_Usuario_PK PRIMARY KEY
);

-- TABLA FIDE_EMPLEADOS_TB
CREATE TABLE FIDE_EMPLEADOS_TB (
    UPI NUMBER CONSTRAINT FIDE_EMPLEADOS_TB_UPI_PK PRIMARY KEY
);


-- TABLA FIDE_PERSONAL_TB
CREATE TABLE FIDE_PERSONAL_TB (
    Id_Personal NUMBER CONSTRAINT FIDE_PERSONAL_TB_Id_Personal_PK PRIMARY KEY,
    Id_Rol NUMBER REFERENCES FIDE_ROLES_TB (Id_Rol), -- FK Tabla Roles
    Id_Entrega NUMBER REFERENCES FIDE_ENTREGAS_TB (Id_Entrega), -- FK Tabla Entregas
    Horario_Id NUMBER REFERENCES FIDE_HORARIO_TB (Horario_Id), -- FK Tabla Horario
    Estado_Id NUMBER REFERENCES FIDE_ESTADO_TB (Estado_Id), -- FK Tabla Estado
    Tipo_Personal VARCHAR2(100),
    Nombre VARCHAR2(100),
    Apellidos VARCHAR2(100),
    Datos_Contacto VARCHAR2(255),
    Linea_Trabajo VARCHAR2(100),
    
    -- Atributos FK's condicionales y referenciales
    Id_Usuario NUMBER,
    UPI NUMBER,
    CONSTRAINT FIDE_PERSONAL_TB_UQ_Personal_Usuario UNIQUE (Id_Usuario),
    CONSTRAINT FIDE_PERSONAL_TB_UQ_Personal_Empleados UNIQUE (UPI),
    CONSTRAINT FIDE_PERSONAL_TB_FK_Personal_Usuario FOREIGN KEY (Id_Usuario) REFERENCES FIDE_USUARIOS_TB (Id_Usuario),
    CONSTRAINT FIDE_PERSONAL_TB_FK_Personal_Empleados FOREIGN KEY (UPI) REFERENCES FIDE_EMPLEADOS_TB (UPI),
    CONSTRAINT FIDE_PERSONAL_TB_CK_Personal_Type CHECK (
        (Tipo_Personal = 'Usuario' AND Id_Usuario IS NOT NULL AND UPI IS NULL) OR
        (Tipo_Personal = 'Empleado' AND Id_Usuario IS NULL AND UPI IS NOT NULL)
    )
);


-- TABLA FIDE_TAREAS_TB
CREATE TABLE FIDE_TAREAS_TB (
    Id_Tarea INT CONSTRAINT FIDE_TAREAS_TB_Id_Tarea_PK PRIMARY KEY,
    UPI NUMBER CONSTRAINT FIDE_TAREAS_TB_UPI_FK REFERENCES FIDE_PERSONAL_TB(UPI),
    Estado_Id INT CONSTRAINT FIDE_TAREAS_TB_Estado_Id_FK REFERENCES FIDE_ESTADO_TB(Estado_Id),
    Nombre VARCHAR2(100),
    Fecha_Recibido DATE,
    Descripcion VARCHAR2(200)
);


-- TABLA FIDE_INGRESOS_TB
CREATE TABLE FIDE_INGRESOS_TB (
    Id_Ingreso INT,
    Id_Material INT,
    UPI NUMBER,
    Estado_Id INT,
    Cantidad_Recibida INT,
    Fecha_Ingreso DATE,
    CONSTRAINT FIDE_INGRESOS_TB_Id_Ingreso_PK PRIMARY KEY (Id_Ingreso),
    CONSTRAINT FIDE_INGRESOS_TB_Id_Material_FK FOREIGN KEY (Id_Material) REFERENCES FIDE_MATERIALES_TB(Id_Material),
    CONSTRAINT FIDE_INGRESOS_TB_UPI_FK FOREIGN KEY (UPI) REFERENCES FIDE_PERSONAL_TB(UPI),
    CONSTRAINT FIDE_INGRESOS_TB_Estado_Id_FK FOREIGN KEY (Estado_Id) REFERENCES FIDE_ESTADO_TB(Estado_Id)
);



--============================= GESTION Y CONTROL ============================--

/*Creacion de Tablas Parte 02*/

-- TABLA FIDE_INVENTARIO_TB
CREATE TABLE FIDE_INVENTARIO_TB (
    Id_Inventario INT,
    Id_Usuario NUMBER,
    UPI NUMBER,
    Id_Material INT,
    Estado_Id INT,
    Fecha DATE,
    Alertas_Stock VARCHAR2(200),
    CONSTRAINT FIDE_INVENTARIO_TB_Id_Inventario_PK PRIMARY KEY (Id_Inventario),
    CONSTRAINT FIDE_INVENTARIO_TB_Id_Usuario_FK FOREIGN KEY (Id_Usuario) REFERENCES FIDE_PERSONAL_TB(Id_Usuario),
    CONSTRAINT FIDE_INVENTARIO_TB_UPI_FK FOREIGN KEY (UPI) REFERENCES FIDE_PERSONAL_TB(UPI),
    CONSTRAINT FIDE_INVENTARIO_TB_Id_Material_FK FOREIGN KEY (Id_Material) REFERENCES FIDE_MATERIALES_TB(Id_Material),
    CONSTRAINT FIDE_INVENTARIO_TB_Estado_Id_FK FOREIGN KEY (Estado_Id) REFERENCES FIDE_ESTADO_TB(Estado_Id)
);


-- TABLA FIDE_REGISTRO_DIARIO_TB
CREATE TABLE FIDE_REGISTRO_DIARIO_TB (
    Id_Registro INT,
    Id_Entrega INT,
    Id_Ingreso INT,
    Id_Tarea INT,
    Estado_Id INT,
    CONSTRAINT FIDE_REGISTRO_DIARIO_TB_Id_Registro_PK PRIMARY KEY (Id_Registro),
    CONSTRAINT FIDE_REGISTRO_DIARIO_TB_Id_Entrega_FK FOREIGN KEY (Id_Entrega) REFERENCES FIDE_ENTREGAS_TB(Id_Entrega),
    CONSTRAINT FIDE_REGISTRO_DIARIO_TB_Id_Ingreso_FK FOREIGN KEY (Id_Ingreso) REFERENCES FIDE_INGRESOS_TB(Id_Ingreso),
    CONSTRAINT FIDE_REGISTRO_DIARIO_TB_Id_Tarea_FK FOREIGN KEY (Id_Tarea) REFERENCES FIDE_TAREAS_TB(Id_Tarea),
    CONSTRAINT FIDE_REGISTRO_DIARIO_TB_Estado_Id_FK FOREIGN KEY (Estado_Id) REFERENCES FIDE_ESTADO_TB(Estado_Id)
);

-- TABLA FIDE_REPORTES_TB
CREATE TABLE FIDE_REPORTES_TB (
    Id_Reporte INT,
    Id_Usuario NUMBER,
    Id_Inventario INT,
    Id_Registro INT,
    Estado_Id INT,
    Descripcion VARCHAR2(200),
    CONSTRAINT FIDE_REPORTES_TB_Id_Reporte_PK PRIMARY KEY (Id_Reporte),
    CONSTRAINT FIDE_REPORTES_TB_Id_Usuario_FK FOREIGN KEY (Id_Usuario) REFERENCES FIDE_PERSONAL_TB(Id_Usuario),
    CONSTRAINT FIDE_REPORTES_TB_Id_Inventario_FK FOREIGN KEY (Id_Inventario) REFERENCES FIDE_INVENTARIO_TB(Id_Inventario),
    CONSTRAINT FIDE_REPORTES_TB_Id_Registro_FK FOREIGN KEY (Id_Registro) REFERENCES FIDE_REGISTRO_DIARIO_TB(Id_Registro),
    CONSTRAINT FIDE_REPORTES_TB_Estado_Id_FK FOREIGN KEY (Estado_Id) REFERENCES FIDE_ESTADO_TB(Estado_Id)
);








