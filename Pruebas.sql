/* FUNCIÓN PARA VALIDAR E INSERTAR MONEDA SI NO EXISTE */
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
    -- Validar si ya existe por nombre
    SELECT id INTO v_id
    FROM Moneda
    WHERE moneda = p_moneda;

    -- insertar nueva moneda
    IF v_id IS NULL THEN
        INSERT INTO Moneda(moneda, sigla, simbolo, emisor)
        VALUES (p_moneda, p_sigla, p_simbolo, p_emisor)
        RETURNING id INTO v_id;
    END IF;

    RETURN v_id;
END;
$$ LANGUAGE plpgsql;


SELECT 
    id, 
    moneda, 
    sigla
FROM 
    moneda
ORDER BY 
    id;

SELECT 
    COUNT(*) AS totalregistroscambio
FROM 
    cambiomoneda;
SELECT 
    m.sigla,
    COUNT(cm.idmoneda) AS registros_por_moneda
FROM 
    cambiomoneda cm
        JOIN moneda m 
            ON cm.idmoneda = m.id
GROUP BY 
    m.sigla
ORDER BY 
    m.sigla;
SELECT 
    cm.idmoneda, 
    m.sigla, 
    cm.fecha, 
    cm.cambio
FROM 
    cambiomoneda cm
        JOIN moneda m 
            ON cm.idmoneda = m.id
ORDER BY 
    cm.fecha DESC, 
    cm.idmoneda 
LIMIT 100;
