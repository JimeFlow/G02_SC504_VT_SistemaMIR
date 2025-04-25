<?php
include_once __DIR__ . '/../controllers/RegistrosController.php';

$controller = new RegistrosController();

// Cargar dropdowns
$entregas = $controller->obtenerEntregas();
$ingresos = $controller->obtenerIngresos();
$tareas = $controller->obtenerTareas();
$estados = $controller->obtenerEstados();

// Agregar nuevo registro
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['agregar'])) {
    $controller->agregarRegistro($_POST['id_registro'], $_POST['id_entrega'], $_POST['id_ingreso'], $_POST['id_tarea'], $_POST['estado_id']);
    $mensaje = "<p class='text-success'>✅ Registro agregado exitosamente.</p>";
}

// Eliminar registro
if (isset($_GET['eliminar'])) {
    $resultado = $controller->eliminarRegistro($_GET['eliminar']);
    if ($resultado === true) {
        $mensaje = "<p class='text-success'>✅ Registro eliminado correctamente.</p>";
    } else {
        $mensaje = "<pre class='text-danger'>❌ Error al eliminar: $resultado</pre>";
    }
    // No redirigir automáticamente para poder ver el error
}

// Obtener datos para editar
if (isset($_GET['editar'])) {
    $registroEditar = $controller->obtenerRegistroPorId($_GET['editar']);
}

// Actualizar registro
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['actualizar'])) {
    $controller->actualizarRegistro($_POST['id_registro'], $_POST['id_entrega'], $_POST['id_ingreso'], $_POST['id_tarea'], $_POST['estado_id']);
    $mensaje = "<p class='text-primary'>✅ Registro actualizado correctamente.</p>";
    echo "<script>window.location = 'registros.php';</script>";
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Registros</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary mb-4">
  <div class="container-fluid">
    <a class="navbar-brand" href="../index.php">📊 Dashboard de Gestión</a>
  </div>
</nav>

<div class="container">
    <?= $mensaje ?? '' ?>

    <h2>Agregar Registro Diario</h2>
    <form method="POST" class="mb-4">
        <div class="row g-3">
            <div class="col-md-4">
                <label for="id_registro" class="form-label">ID Registro</label>
                <input type="text" class="form-control" id="id_registro" name="id_registro" required />
            </div>
            <div class="col-md-4">
                <label for="id_entrega" class="form-label">Entrega</label>
                <select class="form-select" id="id_entrega" name="id_entrega" required>
                    <?php foreach ($entregas as $e) echo "<option value='{$e['ID_ENTREGA']}'>{$e['ID_ENTREGA']}</option>"; ?>
                </select>
            </div>
            <div class="col-md-4">
                <label for="id_ingreso" class="form-label">Ingreso</label>
                <select class="form-select" id="id_ingreso" name="id_ingreso" required>
                    <?php foreach ($ingresos as $i) echo "<option value='{$i['ID_INGRESO']}'>{$i['ID_INGRESO']}</option>"; ?>
                </select>
            </div>
            <div class="col-md-4">
                <label for="id_tarea" class="form-label">Tarea</label>
                <select class="form-select" id="id_tarea" name="id_tarea" required>
                    <?php foreach ($tareas as $t) echo "<option value='{$t['ID_TAREA']}'>{$t['ID_TAREA']}</option>"; ?>
                </select>
            </div>
            <div class="col-md-4">
                <label for="estado_id" class="form-label">Estado</label>
                <select class="form-select" id="estado_id" name="estado_id" required>
                    <?php foreach ($estados as $es) echo "<option value='{$es['ESTADO_ID']}'>{$es['DESCRIPCION']}</option>"; ?>
                </select>
            </div>
        </div>
        <button type="submit" name="agregar" class="btn btn-primary mt-3">Agregar</button>
    </form>

    <?php if (isset($registroEditar)) { ?>
    <h2>Editar Registro Diario</h2>
    <form method="POST" class="mb-4">
        <input type="hidden" name="id_registro" value="<?= $registroEditar['ID_REGISTRO'] ?>" />
        <div class="row g-3">
            <div class="col-md-4">
                <label for="id_entrega_edit" class="form-label">Entrega</label>
                <select class="form-select" id="id_entrega_edit" name="id_entrega" required>
                    <?php foreach ($entregas as $e) {
                        $selected = $registroEditar['ID_ENTREGA'] == $e['ID_ENTREGA'] ? 'selected' : '';
                        echo "<option value='{$e['ID_ENTREGA']}' $selected>{$e['ID_ENTREGA']}</option>";
                    } ?>
                </select>
            </div>
            <div class="col-md-4">
                <label for="id_ingreso_edit" class="form-label">Ingreso</label>
                <select class="form-select" id="id_ingreso_edit" name="id_ingreso" required>
                    <?php foreach ($ingresos as $i) {
                        $selected = $registroEditar['ID_INGRESO'] == $i['ID_INGRESO'] ? 'selected' : '';
                        echo "<option value='{$i['ID_INGRESO']}' $selected>{$i['ID_INGRESO']}</option>";
                    } ?>
                </select>
            </div>
            <div class="col-md-4">
                <label for="id_tarea_edit" class="form-label">Tarea</label>
                <select class="form-select" id="id_tarea_edit" name="id_tarea" required>
                    <?php foreach ($tareas as $t) {
                        $selected = $registroEditar['ID_TAREA'] == $t['ID_TAREA'] ? 'selected' : '';
                        echo "<option value='{$t['ID_TAREA']}' $selected>{$t['ID_TAREA']}</option>";
                    } ?>
                </select>
            </div>
            <div class="col-md-4">
                <label for="estado_id_edit" class="form-label">Estado</label>
                <select class="form-select" id="estado_id_edit" name="estado_id" required>
                    <?php foreach ($estados as $es) {
                        $selected = $registroEditar['ESTADO_ID'] == $es['ESTADO_ID'] ? 'selected' : '';
                        echo "<option value='{$es['ESTADO_ID']}' $selected>{$es['DESCRIPCION']}</option>";
                    } ?>
                </select>
            </div>
        </div>
        <button type="submit" name="actualizar" class="btn btn-primary mt-3">Actualizar</button>
    </form>
    <?php } ?>

    <h2>Listado de Registros Diarios</h2>
    <table class="table table-striped table-bordered">
        <thead class="table-primary">
            <tr>
                <th>ID</th>
                <th>Entrega</th>
                <th>Ingreso</th>
                <th>Tarea</th>
                <th>Estado</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <?php
            $registros = $controller->listarRegistros();
            foreach ($registros as $r) {
                echo "<tr>
                    <td>{$r['ID_REGISTRO']}</td>
                    <td>{$r['ID_ENTREGA']}</td>
                    <td>{$r['ID_INGRESO']}</td>
                    <td>{$r['ID_TAREA']}</td>
                    <td>{$r['ESTADO_ID']}</td>
                    <td>
                        <a href='?editar={$r['ID_REGISTRO']}' class='btn btn-sm btn-warning me-1'>Editar</a>
                        <a href='?eliminar={$r['ID_REGISTRO']}' class='btn btn-sm btn-danger' onclick='return confirm(\"¿Eliminar este registro?\")'>Eliminar</a>
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
