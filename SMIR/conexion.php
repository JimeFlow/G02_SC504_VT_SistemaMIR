<?php
    class Conexion {
        public function Conectar() {
            define('HOST', '127.0.0.1');
            define('PORT', 3306);
            define('NAME', 'XE');
            define('USER', 'ABBOTT');
            define('PASS', '123');

            try {
                // Utiliza el nombre del servicio de red 'XE' (de tnsnames.ora)
                $bd = new PDO('oci:dbname=XE', USER, PASS);
                $bd->setAttribute(PDO::ATTR_CASE, PDO::CASE_LOWER);
                $bd->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
                echo 'CONEXION EXITOSA';
                return $bd;
            } catch (Exception $e) {
                echo "ERROR DE CONEXION: ".$e->getMessage();
            }
        }
    }
?>