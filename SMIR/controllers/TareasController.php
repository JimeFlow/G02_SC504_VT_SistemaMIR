<?php
// Incluir el modelo TareasModel para manejar la lógica de datos
include_once __DIR__ . '/../models/TareasModel.php';

// Definición de la clase TareasController para manejar la lógica de negocio relacionada con tareas
class TareasController {
    private $model;

    // Constructor que instancia el modelo TareasModel
    public function __construct() {
        $this->model = new TareasModel();
    }

    // Método para agregar una nueva tarea, delegando al modelo
    public function agregarTarea($id, $nombre, $descripcion, $estado, $fechaRecibido) {
        if (empty($id)) {
            $id = $this->model->obtenerNuevoIdTarea();
        }
        return $this->model->insertarTarea($id, $nombre, $descripcion, $estado, $fechaRecibido);
    }

    // Método para listar todas las tareas, delegando al modelo
    public function listarTareas() {
        return $this->model->listarTareas();
    }

    // Método para eliminar una tarea, delegando al modelo
    public function eliminarTarea($id) {
        return $this->model->eliminarTarea($id);
    }

    // Método para obtener una tarea por su ID, delegando al modelo
    public function obtenerTareaPorId($id) {
        return $this->model->obtenerTareaPorId($id);
    }

    // Método para actualizar una tarea, delegando al modelo
    public function actualizarTarea($id, $nombre, $descripcion, $estado, $fechaRecibido) {
        return $this->model->actualizarTarea($id, $nombre, $descripcion, $estado, $fechaRecibido);
    }
}
?>
