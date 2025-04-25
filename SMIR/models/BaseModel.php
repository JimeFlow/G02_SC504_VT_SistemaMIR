<?php
include_once __DIR__ . '/../config/conexion.php';

class BaseModel {
    protected $conexion;

    public function __construct() {
        try {
            $db = new Conexion();
            $this->conexion = $db->Conectar();
            if ($this->conexion) {
                echo "Conexión establecida correctamente.<br>";
            } else {
                echo "Error al establecer la conexión.<br>";
            }
        } catch (PDOException $e) {
            echo "Error en la conexión: " . $e->getMessage() . "<br>";
        }
    }

    public function executeNonQuery($sql, $params = []) {
        try {
            $this->conexion->beginTransaction();
            $stmt = $this->conexion->prepare($sql);
            if ($stmt->execute($params)) {
                $this->conexion->commit();
                return true;
            } else {
                $this->conexion->rollBack();
                return false;
            }
        } catch (PDOException $e) {
            $this->conexion->rollBack();
            echo "Error al ejecutar la operación: " . $e->getMessage() . "<br>";
            return false;
        }
    }

    public function executeQuery($sql, $params = []) {
        try {
            $stmt = $this->conexion->prepare($sql);
            $stmt->execute($params);
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            echo "Error al ejecutar la consulta: " . $e->getMessage() . "<br>";
            return false;
        }
    }
}
?>
