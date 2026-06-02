

DROP TABLE IF EXISTS inventario;
DROP TABLE IF EXISTS producto;
DROP TABLE IF EXISTS users;
DROP TYPE IF EXISTS estado_inv;


CREATE TYPE estado_inv AS ENUM ('disponible', 'agotado', 'reservado');

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    rol VARCHAR(50),
    config JSONB
);

CREATE TABLE producto (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio NUMERIC(10,2),
    tags TEXT[] 
);

CREATE TABLE inventario (
    id SERIAL PRIMARY KEY,
    cantidad INTEGER NOT NULL,
    estado estado_inv NOT NULL,
    id_producto INTEGER REFERENCES producto(id) ON DELETE CASCADE,
    id_user INTEGER REFERENCES users(id) ON DELETE SET NULL
);


INSERT INTO users (nombre, email, rol, config) VALUES
('Andres saenz', 'andres@mail.com', 'admin', '{"tema": "oscuro", "idioma": "es"}'),
('Valen bermudez', 'valen@mail.com', 'user', '{"tema": "claro", "idioma": "es"}');


INSERT INTO producto (nombre, descripcion, precio, tags) VALUES
('iphone 13', 'iphone 13 pro max', 2500000.00, '{"electronico", "oferta"}'),
('iphone 18', 'iphone 18 pro max', 8500000.00, '{"electronico", "oferta"}');


INSERT INTO inventario (cantidad, estado, id_producto, id_user) VALUES
(10, 'disponible', 1, 1), 
(5, 'reservado', 2, 2);   


SELECT 
    i.id AS inventario_id,
    p.nombre AS producto,
    p.precio,
    i.cantidad,
    i.estado,
    u.nombre AS encargado,
    u.config->>'tema' AS tema_preferido 
FROM inventario i
INNER JOIN producto p ON i.id_producto = p.id
INNER JOIN users u ON i.id_user = u.id;