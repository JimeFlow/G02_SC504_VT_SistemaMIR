<?php
// Incluir archivo de conexión a la base de datos
include_once __DIR__ . '/config/conexion.php';

// Crear instancia de conexión
$db = new Conexion();
$conexion = $db->conectar();

// Función para obtener cantidad de registros por tabla
function contarRegistros($conexion, $tabla) {
    $stmt = oci_parse($conexion, "SELECT COUNT(*) AS TOTAL FROM $tabla");
    oci_execute($stmt);
    $row = oci_fetch_assoc($stmt);
    return $row['TOTAL'];
}

// Obtener conteo de registros para diferentes tablas
$conteoInventario = contarRegistros($conexion, 'FIDE_INVENTARIO_TB');
$conteoMateriales = contarRegistros($conexion, 'FIDE_MATERIALES_TB');
$conteoEmpleados = contarRegistros($conexion, 'FIDE_PERSONAL_TB');
$conteoEntregas = contarRegistros($conexion, 'FIDE_ENTREGAS_TB');
$conteoReportes = contarRegistros($conexion, 'FIDE_REPORTES_TB');
$conteoRegistros = contarRegistros($conexion, 'FIDE_REGISTRO_DIARIO_TB');
$conteoTareas = contarRegistros($conexion, 'FIDE_TAREAS_TB');
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard</title>
    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <div class="container-fluid">
    <a class="navbar-brand" href="#">📊 Dashboard de Gestión</a>
  </div>
</nav>

<!-- Main container -->
<div class="container my-4">
    <div class="row g-4 justify-content-center">
        <div class="col-12 text-center mb-4">
            <h1>Sistema de Manejo de Inventarios y Registros</h1>
        </div>

        <div class="col-sm-6 col-md-4 col-lg-3">
            <div class="card text-center shadow-sm">
                <div class="card-body">
                    <h2 class="card-title display-5"><?= $conteoInventario ?></h2>
                    <a href="views/inventario.php" class="btn btn-outline-primary">Inventario</a>
                </div>
            </div>
        </div>

        <div class="col-sm-6 col-md-4 col-lg-3">
            <div class="card text-center shadow-sm">
                <div class="card-body">
                    <h2 class="card-title display-5"><?= $conteoMateriales ?></h2>
                    <a href="views/materiales.php" class="btn btn-outline-primary">Materiales</a>
                </div>
            </div>
        </div>

        <div class="col-sm-6 col-md-4 col-lg-3">
            <div class="card text-center shadow-sm">
                <div class="card-body">
                    <h2 class="card-title display-5"><?= $conteoEmpleados ?></h2>
                    <a href="views/empleados.php" class="btn btn-outline-primary">Empleados</a>
                </div>
            </div>
        </div>

        <div class="col-sm-6 col-md-4 col-lg-3">
            <div class="card text-center shadow-sm">
                <div class="card-body">
                    <h2 class="card-title display-5"><?= $conteoEntregas ?></h2>
                    <a href="views/entregas.php" class="btn btn-outline-primary">Entregas</a>
                </div>
            </div>
        </div>

        <div class="col-sm-6 col-md-4 col-lg-3">
            <div class="card text-center shadow-sm">
                <div class="card-body">
                    <h2 class="card-title display-5"><?= $conteoReportes ?></h2>
                    <a href="views/reportes.php" class="btn btn-outline-primary">Reportes</a>
                </div>
            </div>
        </div>

        <div class="col-sm-6 col-md-4 col-lg-3">
            <div class="card text-center shadow-sm">
                <div class="card-body">
                    <h2 class="card-title display-5"><?= $conteoRegistros ?></h2>
                    <a href="views/registros.php" class="btn btn-outline-primary">Registros</a>
                </div>
            </div>
        </div>

        <div class="col-sm-6 col-md-4 col-lg-3">
            <div class="card text-center shadow-sm">
                <div class="card-body">
                    <h2 class="card-title display-5"><?= $conteoTareas ?></h2>
                    <a href="views/tareas.php" class="btn btn-outline-primary">Tareas</a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS Bundle CDN (includes Popper) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
