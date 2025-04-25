<?php
// Incluir el modelo RegistrosModel para manejar la lógica de datos
include_once __DIR__ . '/../models/RegistrosModel.php';

// Definición de la clase RegistrosController para manejar la lógica de negocio relacionada con registros diarios
class RegistrosController {
    private $model;

    // Constructor que instancia el modelo RegistrosModel
    public function __construct() {
        $this->model = new RegistrosModel();
    }

    // Método para agregar un nuevo registro diario, delegando al modelo
    public function agregarRegistro($id, $idEntrega, $idIngreso, $idTarea, $estadoId) {
        return $this->model->insertarRegistro($id, $idEntrega, $idIngreso, $idTarea, $estadoId);
    }

    // Método para listar todos los registros diarios, delegando al modelo
    public function listarRegistros() {
        return $this->model->listarRegistros();
    }

    // Método para eliminar un registro diario, delegando al modelo
    public function eliminarRegistro($id) {
        return $this->model->eliminarRegistro($id);
    }

    // Método para obtener un registro diario por su ID, delegando al modelo
    public function obtenerRegistroPorId($id) {
        return $this->model->obtenerRegistroPorId($id);
    }

    // Método para actualizar un registro diario, delegando al modelo
    public function actualizarRegistro($id, $idEntrega, $idIngreso, $idTarea, $estadoId) {
        return $this->model->actualizarRegistro($id, $idEntrega, $idIngreso, $idTarea, $estadoId);
    }

    // Métodos auxiliares para obtener datos para dropdowns, delegando al modelo
    public function obtenerEntregas() {
        return $this->model->obtenerEntregas();
    }

    public function obtenerIngresos() {
        return $this->model->obtenerIngresos();
    }

    public function obtenerTareas() {
        return $this->model->obtenerTareas();
    }

    public function obtenerEstados() {
        return $this->model->obtenerEstados();
    }
}
