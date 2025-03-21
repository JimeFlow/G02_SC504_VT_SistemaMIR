/*CREADO POR: Grupo 2
FECHA: 20/03/2025
PROYECTO FINAL: Avance 02 con el Esquema ABBOTT*/ 

-- CORREGIR NOMBRES APLICANDO LA NOMENCLATURA FIDE_NOMBRE_TB
-- LLAVES PRIMARIAS CON LA NOMENCLATURA DE NOMBRETABLA_NOMBREATRIBUTO_PK
-- AGREGAR LAS LLAVES COMPUESTAS Y LOS CONSTRAINTS QUE FALTAN EN ALGUNAS TABLAS

/*Creacion de Tablas Parte 01*/

-- TABLA ESTADO
CREATE TABLE Fide_Estado_TB (
    Estado_Id NUMBER CONSTRAINT Estado_EstadoID_PK PRIMARY KEY,
    Descripcion VARCHAR2(50) -- Activo / Inactivo - Pendiente / En Proceso / Completada
);

DROP TABLE ESTADO;
--============================== ROLES Y AREAS ==============================--

-- TABLA TIPOS ROL
CREATE TABLE Tipos_Rol (
    TipoRol_Id NUMBER CONSTRAINT TiposRol_TipoRolID_PK PRIMARY KEY, 
    Nombre_Rol VARCHAR2(50) -- Administrador / Supervisor / Operador (Empleado)
);

-- TABLA ROLES
CREATE TABLE Roles (
    Id_Rol NUMBER CONSTRAINT Roles_ID_PK PRIMARY KEY, 
    TipoRol_Id NUMBER REFERENCES Tipos_Rol(TipoRol_Id), -- FK Tabla Tipo Rol
    Estado_Id NUMBER REFERENCES Estado(Estado_Id) -- FK Tabla Estado
);

 -- TABLA AREAS
CREATE TABLE Areas (
    Area_Id NUMBER CONSTRAINT Areas_ID_PK PRIMARY KEY,
    Nombre VARCHAR2(100),
    Descripcion_Tarea VARCHAR2(200)
);

-- TABLA AREA ROL
CREATE TABLE Area_Rol (
    Area_Rol_Id NUMBER(5) CONSTRAINT Area_Rol_ID_PK PRIMARY KEY,
    Id_Rol NUMBER REFERENCES Roles(Id_Rol), -- FK Tabla Rol
    Area_Id NUMBER REFERENCES Areas(Area_Id) -- FK Tabla Area
);

--======================= DATOS DE MATERIALES Y BODEGAS ======================--

-- TABLA BODEGAS
CREATE TABLE BODEGAS (
    Bodega_Id INT,
    Estado_Id INT,
    Sucursal VARCHAR2(100),
    Stock NUMBER,
    PRIMARY KEY (Bodega_Id),
    FOREIGN KEY (Estado_Id) REFERENCES ESTADO(Estado_Id)
);

-- TABLA PERSONAL MATERIALES
CREATE TABLE Materiales (
    Id_Material INT,
    Estado_Id INT,
    Nombre VARCHAR2(100),
    Fecha_Vencimiento DATE,
    Cantidad_Disponible INT,
    Cantidad_Solicitada INT,
    PRIMARY KEY (Id_Material),
    FOREIGN KEY (Estado_Id) REFERENCES ESTADO(Estado_Id)
);

-- TABLA BODEGA MATERIAL -- LLAVE COMPUESTA
CREATE TABLE BODEGA_MATERIAL (
    Bodega_Material_Id INT,
    Bodega_Id INT,
    Id_Material INT,
    PRIMARY KEY (Bodega_Material_Id),
    FOREIGN KEY (Bodega_Id) REFERENCES BODEGAS(Bodega_Id),
    FOREIGN KEY (Id_Material) REFERENCES MATERIALES(Id_Material)
);

--======================= DATOS DE ENTREGAS E INGRESOS =======================--

-- TABLA DATOS ENTREGAS
CREATE TABLE Datos_Entregas (
    Dato_Entrega_Id NUMBER CONSTRAINT Datos_Entregas_ID_PK PRIMARY KEY,
    Estado_Id NUMBER REFERENCES Estado(Estado_Id), -- FK Tabla Estado
    Fecha DATE,
    Hora TIMESTAMP
);

-- TABLA ENTREGAS -- LLAVE COMPUESTA
CREATE TABLE Entregas (
    Id_Entrega NUMBER CONSTRAINT Entregas_ID_PK PRIMARY KEY,
    Id_Material NUMBER REFERENCES Materiales(Id_Material), -- FK Tabla Materiales
    Dato_Entrega_Id NUMBER REFERENCES Datos_Entregas(Dato_Entrega_Id), -- FK Tabla Datos Entrega
    Estado_Id NUMBER REFERENCES Estado(Estado_Id), -- FK Tabla Estado
    Destinatario VARCHAR2(100),
    Cantidad_Restante NUMBER
);

--========================== PERSONAL DE LA EMPRESA ==========================--

-- TABLA HORARIO
CREATE TABLE Horario (
    Horario_Id NUMBER CONSTRAINT Horario_ID_PK PRIMARY KEY,
    Estado_Id NUMBER REFERENCES Estado(Estado_Id), -- FK Tabla Estado
    Descripcion VARCHAR2(255)
);

-- TABLAS USUARIOS Y EMPLEADOS PARA PERSONAL
CREATE TABLE Usuarios (
    Id_Usuario NUMBER CONSTRAINT PK_Usuarios PRIMARY KEY
);
CREATE TABLE Empleados (
    UPI NUMBER CONSTRAINT PK_Empleados PRIMARY KEY
);

-- TABLA PERSONAL -- LLAVE COMPUESTA
CREATE TABLE Personal (
    Id_Personal NUMBER CONSTRAINT Id_Personal_PK PRIMARY KEY,
    Id_Rol NUMBER REFERENCES Roles (Id_Rol), -- FK  Tabla Roles
    Id_Entrega NUMBER REFERENCES Entregas (Id_Entrega), -- FK  Tabla Entregas
    Horario_Id NUMBER REFERENCES Horario (Horario_Id), -- FK  Tabla Horario
    Estado_Id NUMBER REFERENCES Estado (Estado_Id), -- FK  Tabla Estado
    Tipo_Personal VARCHAR2(100),
    Nombre VARCHAR2(100),
    Apellidos VARCHAR2(100),
    Datos_Contacto VARCHAR2(255),
    Linea_Trabajo VARCHAR2(100),
    
    -- Atributos FK's condicionales y referenciales
    Id_Usuario NUMBER,
    UPI NUMBER,
    CONSTRAINT UQ_Personal_Usuario UNIQUE (Id_Usuario),
    CONSTRAINT UQ_Personal_Empleados UNIQUE (UPI),
    CONSTRAINT FK_Personal_Usuario FOREIGN KEY (Id_Usuario) REFERENCES Usuarios (Id_Usuario),
    CONSTRAINT FK_Personal_Empleados FOREIGN KEY (UPI) REFERENCES Empleados (UPI),
    CONSTRAINT CK_Personal_Type CHECK (
        (Tipo_Personal = 'Usuario' AND Id_Usuario IS NOT NULL AND UPI IS NULL) OR
        (Tipo_Personal = 'Empleado' AND Id_Usuario IS NULL AND UPI IS NOT NULL)
    )
);

-- TABLA TAREAS
CREATE TABLE TAREAS (
    Id_Tarea INT,
    UPI NUMBER,
    Estado_Id INT,
    Nombre VARCHAR2(100),
    Fecha_Recibido DATE,
    Descripcion VARCHAR2(200),
    PRIMARY KEY (Id_Tarea),
    FOREIGN KEY (UPI) REFERENCES Personal(UPI),
    FOREIGN KEY (Estado_Id) REFERENCES ESTADO(Estado_Id)
);

-- TABLA INGRESOS
CREATE TABLE INGRESOS (
    Id_Ingreso INT, -- LLAVE COMPUESTA
    Id_Material INT, -- LLAVE COMPUESTA 
    UPI NUMBER,
    Estado_Id INT,
    Cantidad_Recibida INT,
    Fecha_Ingreso DATE,
    PRIMARY KEY (Id_Ingreso),
    FOREIGN KEY (Id_Material) REFERENCES MATERIALES(Id_Material),
    FOREIGN KEY (UPI) REFERENCES Personal(UPI),
    FOREIGN KEY (Estado_Id) REFERENCES ESTADO(Estado_Id)
);

--============================= GESTION Y CONTROL ============================--

/*Creacion de Tablas Parte 02*/

-- TABLA INVENTARIO
CREATE TABLE INVENTARIO (
    Id_Inventario INT,
    Id_Usuario NUMBER,
    UPI NUMBER,
    Id_Material INT,
    Estado_Id INT,
    Fecha DATE,
    Alertas_Stock VARCHAR2(200),
    PRIMARY KEY (Id_Inventario),
    FOREIGN KEY (Id_Usuario) REFERENCES Personal(Id_Usuario),
    FOREIGN KEY (UPI) REFERENCES Personal(UPI),
    FOREIGN KEY (Id_Material) REFERENCES MATERIALES(Id_Material),
    FOREIGN KEY (Estado_Id) REFERENCES ESTADO(Estado_Id)
);

-- TABLA REGISTRO DIARIO
CREATE TABLE REGISTRO_DIARIO (
    Id_Registro INT,
    Id_Entrega INT,
    Id_Ingreso INT,
    Id_Tarea INT,
    Estado_Id INT,
    PRIMARY KEY (Id_Registro),
    FOREIGN KEY (Id_Entrega) REFERENCES ENTREGAS(Id_Entrega),
    FOREIGN KEY (Id_Ingreso) REFERENCES INGRESOS(Id_Ingreso),
    FOREIGN KEY (Id_Tarea) REFERENCES TAREAS(Id_Tarea),
    FOREIGN KEY (Estado_Id) REFERENCES ESTADO(Estado_Id)
);

-- TABLA REPORTES
CREATE TABLE REPORTES (
    Id_Reporte INT,
    Id_Usuario NUMBER,
    Id_Inventario INT,
    Id_Registro INT,
    Estado_Id INT,
    Descripcion VARCHAR2(200),
    PRIMARY KEY (Id_Reporte),
    FOREIGN KEY (Id_Usuario) REFERENCES Personal(Id_Usuario),
    FOREIGN KEY (Id_Inventario) REFERENCES INVENTARIO(Id_Inventario),
    FOREIGN KEY (Id_Registro) REFERENCES REGISTRO_DIARIO(Id_Registro),
    FOREIGN KEY (Estado_Id) REFERENCES ESTADO(Estado_Id)
);

