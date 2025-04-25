<?php
// Incluir archivo de conexión a la base de datos
include_once __DIR__ . '/../config/conexion.php';

// Definición de la clase RegistrosModel para manejar operaciones relacionadas con registros diarios
class RegistrosModel {
    private $conexion;

    // Constructor que establece la conexión a la base de datos
    public function __construct() {
        $db = new Conexion();
        $this->conexion = $db->conectar();
    }

    // Método para insertar un nuevo registro diario
    public function insertarRegistro($id, $idEntrega, $idIngreso, $idTarea, $estadoId) {
        $sql = "INSERT INTO FIDE_REGISTRO_DIARIO_TB (ID_REGISTRO, ID_ENTREGA, ID_INGRESO, ID_TAREA, ESTADO_ID)
                VALUES (:id, :entrega, :ingreso, :tarea, :estado)";
        $stmt = oci_parse($this->conexion, $sql);
        // Vinculación de parámetros para la consulta SQL
        oci_bind_by_name($stmt, ':id', $id);
        oci_bind_by_name($stmt, ':entrega', $idEntrega);
        oci_bind_by_name($stmt, ':ingreso', $idIngreso);
        oci_bind_by_name($stmt, ':tarea', $idTarea);
        oci_bind_by_name($stmt, ':estado', $estadoId);
        // Ejecutar la consulta
        return oci_execute($stmt);
    }

    // Método para listar todos los registros diarios
    public function listarRegistros() {
        $sql = "SELECT * FROM FIDE_REGISTRO_DIARIO_TB";
        $stmt = oci_parse($this->conexion, $sql);
        oci_execute($stmt);
        $registros = [];
        // Recorrer resultados y almacenarlos en un arreglo
        while ($fila = oci_fetch_assoc($stmt)) {
            $registros[] = $fila;
        }
        return $registros;
    }

    // Método para eliminar un registro diario y sus reportes relacionados
    public function eliminarRegistro($id) {
        // Primero eliminamos los reportes relacionados
        $sqlReportes = "DELETE FROM FIDE_REPORTES_TB WHERE ID_REGISTRO = :id";
        $stmtReportes = oci_parse($this->conexion, $sqlReportes);
        oci_bind_by_name($stmtReportes, ':id', $id);
        oci_execute($stmtReportes); // No comprobamos errores aquí, pero se podría extender
    
        // Luego eliminamos el registro diario
        $sql = "DELETE FROM FIDE_REGISTRO_DIARIO_TB WHERE ID_REGISTRO = :id";
        $stmt = oci_parse($this->conexion, $sql);
        oci_bind_by_name($stmt, ':id', $id);
    
        if (oci_execute($stmt)) {
            return true;
        } else {
            $e = oci_error($stmt);
            return $e['message'];
        }
    }
    
    // Método para obtener un registro diario por su ID
    public function obtenerRegistroPorId($id) {
        $sql = "SELECT * FROM FIDE_REGISTRO_DIARIO_TB WHERE ID_REGISTRO = :id";
        $stmt = oci_parse($this->conexion, $sql);
        oci_bind_by_name($stmt, ':id', $id);
        oci_execute($stmt);
        return oci_fetch_assoc($stmt);
    }

    // Método para actualizar un registro diario existente
    public function actualizarRegistro($id, $idEntrega, $idIngreso, $idTarea, $estadoId) {
        $sql = "UPDATE FIDE_REGISTRO_DIARIO_TB 
                SET ID_ENTREGA = :entrega,
                    ID_INGRESO = :ingreso,
                    ID_TAREA = :tarea,
                    ESTADO_ID = :estado
                WHERE ID_REGISTRO = :id";
        $stmt = oci_parse($this->conexion, $sql);
        // Vinculación de parámetros para la consulta de actualización
        oci_bind_by_name($stmt, ':id', $id);
        oci_bind_by_name($stmt, ':entrega', $idEntrega);
        oci_bind_by_name($stmt, ':ingreso', $idIngreso);
        oci_bind_by_name($stmt, ':tarea', $idTarea);
        oci_bind_by_name($stmt, ':estado', $estadoId);
        // Ejecutar la consulta de actualización
        return oci_execute($stmt);
    }

    // Métodos para obtener datos para dropdowns
    public function obtenerEntregas() {
        return $this->obtenerTablaSimple("FIDE_ENTREGAS_TB", "ID_ENTREGA");
    }

    public function obtenerIngresos() {
        return $this->obtenerTablaSimple("FIDE_INGRESOS_TB", "ID_INGRESO");
    }

    public function obtenerTareas() {
        return $this->obtenerTablaSimple("FIDE_TAREAS_TB", "ID_TAREA");
    }

    public function obtenerEstados() {
        return $this->obtenerTablaSimple("FIDE_ESTADO_TB", "ESTADO_ID", "DESCRIPCION");
    }

    // Método privado para obtener datos simples de una tabla
    private function obtenerTablaSimple($tabla, $campoId, $campoTexto = null) {
        $sql = "SELECT $campoId" . ($campoTexto ? ", $campoTexto" : "") . " FROM $tabla";
        $stmt = oci_parse($this->conexion, $sql);
        oci_execute($stmt);
        $datos = [];
        // Recorrer resultados y almacenarlos en un arreglo
        while ($fila = oci_fetch_assoc($stmt)) {
            $datos[] = $fila;
        }
        return $datos;
    }
}
