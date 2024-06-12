USE GD1C2024

/* TABLAS CREADAS
	1. Supermercado					--
	2. Sucursal						--
	3. Empleado
	4. Producto						--
	5. Ticket
	6. DetalleTicket
	7. Pago
	8. DetallePago
	9. MedioDePago
	10. PromocionProducto
	11. DescuentoMedioPago
	12. Promocion_x_Producto
	13. Regla						--
	14. Promocion_x_Regla
	15. ENVIO 						--
	16. ESTADOENVIO 				--
	17. CLIENTE	  					--
	18. DOMICILIO 					--
	19. LOCALIDAD 					--
	20. PROVINCIA 					--
	21. CAJA 						--
	22. TIPOCAJA					--
	23. MARCA						--
	24. CATEGORIA					--
	25. SUBCATEGORIA				--
	26. TIPO MEDIODEPAGO			--
	27. DESCUENTOPORMEDIODEPAGO
*/

CREATE TABLE Provincia(
	PROVINCIA_ID INT PRIMARY KEY IDENTITY,
	PROVINCIA_NOMBRE NVARCHAR(255)
);

CREATE TABLE Localidad(
	LOCALIDAD_ID INT PRIMARY KEY IDENTITY,
	PROVINCIA_ID INT FOREIGN KEY REFERENCES Provincia(PROVINCIA_ID),
	LOCALIDAD_NOMBRE NVARCHAR(255),
	LOCALIDAD_CODIGO_POSTAL INT,
);

CREATE TABLE Domicilio(
	DOMICILIO_ID INT PRIMARY KEY IDENTITY,
	LOCALIDAD_ID INT FOREIGN KEY REFERENCES Localidad(LOCALIDAD_ID),
	DIRECCION NVARCHAR(255),
	ALTURA INT,
	PISO INT,
	DEPARTAMENTO NVARCHAR(255)
);

CREATE TABLE Cliente(
	CLIENTE_ID INT PRIMARY KEY IDENTITY,
	DOMICILIO_ID INT FOREIGN KEY REFERENCES Domicilio(DOMICILIO_ID),
	CLIENTE_NOMBRE NVARCHAR(255),
	CLIENTE_APELLIDO NVARCHAR(255),
	CLIENTE_DNI DECIMAL(18,0),
	CLIENTE_FECHA_REGISTRO DATETIME,
	CLIENTE_TELEFONO DECIMAL(18,2),
	CLIENTE_MAIL NVARCHAR(255),
	CLIENTE_FECHA_NACIMIENTO DATE
);

CREATE TABLE Marca(
	MARCA_ID INT PRIMARY KEY IDENTITY,
	MARCA_NOMBRE NVARCHAR(255),
	MARCA_DECRIPCION NVARCHAR(255)
);

CREATE TABLE Subcategoria(
	SUBCATEGORIA_ID INT PRIMARY KEY IDENTITY,
	SUBCATEGORIA_NOMBRE NVARCHAR(255),
	SUBCATEGORIA_DESCRIPCION NVARCHAR(255)
);

CREATE TABLE Categoria(
	 CATEGORIA_ID INT PRIMARY KEY IDENTITY,
	 SUBCATEGORIA_ID INT FOREIGN KEY REFERENCES Subcategoria(SUBCATEGORIA_ID),
	 CATEGORIA_NOMBRE NVARCHAR(255),
	 CATEGORIA_DESCRIPCION NVARCHAR(255)
);

CREATE TABLE Producto (
    PRODUCTO_ID INT PRIMARY KEY IDENTITY,
	MARCA_ID INT FOREIGN KEY REFERENCES Marca(MARCA_ID),     
	CATEGORIA_ID INT FOREIGN KEY REFERENCES Categoria(CATEGORIA_ID), 
    PRODUCTO_NOMBRE NVARCHAR(255) NOT NULL,
	PRODUCTO_DESCRIPCION NVARCHAR(255),
    PRODUCTO_PRECIO DECIMAL(18, 2)
);

CREATE TABLE Supermercado (
    SUPER_ID INT PRIMARY KEY IDENTITY,
    DOMICILIO_ID INT FOREIGN KEY REFERENCES Domicilio(DOMICILIO_ID),
    SUPER_NOMBRE NVARCHAR(255) NOT NULL,
    SUPER_RAZON_SOC NVARCHAR(255) NOT NULL,
    SUPER_CUIT NVARCHAR(255) NOT NULL,
    SUPER_IIBB NVARCHAR(255) NOT NULL,
    SUPER_FECHA_INI_ACTIVIDAD DATETIME,
    SUPER_CONDICION_FISCAL NVARCHAR(255)
);

CREATE TABLE Sucursal (
    SUCURSAL_ID INT PRIMARY KEY IDENTITY,
    SUPER_ID INT FOREIGN KEY REFERENCES Supermercado(SUPER_ID),
    SUCURSAL_NOMBRE NVARCHAR(255) NOT NULL,
    SUCURSAL_DIRECCION NVARCHAR(255),
    SUCURSAL_LOCALIDAD NVARCHAR(255),
    SUCURSAL_PROVINCIA NVARCHAR(255)
);

CREATE TABLE Empleado (
    EMPLEADO_ID INT PRIMARY KEY IDENTITY,
    EMPLEADO_NOMBRE NVARCHAR(255) NOT NULL,
    EMPLEADO_APELLIDO NVARCHAR(255) NOT NULL,
    EMPLEADO_DNI DECIMAL(18, 0) NOT NULL,
    EMPLEADO_FECHA_REGISTRO DATETIME,
    EMPLEADO_TELEFONO NVARCHAR(255)
);

CREATE TABLE TipoCaja(
	CAJA_TIPO_ID INT PRIMARY KEY IDENTITY, 
	CAJA_NOMBRE NVARCHAR(255),
	CAJA_DESCRIPCION NVARCHAR(255)
);

CREATE TABLE Caja(
	CAJA_ID INT PRIMARY KEY IDENTITY,
	CAJA_TIPO_ID INT FOREIGN KEY REFERENCES TipoCaja(CAJA_TIPO_ID),
	CAJA_NUMERO DECIMAL(18,0)
);
CREATE TABLE EstadoEnvio(
	ESTADO_ENVIO_ID DECIMAL(18,0) PRIMARY KEY IDENTITY,
	ESTADO NVARCHAR(255)
);

CREATE TABLE Envio (           
    ENVIO_NRO_ID INT PRIMARY KEY IDENTITY, 
	CLIENTE_ID INT FOREIGN KEY REFERENCES Cliente(CLIENTE_ID), 
    ESTADO_ENVIO_ID DECIMAL(18,0) FOREIGN KEY REFERENCES EstadoEnvio(ESTADO_ENVIO_ID),
	ENVIO_COSTO DECIMAL(18,2),
	ENVIO_FECHA_PROGRAMADA DATETIME,
	ENVIO_HORA_INICIO DECIMAL(18,2),
	ENVIO_HORA_FIN DECIMAL(18,2),
	ENVIO_FECHA_ENTREGA DATETIME
);

CREATE TABLE Ticket (
    TICKET_ID INT PRIMARY KEY IDENTITY,
    SUCURSAL_ID INT FOREIGN KEY REFERENCES Sucursal(SUCURSAL_ID),
    EMPLEADO_ID INT FOREIGN KEY REFERENCES Empleado(EMPLEADO_ID),
    CAJA_ID INT FOREIGN KEY REFERENCES Caja(CAJA_ID),
    ENVIO_NRO_ID INT FOREIGN KEY REFERENCES Envio(ENVIO_NRO_ID),
    TICKET_NUMERO DECIMAL(18, 0) NOT NULL,
    TICKET_FECHA_HORA DATETIME NOT NULL,
    TICKET_TIPO_COMPROBANTE NVARCHAR(255),
    TICKET_SUBTOTAL_PRODUCTOS DECIMAL(18, 2),
    TICKET_TOTAL_DESCUENTO_APLICADO DECIMAL(18, 2),
    TICKET_TOTAL_DESCUENTO_APLICADO_MP DECIMAL(18, 2),
    TICKET_TOTAL_ENVIO DECIMAL(18, 2),
    TICKET_TOTAL_TICKET DECIMAL(18, 2)
);

CREATE TABLE DetalleTicket (
    DETALLE_TICKET_ID INT PRIMARY KEY IDENTITY,
    TICKET_ID INT FOREIGN KEY REFERENCES Ticket(TICKET_ID),
    PRODUCTO_ID INT FOREIGN KEY REFERENCES Producto(PRODUCTO_ID),
    CANTIDAD INT,
    PRECIO_UNITARIO DECIMAL(18, 2),
    DESCUENTO_APLICADO DECIMAL(18, 2),
    TOTAL_PRODUCTO DECIMAL(18, 2)
);

CREATE TABLE Promocion( 
    PROMOCION_ID INT PRIMARY KEY IDENTITY,
    PRODUCTO_ID INT FOREIGN KEY REFERENCES Producto(PRODUCTO_ID),
    DESCRIPCION NVARCHAR(255) NOT NULL,
    FECHA_INICIO DATETIME,
    FECHA_FIN DATETIME,
	PROMOCION_APLICADA_DESCUENTO DECIMAL(18,2),                     
);

CREATE TABLE DetalleTicketXPromocion(
	PROMOCION_ID INT FOREIGN KEY REFERENCES Promocion(PROMOCION_ID),
	DETALLE_TICKET_ID INT FOREIGN KEY REFERENCES DetalleTicket(DETALLE_TICKET_ID),
	PRIMARY KEY (PROMOCION_ID, DETALLE_TICKET_ID),
	TICKET_ID INT FOREIGN KEY REFERENCES Ticket(TICKET_ID)   ------- 
);

CREATE TABLE TipoMedioPago(
	TIPO_MEDIO_PAGO_ID INT PRIMARY KEY IDENTITY,
	TIPO_MEDIO_PAGO NVARCHAR(255),
	TARJETA_NUMERO NVARCHAR(255),
	TARJETA_CUOTAS DECIMAL(18,2),
	TARJETA_FECHA_VENCEMIENTO DATETIME
);

CREATE TABLE MedioDePago (
    MEDIO_PAGO_ID INT PRIMARY KEY IDENTITY,
    MEDIO_PAGO_DESCRIPCION NVARCHAR(255) NOT NULL,
	TIPO_MEDIO_PAGO_ID INT FOREIGN KEY REFERENCES TipoMedioPago(TIPO_MEDIO_PAGO_ID) -----AGREGADO
);

CREATE TABLE Pago (
    PAGO_ID INT PRIMARY KEY IDENTITY,
    TICKET_ID INT FOREIGN KEY REFERENCES Ticket(TICKET_ID),
    MEDIO_PAGO_ID INT FOREIGN KEY REFERENCES MedioDePago(MEDIO_PAGO_ID),
	FECHA_PAGO DATETIME NOT NULL,
    IMPORTE DECIMAL(18, 2) NOT NULL,
    PAGO_DESCUENTO_APLICADO DECIMAL(18,2)
);

CREATE TABLE DetallePago (
    DETALLE_PAGO_ID INT PRIMARY KEY IDENTITY,
    PAGO_ID INT FOREIGN KEY REFERENCES Pago(PAGO_ID),
    MEDIO_PAGO_ID INT FOREIGN KEY REFERENCES MedioDePago(MEDIO_PAGO_ID),
    CLIENTE_NOMBRE NVARCHAR(255),
    CLIENTE_DNI DECIMAL(18, 0),
    NUMERO_TARJETA NVARCHAR(255),
    FECHA_VENCIMIENTO_TARJETA DATETIME,
    CUOTAS INT
);

CREATE TABLE Descuento(
    DESCUENTO_ID INT PRIMARY KEY IDENTITY,
    DESCRIPCION NVARCHAR(255) NOT NULL,
    MEDIO_PAGO_ID INT FOREIGN KEY REFERENCES MedioDePago(MEDIO_PAGO_ID),
    FECHA_INICIO DATETIME,
    FECHA_FIN DATETIME,
    DESCUENTO_PORCENTAJE DECIMAL(18, 2),
    DESCUENTO_TOPE DECIMAL(18, 2)
);

CREATE TABLE Descuento_X_MedioPago(
   MEDIO_PAGO_ID INT FOREIGN KEY REFERENCES MedioDePago(MEDIO_PAGO_ID),
   DESCUENTO_ID INT FOREIGN KEY REFERENCES Descuento(DESCUENTO_ID),
   PRIMARY KEY (MEDIO_PAGO_ID, DESCUENTO_ID)
);

CREATE TABLE Promocion_x_Producto (
    PRODUCTO_ID INT FOREIGN KEY REFERENCES Producto(PRODUCTO_ID),
    PROMOCION_ID INT FOREIGN KEY REFERENCES Promocion(PROMOCION_ID),
    PRIMARY KEY (PRODUCTO_ID, PROMOCION_ID)
);

CREATE TABLE Regla (
    REGLA_ID INT PRIMARY KEY IDENTITY,
    REGLA_DESCRIPCION NVARCHAR(255) NOT NULL,
    REGLA_DESCUENTO_PORCENTAJE DECIMAL(18, 2) NOT NULL,
    REGLA_CANTIDAD_APLICABLE_REGLA INT NOT NULL,
    REGLA_CANTIDAD_APLICABLE_DESCUENTO INT NOT NULL,
    REGLA_CANTIDAD_MAXIMA INT NOT NULL,
    REGLA_MISMA_MARCA BIT NOT NULL,
    REGLA_MISMO_PRODUCTO BIT NOT NULL
);

CREATE TABLE Promocion_x_Regla (
	REGLA_ID INT FOREIGN KEY REFERENCES Regla(REGLA_ID),
	PROMOCION_ID INT FOREIGN KEY REFERENCES Promocion(PROMOCION_ID)
	PRIMARY KEY (REGLA_ID, PROMOCION_ID)
);