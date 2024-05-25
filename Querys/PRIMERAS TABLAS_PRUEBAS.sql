USE GD1C2024

DROP TABLE Ticket
-- TICKET
CREATE TABLE Ticket (
	ticket_numero SMALLINT IDENTITY PRIMARY KEY,
	legajo_empleado SMALLINT FOREIGN KEY REFERENCES Empleado(legajo_empleado),
	id_sucursal SMALLINT FOREIGN KEY REFERENCES Sucursal(id_sucursal),
	--nro_envio SMALLINT FOREIGN KEY REFERENCES Envio(nro_envio),
	--nro_caja SMALLINT FOREIGN KEY REFERENCES Caja(nro_caja),
	ticket_fecha_hora DATETIME NOT NULL,
	ticket_tipo_comprobante VARCHAR(10) NOT NULL,
	ticket_total_descuento_aplicado DECIMAL(18,2) DEFAULT 0, 
	ticket_total_descuento_aplicado_mp DECIMAL(18,2) DEFAULT 0,
	ticket_subtotal_productos DECIMAL(18,2),
	ticket_total_ticket DECIMAL(18,2)
)
DROP TABLE Empleado
-- EMPLEADO
CREATE TABLE Empleado (
	legajo_empleado SMALLINT IDENTITY PRIMARY KEY,
	empleado_nombre NVARCHAR(255),
	empleado_apellido NVARCHAR(255),
	empleado_dni INT,
	empleado_fecha_registro DATETIME NOT NULL,
	empleado_telefono VARCHAR(20),
	empleado_mail NVARCHAR(100),
	empleado_fecha_nacimiento DATE NOT NULL
)

DROP TABLE Sucursal
CREATE TABLE Sucursal (
	id_sucursal SMALLINT PRIMARY KEY,
	id_super SMALLINT FOREIGN KEY REFERENCES Supermercado(id_super),
	id_domicilio SMALLINT FOREIGN KEY REFERENCES Domicilio(id_domicilio),
	sucursal_nombre VARCHAR(50)
)

DROP TABLE Supermercado
CREATE TABLE Supermercado (
	id_super SMALLINT PRIMARY KEY,
	id_domicilio SMALLINT FOREIGN KEY REFERENCES Domicilio(id_domicilio),
	super_nombre NVARCHAR(50),
	super_razon_soc NVARCHAR(50),
	super_cuit VARCHAR(25),
	super_IIBB NVARCHAR(50),
	super_fecha_ini_actividad DATETIME NOT NULL,
	super_condicion_fiscal NVARCHAR(255)
)

DROP TABLE Domicilio
CREATE TABLE Domicilio (
	id_domicilio SMALLINT PRIMARY KEY,
	id_localidad SMALLINT FOREIGN KEY REFERENCES Localidad(id_localidad),
	direccion NVARCHAR(50) not null,
	altura INT not null,
	piso SMALLINT,
	departamento SMALLINT
)

DROP TABLE Localidad
CREATE TABLE Localidad (
	id_localidad SMALLINT PRIMARY KEY,
	id_provincia SMALLINT FOREIGN KEY REFERENCES Provincia(id_provincia),
	nombre_localidad NVARCHAR(50),
	codigo_postal SMALLINT
)

DROP TABLE Provincia
CREATE TABLE Provincia (
	id_provincia SMALLINT PRIMARY KEY,
	nombre_provincia NVARCHAR(50)
)