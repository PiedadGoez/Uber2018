
CREATE or REPLACE VIEW VIAJES_CLIENTES AS

SELECT
    servicios.id AS ID_VIAJE,
     servicios.estado,
     servicios.fecha_viaje,
     usuarios.nombre,
     usuarios.tipo_usuario,
     vehiculos.placa,
     servicios.tarifa_dinamica,
     servicios.tipo_servicio,
     ciudades.nombre   AS nombre_ciudad,
     facturas.valor_total

     
     
 FROM
     servicios
     INNER JOIN ciudades ON servicios.ciudad_id = ciudades.id
     INNER JOIN usuarios ON servicios.cliente_id = usuarios.id
     INNER JOIN vehiculos ON vehiculos.fk_usuario = usuarios.id
     INNER JOIN facturas ON facturas.cliente_id = usuarios.id
                               
 WHERE
     servicios.estado = 'REALIZADO'
 ORDER BY
     servicios.fecha_viaje,usuarios.tipo_usuario ;