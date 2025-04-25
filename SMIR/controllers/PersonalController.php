<?php
// Incluir el modelo PersonalModel para manejar la lógica de datos
include_once __DIR__ . '/../models/PersonalModel.php';

// Definición de la clase PersonalController para manejar la lógica de negocio relacionada con personal
class PersonalController {
    private $model;

    // Constructor que instancia el modelo PersonalModel
    public function __construct() {
        $this->model = new PersonalModel();
    }

    // Método para agregar un nuevo empleado, delegando al modelo
    public function agregarEmpleado($idPersonal, $idRol, $idEntrega, $horarioId, $estadoId, $tipo, $nombre, $apellidos, $contacto, $linea, $idUsuario, $upi) {
        return $this->model->insertarEmpleado($idPersonal, $idRol, $idEntrega, $horarioId, $estadoId, $tipo, $nombre, $apellidos, $contacto, $linea, $idUsuario, $upi);
    }

    // Método para listar empleados activos, delegando al modelo
    public function listarEmpleados() {
        return $this->model->listarEmpleados();
    }

    // Método para eliminar un empleado, delegando al modelo
    public function eliminarEmpleado($id) {
        return $this->model->eliminarEmpleado($id);
    }

    // Método para obtener un empleado por su ID, delegando al modelo
    public function obtenerEmpleadoPorId($id) {
        return $this->model->obtenerEmpleadoPorId($id);
    }

    // Método para actualizar un empleado, delegando al modelo
    public function actualizarEmpleado($idPersonal, $idRol, $idEntrega, $horarioId, $estadoId, $tipo, $nombre, $apellidos, $contacto, $linea, $idUsuario, $upi) {
        return $this->model->actualizarEmpleado($idPersonal, $idRol, $idEntrega, $horarioId, $estadoId, $tipo, $nombre, $apellidos, $contacto, $linea, $idUsuario, $upi);
    }
}
