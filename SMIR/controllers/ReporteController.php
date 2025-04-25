<?php
include_once __DIR__ . '/../models/ReporteModel.php';

class ReporteController {
    private $model;

    public function __construct() {
        $this->model = new ReporteModel();
    }

    public function agregarReporte($id, $usuario, $inventario, $registro, $estado, $descripcion) {
        // Obtener nuevo ID desde la secuencia para evitar NULL
        $id = $this->model->obtenerNuevoIdReporte();
        return $this->model->insertarReporte($id, $usuario, $inventario, $registro, $estado, $descripcion);
    }

    public function actualizarReporte($id, $usuario, $inventario, $registro, $estado, $descripcion) {
        return $this->model->actualizarReporte($id, $usuario, $inventario, $registro, $estado, $descripcion);
    }

    public function eliminarReporte($id) {
        return $this->model->eliminarReporte($id);
    }

    public function listarReportes() {
        return $this->model->listarReportes();
    }

    public function obtenerReportePorId($id) {
        return $this->model->obtenerReportePorId($id);
    }

    public function obtenerUsuarios() {
        return $this->model->obtenerTabla("SELECT ID_USUARIO FROM FIDE_PERSONAL_TB WHERE ID_USUARIO IS NOT NULL");
    }

    public function obtenerInventarios() {
        return $this->model->obtenerTabla("SELECT ID_INVENTARIO FROM FIDE_INVENTARIO_TB");
    }

    public function obtenerRegistros() {
        return $this->model->obtenerTabla("SELECT ID_REGISTRO FROM FIDE_REGISTRO_DIARIO_TB");
    }

    public function obtenerEstados() {
        return $this->model->obtenerTabla("SELECT ESTADO_ID, DESCRIPCION FROM FIDE_ESTADO_TB");
    }
}
