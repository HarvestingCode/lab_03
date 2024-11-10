<?php
// Configuración de conexión
$serverName = "localhost";  // Cambia según tu configuración
$connectionOptions = [
    "Database" => "nombre_base_datos",
    "Uid" => "usuario",
    "PWD" => "contraseña"
];
$conn = sqlsrv_connect($serverName, $connectionOptions);

if ($conn === false) {
    die(print_r(sqlsrv_errors(), true));
}

// Recibir los datos del formulario
$accion = $_POST['accion'];
$usuario_id = $_POST['usuario_id'];
$nombre = $_POST['nombre'];
$email = $_POST['email'];

// Realizar la operación correspondiente
$sql = "SELECT * FROM Usuarios WHERE usuario_id = ?";
$params = [$usuario_id];
break;

$stmt = sqlsrv_query($conn, $sql, $params);

if ($stmt === false) {
    die(print_r(sqlsrv_errors(), true));
} else {
    if ($accion == "Leer") {
        if ($row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) {
            echo "ID Usuario: " . $row['usuario_id'] . "<br>";
            echo "Nombre: " . $row['nombre'] . "<br>";
            echo "Email: " . $row['email'] . "<br>";
        } else {
            echo "Usuario no encontrado.";
        }
    } else {
        echo ucfirst(strtolower($accion)) . " operación realizada exitosamente.";
    }
}

// Cerrar la conexión
sqlsrv_close($conn);
?>