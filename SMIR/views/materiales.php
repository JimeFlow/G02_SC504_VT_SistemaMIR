<?php
include_once __DIR__ . '/../controllers/MaterialController.php';

$controller = new MaterialController();

// Agregar material
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['agregar'])) {
    $idMaterial = $_POST['id_material'];
    $estadoId = $_POST['estado_id'];
    $nombre = $_POST['nombre'];
    $fechaVencimiento = $_POST['fecha_vencimiento'];
    $cantidadDisponible = $_POST['cantidad_disponible'];
    $cantidadSolicitada = $_POST['cantidad_solicitada'];

    if ($controller->agregarMaterial($idMaterial, $estadoId, $nombre, $fechaVencimiento, $cantidadDisponible, $cantidadSolicitada)) {
        $mensaje = "<p class='text-success'>✔️ Material agregado exitosamente.</p>";
    } else {
        $mensaje = "<p class='text-danger'>❌ Error al agregar material.</p>";
    }
}

// Eliminar material
if (isset($_GET['eliminar'])) {
    $controller->eliminarMaterial($_GET['eliminar']);
    echo "<script>window.location = 'materiales.php';</script>";
}

// Obtener datos para edición
if (isset($_GET['editar'])) {
    $datosEditar = $controller->obtenerMaterialPorId($_GET['editar']);
}

// Actualizar material
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['actualizar'])) {
    $idMaterial = $_POST['id_material'];
    $estadoId = $_POST['estado_id'];
    $nombre = $_POST['nombre'];
    $fechaVencimiento = $_POST['fecha_vencimiento'];
    $cantidadDisponible = $_POST['cantidad_disponible'];
    $cantidadSolicitada = $_POST['cantidad_solicitada'];

    if ($controller->actualizarMaterial($idMaterial, $estadoId, $nombre, $fechaVencimiento, $cantidadDisponible, $cantidadSolicitada)) {
        $mensaje = "<p class='text-primary'>✔️ Material actualizado correctamente.</p>";
    } else {
        $mensaje = "<p class='text-danger'>❌ Error al actualizar material.</p>";
    }

    echo "<script>window.location = 'materiales.php';</script>";
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Materiales</title>
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

    <h2>Agregar Material</h2>
    <form method="POST" class="mb-4">
        <div class="row g-3">
            <div class="col-md-4">
                <label for="id_material" class="form-label">ID Material</label>
                <input type="text" class="form-control" id="id_material" name="id_material" required />
            </div>
            <div class="col-md-4">
                <label for="estado_id" class="form-label">Estado ID</label>
                <input type="text" class="form-control" id="estado_id" name="estado_id" required />
            </div>
            <div class="col-md-4">
                <label for="nombre" class="form-label">Nombre</label>
                <input type="text" class="form-control" id="nombre" name="nombre" required />
            </div>
            <div class="col-md-4">
                <label for="fecha_vencimiento" class="form-label">Fecha Vencimiento</label>
                <input type="date" class="form-control" id="fecha_vencimiento" name="fecha_vencimiento" required />
            </div>
            <div class="col-md-4">
                <label for="cantidad_disponible" class="form-label">Cantidad Disponible</label>
                <input type="text" class="form-control" id="cantidad_disponible" name="cantidad_disponible" required />
            </div>
            <div class="col-md-4">
                <label for="cantidad_solicitada" class="form-label">Cantidad Solicitada</label>
                <input type="text" class="form-control" id="cantidad_solicitada" name="cantidad_solicitada" required />
            </div>
        </div>
        <button type="submit" name="agregar" class="btn btn-primary mt-3">Agregar</button>
    </form>

    <?php if (isset($datosEditar)) { ?>
    <h2>Editar Material</h2>
    <form method="POST" class="mb-4">
        <input type="hidden" name="id_material" value="<?= $datosEditar['ID_MATERIAL'] ?>" />
        <div class="row g-3">
            <div class="col-md-4">
                <label for="estado_id_edit" class="form-label">Estado ID</label>
                <input type="text" class="form-control" id="estado_id_edit" name="estado_id" value="<?= $datosEditar['ESTADO_ID'] ?>" required />
            </div>
            <div class="col-md-4">
                <label for="nombre_edit" class="form-label">Nombre</label>
                <input type="text" class="form-control" id="nombre_edit" name="nombre" value="<?= $datosEditar['NOMBRE'] ?>" required />
            </div>
            <div class="col-md-4">
                <label for="fecha_vencimiento_edit" class="form-label">Fecha Vencimiento</label>
                <input type="date" class="form-control" id="fecha_vencimiento_edit" name="fecha_vencimiento" value="<?= date('Y-m-d', strtotime($datosEditar['FECHA_VENCIMIENTO'])) ?>" required />
            </div>
            <div class="col-md-4">
                <label for="cantidad_disponible_edit" class="form-label">Cantidad Disponible</label>
                <input type="text" class="form-control" id="cantidad_disponible_edit" name="cantidad_disponible" value="<?= $datosEditar['CANTIDAD_DISPONIBLE'] ?>" required />
            </div>
            <div class="col-md-4">
                <label for="cantidad_solicitada_edit" class="form-label">Cantidad Solicitada</label>
                <input type="text" class="form-control" id="cantidad_solicitada_edit" name="cantidad_solicitada" value="<?= $datosEditar['CANTIDAD_SOLICITADA'] ?>" required />
            </div>
        </div>
        <button type="submit" name="actualizar" class="btn btn-primary mt-3">Actualizar</button>
    </form>
    <?php } ?>

    <h2>Listado de Materiales</h2>
    <table class="table table-striped table-bordered">
        <thead class="table-primary">
            <tr>
                <th>ID</th>
                <th>Estado</th>
                <th>Nombre</th>
                <th>Fecha Vencimiento</th>
                <th>Cantidad Disponible</th>
                <th>Cantidad Solicitada</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <?php
            $materiales = $controller->listarMateriales();
            foreach ($materiales as $material) {
                echo "<tr>
                    <td>{$material['ID_MATERIAL']}</td>
                    <td>{$material['ESTADO_ID']}</td>
                    <td>{$material['NOMBRE']}</td>
                    <td>{$material['FECHA_VENCIMIENTO']}</td>
                    <td>{$material['CANTIDAD_DISPONIBLE']}</td>
                    <td>{$material['CANTIDAD_SOLICITADA']}</td>
                    <td>
                        <a href='?editar={$material['ID_MATERIAL']}' class='btn btn-sm btn-warning me-1'>Editar</a>
                        <a href='?eliminar={$material['ID_MATERIAL']}' class='btn btn-sm btn-danger' onclick='return confirm(\"¿Eliminar este material?\")'>Eliminar</a>
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
