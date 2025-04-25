<?php
include_once __DIR__ . '/../controllers/EntregasController.php';

$controller = new EntregasController();

// Obtener listas para dropdowns
$materiales = $controller->obtenerMateriales();
$datosEntregas = $controller->obtenerDatosEntregas();
$estados = $controller->obtenerEstados();

// Agregar entrega
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['agregar'])) {
    $resultado = $controller->agregarEntrega(
        $_POST['id_entrega'], $_POST['id_material'], $_POST['dato_entrega_id'],
        $_POST['estado_id'], $_POST['destinatario'], $_POST['cantidad_restante']
    );

    $mensaje = $resultado ? "<p class='text-success'>Entrega agregada correctamente.</p>" : "<p class='text-danger'>Error al agregar entrega.</p>";
}

// Eliminar entrega
if (isset($_GET['eliminar'])) {
    $resultado = $controller->eliminarEntrega($_GET['eliminar']);
    if ($resultado) {
        $mensaje = "<p class='text-success'>Entrega eliminada correctamente.</p>";
    } else {
        $mensaje = "<p class='text-danger'>❌ Error al eliminar la entrega.</p>";
    }
}

// Obtener datos para edición
if (isset($_GET['editar'])) {
    $editar = $controller->obtenerEntregaPorId($_GET['editar']);
}

// Actualizar entrega
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['actualizar'])) {
    $resultado = $controller->actualizarEntrega(
        $_POST['id_entrega'], $_POST['id_material'], $_POST['dato_entrega_id'],
        $_POST['estado_id'], $_POST['destinatario'], $_POST['cantidad_restante']
    );

    $mensaje = $resultado ? "<p class='text-primary'>Entrega actualizada correctamente.</p>" : "<p class='text-danger'>Error al actualizar entrega.</p>";
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Entregas</title>
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

    <h2>Agregar Entrega</h2>
    <form method="POST" class="mb-4">
        <div class="row g-3">
            <div class="col-md-4 d-none">
                <label for="id_entrega" class="form-label">ID Entrega</label>
                <input type="text" class="form-control" id="id_entrega" name="id_entrega" />
            </div>
            <div class="col-md-4">
                <label for="id_material" class="form-label">Material</label>
                <select class="form-select" id="id_material" name="id_material" required>
                    <option value="" disabled selected>Seleccione un material</option>
                    <?php foreach ($materiales as $material): ?>
                        <option value="<?= $material['ID_MATERIAL'] ?>"><?= htmlspecialchars($material['NOMBRE']) ?></option>
                    <?php endforeach; ?>
                </select>
            </div>
            <div class="col-md-4">
                <label for="dato_entrega_id" class="form-label">Dato Entrega</label>
                <select class="form-select" id="dato_entrega_id" name="dato_entrega_id" required>
                    <option value="" disabled selected>Seleccione un dato de entrega</option>
                    <?php foreach ($datosEntregas as $dato): ?>
                        <option value="<?= $dato['DATO_ENTREGA_ID'] ?>"><?= htmlspecialchars($dato['FECHA']) ?></option>
                    <?php endforeach; ?>
                </select>
            </div>
            <div class="col-md-4">
                <label for="estado_id" class="form-label">Estado</label>
                <select class="form-select" id="estado_id" name="estado_id" required>
                    <option value="" disabled selected>Seleccione un estado</option>
                    <?php foreach ($estados as $estado): ?>
                        <option value="<?= $estado['ESTADO_ID'] ?>"><?= htmlspecialchars($estado['DESCRIPCION']) ?></option>
                    <?php endforeach; ?>
                </select>
            </div>
            <div class="col-md-4">
                <label for="destinatario" class="form-label">Destinatario</label>
                <input type="text" class="form-control" id="destinatario" name="destinatario" required />
            </div>
            <div class="col-md-4">
                <label for="cantidad_restante" class="form-label">Cantidad Restante</label>
                <input type="text" class="form-control" id="cantidad_restante" name="cantidad_restante" required />
            </div>
        </div>
        <button type="submit" name="agregar" class="btn btn-primary mt-3">Agregar</button>
    </form>

    <?php if (isset($editar)) { ?>
    <h2>Editar Entrega</h2>
    <form method="POST" class="mb-4">
        <input type="hidden" name="id_entrega" value="<?= $editar['ID_ENTREGA'] ?>" />
        <div class="row g-3">
            <div class="col-md-4">
                <label for="id_material_edit" class="form-label">Material</label>
                <select class="form-select" id="id_material_edit" name="id_material" required>
                    <option value="" disabled>Seleccione un material</option>
                    <?php foreach ($materiales as $material): ?>
                        <option value="<?= $material['ID_MATERIAL'] ?>" <?= $material['ID_MATERIAL'] == $editar['ID_MATERIAL'] ? 'selected' : '' ?>>
                            <?= htmlspecialchars($material['NOMBRE']) ?>
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>
            <div class="col-md-4">
                <label for="dato_entrega_id_edit" class="form-label">Dato Entrega</label>
                <select class="form-select" id="dato_entrega_id_edit" name="dato_entrega_id" required>
                    <option value="" disabled>Seleccione un dato de entrega</option>
                    <?php foreach ($datosEntregas as $dato): ?>
                        <option value="<?= $dato['DATO_ENTREGA_ID'] ?>" <?= $dato['DATO_ENTREGA_ID'] == $editar['DATO_ENTREGA_ID'] ? 'selected' : '' ?>>
                            <?= htmlspecialchars($dato['FECHA']) ?>
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>
            <div class="col-md-4">
                <label for="estado_id_edit" class="form-label">Estado</label>
                <select class="form-select" id="estado_id_edit" name="estado_id" required>
                    <option value="" disabled>Seleccione un estado</option>
                    <?php foreach ($estados as $estado): ?>
                        <option value="<?= $estado['ESTADO_ID'] ?>" <?= $estado['ESTADO_ID'] == $editar['ESTADO_ID'] ? 'selected' : '' ?>>
                            <?= htmlspecialchars($estado['DESCRIPCION']) ?>
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>
            <div class="col-md-4">
                <label for="destinatario_edit" class="form-label">Destinatario</label>
                <input type="text" class="form-control" id="destinatario_edit" name="destinatario" value="<?= $editar['DESTINATARIO'] ?>" required />
            </div>
            <div class="col-md-4">
                <label for="cantidad_restante_edit" class="form-label">Cantidad Restante</label>
                <input type="text" class="form-control" id="cantidad_restante_edit" name="cantidad_restante" value="<?= $editar['CANTIDAD_RESTANTE'] ?>" required />
            </div>
        </div>
        <button type="submit" name="actualizar" class="btn btn-primary mt-3">Actualizar</button>
    </form>
    <?php } ?>

    <h2>Entregas Registradas</h2>
    <table class="table table-striped table-bordered">
        <thead class="table-primary">
            <tr>
                <th>ID Entrega</th>
                <th>ID Material</th>
                <th>Dato Entrega ID</th>
                <th>Estado ID</th>
                <th>Destinatario</th>
                <th>Cantidad Restante</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <?php
            $entregas = $controller->listarEntregas();
            foreach ($entregas as $entrega) {
                echo "<tr>
                    <td>{$entrega['ID_ENTREGA']}</td>
                    <td>{$entrega['ID_MATERIAL']}</td>
                    <td>{$entrega['DATO_ENTREGA_ID']}</td>
                    <td>{$entrega['ESTADO_ID']}</td>
                    <td>{$entrega['DESTINATARIO']}</td>
                    <td>{$entrega['CANTIDAD_RESTANTE']}</td>
                    <td>
                        <a href='?editar={$entrega['ID_ENTREGA']}' class='btn btn-sm btn-warning me-1'>Editar</a>
                        <a href='?eliminar={$entrega['ID_ENTREGA']}' class='btn btn-sm btn-danger' onclick='return confirm(\"¿Eliminar esta entrega?\")'>Eliminar</a>
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
