


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

    
    
    
    