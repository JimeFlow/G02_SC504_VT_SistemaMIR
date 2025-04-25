<?php
include_once __DIR__ . '/../controllers/InventarioController.php';

$controller = new InventarioController();

// Obtener listas para dropdowns
$empleados = $controller->listarEmpleados();
$materiales = $controller->listarMateriales();
$estados = $controller->listarEstados();

// Extraer UPIs únicos de empleados para dropdown UPI
$upis = [];
foreach ($empleados as $emp) {
    if (!in_array($emp['UPI'], $upis)) {
        $upis[] = $emp['UPI'];
    }
}

// Generar alertas de stock bajo
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['generar_alertas'])) {
    if ($controller->generarAlertasStock()) {
        $mensaje = "<p class='text-success'>Alertas de stock generadas correctamente.</p>";
    } else {
        $mensaje = "<p class='text-danger'>Error al generar alertas de stock.</p>";
    }
}

// Agregar nuevo inventario
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['agregar'])) {
    // $idInventario = $_POST['id_inventario']; // Removed because ID is auto-generated
    $idUsuario = $_POST['id_usuario'];
    $upi = $_POST['upi'];
    $idMaterial = $_POST['id_material'];
    $estadoId = $_POST['estado_id'];
    $fecha = $_POST['fecha'];
    $alerta = isset($_POST['alerta']) ? $_POST['alerta'] : '';

    if ($controller->agregarInventario(null, $idUsuario, $upi, $idMaterial, $estadoId, $fecha, $alerta)) {
        $mensaje = "<p class='text-success'>Inventario agregado exitosamente.</p>";
    } else {
        $mensaje = "<p class='text-danger'>Error al agregar inventario.</p>";
    }
}

// Eliminar inventario
if (isset($_GET['eliminar'])) {
    $controller->eliminarInventario($_GET['eliminar']);
    echo "<script>window.location = 'inventario.php';</script>";
}

// Obtener datos para edición
if (isset($_GET['editar'])) {
    $datosEditar = $controller->obtenerInventarioPorId($_GET['editar']);
}

// Actualizar inventario
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['actualizar'])) {
    $idInventario = $_POST['id_inventario'];
    $idUsuario = $_POST['id_usuario'];
    $upi = $_POST['upi'];
    $idMaterial = $_POST['id_material'];
    $estadoId = $_POST['estado_id'];
    $fecha = $_POST['fecha'];
    $alerta = isset($_POST['alerta']) ? $_POST['alerta'] : '';

    if ($controller->actualizarInventario($idInventario, $idUsuario, $upi, $idMaterial, $estadoId, $fecha, $alerta)) {
        $mensaje = "<p class='text-primary'>Inventario actualizado correctamente.</p>";
    } else {
        $mensaje = "<p class='text-danger'>Error al actualizar inventario.</p>";
    }

    echo "<script>window.location = 'inventario.php';</script>";
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Inventario</title>
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

    <h2>Agregar Alerta de Inventario</h2>
    <form method="POST" class="mb-4">
        <div class="row g-3">
                <div class="col-md-4">
                    <label for="id_usuario" class="form-label">ID Usuario</label>
                    <input type="text" class="form-control" id="id_usuario" name="id_usuario" required />
                </div>
                <div class="col-md-4">
                    <label for="upi" class="form-label">UPI</label>
                    <input type="text" class="form-control" id="upi" name="upi" required />
                </div>
                <div class="col-md-4">
                    <label for="id_material" class="form-label">ID Material</label>
                    <select class="form-select" id="id_material" name="id_material" required>
                        <option value="">Seleccione un material</option>
                        <?php foreach ($materiales as $material): ?>
                            <option value="<?= htmlspecialchars($material['ID_MATERIAL']) ?>"><?= htmlspecialchars($material['NOMBRE'] ?? $material['NOMBRE_MATERIAL'] ?? $material['ID_MATERIAL']) ?></option>
                        <?php endforeach; ?>
                    </select>
                </div>
                <div class="col-md-4">
                    <label for="estado_id" class="form-label">Estado</label>
                    <select class="form-select" id="estado_id" name="estado_id" required>
                        <option value="">Seleccione un estado</option>
                        <?php if (!empty($estados)): ?>
                            <?php foreach ($estados as $estado): ?>
                                <option value="<?= htmlspecialchars($estado['ESTADO_ID']) ?>"><?= htmlspecialchars($estado['DESCRIPCION']) ?></option>
                            <?php endforeach; ?>
                        <?php else: ?>
                            <option value="">No hay estados disponibles</option>
                        <?php endif; ?>
                    </select>
                </div>
            <div class="col-md-4">
                <label for="fecha" class="form-label">Fecha</label>
                <input type="date" class="form-control" id="fecha" name="fecha" required />
            </div>
            <div class="col-md-4">
                <label for="alerta" class="form-label">Alerta</label>
                <select class="form-select" id="alerta" name="alerta">
                    <option value="">Seleccione una alerta</option>
                    <option value="Stock bajo">Stock bajo</option>
                    <option value="Stock medio">Stock medio</option>
                    <option value="Stock alto">Stock alto</option>
                </select>
            </div>
        </div>
        <button type="submit" name="agregar" class="btn btn-primary mt-3">Agregar</button>
    </form>

    <?php if (isset($datosEditar)) { ?>
    <h2>Editar Inventario</h2>
    <form method="POST" class="mb-4">
        <input type="hidden" name="id_inventario" value="<?= $datosEditar['ID_INVENTARIO'] ?>" />
        <div class="row g-3">
            <div class="col-md-4">
                <label for="id_usuario_edit" class="form-label">ID Usuario</label>
                <input type="text" class="form-control" id="id_usuario_edit" name="id_usuario" value="<?= $datosEditar['ID_USUARIO'] ?>" required />
            </div>
            <div class="col-md-4">
                <label for="upi_edit" class="form-label">UPI</label>
                <input type="text" class="form-control" id="upi_edit" name="upi" value="<?= $datosEditar['UPI'] ?>" required />
            </div>
            <div class="col-md-4">
                <label for="id_material_edit" class="form-label">ID Material</label>
                <select class="form-select" id="id_material_edit" name="id_material" required>
                    <option value="">Seleccione un material</option>
                    <?php foreach ($materiales as $material): ?>
                        <option value="<?= htmlspecialchars($material['ID_MATERIAL']) ?>" <?= $datosEditar['ID_MATERIAL'] == $material['ID_MATERIAL'] ? 'selected' : '' ?>>
                            <?= htmlspecialchars($material['NOMBRE'] ?? $material['NOMBRE_MATERIAL'] ?? $material['ID_MATERIAL']) ?>
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>
            <div class="col-md-4">
                <label for="estado_id_edit" class="form-label">Estado</label>
                <select class="form-select" id="estado_id_edit" name="estado_id" required>
                    <option value="">Seleccione un estado</option>
                    <?php if (!empty($estados)): ?>
                        <?php foreach ($estados as $estado): ?>
                            <option value="<?= htmlspecialchars($estado['ESTADO_ID']) ?>" <?= $datosEditar['ESTADO_ID'] == $estado['ESTADO_ID'] ? 'selected' : '' ?>>
                                <?= htmlspecialchars($estado['DESCRIPCION']) ?>
                            </option>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <option value="">No hay estados disponibles</option>
                    <?php endif; ?>
                </select>
            </div>
            <div class="col-md-4">
                <label for="fecha_edit" class="form-label">Fecha</label>
                <input type="date" class="form-control" id="fecha_edit" name="fecha" value="<?= date('Y-m-d', strtotime($datosEditar['FECHA'])) ?>" required />
            </div>
            <div class="col-md-4">
                <label for="alerta_edit" class="form-label">Alerta</label>
                <select class="form-select" id="alerta_edit" name="alerta">
                    <option value="">Seleccione una alerta</option>
                    <option value="Stock bajo" <?= $datosEditar['ALERTAS_STOCK'] == 'Stock bajo' ? 'selected' : '' ?>>Stock bajo</option>
                    <option value="Stock medio" <?= $datosEditar['ALERTAS_STOCK'] == 'Stock medio' ? 'selected' : '' ?>>Stock medio</option>
                    <option value="Stock alto" <?= $datosEditar['ALERTAS_STOCK'] == 'Stock alto' ? 'selected' : '' ?>>Stock alto</option>
                </select>
            </div>
        </div>
        <button type="submit" name="actualizar" class="btn btn-primary mt-3">Actualizar</button>
    </form>
    <?php } ?>

    <div class="mb-4">
        <form method="POST">
            <button type="submit" name="generar_alertas" class="btn btn-warning">Generar Alertas de Stock</button>
        </form>

        <?php
        // Mostrar inventarios con alerta de stock bajo después de generar alertas
        if (isset($_POST['generar_alertas'])) {
            $inventariosConAlerta = $controller->obtenerInventariosConAlertaBajoStock();
            if (!empty($inventariosConAlerta)) {
                echo "<h4 class='mt-3'>Inventarios con alerta de Stock Bajo:</h4>";
                echo "<ul>";
                foreach ($inventariosConAlerta as $inv) {
                    echo "<li>ID Inventario: " . htmlspecialchars($inv['ID_INVENTARIO']) . " - Alerta: " . htmlspecialchars($inv['ALERTAS_STOCK']) . "</li>";
                }
                echo "</ul>";
            } else {
                echo "<p>No hay inventarios con alerta de stock bajo.</p>";
            }
        }
        ?>
    </div>

    <h2>Inventario Registrado</h2>

    <table class="table table-striped table-bordered">
        <thead class="table-primary">
            <tr>
                <th>ID Inventario</th>
                <th>ID Usuario</th>
                <th>UPI</th>
                <th>ID Material</th>
                <th>Estado ID</th>
                <th>Fecha</th>
                <th>Alerta</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <?php
            $inventario = $controller->listarInventario();
            foreach ($inventario as $fila):
                $estadoDesc = '';
                foreach ($estados as $estado) {
                    if ($estado['ESTADO_ID'] == $fila['ESTADO_ID']) {
                        $estadoDesc = $estado['DESCRIPCION'];
                        break;
                    }
                }
                $nombreMaterial = $fila['ID_MATERIAL'];
                foreach ($materiales as $material) {
                    if ($material['ID_MATERIAL'] == $fila['ID_MATERIAL']) {
                        $nombreMaterial = $material['NOMBRE'] ?? $material['NOMBRE_MATERIAL'] ?? $fila['ID_MATERIAL'];
                        break;
                    }
                }
            ?>
                <tr>
                    <td><?= htmlspecialchars($fila['ID_INVENTARIO']) ?></td>
                    <td><?= htmlspecialchars($fila['ID_USUARIO']) ?></td>
                    <td><?= htmlspecialchars($fila['UPI']) ?></td>
                    <td><?= htmlspecialchars($nombreMaterial) ?></td>
                    <td><?= htmlspecialchars($estadoDesc) ?></td>
                    <td><?= htmlspecialchars($fila['FECHA']) ?></td>
                    <td><?= htmlspecialchars($fila['ALERTAS_STOCK']) ?></td>
                    <td>
                        <a href='?editar=<?= htmlspecialchars($fila['ID_INVENTARIO']) ?>' class='btn btn-sm btn-warning me-1'>Editar</a>
                        <a href='?eliminar=<?= htmlspecialchars($fila['ID_INVENTARIO']) ?>' class='btn btn-sm btn-danger' onclick='return confirm("¿Estás seguro de eliminar este inventario?")'>Eliminar</a>
                    </td>
                </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
