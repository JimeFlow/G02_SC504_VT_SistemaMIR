<?php
// Incluir archivo de conexión a la base de datos
include_once __DIR__ . '/../config/conexion.php';

// Definición de la clase InventarioModel para manejar operaciones relacionadas con inventario
class InventarioModel {
    private $conexion;

    // Constructor que establece la conexión a la base de datos
    public function __construct() {
        $db = new Conexion();
        $this->conexion = $db->conectar();
    }

    // Método para generar alertas de stock bajo llamando al procedimiento almacenado
    public function generarAlertasStock() {
        try {
            // Preparar la llamada al procedimiento almacenado
            $sql = "BEGIN FIDE_INVENTARIO_TB_Generar_Alertas_Stock_SP; END;";
            $stmt = oci_parse($this->conexion, $sql);

            // Ejecutar el procedimiento almacenado
            if (oci_execute($stmt)) {
                return true; // Procedimiento ejecutado correctamente
            } else {
                $e = oci_error($stmt);
                echo "Error al generar alertas de stock: " . $e['message'] . "<br>";
                return false;
            }
        } catch (Exception $e) {
            echo "Error al ejecutar la operación: " . $e->getMessage() . "<br>";
            return false;
        }
    }

    // Método para obtener inventarios con alertas de stock bajo
    public function obtenerInventariosConAlertaBajoStock() {
        try {
            $sql = "SELECT ID_INVENTARIO, ALERTAS_STOCK FROM FIDE_INVENTARIO_TB WHERE ALERTAS_STOCK LIKE '%Stock bajo%'";
            $stmt = oci_parse($this->conexion, $sql);
            oci_execute($stmt);

            $resultados = [];
            while ($row = oci_fetch_assoc($stmt)) {
                $resultados[] = $row;
            }
            return $resultados;
        } catch (Exception $e) {
            echo "Error al obtener inventarios con alerta de stock bajo: " . $e->getMessage() . "<br>";
            return [];
        }
    }

    // Método para insertar un nuevo registro en inventario
    public function insertarInventario($idInventario, $idUsuario, $upi, $idMaterial, $estadoId, $fecha, $alerta) {
        try {
            // Obtener el siguiente valor de la secuencia para ID_INVENTARIO
            $seqSql = "SELECT SEQ_FIDE_ID_INVENTARIO.NEXTVAL AS NEXT_ID FROM DUAL";
            $seqStmt = oci_parse($this->conexion, $seqSql);
            oci_execute($seqStmt);
            $row = oci_fetch_assoc($seqStmt);
            $nextId = $row['NEXT_ID'];

            $sql = "INSERT INTO FIDE_INVENTARIO_TB (ID_INVENTARIO, ID_USUARIO, UPI, ID_MATERIAL, ESTADO_ID, FECHA, ALERTAS_STOCK) 
                    VALUES (:id_inventario, :id_usuario, :upi, :id_material, :estado_id, TO_DATE(:fecha, 'YYYY-MM-DD'), :alertas_stock)";
            
            $stmt = oci_parse($this->conexion, $sql);

            // Vinculación de parámetros para la consulta SQL
            oci_bind_by_name($stmt, ':id_inventario', $nextId);
            oci_bind_by_name($stmt, ':id_usuario', $idUsuario);
            oci_bind_by_name($stmt, ':upi', $upi);
            oci_bind_by_name($stmt, ':id_material', $idMaterial);
            oci_bind_by_name($stmt, ':estado_id', $estadoId);
            oci_bind_by_name($stmt, ':fecha', $fecha);
            oci_bind_by_name($stmt, ':alertas_stock', $alerta);

            // Ejecutar la consulta
            if (oci_execute($stmt)) {
                return true;
            } else {
                $e = oci_error($stmt);
                echo "Error al agregar inventario: " . $e['message'] . "<br>";
                return false;
            }
        } catch (Exception $e) {
            echo "Error al ejecutar la operación: " . $e->getMessage() . "<br>";
            return false;
        }
    }

    // Método para eliminar un registro de inventario por ID
    public function eliminarInventario($id) {
        $sql = "DELETE FROM FIDE_INVENTARIO_TB WHERE ID_INVENTARIO = :id";
        $stmt = oci_parse($this->conexion, $sql);
        oci_bind_by_name($stmt, ':id', $id);
        return oci_execute($stmt);
    }

    // Método para desactivar un registro de inventario (actualizar ESTADO_ID a 2)
    public function desactivarInventario($id) {
        $sql = "UPDATE FIDE_INVENTARIO_TB SET ESTADO_ID = 2 WHERE ID_INVENTARIO = :id";
        $stmt = oci_parse($this->conexion, $sql);
        oci_bind_by_name($stmt, ':id', $id);
        return oci_execute($stmt);
    }
    
    // Método para obtener un registro de inventario por ID
    public function obtenerInventarioPorId($id) {
        $sql = "SELECT * FROM FIDE_INVENTARIO_TB WHERE ID_INVENTARIO = :id";
        $stmt = oci_parse($this->conexion, $sql);
        oci_bind_by_name($stmt, ':id', $id);
        oci_execute($stmt);
        return oci_fetch_assoc($stmt);
    }
    
    // Método para actualizar un registro de inventario existente
    public function actualizarInventario($idInventario, $idUsuario, $upi, $idMaterial, $estadoId, $fecha, $alerta) {
        $sql = "UPDATE FIDE_INVENTARIO_TB 
                SET ID_USUARIO = :id_usuario, 
                    UPI = :upi, 
                    ID_MATERIAL = :id_material, 
                    ESTADO_ID = :estado_id, 
                    FECHA = TO_DATE(:fecha, 'YYYY-MM-DD'), 
                    ALERTAS_STOCK = :alertas_stock 
                WHERE ID_INVENTARIO = :id_inventario";
    
        $stmt = oci_parse($this->conexion, $sql);
        // Vinculación de parámetros para la consulta de actualización
        oci_bind_by_name($stmt, ':id_usuario', $idUsuario);
        oci_bind_by_name($stmt, ':upi', $upi);
        oci_bind_by_name($stmt, ':id_material', $idMaterial);
        oci_bind_by_name($stmt, ':estado_id', $estadoId);
        oci_bind_by_name($stmt, ':fecha', $fecha);
        oci_bind_by_name($stmt, ':alertas_stock', $alerta);
        oci_bind_by_name($stmt, ':id_inventario', $idInventario);
        
        // Ejecutar la consulta de actualización
        return oci_execute($stmt);
    }

    // Método para listar todos los registros de inventario
    public function listarInventario() {
        try {
            $sql = "SELECT * FROM FIDE_INVENTARIO_TB WHERE ESTADO_ID != 2";
            $stmt = oci_parse($this->conexion, $sql);
            oci_execute($stmt);

            $inventarios = [];
            // Recorrer resultados y almacenarlos en un arreglo
            while ($row = oci_fetch_assoc($stmt)) {
                $inventarios[] = $row;
            }
            return $inventarios;
        } catch (Exception $e) {
            echo "Error al listar inventario: " . $e->getMessage() . "<br>";
            return [];
        }
    }
}
?>
