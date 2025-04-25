<?php
include_once __DIR__ . '/../controllers/PersonalController.php';

$controller = new PersonalController();

$mensaje = ''; 

// Agregar nuevo empleado
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['agregar'])) {
    $controller->agregarEmpleado(
        $_POST['id_personal'], $_POST['id_rol'], null, $_POST['horario_id'],
        $_POST['estado_id'], $_POST['tipo_personal'], $_POST['nombre'], $_POST['apellidos'],
        $_POST['datos_contacto'], $_POST['linea_trabajo'], $_POST['id_usuario'] ?: null, null
    );
    $mensaje = "<p class='text-success'>✅ Empleado agregado exitosamente.</p>";
}

// Eliminar (lógico) un empleado
if (isset($_GET['eliminar'])) {
    $resultado = $controller->eliminarEmpleado($_GET['eliminar']);
    if ($resultado) {
        $mensaje = "<p class='text-success'>✅ Empleado marcado como inactivo correctamente.</p>";
    } else {
        $mensaje = "<p class='text-danger'>❌ No se pudo marcar el empleado como inactivo.</p>";
    }
}

// Obtener datos para edición
if (isset($_GET['editar'])) {
    $editar = $controller->obtenerEmpleadoPorId($_GET['editar']);
}

// Actualizar empleado
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['actualizar'])) {
    $controller->actualizarEmpleado(
        $_POST['id_personal'], $_POST['id_rol'], null, $_POST['horario_id'],
        $_POST['estado_id'], $_POST['tipo_personal'], $_POST['nombre'], $_POST['apellidos'],
        $_POST['datos_contacto'], $_POST['linea_trabajo'], $_POST['id_usuario'] ?: null, null
    );
    $mensaje = "<p class='text-primary'>✅ Empleado actualizado correctamente.</p>";
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Empleados</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary mb-4">
  <div class="container-fluid">
    <a class="navbar-brand" href="../index.php">📊 Dashboard de Gestión</a>
  </div>
</nav>

<div class="container">
    <?= $mensaje ?>

    <h2>Agregar Empleado</h2>
    <form method="POST" class="mb-4">
        <div class="row g-3">
            <div class="col-md-4">
                <label for="id_personal" class="form-label">ID</label>
                <input type="text" class="form-control" id="id_personal" name="id_personal" required />
            </div>
            <div class="col-md-4">
                <label for="id_rol" class="form-label">Rol ID</label>
                <input type="text" class="form-control" id="id_rol" name="id_rol" required />
            </div>
            <div class="col-md-4">
                <label for="horario_id" class="form-label">Horario ID</label>
                <input type="text" class="form-control" id="horario_id" name="horario_id" required />
            </div>
            <div class="col-md-4">
                <label for="estado_id" class="form-label">Estado ID</label>
                <input type="text" class="form-control" id="estado_id" name="estado_id" required />
            </div>
            <div class="col-md-4">
                <label for="tipo_personal" class="form-label">Tipo</label>
                <input type="text" class="form-control" id="tipo_personal" name="tipo_personal" required />
            </div>
            <div class="col-md-4">
                <label for="nombre" class="form-label">Nombre</label>
                <input type="text" class="form-control" id="nombre" name="nombre" required />
            </div>
            <div class="col-md-4">
                <label for="apellidos" class="form-label">Apellidos</label>
                <input type="text" class="form-control" id="apellidos" name="apellidos" required />
            </div>
            <div class="col-md-4">
                <label for="datos_contacto" class="form-label">Contacto</label>
                <input type="text" class="form-control" id="datos_contacto" name="datos_contacto" required />
            </div>
            <div class="col-md-4">
                <label for="linea_trabajo" class="form-label">Línea de Trabajo</label>
                <input type="text" class="form-control" id="linea_trabajo" name="linea_trabajo" required />
            </div>
            <div class="col-md-4">
                <label for="id_usuario" class="form-label">ID Usuario</label>
                <input type="text" class="form-control" id="id_usuario" name="id_usuario" />
            </div>
        </div>
        <button type="submit" name="agregar" class="btn btn-primary mt-3">Agregar</button>
    </form>

    <?php if (isset($editar)) { ?>
    <h2>Editar Empleado</h2>
    <form method="POST" class="mb-4">
        <input type="hidden" name="id_personal" value="<?= $editar['ID_PERSONAL'] ?>" />
        <div class="row g-3">
            <div class="col-md-4">
                <label for="id_rol_edit" class="form-label">Rol ID</label>
                <input type="text" class="form-control" id="id_rol_edit" name="id_rol" value="<?= $editar['ID_ROL'] ?>" />
            </div>
            <div class="col-md-4">
                <label for="horario_id_edit" class="form-label">Horario ID</label>
                <input type="text" class="form-control" id="horario_id_edit" name="horario_id" value="<?= $editar['HORARIO_ID'] ?>" />
            </div>
            <div class="col-md-4">
                <label for="estado_id_edit" class="form-label">Estado ID</label>
                <input type="text" class="form-control" id="estado_id_edit" name="estado_id" value="<?= $editar['ESTADO_ID'] ?>" />
            </div>
            <div class="col-md-4">
                <label for="tipo_personal_edit" class="form-label">Tipo</label>
                <input type="text" class="form-control" id="tipo_personal_edit" name="tipo_personal" value="<?= $editar['TIPO_PERSONAL'] ?>" />
            </div>
            <div class="col-md-4">
                <label for="nombre_edit" class="form-label">Nombre</label>
                <input type="text" class="form-control" id="nombre_edit" name="nombre" value="<?= $editar['NOMBRE'] ?>" />
            </div>
            <div class="col-md-4">
                <label for="apellidos_edit" class="form-label">Apellidos</label>
                <input type="text" class="form-control" id="apellidos_edit" name="apellidos" value="<?= $editar['APELLIDOS'] ?>" />
            </div>
            <div class="col-md-4">
                <label for="datos_contacto_edit" class="form-label">Contacto</label>
                <input type="text" class="form-control" id="datos_contacto_edit" name="datos_contacto" value="<?= $editar['DATOS_CONTACTO'] ?>" />
            </div>
            <div class="col-md-4">
                <label for="linea_trabajo_edit" class="form-label">Línea de Trabajo</label>
                <input type="text" class="form-control" id="linea_trabajo_edit" name="linea_trabajo" value="<?= $editar['LINEA_TRABAJO'] ?>" />
            </div>
            <div class="col-md-4">
                <label for="id_usuario_edit" class="form-label">ID Usuario</label>
                <input type="text" class="form-control" id="id_usuario_edit" name="id_usuario" value="<?= $editar['ID_USUARIO'] ?>" />
            </div>
        </div>
        <button type="submit" name="actualizar" class="btn btn-primary mt-3">Actualizar</button>
    </form>
    <?php } ?>

    <h2>Listado de Empleados</h2>
    <table class="table table-striped table-bordered">
        <thead class="table-primary">
            <tr>
                <th>ID</th>
                <th>Nombre</th>
                <th>Apellidos</th>
                <th>Tipo</th>
                <th>Contacto</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <?php
            $empleados = $controller->listarEmpleados();
            foreach ($empleados as $emp) {
                echo "<tr>
                    <td>{$emp['ID_PERSONAL']}</td>
                    <td>{$emp['NOMBRE']}</td>
                    <td>{$emp['APELLIDOS']}</td>
                    <td>{$emp['TIPO_PERSONAL']}</td>
                    <td>{$emp['DATOS_CONTACTO']}</td>
                    <td>
                        <a href='?editar={$emp['ID_PERSONAL']}' class='btn btn-sm btn-warning me-1'>Editar</a>
                        <a href='?eliminar={$emp['ID_PERSONAL']}' class='btn btn-sm btn-danger' onclick='return confirm(\"¿Seguro que quieres marcar como inactivo este empleado?\")'>Eliminar</a>
                    </td>
                </tr>";
            }
            ?>
        </tbody>
    </table>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
