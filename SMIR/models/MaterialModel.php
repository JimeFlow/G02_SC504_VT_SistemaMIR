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
}
?>
