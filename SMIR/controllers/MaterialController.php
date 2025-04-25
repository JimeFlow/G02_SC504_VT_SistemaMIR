<?php
// Incluir el modelo MaterialModel para manejar la lógica de datos
include_once __DIR__ . '/../models/MaterialModel.php';

// Definición de la clase MaterialController para manejar la lógica de negocio relacionada con materiales
class MaterialController {
    private $model;

    // Constructor que instancia el modelo MaterialModel
    public function __construct() {
        $this->model = new MaterialModel();
    }

    // Método para agregar un nuevo material, delegando al modelo
    public function agregarMaterial($id, $estadoId, $nombre, $fecha, $disponible, $solicitada) {
        if ($id === null || $id === '') {
            $id = $this->model->getNextMaterialId();
        }
        return $this->model->insertarMaterial($id, $estadoId, $nombre, $fecha, $disponible, $solicitada);
    }

    // Método para listar todos los materiales, delegando al modelo
    public function listarMateriales() {
        return $this->model->obtenerMateriales();
    }

    // Método para eliminar un material, delegando al modelo
    public function eliminarMaterial($id) {
        return $this->model->eliminarMaterial($id);
    }

    // Método para obtener un material por su ID, delegando al modelo
    public function obtenerMaterialPorId($id) {
        return $this->model->obtenerMaterialPorId($id);
    }

    // Método para actualizar un material, delegando al modelo
    public function actualizarMaterial($id, $estadoId, $nombre, $fecha, $disponible, $solicitada) {
        return $this->model->actualizarMaterial($id, $estadoId, $nombre, $fecha, $disponible, $solicitada);
    }

    // Método para obtener todos los estados
    public function listarEstados() {
        return $this->model->getEstados();
    }
}
?>
