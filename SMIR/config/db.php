<?php
$usuario = '';
$password = '';
$host = '';
$puerto = '';
$sid = '';

$conn = oci_connect($usuario, $password, "//$host:$puerto/$sid");
if (!$conn) {
    $error = oci_error();
    die("Error de conexión: " . $error['message']);
}
?>
