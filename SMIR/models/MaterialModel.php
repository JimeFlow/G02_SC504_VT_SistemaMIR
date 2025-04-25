<?php
// Incluir archivo de conexión a la base de datos
include_once __DIR__ . '/../config/conexion.php';

// Definición de la clase MaterialModel para manejar operaciones relacionadas con materiales
class MaterialModel {
    private $conexion;

    // Constructor que establece la conexión a la base de datos
    public function __construct() {
        $db = new Conexion();
        $this->conexion = $db->conectar();
    }

    // Método para obtener el siguiente valor de la secuencia SEQ_FIDE_ID_MATERIAL
    public function getNextMaterialId() {
        // Get max ID from table
        $sqlMax = "SELECT NVL(MAX(ID_MATERIAL), 0) AS MAX_ID FROM FIDE_MATERIALES_TB";
        $stmtMax = oci_parse($this->conexion, $sqlMax);
        oci_execute($stmtMax);
        $rowMax = oci_fetch_assoc($stmtMax);
        $maxId = $rowMax['MAX_ID'] ?? 0;

        // Get next sequence value
        $sqlSeq = "SELECT SEQ_FIDE_ID_MATERIAL.NEXTVAL AS NEXT_ID FROM DUAL";
        $stmtSeq = oci_parse($this->conexion, $sqlSeq);
        oci_execute($stmtSeq);
        $rowSeq = oci_fetch_assoc($stmtSeq);
        $nextSeqVal = $rowSeq['NEXT_ID'] ?? null;

        // If sequence value is less or equal to max ID, advance sequence
        if ($nextSeqVal <= $maxId) {
            $diff = $maxId - $nextSeqVal + 1;
            for ($i = 0; $i < $diff; $i++) {
                $stmtSeq = oci_parse($this->conexion, "SELECT SEQ_FIDE_ID_MATERIAL.NEXTVAL FROM DUAL");
                oci_execute($stmtSeq);
            }
            // Get new sequence value after advancing
            $stmtSeq = oci_parse($this->conexion, "SELECT SEQ_FIDE_ID_MATERIAL.CURRVAL AS CURR_ID FROM DUAL");
            oci_execute($stmtSeq);
            $rowSeq = oci_fetch_assoc($stmtSeq);
            $nextSeqVal = $rowSeq['CURR_ID'] ?? null;
        }

        return $nextSeqVal;
    }

    // Método para insertar un nuevo material en la base de datos
    public function insertarMaterial($id, $estadoId, $nombre, $fecha, $disponible, $solicitada) {
        $sql = "INSERT INTO FIDE_MATERIALES_TB (ID_MATERIAL, ESTADO_ID, NOMBRE, FECHA_VENCIMIENTO, CANTIDAD_DISPONIBLE, CANTIDAD_SOLICITADA)
                VALUES (:id, :estado, :nombre, TO_DATE(:fecha, 'YYYY-MM-DD'), :disponible, :solicitada)";
        $stmt = oci_parse($this->conexion, $sql);
        // Vinculación de parámetros para la consulta SQL
        oci_bind_by_name($stmt, ':id', $id);
        oci_bind_by_name($stmt, ':estado', $estadoId);
        oci_bind_by_name($stmt, ':nombre', $nombre);
        oci_bind_by_name($stmt, ':fecha', $fecha);
        oci_bind_by_name($stmt, ':disponible', $disponible);
        oci_bind_by_name($stmt, ':solicitada', $solicitada);
        // Ejecutar la consulta
        return oci_execute($stmt);
    }

    // Método para obtener todos los materiales ordenados por ID
    public function obtenerMateriales() {
        $sql = "SELECT * FROM FIDE_MATERIALES_TB ORDER BY ID_MATERIAL";
        $stmt = oci_parse($this->conexion, $sql);
        oci_execute($stmt);
        $resultados = [];
        // Recorrer resultados y almacenarlos en un arreglo
        while ($row = oci_fetch_assoc($stmt)) {
            $resultados[] = $row;
        }
        return $resultados;
    }

    // Método para eliminar un material por su ID
    public function eliminarMaterial($id) {
        $sql = "DELETE FROM FIDE_MATERIALES_TB WHERE ID_MATERIAL = :id";
        $stmt = oci_parse($this->conexion, $sql);
        oci_bind_by_name($stmt, ':id', $id);
        // Ejecutar la consulta de eliminación
        return oci_execute($stmt);
    }

    // Método para obtener un material por su ID
    public function obtenerMaterialPorId($id) {
        $sql = "SELECT * FROM FIDE_MATERIALES_TB WHERE ID_MATERIAL = :id";
        $stmt = oci_parse($this->conexion, $sql);
        oci_bind_by_name($stmt, ':id', $id);
        oci_execute($stmt);
        return oci_fetch_assoc($stmt);
    }

    // Método para actualizar un material existente
    public function actualizarMaterial($id, $estadoId, $nombre, $fecha, $disponible, $solicitada) {
        $sql = "UPDATE FIDE_MATERIALES_TB 
                SET ESTADO_ID = :estado, NOMBRE = :nombre, FECHA_VENCIMIENTO = TO_DATE(:fecha, 'YYYY-MM-DD'),
                    CANTIDAD_DISPONIBLE = :disponible, CANTIDAD_SOLICITADA = :solicitada
                WHERE ID_MATERIAL = :id";
        $stmt = oci_parse($this->conexion, $sql);
        // Vinculación de parámetros para la consulta de actualización
        oci_bind_by_name($stmt, ':estado', $estadoId);
        oci_bind_by_name($stmt, ':nombre', $nombre);
        oci_bind_by_name($stmt, ':fecha', $fecha);
        oci_bind_by_name($stmt, ':disponible', $disponible);
        oci_bind_by_name($stmt, ':solicitada', $solicitada);
        oci_bind_by_name($stmt, ':id', $id);
        // Ejecutar la consulta de actualización
        return oci_execute($stmt);
    }
    // Método para obtener todos los estados
    public function getEstados() {
        $sql = "SELECT ESTADO_ID, DESCRIPCION FROM FIDE_ESTADO_TB ORDER BY ESTADO_ID";
        $stmt = oci_parse($this->conexion, $sql);
        oci_execute($stmt);
        $estados = [];
        while ($row = oci_fetch_assoc($stmt)) {
            $estados[] = $row;
        }
        return $estados;
    }
}
?>
