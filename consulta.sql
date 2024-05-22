CREATE TABLE Categorías (
    id_categoria INTEGER PRIMARY KEY,
    nombre TEXT,
    descripción TEXT
);
CREATE TABLE Chefs (
    id_chef INTEGER PRIMARY KEY,
    nombre TEXT,
    especialidad TEXT
);
CREATE TABLE Especialidades (
    id_especialidad INTEGER PRIMARY KEY,
    nombre TEXT
);
CREATE TABLE Ingredientes (
    id_ingrediente INTEGER PRIMARY KEY,
    nombre TEXT,
    cantidad_stock INTEGER,
    unidad_medida TEXT
);
CREATE TABLE Menú (
    id_plato INTEGER PRIMARY KEY,
    nombre TEXT,
    descripción TEXT,
    id_categoria INTEGER,
    id_chef INTEGER,
    FOREIGN KEY (id_categoria) REFERENCES Categorías(id_categoria),
    FOREIGN KEY (id_chef) REFERENCES Chefs(id_chef)
);
CREATE TABLE PlatosIngredientes (
    id_plato INTEGER,
    id_ingrediente INTEGER,
    cantidad INTEGER,
    PRIMARY KEY (id_plato, id_ingrediente),
    FOREIGN KEY (id_plato) REFERENCES Menú(id_plato),
    FOREIGN KEY (id_ingrediente) REFERENCES Ingredientes(id_ingrediente)
);
CREATE TABLE EspecialidadesPlatos (
    id_plato INTEGER,
    id_especialidad INTEGER,
    PRIMARY KEY (id_plato, id_especialidad),
    FOREIGN KEY (id_plato) REFERENCES Menú(id_plato),
    FOREIGN KEY (id_especialidad) REFERENCES Especialidades(id_especialidad)
);

-- Consultas Básicas:

-- Categorías
SELECT * FROM Categorías;

-- Chefs
SELECT * FROM Chefs;

-- Especialidades
SELECT * FROM Especialidades;

-- Ingredientes
SELECT * FROM Ingredientes;

-- Menú
SELECT * FROM Menú;

-- PlatosIngredientes
SELECT * FROM PlatosIngredientes;

-- EspecialidadesPlatos
SELECT * FROM EspecialidadesPlatos;

-- Consultas con Filtros:

-- Chefs especializados en Cocina Francesa
SELECT * FROM Chefs WHERE especialidad LIKE '%Francesa%';

-- Ingredientes con stock mayor a 100
SELECT * FROM Ingredientes WHERE cantidad_stock > 100;


-- Obtener los platos junto con sus categorías y chefs
SELECT Menú.nombre AS Plato, Categorías.nombre AS Categoría, Chefs.nombre AS Chef
FROM Menú
INNER JOIN Categorías ON Menú.id_categoria = Categorías.id_categoria
INNER JOIN Chefs ON Menú.id_chef = Chefs.id_chef;

-- Obtener los platos junto con sus ingredientes y cantidades
SELECT Menú.nombre AS Plato, Ingredientes.nombre AS Ingrediente, PlatosIngredientes.cantidad
FROM PlatosIngredientes
INNER JOIN Menú ON PlatosIngredientes.id_plato = Menú.id_plato
INNER JOIN Ingredientes ON PlatosIngredientes.id_ingrediente = Ingredientes.id_ingrediente;

-- Obtener los platos junto con sus especialidades
SELECT Menú.nombre AS Plato, Especialidades.nombre AS Especialidad
FROM EspecialidadesPlatos
INNER JOIN Menú ON EspecialidadesPlatos.id_plato = Menú.id_plato
INNER JOIN Especialidades ON EspecialidadesPlatos.id_especialidad = Especialidades.id_especialidad;

-- Left Join:

-- Obtener todos los platos y sus categorías (incluyendo aquellos sin categorías asignadas)
SELECT Menú.nombre AS Plato, Categorías.nombre AS Categoría
FROM Menú
LEFT JOIN Categorías ON Menú.id_categoria = Categorías.id_categoria;

-- Obtener todos los platos y sus ingredientes (incluyendo aquellos sin ingredientes asignados)
SELECT Menú.nombre AS Plato, Ingredientes.nombre AS Ingrediente, PlatosIngredientes.cantidad
FROM Menú
LEFT JOIN PlatosIngredientes ON Menú.id_plato = PlatosIngredientes.id_plato
LEFT JOIN Ingredientes ON PlatosIngredientes.id_ingrediente = Ingredientes.id_ingrediente;

-- Obtener todos los platos y sus especialidades (incluyendo aquellos sin especialidades asignadas)
SELECT Menú.nombre AS Plato, Especialidades.nombre AS Especialidad
FROM Menú
LEFT JOIN EspecialidadesPlatos ON Menú.id_plato = EspecialidadesPlatos.id_plato
LEFT JOIN Especialidades ON EspecialidadesPlatos.id_especialidad = Especialidades.id_especialidad;

-- Right Join:

-- Obtener todos los ingredientes y los platos que los utilizan (incluyendo aquellos ingredientes que no se utilizan en ningún plato)
SELECT Ingredientes.nombre AS Ingrediente, Menú.nombre AS Plato, PlatosIngredientes.cantidad
FROM Ingredientes
RIGHT JOIN PlatosIngredientes ON Ingredientes.id_ingrediente = PlatosIngredientes.id_ingrediente
RIGHT JOIN Menú ON PlatosIngredientes.id_plato = Menú.id_plato;

-- Obtener todas las especialidades y los platos que las tienen asignadas (incluyendo aquellas especialidades que no se han asignado a ningún plato)
SELECT Especialidades.nombre AS Especialidad, Menú.nombre AS Plato
FROM Especialidades
RIGHT JOIN EspecialidadesPlatos ON Especialidades.id_especialidad = EspecialidadesPlatos.id_especialidad
RIGHT JOIN Menú ON EspecialidadesPlatos.id_plato = Menú.id_plato;

-- Agregaciones:

-- Contar el número de platos por categoría
SELECT Categorías.nombre AS Categoría, COUNT(Menú.id_plato) AS NúmeroDePlatos
FROM Menú
INNER JOIN Categorías ON Menú.id_categoria = Categorías.id_categoria
GROUP BY Categorías.nombre;

-- Calcular la cantidad total de ingredientes necesarios para cada plato
SELECT Menú.nombre AS Plato, SUM(PlatosIngredientes.cantidad) AS CantidadTotalIngredientes
FROM PlatosIngredientes
INNER JOIN Menú ON PlatosIngredientes.id_plato = Menú.id_plato
GROUP BY Menú.nombre;

-- Contar el número de platos por chef
SELECT Chefs.nombre AS Chef, COUNT(Menú.id_plato) AS NúmeroDePlatos
FROM Menú
INNER JOIN Chefs ON Menú.id_chef = Chefs.id_chef
GROUP BY Chefs.nombre;

-- Subconsultas:

-- Obtener los nombres de los chefs que tienen más de un plato en el menú
SELECT nombre
FROM Chefs
WHERE id_chef IN (
    SELECT id_chef
    FROM Menú
    GROUP BY id_chef
    HAVING COUNT(id_plato) > 1
);

-- Obtener los nombres de los platos que requieren más de 2 ingredientes
SELECT nombre
FROM Menú
WHERE id_plato IN (
    SELECT id_plato
    FROM PlatosIngredientes
    GROUP BY id_plato
    HAVING COUNT(id_ingrediente) > 2
);
