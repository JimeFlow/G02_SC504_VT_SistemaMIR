<?php
// Incluir archivo de conexión a la base de datos
include_once __DIR__ . '/../config/conexion.php';

// Definición de la clase EntregasModel para manejar operaciones relacionadas con entregas
class EntregasModel {
    private $conexion;

    // Constructor que establece la conexión a la base de datos
    public function __construct() {
        $db = new Conexion();
        $this->conexion = $db->conectar();
    }

    // Método para obtener el siguiente valor de la secuencia SEQ_FIDE_ID_ENTREGA
    public function obtenerNuevoIdEntrega() {
        $sql = "SELECT SEQ_FIDE_ID_ENTREGA.NEXTVAL AS NUEVO_ID FROM DUAL";
        $stmt = oci_parse($this->conexion, $sql);
        oci_execute($stmt);
        $row = oci_fetch_assoc($stmt);
        return $row ? $row['NUEVO_ID'] : null;
    }

    // Método para insertar una nueva entrega
    public function insertarEntrega($idEntrega, $idMaterial, $datoEntregaId, $estadoId, $destinatario, $cantidadRestante) {
        $sql = "INSERT INTO FIDE_ENTREGAS_TB 
                (ID_ENTREGA, ID_MATERIAL, DATO_ENTREGA_ID, ESTADO_ID, DESTINATARIO, CANTIDAD_RESTANTE)
                VALUES (:id_entrega, :id_material, :dato_entrega_id, :estado_id, :destinatario, :cantidad_restante)";
        $stmt = oci_parse($this->conexion, $sql);
        // Vinculación de parámetros para la consulta SQL
        oci_bind_by_name($stmt, ':id_entrega', $idEntrega);
        oci_bind_by_name($stmt, ':id_material', $idMaterial);
        oci_bind_by_name($stmt, ':dato_entrega_id', $datoEntregaId);
        oci_bind_by_name($stmt, ':estado_id', $estadoId);
        oci_bind_by_name($stmt, ':destinatario', $destinatario);
        oci_bind_by_name($stmt, ':cantidad_restante', $cantidadRestante);
        // Ejecutar la consulta
        return oci_execute($stmt);
    }

    // Método para listar todas las entregas
    public function listarEntregas() {
        $sql = "SELECT * FROM FIDE_ENTREGAS_TB WHERE ESTADO_ID != 2";
        $stmt = oci_parse($this->conexion, $sql);
        oci_execute($stmt);
        $entregas = [];
        // Recorrer resultados y almacenarlos en un arreglo
        while ($row = oci_fetch_assoc($stmt)) {
            $entregas[] = $row;
        }
        return $entregas;
    }

    // Método para obtener una entrega por su ID
    public function obtenerEntregaPorId($idEntrega) {
        $sql = "SELECT * FROM FIDE_ENTREGAS_TB WHERE ID_ENTREGA = :id";
        $stmt = oci_parse($this->conexion, $sql);
        oci_bind_by_name($stmt, ':id', $idEntrega);
        oci_execute($stmt);
        return oci_fetch_assoc($stmt);
    }

    // Método para actualizar una entrega existente
    public function actualizarEntrega($idEntrega, $idMaterial, $datoEntregaId, $estadoId, $destinatario, $cantidadRestante) {
        $sql = "UPDATE FIDE_ENTREGAS_TB 
                SET ID_MATERIAL = :id_material,
                    DATO_ENTREGA_ID = :dato_entrega_id,
                    ESTADO_ID = :estado_id,
                    DESTINATARIO = :destinatario,
                    CANTIDAD_RESTANTE = :cantidad_restante
                WHERE ID_ENTREGA = :id_entrega";
        $stmt = oci_parse($this->conexion, $sql);
        // Vinculación de parámetros para la consulta de actualización
        oci_bind_by_name($stmt, ':id_entrega', $idEntrega);
        oci_bind_by_name($stmt, ':id_material', $idMaterial);
        oci_bind_by_name($stmt, ':dato_entrega_id', $datoEntregaId);
        oci_bind_by_name($stmt, ':estado_id', $estadoId);
        oci_bind_by_name($stmt, ':destinatario', $destinatario);
        oci_bind_by_name($stmt, ':cantidad_restante', $cantidadRestante);
        // Ejecutar la consulta de actualización
        return oci_execute($stmt);
    }

    // Método para eliminar una entrega, verificando relaciones con personal
    public function eliminarEntrega($idEntrega) {
        // Verificamos si existen registros en FIDE_PERSONAL_TB que usan esta entrega
        $sqlVerificar = "SELECT COUNT(*) AS TOTAL FROM FIDE_PERSONAL_TB WHERE ID_ENTREGA = :id";
        $stmtVerificar = oci_parse($this->conexion, $sqlVerificar);
        oci_bind_by_name($stmtVerificar, ':id', $idEntrega);
        oci_execute($stmtVerificar);
        $row = oci_fetch_assoc($stmtVerificar);

        // Si hay personal relacionado, no se permite eliminar la entrega
        if ($row && $row['TOTAL'] > 0) {
            echo "❌ No se puede eliminar la entrega porque está relacionada con personal registrado.<br>";
            return false;
        }

        // Si no hay registros relacionados, actualizamos el estado a 2 (inactivo) en lugar de eliminar
        $sql = "UPDATE FIDE_ENTREGAS_TB SET ESTADO_ID = 2 WHERE ID_ENTREGA = :id";
        $stmt = oci_parse($this->conexion, $sql);
        oci_bind_by_name($stmt, ':id', $idEntrega);

        // Ejecutar la consulta de actualización
        if (oci_execute($stmt)) {
            return true;
        } else {
            $e = oci_error($stmt);
            echo "Error al actualizar estado de entrega: " . $e['message'] . "<br>";
            return false;
        }
    }

    // método para listar materiales para dropdown
    public function listarMateriales() {
        $sql = "SELECT ID_MATERIAL, NOMBRE FROM FIDE_MATERIALES_TB ORDER BY NOMBRE";
        $stmt = oci_parse($this->conexion, $sql);
        oci_execute($stmt);
        $materiales = [];
        while ($row = oci_fetch_assoc($stmt)) {
            $materiales[] = $row;
        }
        return $materiales;
    }

    // método para listar datos de entregas para dropdown
    public function listarDatosEntregas() {
        $sql = "SELECT DATO_ENTREGA_ID, TO_CHAR(FECHA, 'YYYY-MM-DD') AS FECHA FROM FIDE_DATOS_ENTREGAS_TB ORDER BY FECHA DESC";
        $stmt = oci_parse($this->conexion, $sql);
        oci_execute($stmt);
        $datos = [];
        while ($row = oci_fetch_assoc($stmt)) {
            $datos[] = $row;
        }
        return $datos;
    }

    // método para listar estados para dropdown
    public function listarEstados() {
        $sql = "SELECT ESTADO_ID, DESCRIPCION FROM FIDE_ESTADO_TB ORDER BY DESCRIPCION";
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
