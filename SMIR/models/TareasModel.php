<?php
// Incluir archivo de conexión a la base de datos
include_once __DIR__ . '/../config/conexion.php';

// Definición de la clase TareasModel para manejar operaciones relacionadas con tareas usando procedimientos almacenados existentes
class TareasModel {
    private $conexion;

    // Constructor que establece la conexión a la base de datos
    public function __construct() {
        $db = new Conexion();
        $this->conexion = $db->conectar();
    }

    // Método para obtener el siguiente valor de la secuencia SEQ_FIDE_ID_TAREA
    public function obtenerNuevoIdTarea() {
        $sql = "SELECT SEQ_FIDE_ID_TAREA.NEXTVAL AS NUEVO_ID FROM DUAL";
        $stmt = oci_parse($this->conexion, $sql);
        oci_execute($stmt);
        $row = oci_fetch_assoc($stmt);
        return $row ? $row['NUEVO_ID'] : null;
    }

    // Método para insertar una nueva tarea usando procedimiento almacenado existente
    public function insertarTarea($idTarea, $nombre, $descripcion, $estado, $fechaCreacion) {
        $sql = "BEGIN FIDE_TAREAS_TB_Insertar_Tarea_SP(:id_tarea, NULL, :estado, :nombre, TO_DATE(:fecha_creacion, 'YYYY-MM-DD'), :descripcion); END;";
        $stmt = oci_parse($this->conexion, $sql);
        // Vinculación de parámetros para el procedimiento almacenado
        oci_bind_by_name($stmt, ':id_tarea', $idTarea);
        oci_bind_by_name($stmt, ':estado', $estado);
        oci_bind_by_name($stmt, ':nombre', $nombre);
        oci_bind_by_name($stmt, ':fecha_creacion', $fechaCreacion);
        oci_bind_by_name($stmt, ':descripcion', $descripcion);
        // Ejecutar el procedimiento almacenado
        return oci_execute($stmt);
    }

    // Método para listar todas las tareas (no hay procedimiento, uso consulta directa)
    public function listarTareas() {
        $sql = "SELECT ID_TAREA, NOMBRE, DESCRIPCION, ESTADO_ID, TO_CHAR(FECHA_RECIBIDO, 'YYYY-MM-DD') AS FECHA_RECIBIDO FROM FIDE_TAREAS_TB ORDER BY FECHA_RECIBIDO DESC";
        $stmt = oci_parse($this->conexion, $sql);
        oci_execute($stmt);
        $tareas = [];
        while ($row = oci_fetch_assoc($stmt)) {
            $tareas[] = $row;
        }
        return $tareas;
    }

    // Método para obtener una tarea por su ID usando procedimiento almacenado existente
    public function obtenerTareaPorId($idTarea) {
        $sql = "SELECT ID_TAREA, UPI, NOMBRE, FECHA_RECIBIDO, DESCRIPCION, ESTADO_ID FROM FIDE_TAREAS_TB WHERE ID_TAREA = :id_tarea";
        $stmt = oci_parse($this->conexion, $sql);
        oci_bind_by_name($stmt, ':id_tarea', $idTarea);
        oci_execute($stmt);
        $row = oci_fetch_assoc($stmt);
        if (!$row) {
            return null;
        }
        return $row;
    }

    // Método para actualizar una tarea (no hay procedimiento, uso consulta directa)
    public function actualizarTarea($idTarea, $nombre, $descripcion, $estado, $fechaRecibido) {
        $sql = "UPDATE FIDE_TAREAS_TB 
                SET NOMBRE = :nombre,
                    DESCRIPCION = :descripcion,
                    ESTADO_ID = :estado,
                    FECHA_RECIBIDO = TO_DATE(:fecha_recibido, 'YYYY-MM-DD')
                WHERE ID_TAREA = :id_tarea";
        $stmt = oci_parse($this->conexion, $sql);
        oci_bind_by_name($stmt, ':id_tarea', $idTarea);
        oci_bind_by_name($stmt, ':nombre', $nombre);
        oci_bind_by_name($stmt, ':descripcion', $descripcion);
        oci_bind_by_name($stmt, ':estado', $estado);
        oci_bind_by_name($stmt, ':fecha_recibido', $fechaRecibido);
        return oci_execute($stmt);
    }

    // Método para eliminar una tarea usando procedimiento almacenado existente
    public function eliminarTarea($idTarea) {
        $sql = "BEGIN FIDE_TAREAS_TB_Eliminar_Tarea_SP(:id_tarea); END;";
        $stmt = oci_parse($this->conexion, $sql);
        oci_bind_by_name($stmt, ':id_tarea', $idTarea);
        return oci_execute($stmt);
    }
}
?>
