

--plan ejecuccion 1

explain plan set STATEMENT_ID='pe'  into plan_table for
select * from VIAJES_CLIENTES;
select plan_table_output from table(dbms_xplan.display('plan_table','pe','typical'));


--plan ejecuccion 2 mejorado
explain plan set STATEMENT_ID='q1'  into plan_table for
select * from VIAJES_CLIENTES where nombre='Silvestre Gallardo';
select plan_table_output from table(dbms_xplan.display('plan_table','q1','typical'));
CREATE INDEX VIAJE_ID_USER_NAME_idx ON USUARIOS(ID,NOMBRE); 

