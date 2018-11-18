

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

    