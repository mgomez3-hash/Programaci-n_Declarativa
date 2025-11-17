--Ejecutar primero
CREATE DATABASE Monedas; 

--Para las siguientes instrucciones, se debe cambiar la conexión

/* Crear tabla MONEDA */
CREATE TABLE Moneda( 
	Id SERIAL PRIMARY KEY,
	Moneda VARCHAR(100) NOT NULL,
	Sigla VARCHAR(5) NOT NULL,
	Simbolo VARCHAR(5) NULL,
	Emisor VARCHAR(100) NULL,
	Imagen BYTEA NULL
	);

/* Crear indice para MONEDA
	ordenado por MONEDA */
CREATE UNIQUE INDEX ixMoneda
	ON Moneda(Moneda);

/* Crear tabla CAMBIOMONEDA */
CREATE TABLE CambioMoneda( 
    Id SERIAL PRIMARY KEY,
	IdMoneda int NOT NULL,
	CONSTRAINT fkCambioMoneda_IdMoneda FOREIGN KEY (IdMoneda)
		REFERENCES Moneda(Id),
	Fecha DATE NOT NULL,
	Cambio FLOAT NOT NULL
);

/* Crear indice para CAMBIOMONEDA
	ordenado por MONEDA, FECHA */
CREATE UNIQUE INDEX ixCambioMoneda
	ON CambioMoneda(IdMoneda, Fecha);

/* Crear tabla PAIS */
CREATE TABLE Pais(
	Id SERIAL PRIMARY KEY,
	Pais varchar(50) not null,
	CodigoAlfa2 varchar(5) not null,
	CodigoAlfa3 varchar(5) not null, 
	IdMoneda int NOT NULL,
	CONSTRAINT fkPais_IdMoneda FOREIGN KEY (IdMoneda)
		REFERENCES Moneda(Id),
	Mapa BYTEA NULL,
	Bandera BYTEA NULL
	);

/* Crear indice para PAIS
	ordenado por PAIS */
CREATE UNIQUE INDEX ixPais
	ON Pais(Pais);

/*INSERTAR MONEDA SI NO EXISTE (VALIDACIÓN)*/

CREATE OR REPLACE FUNCTION insertar_moneda_si_no_existe(
    p_moneda VARCHAR,
    p_sigla VARCHAR,
    p_simbolo VARCHAR,
    p_emisor VARCHAR
)
RETURNS INT AS $$
DECLARE
    v_id INT;
BEGIN
    SELECT id INTO v_id
    FROM Moneda
    WHERE moneda = p_moneda;

    IF v_id IS NULL THEN
        INSERT INTO Moneda(moneda, sigla, simbolo, emisor)
        VALUES (p_moneda, p_sigla, p_simbolo, p_emisor)
        RETURNING id INTO v_id;
    END IF;

    RETURN v_id;
END;
$$ LANGUAGE plpgsql;
 
