<?php
class Conexion {
    private $conexion;

    public function conectar() {
        $username = 'ABBOTT';
        $password = '123';
        $host = '127.0.0.1';
        $port = '1521';
        $service_name = 'XE';

        $connection_string = "(DESCRIPTION =
            (ADDRESS = (PROTOCOL = TCP)(HOST = $host)(PORT = $port))
            (CONNECT_DATA = (SERVICE_NAME = $service_name))
        )";

        try {
            $this->conexion = oci_connect($username, $password, $connection_string);
            if (!$this->conexion) {
                $e = oci_error();
                throw new Exception($e['message']);
            }
            return $this->conexion;
        } catch (Exception $e) {
            echo "Error al conectar con Oracle: " . $e->getMessage() . "<br>";
            return false;
        }
    }
}
?>
