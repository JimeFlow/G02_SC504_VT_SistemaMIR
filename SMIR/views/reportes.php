<?php
include_once __DIR__ . '/../controllers/ReporteController.php';
$controller = new ReporteController();

// Manejo de acciones
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['agregar'])) {
    $controller->agregarReporte($_POST['id_reporte'], $_POST['id_usuario'], $_POST['id_inventario'], $_POST['id_registro'], $_POST['estado_id'], $_POST['descripcion']);
    $mensaje = "<p class='text-success'>✅ Reporte agregado exitosamente.</p>";
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['actualizar'])) {
    $controller->actualizarReporte($_POST['id_reporte'], $_POST['id_usuario'], $_POST['id_inventario'], $_POST['id_registro'], $_POST['estado_id'], $_POST['descripcion']);
    $mensaje = "<p class='text-primary'>✅ Reporte actualizado correctamente.</p>";
    echo "<script>window.location = 'reportes.php';</script>";
}

if (isset($_GET['eliminar'])) {
    $controller->eliminarReporte($_GET['eliminar']);
    echo "<script>window.location = 'reportes.php';</script>";
}

if (isset($_GET['editar'])) {
    $editar = $controller->obtenerReportePorId($_GET['editar']);
}

// Para dropdowns
$usuarios = $controller->obtenerUsuarios();
$inventarios = $controller->obtenerInventarios();
$registros = $controller->obtenerRegistros();
$estados = $controller->obtenerEstados();
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Reportes</title>
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

    <h2>Agregar Reporte</h2>
    <form method="POST" class="mb-4">
        <div class="row g-3">
            <div class="col-md-4 d-none">
                <label for="id_reporte" class="form-label">ID Reporte</label>
                <input type="text" class="form-control" id="id_reporte" name="id_reporte" />
            </div>
            <div class="col-md-4">
                <label for="id_usuario" class="form-label">Usuario</label>
                <select class="form-select" id="id_usuario" name="id_usuario" required>
                    <?php foreach ($usuarios as $u) echo "<option value='{$u['ID_USUARIO']}'>{$u['ID_USUARIO']}</option>"; ?>
                </select>
            </div>
            <div class="col-md-4">
                <label for="id_inventario" class="form-label">Inventario</label>
                <select class="form-select" id="id_inventario" name="id_inventario" required>
                    <?php foreach ($inventarios as $i) echo "<option value='{$i['ID_INVENTARIO']}'>{$i['ID_INVENTARIO']}</option>"; ?>
                </select>
            </div>
            <div class="col-md-4">
                <label for="id_registro" class="form-label">Registro Diario</label>
                <select class="form-select" id="id_registro" name="id_registro" required>
                    <?php foreach ($registros as $r) echo "<option value='{$r['ID_REGISTRO']}'>{$r['ID_REGISTRO']}</option>"; ?>
                </select>
            </div>
            <div class="col-md-4">
                <label for="estado_id" class="form-label">Estado</label>
                <select class="form-select" id="estado_id" name="estado_id" required>
                    <?php foreach ($estados as $e) echo "<option value='{$e['ESTADO_ID']}'>{$e['DESCRIPCION']}</option>"; ?>
                </select>
            </div>
            <div class="col-md-4">
                <label for="descripcion" class="form-label">Descripción</label>
                <input type="text" class="form-control" id="descripcion" name="descripcion" required />
            </div>
        </div>
        <button type="submit" name="agregar" class="btn btn-primary mt-3">Agregar</button>
    </form>

    <?php if (isset($editar)) { ?>
    <h2>Editar Reporte</h2>
    <form method="POST" class="mb-4">
        <input type="hidden" name="id_reporte" value="<?= $editar['ID_REPORTE'] ?>" />
        <div class="row g-3">
            <div class="col-md-4">
                <label for="id_usuario_edit" class="form-label">Usuario</label>
                <select class="form-select" id="id_usuario_edit" name="id_usuario" required>
                    <?php foreach ($usuarios as $u) {
                        $sel = $u['ID_USUARIO'] == $editar['ID_USUARIO'] ? 'selected' : '';
                        echo "<option value='{$u['ID_USUARIO']}' $sel>{$u['ID_USUARIO']}</option>";
                    } ?>
                </select>
            </div>
            <div class="col-md-4">
                <label for="id_inventario_edit" class="form-label">Inventario</label>
                <select class="form-select" id="id_inventario_edit" name="id_inventario" required>
                    <?php foreach ($inventarios as $i) {
                        $sel = $i['ID_INVENTARIO'] == $editar['ID_INVENTARIO'] ? 'selected' : '';
                        echo "<option value='{$i['ID_INVENTARIO']}' $sel>{$i['ID_INVENTARIO']}</option>";
                    } ?>
                </select>
            </div>
            <div class="col-md-4">
                <label for="id_registro_edit" class="form-label">Registro Diario</label>
                <select class="form-select" id="id_registro_edit" name="id_registro" required>
                    <?php foreach ($registros as $r) {
                        $sel = $r['ID_REGISTRO'] == $editar['ID_REGISTRO'] ? 'selected' : '';
                        echo "<option value='{$r['ID_REGISTRO']}' $sel>{$r['ID_REGISTRO']}</option>";
                    } ?>
                </select>
            </div>
            <div class="col-md-4">
                <label for="estado_id_edit" class="form-label">Estado</label>
                <select class="form-select" id="estado_id_edit" name="estado_id" required>
                    <?php foreach ($estados as $e) {
                        $sel = $e['ESTADO_ID'] == $editar['ESTADO_ID'] ? 'selected' : '';
                        echo "<option value='{$e['ESTADO_ID']}' $sel>{$e['DESCRIPCION']}</option>";
                    } ?>
                </select>
            </div>
            <div class="col-md-4">
                <label for="descripcion_edit" class="form-label">Descripción</label>
                <input type="text" class="form-control" id="descripcion_edit" name="descripcion" value="<?= $editar['DESCRIPCION'] ?>" required />
            </div>
        </div>
        <button type="submit" name="actualizar" class="btn btn-primary mt-3">Actualizar</button>
    </form>
    <?php } ?>

    <h2>Listado de Reportes</h2>
    <table class="table table-striped table-bordered">
        <thead class="table-primary">
            <tr>
                <th>ID</th><th>Usuario</th><th>Inventario</th><th>Registro</th><th>Estado</th><th>Descripción</th><th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <?php
            $reportes = $controller->listarReportes();
            foreach ($reportes as $r) {
                echo "<tr>
                    <td>{$r['ID_REPORTE']}</td>
                    <td>{$r['ID_USUARIO']}</td>
                    <td>{$r['ID_INVENTARIO']}</td>
                    <td>{$r['ID_REGISTRO']}</td>
                    <td>{$r['ESTADO_ID']}</td>
                    <td>{$r['DESCRIPCION']}</td>
                    <td>
                        <a href='?editar={$r['ID_REPORTE']}' class='btn btn-sm btn-warning me-1'>Editar</a>
                        <a href='?eliminar={$r['ID_REPORTE']}' class='btn btn-sm btn-danger' onclick='return confirm(\"¿Eliminar reporte?\")'>Eliminar</a>
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
