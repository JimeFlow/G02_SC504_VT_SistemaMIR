script /*CREADO POR: Grupo 2
FECHA: 20/03/2025
PROYECTO FINAL: Avance 02 con el Esquema ABBOTT*/


CREATE TABLE ESTADO (
    Estado_Id INT PRIMARY KEY,
    Descripcion VARCHAR2(100)
);



CREATE TABLE TAREAS (
    Id_Tarea INT,
    UPI INT,
    Estado_Id INT,
    Nombre VARCHAR2(100),
    Fecha_Recibido DATE,
    Descripcion VARCHAR2(200),
    PRIMARY KEY (Id_Tarea, UPI, Estado_Id),
    FOREIGN KEY (UPI) REFERENCES USUARIOS(UPI),
    FOREIGN KEY (Estado_Id) REFERENCES ESTADO(Estado_Id)
);



CREATE TABLE REGISTRO_DIARIO (
    Id_Registro INT,
    Id_Entrega INT,
    Id_Ingreso INT,
    Id_Tarea INT,
    Estado_Id INT,
    PRIMARY KEY (Id_Registro, Id_Entrega, Id_Ingreso, Id_Tarea, Estado_Id),
    FOREIGN KEY (Id_Entrega) REFERENCES ENTREGAS(Id_Entrega),
    FOREIGN KEY (Id_Ingreso) REFERENCES INGRESOS(Id_Ingreso),
    FOREIGN KEY (Id_Tarea, Estado_Id) REFERENCES TAREAS(Id_Tarea, Estado_Id)
);




CREATE TABLE INGRESOS (
    Id_Ingreso INT,
    Id_Material INT,
    UPI INT,
    Estado_Id INT,
    Cantidad_Recibida INT,
    Fecha_Ingreso DATE,
    PRIMARY KEY (Id_Ingreso, Id_Material, UPI, Estado_Id),
    FOREIGN KEY (Id_Material) REFERENCES MATERIALES(Id_Material),
    FOREIGN KEY (UPI) REFERENCES UNIDADES_PRODUCTIVAS(UPI),
    FOREIGN KEY (Estado_Id) REFERENCES ESTADO(Estado_Id)
);




CREATE TABLE MATERIALES (
    Id_Material INT,
    Id_Bodega INT,
    Estado_Id INT,
    Nombre VARCHAR2(100),
    Fecha_Vencimiento DATE,
    Cantidad_Disponible INT,
    Cantidad_Solicitada INT,
    PRIMARY KEY (Id_Material, Id_Bodega, Estado_Id),
    FOREIGN KEY (Id_Bodega) REFERENCES BODEGAS(Id_Bodega),
    FOREIGN KEY (Estado_Id) REFERENCES ESTADO(Estado_Id)
);




CREATE TABLE BODEGA_MATERIAL (
    Bodega_Material_Id INT,
    Bodega_Id INT,
    Id_Material INT,
    PRIMARY KEY (Bodega_Material_Id, Bodega_Id, Id_Material),
    FOREIGN KEY (Bodega_Id) REFERENCES BODEGAS(Id_Bodega),
    FOREIGN KEY (Id_Material) REFERENCES MATERIALES(Id_Material)
);




CREATE TABLE BODEGAS (
    Bodega_Id INT,
    Estado_Id INT,
    Sucursal VARCHAR2(100),
    Stock NUMBER,
    PRIMARY KEY (Bodega_Id),
    FOREIGN KEY (Estado_Id) REFERENCES ESTADO(Estado_Id)
);




CREATE TABLE REPORTES (
    Id_Reporte INT,
    Id_Usuario INT,
    Id_Inventario INT,
    Id_Registro INT,
    Estado_Id INT,
    Descripcion VARCHAR2(200),
    PRIMARY KEY (Id_Reporte),
    FOREIGN KEY (Id_Usuario) REFERENCES USUARIOS(Id_Usuario),
    FOREIGN KEY (Id_Inventario) REFERENCES INVENTARIO(Id_Inventario),
    FOREIGN KEY (Id_Registro) REFERENCES REGISTRO_DIARIO(Id_Registro),
    FOREIGN KEY (Estado_Id) REFERENCES ESTADO(Estado_Id)
);




CREATE TABLE INVENTARIO (
    Id_Inventario INT,
    Id_Usuario INT,
    UPI INT,
    Id_Material INT,
    Estado_Id INT,
    Fecha DATE,
    Alertas_Stock VARCHAR2(200),
    PRIMARY KEY (Id_Inventario),
    FOREIGN KEY (Id_Usuario) REFERENCES USUARIOS(Id_Usuario),
    FOREIGN KEY (UPI) REFERENCES UPI_TABLA(UPI),
    FOREIGN KEY (Id_Material) REFERENCES MATERIALES(Id_Material),
    FOREIGN KEY (Estado_Id) REFERENCES ESTADO(Estado_Id)
);


..


