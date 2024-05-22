const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const path = require('path');
const fs = require('fs');

const app = express();
const port = 3000;

// Define la ruta de la base de datos
const dbPath = path.resolve(__dirname, 'Database.db');

// Crea el archivo de la base de datos si no existe
if (!fs.existsSync(dbPath)) {
    fs.writeFileSync(dbPath, '');
}

// Crear la conexión a la base de datos
const db = new sqlite3.Database(dbPath, (err) => {
    if (err) {
        console.error('Error connecting to the database:', err.message);
    } else {
        console.log('Connected to the SQLite database.');
    }
});

// Ruta de ejemplo para obtener datos de la base de datos
app.get('/data', (req, res) => {
    const sql = 'SELECT * FROM Ingredientes';
    
    db.all(sql, [], (err, rows) => {
        if (err) {
            res.status(500).json({ error: err.message });
            return;
        }
        res.json({
            message: 'success',
            data: rows
        });
    });
});

// Iniciar el servidor
app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});

// Cerrar la conexión a la base de datos cuando se cierra el servidor
process.on('SIGINT', () => {
    db.close((err) => {
        if (err) {
            console.error('Error closing the database:', err.message);
        }
        console.log('Database connection closed.');
        process.exit(0);
    });
});
