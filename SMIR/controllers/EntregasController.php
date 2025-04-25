<?php
// Incluir el modelo EntregasModel para manejar la lógica de datos
include_once __DIR__ . '/../models/EntregasModel.php';

// Definición de la clase EntregasController para manejar la lógica de negocio relacionada con entregas
class EntregasController {
    private $model;

    // Constructor que instancia el modelo EntregasModel
    public function __construct() {
        $this->model = new EntregasModel();
    }

    // Método para agregar una nueva entrega, delegando al modelo
    public function agregarEntrega($id, $material, $dato, $estado, $dest, $cantidad) {
        // Siempre obtener un nuevo ID para evitar conflictos de clave primaria
        $id = $this->model->obtenerNuevoIdEntrega();
        error_log("Nuevo ID Entrega generado: " . $id);
        return $this->model->insertarEntrega($id, $material, $dato, $estado, $dest, $cantidad);
    }

    // Método para listar todas las entregas, delegando al modelo
    public function listarEntregas() {
        return $this->model->listarEntregas();
    }

    // Método para eliminar una entrega, delegando al modelo
    public function eliminarEntrega($id) {
        return $this->model->eliminarEntrega($id);
    }

    // Método para obtener una entrega por su ID, delegando al modelo
    public function obtenerEntregaPorId($id) {
        return $this->model->obtenerEntregaPorId($id);
    }

    // Método para actualizar una entrega, delegando al modelo
    public function actualizarEntrega($id, $material, $dato, $estado, $dest, $cantidad) {
        return $this->model->actualizarEntrega($id, $material, $dato, $estado, $dest, $cantidad);
    }

    // Nuevo método para obtener lista de materiales para dropdown
    public function obtenerMateriales() {
        return $this->model->listarMateriales();
    }

    // Nuevo método para obtener lista de datos de entregas para dropdown
    public function obtenerDatosEntregas() {
        return $this->model->listarDatosEntregas();
    }

    // Nuevo método para obtener lista de estados para dropdown
    public function obtenerEstados() {
        return $this->model->listarEstados();
    }
}
