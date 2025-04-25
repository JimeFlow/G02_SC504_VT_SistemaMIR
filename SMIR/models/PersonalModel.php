<?php
// Incluir archivo de conexión a la base de datos
include_once __DIR__ . '/../config/conexion.php';

// Definición de la clase PersonalModel para manejar operaciones relacionadas con el personal
class PersonalModel {
    private $conexion;

    // Constructor que establece la conexión a la base de datos
    public function __construct() {
        $db = new Conexion();
        $this->conexion = $db->conectar();
    }

    // Método para insertar un nuevo empleado usando un procedimiento almacenado
    public function insertarEmpleado($idPersonal, $idRol, $idEntrega, $horarioId, $estadoId, $tipo, $nombre, $apellidos, $contacto, $linea, $idUsuario, $upi) {
        $sql = "BEGIN FIDE_PERSONAL_TB_Registrar_Personal_SP(:idPersonal, :idRol, :idEntrega, :horarioId, :estadoId, :tipo, :nombre, :apellidos, :contacto, :linea, :idUsuario, :upi); END;";

        $stmt = oci_parse($this->conexion, $sql);
        // Vinculación de parámetros para el procedimiento almacenado
        oci_bind_by_name($stmt, ':idPersonal', $idPersonal);
        oci_bind_by_name($stmt, ':idRol', $idRol);
        oci_bind_by_name($stmt, ':idEntrega', $idEntrega);
        oci_bind_by_name($stmt, ':horarioId', $horarioId);
        oci_bind_by_name($stmt, ':estadoId', $estadoId);
        oci_bind_by_name($stmt, ':tipo', $tipo);
        oci_bind_by_name($stmt, ':nombre', $nombre);
        oci_bind_by_name($stmt, ':apellidos', $apellidos);
        oci_bind_by_name($stmt, ':contacto', $contacto);
        oci_bind_by_name($stmt, ':linea', $linea);
        oci_bind_by_name($stmt, ':idUsuario', $idUsuario);
        oci_bind_by_name($stmt, ':upi', $upi);

        // Ejecutar el procedimiento almacenado
        return oci_execute($stmt);
    }

    // Método para listar todos los empleados activos (ESTADO_ID = 1)
    public function listarEmpleados() {
        $sql = "SELECT * FROM FIDE_PERSONAL_TB WHERE ESTADO_ID = 1"; // Solo mostrar activos
        $stmt = oci_parse($this->conexion, $sql);
        oci_execute($stmt);
        $resultados = [];
        // Recorrer resultados y almacenarlos en un arreglo
        while ($fila = oci_fetch_assoc($stmt)) {
            $resultados[] = $fila;
        }
        return $resultados;
    }
    
    // Método para eliminar lógicamente un empleado (cambia ESTADO_ID a 2 - Inactivo)
    public function eliminarEmpleado($id) {
        // Usar procedimiento almacenado para actualización lógica del estado
        $sql = "BEGIN FIDE_PERSONAL_TB_Actualizar_Estado_Empleado_SP(:id, :estado); END;";
        $stmt = oci_parse($this->conexion, $sql);
        $estadoInactivo = 2; // Estado inactivo
        oci_bind_by_name($stmt, ':id', $id);
        oci_bind_by_name($stmt, ':estado', $estadoInactivo);

        return oci_execute($stmt);
    }
    
    // Método para obtener un empleado por su ID
    public function obtenerEmpleadoPorId($id) {
        $sql = "SELECT * FROM FIDE_PERSONAL_TB WHERE ID_PERSONAL = :id";
        $stmt = oci_parse($this->conexion, $sql);
        oci_bind_by_name($stmt, ':id', $id);
        oci_execute($stmt);
        return oci_fetch_assoc($stmt);
    }

    // Método para actualizar datos de un empleado usando procedimientos almacenados separados
    public function actualizarEmpleado($idPersonal, $idRol, $idEntrega, $horarioId, $estadoId, $tipo, $nombre, $apellidos, $contacto, $linea, $idUsuario, $upi) {
        // Actualizar rol del empleado
        $sqlRol = "BEGIN FIDE_PERSONAL_TB_Actualizar_Rol_Empleado_SP(:upi, :idRol); END;";
        $stmtRol = oci_parse($this->conexion, $sqlRol);
        oci_bind_by_name($stmtRol, ':upi', $upi);
        oci_bind_by_name($stmtRol, ':idRol', $idRol);
        $resRol = oci_execute($stmtRol);

        // Actualizar horario del empleado
        $sqlHorario = "BEGIN FIDE_PERSONAL_TB_Actualizar_Horario_Empleado_SP(:idPersonal, :horarioId); END;";
        $stmtHorario = oci_parse($this->conexion, $sqlHorario);
        oci_bind_by_name($stmtHorario, ':idPersonal', $idPersonal);
        oci_bind_by_name($stmtHorario, ':horarioId', $horarioId);
        $resHorario = oci_execute($stmtHorario);

        // Actualizar contacto del empleado
        $sqlContacto = "BEGIN FIDE_PERSONAL_TB_Actualizar_Contacto_Personal_SP(:tipo, :contacto); END;";
        $stmtContacto = oci_parse($this->conexion, $sqlContacto);
        oci_bind_by_name($stmtContacto, ':tipo', $tipo);
        oci_bind_by_name($stmtContacto, ':contacto', $contacto);
        $resContacto = oci_execute($stmtContacto);

        // Actualizar otros campos del empleado
        $sqlOtros = "UPDATE FIDE_PERSONAL_TB SET 
                        NOMBRE = :nombre,
                        APELLIDOS = :apellidos,
                        LINEA_TRABAJO = :linea,
                        ID_USUARIO = :idUsuario,
                        ESTADO_ID = :estadoId
                      WHERE ID_PERSONAL = :idPersonal";
        $stmtOtros = oci_parse($this->conexion, $sqlOtros);
        oci_bind_by_name($stmtOtros, ':nombre', $nombre);
        oci_bind_by_name($stmtOtros, ':apellidos', $apellidos);
        oci_bind_by_name($stmtOtros, ':linea', $linea);
        oci_bind_by_name($stmtOtros, ':idUsuario', $idUsuario);
        oci_bind_by_name($stmtOtros, ':estadoId', $estadoId);
        oci_bind_by_name($stmtOtros, ':idPersonal', $idPersonal);
        $resOtros = oci_execute($stmtOtros);

        // Retornar true si todas las actualizaciones fueron exitosas
        return $resRol && $resHorario && $resContacto && $resOtros;
    }
}
