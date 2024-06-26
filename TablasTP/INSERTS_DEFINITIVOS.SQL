-- 1 PROVINCIA
INSERT INTO Provincia (PROVINCIA_NOMBRE)
SELECT DISTINCT CLIENTE_PROVINCIA 
FROM gd_esquema.Maestra 

INSERT INTO Provincia (PROVINCIA_NOMBRE)
SELECT DISTINCT SUPER_PROVINCIA 
FROM gd_esquema.Maestra 

INSERT INTO Provincia (PROVINCIA_NOMBRE)
SELECT DISTINCT SUCURSAL_PROVINCIA 
FROM gd_esquema.Maestra 
-- 2 LOCALIDAD
INSERT INTO Localidad (PROVINCIA_ID, LOCALIDAD_NOMBRE)
SELECT DISTINCT P.PROVINCIA_ID, M.CLIENTE_LOCALIDAD
FROM gd_esquema.Maestra M
INNER JOIN Provincia P ON M.CLIENTE_PROVINCIA = P.PROVINCIA_NOMBRE;
       
INSERT INTO Localidad (PROVINCIA_ID, LOCALIDAD_NOMBRE)
SELECT DISTINCT P.PROVINCIA_ID, M.SUPER_LOCALIDAD
FROM gd_esquema.Maestra M
INNER JOIN Provincia P ON M.CLIENTE_PROVINCIA = P.PROVINCIA_NOMBRE

INSERT INTO Localidad (PROVINCIA_ID, LOCALIDAD_NOMBRE)
SELECT DISTINCT P.PROVINCIA_ID, M.SUCURSAL_LOCALIDAD
FROM gd_esquema.Maestra M
INNER JOIN Provincia P ON M.SUCURSAL_PROVINCIA = P.PROVINCIA_NOMBRE
-- 3 DOMICILIO
INSERT INTO Domicilio (LOCALIDAD_ID, DIRECCION, ALTURA, PISO, DEPARTAMENTO)
SELECT DISTINCT L.LOCALIDAD_ID,
SUBSTRING(M.CLIENTE_DOMICILIO, 1, LEN(M.CLIENTE_DOMICILIO) - CHARINDEX(' ', REVERSE(M.CLIENTE_DOMICILIO))) AS DIRECCION,
RIGHT(M.CLIENTE_DOMICILIO, CHARINDEX(' ', REVERSE(M.CLIENTE_DOMICILIO)) - 1) AS ALTURA,
NULL AS PISO,
NULL AS DEPARTAMENTO
FROM gd_esquema.Maestra M
INNER JOIN Localidad L ON M.CLIENTE_LOCALIDAD = L.LOCALIDAD_NOMBRE;

INSERT INTO Domicilio (LOCALIDAD_ID, DIRECCION, ALTURA, PISO, DEPARTAMENTO)
SELECT DISTINCT L.LOCALIDAD_ID,
SUBSTRING(M.SUPER_DOMICILIO, 1, LEN(M.SUPER_DOMICILIO) - CHARINDEX(' ', REVERSE(M.SUPER_DOMICILIO))) AS DIRECCION,
RIGHT(M.SUPER_DOMICILIO, CHARINDEX(' ', REVERSE(M.SUPER_DOMICILIO)) - 1) AS ALTURA,
NULL AS PISO,
NULL AS DEPARTAMENTO
FROM gd_esquema.Maestra M
INNER JOIN Localidad L ON M.SUPER_LOCALIDAD = L.LOCALIDAD_NOMBRE;

INSERT INTO Domicilio (LOCALIDAD_ID, DIRECCION, ALTURA, PISO, DEPARTAMENTO)
SELECT DISTINCT L.LOCALIDAD_ID,
SUBSTRING(M.SUCURSAL_DIRECCION, 1, LEN(M.SUCURSAL_DIRECCION) - CHARINDEX(' ', REVERSE(M.SUCURSAL_DIRECCION))) AS DIRECCION,
RIGHT(M.SUCURSAL_DIRECCION, CHARINDEX(' ', REVERSE(M.SUCURSAL_DIRECCION)) - 1) AS ALTURA,
NULL AS PISO,
NULL AS DEPARTAMENTO
FROM gd_esquema.Maestra M
INNER JOIN Localidad L ON M.SUCURSAL_LOCALIDAD = L.LOCALIDAD_NOMBRE;
-- 4 CLIENTE
INSERT INTO Cliente (
CLIENTE_NOMBRE, CLIENTE_APELLIDO, CLIENTE_DNI, CLIENTE_FECHA_REGISTRO,
CLIENTE_FECHA_NACIMIENTO, CLIENTE_MAIL, CLIENTE_TELEFONO,
DOMICILIO_ID 
)
SELECT DISTINCT
CLIENTE_NOMBRE, CLIENTE_APELLIDO, CLIENTE_DNI, CLIENTE_FECHA_REGISTRO,
CLIENTE_FECHA_NACIMIENTO, CLIENTE_MAIL, CLIENTE_TELEFONO,
D.DOMICILIO_ID 
FROM gd_esquema.Maestra M
INNER JOIN Domicilio D ON 
M.CLIENTE_DOMICILIO = D.DIRECCION + ' ' + CAST(D.ALTURA AS NVARCHAR(50));
-- 5 ESTADO ENVIO
INSERT INTO EstadoEnvio (ESTADO)
SELECT DISTINCT ENVIO_ESTADO
FROM gd_esquema.Maestra m
-- 6 ENVIO
INSERT INTO Envio (CLIENTE_ID, ESTADO_ENVIO_ID, ENVIO_COSTO, ENVIO_FECHA_PROGRAMADA, ENVIO_HORA_INICIO, ENVIO_HORA_FIN, ENVIO_FECHA_ENTREGA)
SELECT 
c.CLIENTE_ID, 
e.ESTADO_ENVIO_ID, 
m.ENVIO_COSTO, 
m.ENVIO_FECHA_PROGRAMADA, 
m.ENVIO_HORA_INICIO, 
m.ENVIO_HORA_FIN, 
m.ENVIO_FECHA_ENTREGA
FROM 
gd_esquema.Maestra m
INNER JOIN 
Cliente c ON c.CLIENTE_DNI = m.CLIENTE_DNI 
INNER JOIN 
EstadoEnvio e ON e.ESTADO = m.ENVIO_ESTADO
-- 7 MARCA
INSERT INTO Marca (MARCA_NOMBRE, MARCA_DECRIPCION)
SELECT DISTINCT PRODUCTO_MARCA, null FROM gd_esquema.Maestra
-- 8 SUBCATEGORIA
INSERT INTO Subcategoria (
SUBCATEGORIA_NOMBRE, SUBCATEGORIA_DESCRIPCION
) 
SELECT DISTINCT PRODUCTO_SUB_CATEGORIA, null FROM gd_esquema.Maestra
-- 9 CATEGORIA
INSERT INTO Categoria (
CATEGORIA_NOMBRE, SUBCATEGORIA_ID
)
SELECT DISTINCT PRODUCTO_CATEGORIA, S.SUBCATEGORIA_ID
FROM gd_esquema.Maestra M 
INNER JOIN Subcategoria S ON M.PRODUCTO_SUB_CATEGORIA = S.SUBCATEGORIA_NOMBRE
-- 10 PRODUCTO
INSERT INTO Producto(
PRODUCTO_NOMBRE, PRODUCTO_DESCRIPCION, PRODUCTO_PRECIO, MARCA_ID, CATEGORIA_ID
)
SELECT DISTINCT PRODUCTO_NOMBRE, PRODUCTO_DESCRIPCION, PRODUCTO_PRECIO, 
Ma.MARCA_ID, C.CATEGORIA_ID
FROM gd_esquema.Maestra M
INNER JOIN Categoria C ON M.PRODUCTO_CATEGORIA = C.CATEGORIA_NOMBRE
INNER JOIN Marca Ma ON M.PRODUCTO_MARCA = Ma.MARCA_NOMBRE
-- 11 TIPOCAJA
INSERT INTO TipoCaja (
CAJA_NOMBRE, CAJA_DESCRIPCION
)
SELECT DISTINCT CAJA_TIPO, null
FROM gd_esquema.Maestra
-- 12 CAJA
INSERT INTO Caja (CAJA_NUMERO, CAJA_TIPO_ID)
SELECT DISTINCT CAJA_NUMERO, T.CAJA_TIPO_ID 
FROM gd_esquema.Maestra M
INNER JOIN TipoCaja T ON M.CAJA_TIPO = T.CAJA_NOMBRE
-- 13 REGLA
INSERT INTO Regla (REGLA_DESCRIPCION, REGLA_DESCUENTO_PORCENTAJE, REGLA_CANTIDAD_APLICABLE_REGLA, REGLA_CANTIDAD_APLICABLE_DESCUENTO, 
    REGLA_CANTIDAD_MAXIMA, REGLA_MISMA_MARCA, REGLA_MISMO_PRODUCTO)
SELECT 
    REGLA_DESCRIPCION, 
    REGLA_DESCUENTO_APLICABLE_PROD, 
    REGLA_CANT_APLICABLE_REGLA, 
    REGLA_CANT_APLICA_DESCUENTO, 
    REGLA_CANT_MAX_PROD, 
    CAST(REGLA_APLICA_MISMA_MARCA AS BIT), 
    CAST(REGLA_APLICA_MISMO_PROD AS BIT)
FROM 
    gd_esquema.Maestra
WHERE 
    REGLA_DESCRIPCION IS NOT NULL;
-- 14 SUPERMERCADO
INSERT INTO Supermercado (DOMICILIO_ID, SUPER_NOMBRE, SUPER_RAZON_SOC, SUPER_CUIT, SUPER_IIBB, SUPER_FECHA_INI_ACTIVIDAD, SUPER_CONDICION_FISCAL)
SELECT DISTINCT
    d.DOMICILIO_ID,
    m.SUPER_NOMBRE,
    m.SUPER_RAZON_SOC,
    m.SUPER_CUIT,
    m.SUPER_IIBB,
    m.SUPER_FECHA_INI_ACTIVIDAD,
    m.SUPER_CONDICION_FISCAL
FROM 
    gd_esquema.Maestra m
INNER JOIN Domicilio d ON 
	M.SUPER_DOMICILIO = D.DIRECCION + ' ' + CAST(D.ALTURA AS NVARCHAR(50))
-- 15 SUCURSAL
INSERT INTO Sucursal (SUPER_ID, SUCURSAL_NOMBRE, SUCURSAL_DIRECCION, SUCURSAL_LOCALIDAD, SUCURSAL_PROVINCIA)
SELECT DISTINCT
    s.SUPER_ID,
    m.SUCURSAL_NOMBRE,
    m.SUCURSAL_DIRECCION,
    m.SUCURSAL_LOCALIDAD,
    m.SUCURSAL_PROVINCIA
FROM 
    gd_esquema.Maestra m
INNER JOIN Supermercado s ON 
	s.SUPER_ID = SUPER_ID
-- 16 TIPOMEDIOPAGO
INSERT INTO TipoMedioPago(TIPO_MEDIO_PAGO,TARJETA_NUMERO,TARJETA_CUOTAS,TARJETA_FECHA_VENCEMIENTO)
SELECT DISTINCT 
	m.PAGO_TIPO_MEDIO_PAGO, 
	m.PAGO_TARJETA_NRO, 
	m.PAGO_TARJETA_CUOTAS, 
	m.PAGO_TARJETA_FECHA_VENC 
FROM gd_esquema.Maestra m
-- 17 MEDIODEPAGO
INSERT INTO MedioDePago (
    MEDIO_PAGO_DESCRIPCION, TIPO_MEDIO_PAGO_ID
)
SELECT DISTINCT 
    m.PAGO_MEDIO_PAGO, T.TIPO_MEDIO_PAGO_ID
FROM gd_esquema.Maestra m
 JOIN TipoMedioPago T ON M.PAGO_TIPO_MEDIO_PAGO = T.TIPO_MEDIO_PAGO

