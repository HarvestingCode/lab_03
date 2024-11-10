<?php

$usuario_id = 'USR001';

$sql = "SELECT * FROM Usuarios WHERE usuario_id = ?";
$params = [$usuario_id];
$stmt = sqlsrv_query($conn, $sql, $params);

if ($stmt === false) {
    die(print_r(sqlsrv_errors(), true));
} else {
    if ($row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) {
        echo "Nombre: " . $row['nombre'] . ", Email: " . $row['email'];
    } else {
        echo "Usuario no encontrado.";
    }
}

?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>CRUD con PHP y SQL Server</title>
</head>
<body>
    <h2>Gestión de Usuarios</h2>

    <!-- Formulario para insertar datos -->
    <form action="procesar.php" method="POST">
        <label for="usuario_id">ID Usuario:</label>
        <input type="text" name="usuario_id" required><br><br>
        
        <label for="nombre">Nombre:</label>
        <input type="text" name="nombre" required><br><br>
        
        <label for="email">Email:</label>
        <input type="email" name="email" required><br><br>
        
        <input type="submit" name="accion" value="Crear">
        <input type="submit" name="accion" value="Leer">
        <input type="submit" name="accion" value="Actualizar">
        <input type="submit" name="accion" value="Eliminar">
    </form>
</body>
</html>