--PUNTO 1
CREATE OR REPLACE VIEW MEDIOS_PAGO_CLIENTES AS
    SELECT usuarios.ID AS CLIENTE_ID, usuarios.nombre, medios_de_pagos.ID AS MEDIO_PAGO_ID, medios_de_pagos.NOMBRE AS TIPO, 
    usuarios_medios_pagos.detalle_forma_pago, usuarios_medios_pagos.EMPRESARIAL, usuarios_medios_pagos.nombre_empresa
    FROM usuarios
    INNER JOIN usuarios_medios_pagos 
    ON usuarios.ID = usuarios_medios_pagos.fk_usuario
    INNER JOIN medios_de_pagos ON 
    usuarios_medios_pagos.fk_medio_pago = medios_de_pagos.ID
WITH CHECK OPTION;

select * from MEDIOS_PAGO_CLIENTES;


--PUNTO 2

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
     FROM servicios
     INNER JOIN ciudades ON servicios.ciudad_id = ciudades.id
     INNER JOIN usuarios ON servicios.cliente_id = usuarios.id
     INNER JOIN vehiculos ON vehiculos.fk_usuario = usuarios.id
     INNER JOIN facturas ON facturas.cliente_id = usuarios.id
     WHERE servicios.estado = 'REALIZADO'
 ORDER BY
     servicios.fecha_viaje,usuarios.tipo_usuario ;
     
SELECT * FROM VIAJES_CLIENTES  
     
--PUNTO 3

--plan ejecuccion 1

explain plan set STATEMENT_ID='pe'  into plan_table for
select * from VIAJES_CLIENTES;
select plan_table_output from table(dbms_xplan.display('plan_table','pe','typical'));


--plan ejecuccion 2 mejorado
explain plan set STATEMENT_ID='q1'  into plan_table for
select * from VIAJES_CLIENTES where nombre='Silvestre Gallardo';
select plan_table_output from table(dbms_xplan.display('plan_table','q1','typical'));
CREATE INDEX VIAJE_ID_USER_NAME_idx ON USUARIOS(ID,NOMBRE); 

--PUNTO 5

CREATE OR REPLACE FUNCTION VALOR_DISTANCIA(disKM NUMBER, city ciudades.nombre%TYPE)
   RETURN FLOAT IS   
   --VARIABLES
   valorxkmF NUMBER;
   
   valdistanci float;
   
 --EXCEPCIONES PROPIAS
 city_nofound  EXCEPTION; 
 negativeKM EXCEPTION;
   BEGIN 
   
   --valor por kilometro
      select valorxkm INTO valorxkmF  from ciudades where nombre=UPPER(city);

    IF valorxkmF IS NULL  THEN
    RAISE city_nofound;
    END IF;
    
    IF diskm < 0 THEN
    RAISE negativeKM;
    END IF;
      
      --calculo valor por distancia
      valdistanci:= valorxkmF * disKM;

   RETURN  valdistanci;

   END VALOR_DISTANCIA; 
    
       
        
        DECLARE
        RESULTADO FLOAT;
        BEGIN
        RESULTADO:=VALOR_DISTANCIA(5,'caliHBH');
        
            dbms_output.put_line('EL COSTO DE MULTIPLICAR VALOR * DISTANCIA ES;   '||RESULTADO); 

        END;
		
		
--PUNTO 6

CREATE OR REPLACE FUNCTION VALOR_TIEMPO(quantityminutes NUMBER, city ciudades.nombre%TYPE)

   RETURN FLOAT IS
   --VARIABLES
   minutesnumber NUMBER;
   
   valviaje float;
   
 --EXCEPCIONES PROPIAS
 city_nofound  EXCEPTION; 
 negativeMIN EXCEPTION;
   BEGIN 
   
   --SELECCIONAR VALOR MINUTO
      select valorxminuto INTO minutesnumber  from ciudades where nombre=UPPER(city);

    IF minutesnumber IS NULL  THEN
    RAISE city_nofound;
    END IF;
    
    IF quantityminutes < 0 THEN
    RAISE negativeMIN;
    END IF;
      
      --VALOR VIAJE
      valviaje:= minutesnumber * quantityminutes;

        RETURN  valviaje;
   
    END VALOR_TIEMPO;


--LANZAR FUNCION
        DECLARE
        RESULTADO FLOAT;
        BEGIN
        RESULTADO:=VALOR_TIEMPO(2,'CALI');
        
            dbms_output.put_line('EL VALOR CALCUALDO ES    '||RESULTADO); 

        END;

--PUNTO 7

CREATE OR REPLACE PROCEDURE CALCULAR_TARIFA(idviaje servicios.id%TYPE)  AS
   
   
   --variables
   estadoP VARCHAR2(255);
   ciudad VARCHAR2(255);
   tarifbase NUMBER;
   valdistancia float;
   valtiempo float;
   sum_detallesviaje number;
   valor_total_viaje float;
   
 --EXCEPCIONES PROPIAS
 excep_dist  EXCEPTION; 
 exep_time EXCEPTION;
   
 
   BEGIN 
   
   --estado del viaje
    select ESTADO into estadoP from servicios where id = idviaje;

--actualizar si el viaje  diferente de realizado
    IF estadoP <> 'REALIZADO'  THEN
    UPDATE facturas SET VALOR_TOTAL = 0 WHERE SERVICIO_ID = idviaje;
    END IF;
    
    --consultar tarifa base 
    select c.TARIFABASEXCIUDAD INTO tarifbase 
    from ciudades c inner join servicios s 
    on s.CIUDAD_ID = c.id where s.id = idviaje;
    
    --consultar ciudad
    select c.nombre into ciudad
    from ciudades c inner join servicios s 
    on s.CIUDAD_ID = c.id where s.id = idviaje;
    
    --calcular valor distancia y tiempo
    valdistancia := valor_distancia(5,ciudad);
    valtiempo := valor_tiempo(45,ciudad); 
    
-- lanzar excepcion
    
IF valdistancia IS NULL  THEN
    RAISE excep_dist;
END IF;  
    
    
    -- lanzar excepcion
IF valtiempo IS NULL THEN    
    RAISE exep_time;
END IF;
    
    --sumar detalles del viaje 
    select SUM(s.propina+s.iva) as sumadetalles into sum_detallesviaje
    from ciudades c inner join servicios s 
    on s.CIUDAD_ID = c.id where s.id = idviaje;   
    
    --calculo del valor total del viaje
    valor_total_viaje := tarifbase + valdistancia + valtiempo + sum_detallesviaje;
    
    --actualizar campo valor total
    update facturas set VALOR_TOTAL = valor_total_viaje where SERVICIO_ID = idviaje;
    
    IF SQL%ROWCOUNT >0 THEN
    DBMS_OUTPUT.PUT_LINE('nos fue muy bien ');
    END IF;
    
EXCEPTION
  WHEN excep_dist THEN DBMS_OUTPUT.PUT_LINE('error al hacer el calculo con distancia');
  WHEN exep_time THEN DBMS_OUTPUT.PUT_LINE('error al hacer el calculo con el tiempo');
  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Se ha producido otra excepción.');     

END CALCULAR_TARIFA;
    

    
       
        BEGIN
        CALCULAR_TARIFA(17);
        END;
		


