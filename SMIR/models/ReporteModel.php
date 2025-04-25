<?php
// Incluir archivo de conexión a la base de datos
include_once __DIR__ . '/../config/conexion.php';

// Definición de la clase ReporteModel para manejar operaciones relacionadas con reportes
class ReporteModel {
    private $conexion;

    // Constructor que establece la conexión a la base de datos
    public function __construct() {
        $db = new Conexion();
        $this->conexion = $db->conectar();
    }

    // Método para obtener el siguiente valor de la secuencia SEQ_FIDE_ID_REPORTE
    public function obtenerNuevoIdReporte() {
        $sql = "SELECT SEQ_FIDE_ID_REPORTE.NEXTVAL AS NUEVO_ID FROM DUAL";
        $stmt = oci_parse($this->conexion, $sql);
        oci_execute($stmt);
        $row = oci_fetch_assoc($stmt);
        return $row ? $row['NUEVO_ID'] : null;
    }

    // Método para insertar un nuevo reporte
    public function insertarReporte($id, $usuario, $inventario, $registro, $estado, $descripcion) {
        $sql = "INSERT INTO FIDE_REPORTES_TB (ID_REPORTE, ID_USUARIO, ID_INVENTARIO, ID_REGISTRO, ESTADO_ID, DESCRIPCION)
                VALUES (:id, :usuario, :inventario, :registro, :estado, :descripcion)";
        $stmt = oci_parse($this->conexion, $sql);
        // Vinculación de parámetros para la consulta SQL
        oci_bind_by_name($stmt, ':id', $id);
        oci_bind_by_name($stmt, ':usuario', $usuario);
        oci_bind_by_name($stmt, ':inventario', $inventario);
        oci_bind_by_name($stmt, ':registro', $registro);
        oci_bind_by_name($stmt, ':estado', $estado);
        oci_bind_by_name($stmt, ':descripcion', $descripcion);
        // Ejecutar la consulta
        return oci_execute($stmt);
    }

    // Método para actualizar un reporte existente
    public function actualizarReporte($id, $usuario, $inventario, $registro, $estado, $descripcion) {
        $sql = "UPDATE FIDE_REPORTES_TB 
                SET ID_USUARIO = :usuario, ID_INVENTARIO = :inventario, ID_REGISTRO = :registro, 
                    ESTADO_ID = :estado, DESCRIPCION = :descripcion 
                WHERE ID_REPORTE = :id";
        $stmt = oci_parse($this->conexion, $sql);
        // Vinculación de parámetros para la consulta de actualización
        oci_bind_by_name($stmt, ':id', $id);
        oci_bind_by_name($stmt, ':usuario', $usuario);
        oci_bind_by_name($stmt, ':inventario', $inventario);
        oci_bind_by_name($stmt, ':registro', $registro);
        oci_bind_by_name($stmt, ':estado', $estado);
        oci_bind_by_name($stmt, ':descripcion', $descripcion);
        // Ejecutar la consulta
        return oci_execute($stmt);
    }

    // Método para eliminar un reporte por ID
    public function eliminarReporte($id) {
        // Actualizar el estado a 2 (inactivo) en lugar de eliminar
        $sql = "UPDATE FIDE_REPORTES_TB SET ESTADO_ID = 2 WHERE ID_REPORTE = :id";
        $stmt = oci_parse($this->conexion, $sql);
        oci_bind_by_name($stmt, ':id', $id);
        // Ejecutar la consulta de actualización
        return oci_execute($stmt);
    }

    // Método para listar todos los reportes
    public function listarReportes() {
        $sql = "SELECT * FROM FIDE_REPORTES_TB WHERE ESTADO_ID != 2";
        $stmt = oci_parse($this->conexion, $sql);
        oci_execute($stmt);
        $result = [];
        // Recorrer resultados y almacenarlos en un arreglo
        while ($row = oci_fetch_assoc($stmt)) {
            $result[] = $row;
        }
        return $result;
    }

    // Método para obtener un reporte por su ID
    public function obtenerReportePorId($id) {
        $sql = "SELECT * FROM FIDE_REPORTES_TB WHERE ID_REPORTE = :id";
        $stmt = oci_parse($this->conexion, $sql);
        oci_bind_by_name($stmt, ':id', $id);
        oci_execute($stmt);
        return oci_fetch_assoc($stmt);
    }

    // Método para ejecutar una consulta SQL arbitraria y obtener resultados
    public function obtenerTabla($sql) {
        $stmt = oci_parse($this->conexion, $sql);
        oci_execute($stmt);
        $data = [];
        // Recorrer resultados y almacenarlos en un arreglo
        while ($row = oci_fetch_assoc($stmt)) {
            $data[] = $row;
        }
        return $data;
    }
}
