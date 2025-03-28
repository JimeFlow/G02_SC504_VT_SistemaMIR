<?php

require_once 'conexion.php';

$conex = new Conexion();
$getConection = $conex->Conectar();

// Consulta Inventario por Bodega
$queryInv = "SELECT bod.Sucursal AS bodega, COUNT(*) AS cantidad
             FROM FIDE_INVENTARIO_TB inv
             JOIN FIDE_BODEGAS_TB bod ON inv.Id_Usuario = bod.Bodega_Id
             GROUP BY bod.Sucursal";
$stmtInv = $getConection->prepare($queryInv);
$stmtInv->execute();
$datosInventario = $stmtInv->fetchAll(PDO::FETCH_ASSOC);

// Consulta Empleados por Turno 
$queryEmp = "SELECT turno, COUNT(*) AS total 
             FROM FIDE_PERSONAL_TB 
             WHERE Tipo_Personal = 'Empleado'
             GROUP BY turno";
$stmtEmp = $getConection->prepare($queryEmp);
$stmtEmp->execute();
$datosEmpleadosTurno = $stmtEmp->fetchAll(PDO::FETCH_ASSOC);

?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Reportes - SMIR</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body { font-family: Arial, sans-serif; }
        .sidebar {
            height: 100vh;
            width: 250px;
            position: fixed;
            top: 0;
            left: 0;
            background: #343a40;
            color: white;
            padding-top: 20px;
        }
        .sidebar a { padding: 10px; text-decoration: none; color: white; display: block; }
        .sidebar a:hover { background: #495057; }
        .content { margin-left: 260px; padding: 20px; }
        .chart-container { width: 80%; margin: auto; }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <img id="O365_MainLink_TenantLogoImg" alt="Organizational Logo" 
             title="Organizational Logo"
             src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAHgAAAAfCAYAAAAslQkwAAA...">
        <hr>
        <a class="nav-link text-white" href="index.php"><i class="fas fa-home"></i> Inicio</a>
        <a class="nav-link text-white" href="registro_entrega.php"><i class="fas fa-box"></i> Registro de Entrega</a>
        <a class="nav-link text-white" href="inventario.php"><i class="fas fa-archive"></i> Inventario</a>
        <a class="nav-link text-white" href="empleados.php"><i class="fas fa-users"></i> Empleados</a>
        <a class="nav-link text-white" href="reportes.php"><i class="fas fa-chart-bar"></i> Reportes</a>
    </div>
    <!-- Contenido -->
    <div class="content">
        <h2>Reportes</h2>
        <p>Genera reportes visuales sobre el inventario y empleados.</p>
        <!-- Selección de tipo de reporte -->
        <div class="mb-3">
            <label for="tipoReporte" class="form-label">Selecciona el tipo de reporte:</label>
            <select id="tipoReporte" class="form-select">
                <option value="inventario">Inventario (Cantidades por Bodega)</option>
                <option value="empleados">Empleados por Turno</option>
            </select>
        </div>
        <!-- Botón para generar reporte -->
        <button class="btn btn-primary mb-3" id="generarReporte"><i class="fas fa-chart-bar"></i> Generar Reporte</button>
        <!-- Contenedor del gráfico -->
        <div class="chart-container">
            <canvas id="graficoReportes"></canvas>
        </div>
    </div>
    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Datos de inventario consultados desde PHP
        let datosInventario = <?php echo json_encode($datosInventario); ?>;

        // Datos de empleados por turno consultados desde la BD
        let datosEmpleadosTurno = <?php echo json_encode($datosEmpleadosTurno); ?>;

        let ctx, chart;
        document.addEventListener("DOMContentLoaded", function () {
            ctx = document.getElementById('graficoReportes').getContext('2d');
            document.getElementById("generarReporte").addEventListener("click", function () {
                let tipoReporte = document.getElementById("tipoReporte").value;
                generarGrafico(tipoReporte);
            });
        });

        function generarGrafico(tipo) {
            let etiquetas = [];
            let valores = [];
            let titulo = "";

            if (chart) {
                chart.destroy();
            }

            if (tipo === "inventario") {
                // Convertimos los datos de inventario en arrays de etiquetas y valores
                etiquetas = datosInventario.map(d => d.bodega);
                valores = datosInventario.map(d => parseInt(d.cantidad));
                titulo = "Inventario por Bodega";
            } else {
                // Convertimos los datos de empleados por turno
                etiquetas = datosEmpleadosTurno.map(d => `Turno ${d.turno}`);
                valores = datosEmpleadosTurno.map(d => parseInt(d.total));
                titulo = "Empleados por Turno";
            }

            chart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: etiquetas,
                    datasets: [{
                        label: titulo,
                        data: valores,
                        backgroundColor: ['#007bff', '#28a745', '#ffc107', '#dc3545', '#17a2b8'],
                        borderColor: '#333',
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: { beginAtZero: true }
                    }
                }
            });
        }
    </script>
</body>
</html>
