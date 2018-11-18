

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





