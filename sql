
-- 0. ELIMINAR OBJETOS EXISTENTES (En orden inverso para evitar errores de llave foránea)

IF OBJECT_ID('dbo.Vista_Cuadro_Honor', 'V') IS NOT NULL DROP VIEW dbo.Vista_Cuadro_Honor;
IF OBJECT_ID('dbo.Vista_Sabana_Notas', 'V') IS NOT NULL DROP VIEW dbo.Vista_Sabana_Notas;
IF OBJECT_ID('dbo.Calificaciones', 'U') IS NOT NULL DROP TABLE dbo.Calificaciones;
IF OBJECT_ID('dbo.Estudiantes', 'U') IS NOT NULL DROP TABLE dbo.Estudiantes;
IF OBJECT_ID('dbo.Videojuegos', 'U') IS NOT NULL DROP TABLE dbo.Videojuegos;
IF OBJECT_ID('dbo.Materias', 'U') IS NOT NULL DROP TABLE dbo.Materias;
IF OBJECT_ID('dbo.Grados', 'U') IS NOT NULL DROP TABLE dbo.Grados;


-- 1. ESTRUCTURA DE LA BASE DE DATOS (TABLAS Y RESTRICCIONES)

-- Tabla de Grados
CREATE TABLE Grados (
    Id_Grado INT PRIMARY KEY IDENTITY(1,1),
    Nombre_Grado NVARCHAR(50) NOT NULL UNIQUE,
    Nivel INT NOT NULL CHECK (Nivel >= 6 AND Nivel <= 11)
);

-- Tabla de Estudiantes
CREATE TABLE Estudiantes (
    Id_Estudiante INT PRIMARY KEY IDENTITY(1,1),
    Nombre_Estudiante NVARCHAR(100) NOT NULL,
    Apellido_Estudiante NVARCHAR(100) NOT NULL,
    Id_Grado INT NOT NULL,
    Fecha_Inscripcion DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    CONSTRAINT FK_Estudiantes_Grados FOREIGN KEY (Id_Grado) REFERENCES Grados(Id_Grado)
);

-- Tabla de Materias
CREATE TABLE Materias (
    Id_Materia INT PRIMARY KEY IDENTITY(1,1),
    Nombre_Materia NVARCHAR(100) NOT NULL UNIQUE
);

-- Tabla de Calificaciones
CREATE TABLE Calificaciones (
    Id_Calificacion INT PRIMARY KEY IDENTITY(1,1),
    Id_Estudiante INT NOT NULL,
    Id_Materia INT NOT NULL,
    Id_Grado INT NOT NULL,
    Nota DECIMAL(3,1) NOT NULL CHECK (Nota >= 1 AND Nota <= 10),
    Fecha_Calificacion DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    Estado VARCHAR(10) NOT NULL CHECK (Estado IN ('Aprobado', 'Reprobado')),
    CONSTRAINT FK_Calificaciones_Estudiantes FOREIGN KEY (Id_Estudiante) REFERENCES Estudiantes(Id_Estudiante),
    CONSTRAINT FK_Calificaciones_Materias FOREIGN KEY (Id_Materia) REFERENCES Materias(Id_Materia),
    CONSTRAINT FK_Calificaciones_Grados FOREIGN KEY (Id_Grado) REFERENCES Grados(Id_Grado),
    CONSTRAINT UQ_Calificaciones UNIQUE (Id_Estudiante, Id_Materia, Id_Grado),
    CONSTRAINT CHK_Estado_Coherente CHECK (
        (Nota >= 6 AND Estado = 'Aprobado') OR
        (Nota < 6 AND Estado = 'Reprobado')
    )
);


-- 2. INSERCIÓN DE DATOS 

-- Inserción de Grados (6° a 11°)
INSERT INTO Grados (Nombre_Grado, Nivel) VALUES 
('Sexto', 6), ('Séptimo', 7), ('Octavo', 8), ('Noveno', 9), ('Décimo', 10), ('Undécimo', 11);

-- Inserción de Materias obligatorias
INSERT INTO Materias (Nombre_Materia) VALUES 
('Matemáticas'), ('Lengua Castellana'), ('Física'), ('Química'), ('Inglés'), ('Biología');

-- Inserción de Estudiantes (15 por Grado)
INSERT INTO Estudiantes (Nombre_Estudiante, Apellido_Estudiante, Id_Grado) VALUES
-- GRADO 6° (Id_Grado = 1)
('Juan', 'García', 1), ('María', 'López', 1), ('Carlos', 'Martínez', 1), ('Ana', 'Rodríguez', 1), ('Pedro', 'Hernández', 1), ('Laura', 'González', 1), ('Luis', 'Pérez', 1), ('Sofia', 'Torres', 1), ('Diego', 'Ramírez', 1), ('Elena', 'Castro', 1), ('Miguel', 'Vargas', 1), ('Daniela', 'Soto', 1), ('Andrés', 'Moreno', 1), ('Paula', 'Jiménez', 1), ('Ricardo', 'Flores', 1),
-- GRADO 7° (Id_Grado = 2)
('Camila', 'Silva', 2), ('Fernando', 'Mendez', 2), ('Valeria', 'Ortiz', 2), ('Cristian', 'Reyes', 2), ('Natalia', 'Gómez', 2), ('Roberto', 'Díaz', 2), ('Patricia', 'Cruz', 2), ('Óscar', 'Medina', 2), ('Gabriela', 'Rojas', 2), ('Jorge', 'Salazar', 2), ('Sandra', 'Vega', 2), ('Héctor', 'Rivas', 2), ('Verónica', 'Núñez', 2), ('Marco', 'Espinoza', 2), ('Alejandra', 'Acosta', 2),
-- GRADO 8° (Id_Grado = 3)
('Antonio', 'Álvarez', 3), ('Lorena', 'Ballesteros', 3), ('Raúl', 'Campos', 3), ('Mónica', 'Domínguez', 3), ('Felipe', 'Enríquez', 3), ('Rosa', 'Fuentes', 3), ('Guillermo', 'Guerrero', 3), ('Irene', 'Herrera', 3), ('Julio', 'Iglesias', 3), ('Juana', 'Jiménez', 3), ('Karim', 'Karam', 3), ('Lilia', 'Landa', 3), ('Mario', 'Mora', 3), ('Normal', 'Navarro', 3), ('Óscar', 'Obregón', 3),
-- GRADO 9° (Id_Grado = 4)
('Pablo', 'Parra', 4), ('Queta', 'Quintero', 4), ('Ramón', 'Ríos', 4), ('Silvia', 'Suárez', 4), ('Tomás', 'Téllez', 4), ('Úrsula', 'Uribe', 4), ('Víctor', 'Vázquez', 4), ('Wendy', 'Wagner', 4), ('Xavier', 'Ximénez', 4), ('Yolanda', 'Yañez', 4), ('Zacarías', 'Zamora', 4), ('Amalia', 'Aranda', 4), ('Benito', 'Benítez', 4), ('Consuelo', 'Cortés', 4), ('Donato', 'Durán', 4),
-- GRADO 10° (Id_Grado = 5)
('Emilio', 'Estévez', 5), ('Fabiana', 'Fernández', 5), ('Gaspar', 'García', 5), ('Hilaria', 'Hurtado', 5), ('Ignacio', 'Ibáñez', 5), ('Jacinta', 'Jara', 5), ('Kilian', 'Keller', 5), ('Leonora', 'León', 5), ('Marcos', 'Madrigal', 5), ('Nicanor', 'Neves', 5), ('Olivia', 'Ossa', 5), ('Pascual', 'Pimentel', 5), ('Quirino', 'Quirós', 5), ('Rosario', 'Rosales', 5), ('Salomón', 'Saldaña', 5),
-- GRADO 11° (Id_Grado = 6)
('Tadeo', 'Tapia', 6), ('Úrsula', 'Uriarte', 6), ('Valentín', 'Valdivia', 6), ('Waldina', 'Walters', 6), ('Xenia', 'Xenos', 6), ('Yago', 'Ybarra', 6), ('Zoe', 'Zúñiga', 6), ('Aurelio', 'Aucay', 6), ('Brígida', 'Bravo', 6), ('Casimiro', 'Castillo', 6), ('Dolores', 'Dávila', 6), ('Efrén', 'Elías', 6), ('Felicita', 'Fajardo', 6), ('Gerardo', 'Garay', 6), ('Herminia', 'Herrera', 6);

-- Inserción de Calificaciones
INSERT INTO Calificaciones (Id_Estudiante, Id_Materia, Id_Grado, Nota, Estado) VALUES
(1, 1, 1, 8.5, 'Aprobado'), (1, 2, 1, 7.0, 'Aprobado'), (1, 3, 1, 6.5, 'Aprobado'), (1, 4, 1, 4.5, 'Reprobado'), (1, 5, 1, 7.5, 'Aprobado'), (1, 6, 1, 8.0, 'Aprobado'),
(2, 1, 1, 9.0, 'Aprobado'), (2, 2, 1, 8.5, 'Aprobado'), (2, 3, 1, 7.5, 'Aprobado'), (2, 4, 1, 8.0, 'Aprobado'), (2, 5, 1, 9.0, 'Aprobado'), (2, 6, 1, 8.5, 'Aprobado'),
(3, 1, 1, 6.0, 'Aprobado'), (3, 2, 1, 5.5, 'Reprobado'), (3, 3, 1, 5.0, 'Reprobado'), (3, 4, 1, 6.0, 'Aprobado'), (3, 5, 1, 6.5, 'Aprobado'), (3, 6, 1, 7.0, 'Aprobado'),
(4, 1, 1, 7.0, 'Aprobado'), (4, 2, 1, 4.0, 'Reprobado'), (4, 3, 1, 3.5, 'Reprobado'), (4, 4, 1, 5.5, 'Reprobado'), (4, 5, 1, 7.0, 'Aprobado'), (4, 6, 1, 6.5, 'Aprobado'),
(5, 1, 1, 8.0, 'Aprobado'), (5, 2, 1, 7.5, 'Aprobado'), (5, 3, 1, 8.5, 'Aprobado'), (5, 4, 1, 5.0, 'Reprobado'), (5, 5, 1, 8.0, 'Aprobado'), (5, 6, 1, 7.5, 'Aprobado'),
(6, 1, 1, 9.5, 'Aprobado'), (6, 2, 1, 9.0, 'Aprobado'), (6, 3, 1, 8.5, 'Aprobado'), (6, 4, 1, 9.0, 'Aprobado'), (6, 5, 1, 9.5, 'Aprobado'), (6, 6, 1, 9.0, 'Aprobado'),
(7, 1, 1, 5.5, 'Reprobado'), (7, 2, 1, 6.5, 'Aprobado'), (7, 3, 1, 4.0, 'Reprobado'), (7, 4, 1, 7.0, 'Aprobado'), (7, 5, 1, 6.0, 'Aprobado'), (7, 6, 1, 6.5, 'Aprobado'),
(8, 1, 1, 8.0, 'Aprobado'), (8, 2, 1, 7.5, 'Aprobado'), (8, 3, 1, 8.0, 'Aprobado'), (8, 4, 1, 7.5, 'Aprobado'), (8, 5, 1, 8.5, 'Aprobado'), (8, 6, 1, 8.0, 'Aprobado'),
(9, 1, 1, 4.5, 'Reprobado'), (9, 2, 1, 3.5, 'Reprobado'), (9, 3, 1, 5.0, 'Reprobado'), (9, 4, 1, 4.0, 'Reprobado'), (9, 5, 1, 6.0, 'Aprobado'), (9, 6, 1, 6.5, 'Aprobado'),
(10, 1, 1, 7.5, 'Aprobado'), (10, 2, 1, 7.0, 'Aprobado'), (10, 3, 1, 6.0, 'Aprobado'), (10, 4, 1, 3.5, 'Reprobado'), (10, 5, 1, 7.5, 'Aprobado'), (10, 6, 1, 7.0, 'Aprobado'),
(11, 1, 1, 8.5, 'Aprobado'), (11, 2, 1, 8.0, 'Aprobado'), (11, 3, 1, 8.5, 'Aprobado'), (11, 4, 1, 8.0, 'Aprobado'), (11, 5, 1, 8.5, 'Aprobado'), (11, 6, 1, 8.0, 'Aprobado'),
(12, 1, 1, 6.5, 'Aprobado'), (12, 2, 1, 5.0, 'Reprobado'), (12, 3, 1, 6.0, 'Aprobado'), (12, 4, 1, 4.5, 'Reprobado'), (12, 5, 1, 7.0, 'Aprobado'), (12, 6, 1, 6.5, 'Aprobado'),
(13, 1, 1, 7.0, 'Aprobado'), (13, 2, 1, 7.5, 'Aprobado'), (13, 3, 1, 7.0, 'Aprobado'), (13, 4, 1, 7.5, 'Aprobado'), (13, 5, 1, 7.0, 'Aprobado'), (13, 6, 1, 7.5, 'Aprobado'),
(14, 1, 1, 8.0, 'Aprobado'), (14, 2, 1, 8.5, 'Aprobado'), (14, 3, 1, 2.0, 'Reprobado'), (14, 4, 1, 8.0, 'Aprobado'), (14, 5, 1, 8.5, 'Aprobado'), (14, 6, 1, 8.0, 'Aprobado'),
(15, 1, 1, 5.0, 'Reprobado'), (15, 2, 1, 6.5, 'Aprobado'), (15, 3, 1, 4.5, 'Reprobado'), (15, 4, 1, 3.0, 'Reprobado'), (15, 5, 1, 6.5, 'Aprobado'), (15, 6, 1, 7.0, 'Aprobado'),
-- GRADO 7°
(16, 1, 2, 8.0, 'Aprobado'), (16, 2, 2, 7.5, 'Aprobado'), (16, 3, 2, 8.5, 'Aprobado'), (16, 4, 2, 8.0, 'Aprobado'), (16, 5, 2, 7.0, 'Aprobado'), (16, 6, 2, 8.5, 'Aprobado'),
(17, 1, 2, 7.0, 'Aprobado'), (17, 2, 2, 5.5, 'Reprobado'), (17, 3, 2, 7.5, 'Aprobado'), (17, 4, 2, 6.0, 'Aprobado'), (17, 5, 2, 5.5, 'Reprobado'), (17, 6, 2, 7.0, 'Aprobado'),
(18, 1, 2, 9.0, 'Aprobado'), (18, 2, 2, 8.5, 'Aprobado'), (18, 3, 2, 9.0, 'Aprobado'), (18, 4, 2, 8.5, 'Aprobado'), (18, 5, 2, 9.0, 'Aprobado'), (18, 6, 2, 8.5, 'Aprobado'),
(19, 1, 2, 6.5, 'Aprobado'), (19, 2, 2, 4.0, 'Reprobado'), (19, 3, 2, 6.0, 'Aprobado'), (19, 4, 2, 3.5, 'Reprobado'), (19, 5, 2, 6.5, 'Aprobado'), (19, 6, 2, 6.0, 'Aprobado'),
(20, 1, 2, 8.0, 'Aprobado'), (20, 2, 2, 7.5, 'Aprobado'), (20, 3, 2, 8.0, 'Aprobado'), (20, 4, 2, 7.5, 'Aprobado'), (20, 5, 2, 8.0, 'Aprobado'), (20, 6, 2, 7.5, 'Aprobado'),
(21, 1, 2, 5.5, 'Reprobado'), (21, 2, 2, 6.5, 'Aprobado'), (21, 3, 2, 5.5, 'Reprobado'), (21, 4, 2, 7.0, 'Aprobado'), (21, 5, 2, 6.0, 'Aprobado'), (21, 6, 2, 6.5, 'Aprobado'),
(22, 1, 2, 9.0, 'Aprobado'), (22, 2, 2, 8.0, 'Aprobado'), (22, 3, 2, 9.0, 'Aprobado'), (22, 4, 2, 8.5, 'Aprobado'), (22, 5, 2, 9.0, 'Aprobado'), (22, 6, 2, 8.0, 'Aprobado'),
(23, 1, 2, 7.0, 'Aprobado'), (23, 2, 2, 6.5, 'Aprobado'), (23, 3, 2, 4.5, 'Reprobado'), (23, 4, 2, 6.0, 'Aprobado'), (23, 5, 2, 7.0, 'Aprobado'), (23, 6, 2, 6.5, 'Aprobado'),
(24, 1, 2, 8.5, 'Aprobado'), (24, 2, 2, 8.0, 'Aprobado'), (24, 3, 2, 8.5, 'Aprobado'), (24, 4, 2, 8.0, 'Aprobado'), (24, 5, 2, 8.5, 'Aprobado'), (24, 6, 2, 8.0, 'Aprobado'),
(25, 1, 2, 4.5, 'Reprobado'), (25, 2, 2, 3.5, 'Reprobado'), (25, 3, 2, 5.0, 'Reprobado'), (25, 4, 2, 4.0, 'Reprobado'), (25, 5, 2, 6.0, 'Aprobado'), (25, 6, 2, 6.5, 'Aprobado'),
(26, 1, 2, 7.5, 'Aprobado'), (26, 2, 2, 7.0, 'Aprobado'), (26, 3, 2, 7.5, 'Aprobado'), (26, 4, 2, 7.0, 'Aprobado'), (26, 5, 2, 7.5, 'Aprobado'), (26, 6, 2, 7.0, 'Aprobado'),
(27, 1, 2, 6.0, 'Aprobado'), (27, 2, 2, 5.0, 'Reprobado'), (27, 3, 2, 6.0, 'Aprobado'), (27, 4, 2, 2.5, 'Reprobado'), (27, 5, 2, 6.5, 'Aprobado'), (27, 6, 2, 6.0, 'Aprobado'),
(28, 1, 2, 8.5, 'Aprobado'), (28, 2, 2, 8.5, 'Aprobado'), (28, 3, 2, 8.5, 'Aprobado'), (28, 4, 2, 8.5, 'Aprobado'), (28, 5, 2, 8.5, 'Aprobado'), (28, 6, 2, 8.5, 'Aprobado'),
(29, 1, 2, 5.5, 'Reprobado'), (29, 2, 2, 6.5, 'Aprobado'), (29, 3, 2, 3.5, 'Reprobado'), (29, 4, 2, 6.0, 'Aprobado'), (29, 5, 2, 6.5, 'Aprobado'), (29, 6, 2, 6.5, 'Aprobado'),
(30, 1, 2, 7.0, 'Aprobado'), (30, 2, 2, 7.5, 'Aprobado'), (30, 3, 2, 7.0, 'Aprobado'), (30, 4, 2, 7.5, 'Aprobado'), (30, 5, 2, 7.0, 'Aprobado'), (30, 6, 2, 7.5, 'Aprobado');

PRINT ' Base de datos y estructuras creadas correctamente.';

-- 3). CONSULTAS ANALÍTICAS (CONSOLIDADOS Y AGRUPAMIENTOS)


-- A. Rendimiento general y balance por Asignatura
SELECT 
    'PROMEDIO DE NOTAS POR ASIGNATURA' AS [SECCIÓN],
    M.Nombre_Materia AS [Asignatura],
    ROUND(AVG(C.Nota), 2) AS [Promedio General],
    SUM(CASE WHEN C.Estado = 'Aprobado' THEN 1 ELSE 0 END) AS [Total Aprobados],
    SUM(CASE WHEN C.Estado = 'Reprobado' THEN 1 ELSE 0 END) AS [Total Reprobados]
FROM Calificaciones C
JOIN Materias M ON C.Id_Materia = M.Id_Materia
GROUP BY M.Nombre_Materia
ORDER BY [Promedio General] DESC;

-- B. Alumnos en Alerta Académica
SELECT 
    'ALUMNOS CON MÁS DE 2 MATERIAS REPROBADAS' AS [SECCIÓN],
    E.Nombre_Estudiante + ' ' + E.Apellido_Estudiante AS [Estudiante en Riesgo],
    G.Nombre_Grado AS [Grado],
    COUNT(C.Id_Materia) AS [Materias Reprobadas]
FROM Calificaciones C
JOIN Estudiantes E ON C.Id_Estudiante = E.Id_Estudiante
JOIN Grados G ON C.Id_Grado = G.Id_Grado
WHERE C.Estado = 'Reprobado'
GROUP BY E.Id_Estudiante, E.Nombre_Estudiante, E.Apellido_Estudiante, G.Nombre_Grado
HAVING COUNT(C.Id_Materia) >= 2
ORDER BY [Materias Reprobadas] DESC;


-- 4). OPERACIONES DE CONJUNTOS

-- C. El "Excelencia académica"
SELECT 
    'ALUMNOS EN EXCELENCIA ACADÉMICA (INVICTOS)' AS [SECCIÓN],
    E.Id_Estudiante, 
    E.Nombre_Estudiante + ' ' + E.Apellido_Estudiante AS [Estudiante Invicto]
FROM Estudiantes E
WHERE E.Id_Estudiante IN (
    -- Conjunto A: Todos los estudiantes matriculados
    SELECT Id_Estudiante FROM Estudiantes
    EXCEPT
    -- Conjunto B: Estudiantes que han reprobado alguna materia
    SELECT DISTINCT Id_Estudiante FROM Calificaciones WHERE Estado = 'Reprobado'
);

-- 5). CREACIÓN DE VISTAS ANALÍTICAS

GO

CREATE VIEW Vista_Sabana_Notas AS
SELECT 
    E.Nombre_Estudiante + ' ' + E.Apellido_Estudiante AS Alumno,
    G.Nombre_Grado AS Grado,
    ROUND(AVG(C.Nota), 1) AS Promedio_Definitivo,
    SUM(CASE WHEN C.Estado = 'Reprobado' THEN 1 ELSE 0 END) AS Materias_Perdidas
FROM Calificaciones C
JOIN Estudiantes E ON C.Id_Estudiante = E.Id_Estudiante
JOIN Grados G ON C.Id_Grado = G.Id_Grado
GROUP BY E.Id_Estudiante, E.Nombre_Estudiante, E.Apellido_Estudiante, G.Nombre_Grado;
GO

CREATE VIEW Vista_Cuadro_Honor AS
SELECT 
    G.Nombre_Grado AS Grado,
    E.Nombre_Estudiante + ' ' + E.Apellido_Estudiante AS Alumno,
    ROUND(AVG(C.Nota), 1) AS Promedio_Destacado
FROM Calificaciones C
JOIN Estudiantes E ON C.Id_Estudiante = E.Id_Estudiante
JOIN Grados G ON C.Id_Grado = G.Id_Grado
GROUP BY E.Id_Estudiante, E.Nombre_Estudiante, E.Apellido_Estudiante, G.Nombre_Grado
HAVING AVG(C.Nota) >= 8.5 AND SUM(CASE WHEN C.Estado = 'Reprobado' THEN 1 ELSE 0 END) = 0;
GO


-- 6). PRUEBAS DE LECTURA DE LAS VISTAS (REPORTES FINALES)


-- Consulta de lectura para la Vista A
SELECT 
    'RESULTADO: VISTA SÁBANA DE NOTAS CONSOLIDADAS' AS [SECCIÓN], 
    Alumno, 
    Grado, 
    Promedio_Definitivo, 
    Materias_Perdidas 
FROM Vista_Sabana_Notas 
ORDER BY Grado, Promedio_Definitivo DESC;

-- Consulta de lectura para la Vista B
SELECT 
    'RESULTADO: VISTA CUADRO DE HONOR ACADÉMICO' AS [SECCIÓN], 
    Grado, 
    Alumno, 
    Promedio_Destacado 
FROM Vista_Cuadro_Honor 
ORDER BY Grado, Promedio_Destacado DESC;


-- 7). MANEJO DE ERRORES Y VALIDACIÓN DE REGLAS DE SISTEMA


/*
  PRUEBA 1: Violación del límite superior de la Nota (Nota > 10).
  Se intenta insertar una calificación de 11.5 para verificar que la restricción CHECK actúe.
*/
BEGIN TRY
    INSERT INTO Calificaciones (Id_Estudiante, Id_Materia, Id_Grado, Nota, Estado) 
    VALUES (40, 1, 4, 11.5, 'Aprobado'); -- El valor 11.5 es inválido.
END TRY
BEGIN CATCH
    SELECT 
        'ERROR CONTROLADO: NOTA SUPERIOR AL MÁXIMO PERMITIDO (>10)' AS [SECCIÓN],
        ERROR_NUMBER() AS [Código Error],
        ERROR_MESSAGE() AS [Mensaje del Motor SQL Server],
        'ÉXITO: La restricción CHECK bloqueó la inserción.' AS [Estado Validación];
END CATCH;

/*
  PRUEBA 2: Violación de Coherencia de Estado Académico.
  Se intenta insertar una nota reprobatoria (3.5) pero con Estado 'Aprobado'.
*/
BEGIN TRY
    INSERT INTO Calificaciones (Id_Estudiante, Id_Materia, Id_Grado, Nota, Estado) 
    VALUES (41, 1, 4, 3.5, 'Aprobado'); -- Incoherencia lógica.
END TRY
BEGIN CATCH
    SELECT 
        'ERROR CONTROLADO: ESTADO INCOHERENTE (NOTA < 6 Y APROBADO)' AS [SECCIÓN],
        ERROR_NUMBER() AS [Código Error],
        ERROR_MESSAGE() AS [Mensaje del Motor SQL Server],
        'ÉXITO: CHK_Estado_Coherente protegió los datos.' AS [Estado Validación];
END CATCH;
