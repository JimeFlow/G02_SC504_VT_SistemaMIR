<?php
include_once __DIR__ . '/../controllers/TareasController.php';

$controller = new TareasController();

// Definir lista de estados para dropdown
$estados = [
    ['id' => 1, 'nombre' => 'Pendiente'],
    ['id' => 2, 'nombre' => 'En Proceso'],
    ['id' => 3, 'nombre' => 'Completado'],
    ['id' => 4, 'nombre' => 'Cancelado']
];

// Agregar tarea
    if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['agregar'])) {
        $resultado = $controller->agregarTarea(
            $_POST['id_tarea'], $_POST['nombre'], $_POST['descripcion'],
            $_POST['estado'], $_POST['fecha_recibido']
        );

    $mensaje = $resultado ? "<p class='text-success'>Tarea agregada correctamente.</p>" : "<p class='text-danger'>Error al agregar tarea.</p>";
}


// Eliminar tarea
if (isset($_GET['eliminar'])) {
    $resultado = $controller->eliminarTarea($_GET['eliminar']);
    if ($resultado) {
        $mensaje = "<p class='text-success'>Tarea eliminada correctamente.</p>";
    } else {
        $mensaje = "<p class='text-danger'>❌ Error al eliminar la tarea.</p>";
    }
}

// Obtener datos para edición
if (isset($_GET['editar'])) {
    $editar = $controller->obtenerTareaPorId($_GET['editar']);
}

// Actualizar tarea
    if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['actualizar'])) {
        $resultado = $controller->actualizarTarea(
            $_POST['id_tarea'], $_POST['nombre'], $_POST['descripcion'],
            $_POST['estado'], $_POST['fecha_recibido']
        );

        $mensaje = $resultado ? "<p class='text-primary'>Tarea actualizada correctamente.</p>" : "<p class='text-danger'>Error al actualizar tarea.</p>";
    }
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Tareas</title>
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

    <h2>Agregar Tarea</h2>
    <form method="POST" class="mb-4">
        <div class="row g-3">
            <div class="col-md-4 d-none">
                <label for="id_tarea" class="form-label">ID Tarea</label>
                <input type="text" class="form-control" id="id_tarea" name="id_tarea" />
            </div>
            <div class="col-md-4">
                <label for="nombre" class="form-label">Nombre</label>
                <input type="text" class="form-control" id="nombre" name="nombre" required />
            </div>
            <div class="col-md-4">
                <label for="descripcion" class="form-label">Descripción</label>
                <textarea class="form-control" id="descripcion" name="descripcion" rows="3" required></textarea>
            </div>
            <div class="col-md-4">
                <label for="estado" class="form-label">Estado</label>
                <select class="form-select" id="estado" name="estado" required>
                    <option value="">Seleccione un estado</option>
                    <?php foreach ($estados as $estado) : ?>
                        <option value="<?= $estado['id'] ?>"><?= htmlspecialchars($estado['nombre']) ?></option>
                    <?php endforeach; ?>
                </select>
            </div>
            <div class="col-md-4">
                <label for="fecha_recibido" class="form-label">Fecha de Recepción</label>
                <input type="date" class="form-control" id="fecha_recibido" name="fecha_recibido" required />
            </div>
        </div>
        <button type="submit" name="agregar" class="btn btn-primary mt-3">Agregar</button>
    </form>

    <?php if (isset($editar)) { ?>
    <h2>Editar Tarea</h2>
    <form method="POST" class="mb-4">
        <input type="hidden" name="id_tarea" value="<?= $editar['ID_TAREA'] ?>" />
        <div class="row g-3">
            <div class="col-md-4">
                <label for="nombre_edit" class="form-label">Nombre</label>
                <input type="text" class="form-control" id="nombre_edit" name="nombre" value="<?= $editar['NOMBRE'] ?>" required />
            </div>
            <div class="col-md-4">
                <label for="descripcion_edit" class="form-label">Descripción</label>
                <textarea class="form-control" id="descripcion_edit" name="descripcion" rows="3" required><?= $editar['DESCRIPCION'] ?></textarea>
            </div>
            <div class="col-md-4">
                <label for="estado_edit" class="form-label">Estado</label>
                <select class="form-select" id="estado_edit" name="estado" required>
                    <option value="">Seleccione un estado</option>
                    <?php foreach ($estados as $estado) : ?>
                        <option value="<?= $estado['id'] ?>" <?= (isset($editar) && intval($editar['ESTADO_ID']) === intval($estado['id'])) ? 'selected' : '' ?>>
                            <?= htmlspecialchars($estado['nombre']) ?>
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>
            <div class="col-md-4">
                <label for="fecha_recibido_edit" class="form-label">Fecha de Recepción</label>
                <input type="date" class="form-control" id="fecha_recibido_edit" name="fecha_recibido" value="<?= date('Y-m-d', strtotime($editar['FECHA_RECIBIDO'])) ?>" required />
            </div>
        </div>
        <button type="submit" name="actualizar" class="btn btn-primary mt-3">Actualizar</button>
    </form>
    <?php } ?>

    <h2>Tareas Registradas</h2>
    <table class="table table-striped table-bordered">
        <thead class="table-primary">
            <tr>
                <th>ID Tarea</th>
                <th>Nombre</th>
                <th>Descripción</th>
                <th>Estado</th>
                <th>Fecha de Creación</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <?php
            $tareas = $controller->listarTareas();

            // Función para obtener el nombre del estado por ID
            function obtenerNombreEstado($id, $estados) {
                foreach ($estados as $estado) {
                    if ($estado['id'] == $id) {
                        return $estado['nombre'];
                    }
                }
                return "Desconocido";
            }

            foreach ($tareas as $tarea) {
                $nombreEstado = obtenerNombreEstado($tarea['ESTADO_ID'], $estados);
                echo "<tr>
                    <td>{$tarea['ID_TAREA']}</td>
                    <td>{$tarea['NOMBRE']}</td>
                    <td>{$tarea['DESCRIPCION']}</td>
                    <td>{$nombreEstado}</td>
                    <td>" . date('Y-m-d', strtotime($tarea['FECHA_RECIBIDO'])) . "</td>
                    <td>
                        <a href='?editar={$tarea['ID_TAREA']}' class='btn btn-sm btn-warning me-1'>Editar</a>
                        <a href='?eliminar={$tarea['ID_TAREA']}' class='btn btn-sm btn-danger' onclick='return confirm(\"¿Eliminar esta tarea?\")'>Eliminar</a>
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
