/*CREADO POR: Grupo 2
FECHA: 20/03/2025
PROYECTO FINAL: Avance 02 con el Esquema ABBOTT*/ 

/*Creacion de Tablas Parte 01*/

-- TABLA ESTADO
CREATE TABLE Estado (
    Estado_Id NUMBER CONSTRAINT Estado_ID_PK PRIMARY KEY,
    Descripcion VARCHAR2(50) -- Activo / Inactivo - Pendiente / En Proceso / Completada
);

--============================== ROLES Y AREAS ==============================--

-- TABLA TIPOS ROL
CREATE TABLE Tipos_Rol (
    TipoRol_Id NUMBER CONSTRAINT Tipos_Rol_ID_PK PRIMARY KEY,
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

--============================ DATOS DE ENTREGAS ============================--
-- TABLA DATOS ENTREGAS
CREATE TABLE Datos_Entregas (
    Dato_Entrega_Id NUMBER CONSTRAINT Datos_Entregas_ID_PK PRIMARY KEY,
    Estado_Id NUMBER REFERENCES Estado(Estado_Id), -- FK Tabla Estado
    Fecha DATE,
    Hora TIMESTAMP
);

-- TABLA ENTREGAS
CREATE TABLE Entregas (
    Id_Entrega NUMBER CONSTRAINT Entregas_ID_PK PRIMARY KEY,
    Id_Material NUMBER REFERENCES Materiales(Id_Material), -- FK Tabla Materiales
    Dato_Entrega_Id NUMBER REFERENCES Datos_Entregas(Dato_Entrega_Id), -- FK Tabla Datos Entrega
    Estado_Id NUMBER REFERENCES Estado(Estado_Id), -- FK Tabla Estado
    Destinatario VARCHAR2(100),
    Cantidad_Restante NUMBER
);

--============================ PERSONAL DE LA EMPRESA ============================--
-- TABLA HORARIO
CREATE TABLE Horario (
    Horario_Id NUMBER CONSTRAINT Horario_ID_PK PRIMARY KEY,
    Estado_Id NUMBER REFERENCES Estado(Estado_Id), -- FK Tabla Estado
    Descripcion VARCHAR2(255)
);

-- TABLA PERSONAL
CREATE TABLE Personal (
    Id_Personal NUMBER CONSTRAINT Area_Rol_ID_PK PRIMARY KEY,
    -- Id_Usuario NUMBER REFERENCES Usuario(Id_Usuario),
    Id_Rol NUMBER REFERENCES Roles(Id_Rol), -- FK Tabla Roles
    -- UPI NUMBER REFERENCES Empleados(UPI),
    Id_Entrega NUMBER REFERENCES Entregas(Id_Entrega), -- FK Tabla Entregas
    Horario_Id NUMBER REFERENCES Horario(Horario_Id), -- FK Tabla Horario
    Estado_Id NUMBER REFERENCES Estado(Estado_Id), -- FK Tabla Estado
    Tipo_Personal VARCHAR2(100),
    Nombre VARCHAR2(100),
    Apellidos VARCHAR2(100),
    Datos_Contacto VARCHAR2(255),
    Linea_Trabajo VARCHAR2(100)
);






