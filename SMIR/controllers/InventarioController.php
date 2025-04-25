<?php
// Incluir el modelo InventarioModel para manejar la lógica de datos
include_once __DIR__ . '/../models/InventarioModel.php';

// Definición de la clase InventarioController para manejar la lógica de negocio relacionada con inventario
class InventarioController {
    private $model;
    private $personalController;
    private $materialController;
    private $registrosController;

    // Constructor que instancia el modelo InventarioModel y otros controladores
    public function __construct() {
        $this->model = new InventarioModel();
        include_once __DIR__ . '/PersonalController.php';
        include_once __DIR__ . '/MaterialController.php';
        include_once __DIR__ . '/RegistrosController.php';
        $this->personalController = new PersonalController();
        $this->materialController = new MaterialController();
        $this->registrosController = new RegistrosController();
    }

    // Método para generar alertas de stock bajo delegando al modelo
    public function generarAlertasStock() {
        return $this->model->generarAlertasStock();
    }

    // Método para obtener lista de empleados (usuarios)
    public function listarEmpleados() {
        return $this->personalController->listarEmpleados();
    }

    // Método para obtener lista de materiales
    public function listarMateriales() {
        return $this->materialController->listarMateriales();
    }

    // Método para obtener lista de estados
    public function listarEstados() {
        return $this->registrosController->obtenerEstados();
    }

    // Método para obtener inventarios con alertas de stock bajo
    public function obtenerInventariosConAlertaBajoStock() {
        return $this->model->obtenerInventariosConAlertaBajoStock();
    }

    // Método para agregar un nuevo registro de inventario, delegando al modelo
    public function agregarInventario($idInventario, $idUsuario, $upi, $idMaterial, $estadoId, $fecha, $alerta) {
        return $this->model->insertarInventario($idInventario, $idUsuario, $upi, $idMaterial, $estadoId, $fecha, $alerta);
    }

    // Método para eliminar un registro de inventario, delegando al modelo
    public function eliminarInventario($id) {
        include_once __DIR__ . '/../models/InventarioModel.php';
        $model = new InventarioModel();
        return $model->desactivarInventario($id);
    }
    
    // Método para obtener un registro de inventario por su ID, delegando al modelo
    public function obtenerInventarioPorId($id) {
        include_once __DIR__ . '/../models/InventarioModel.php';
        $model = new InventarioModel();
        return $model->obtenerInventarioPorId($id);
    }
    
    // Método para actualizar un registro de inventario, delegando al modelo
    public function actualizarInventario($idInventario, $idUsuario, $upi, $idMaterial, $estadoId, $fecha, $alerta) {
        include_once __DIR__ . '/../models/InventarioModel.php';
        $model = new InventarioModel();
        return $model->actualizarInventario($idInventario, $idUsuario, $upi, $idMaterial, $estadoId, $fecha, $alerta);
    }
    
    // Método para listar todos los registros de inventario, delegando al modelo
    public function listarInventario() {
        return $this->model->listarInventario();
    }
}
?>
