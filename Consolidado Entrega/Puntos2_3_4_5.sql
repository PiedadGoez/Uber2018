
--Jham pier alzate cardona
--Piedad Goez
--Carlos mario gomez

--punto 2 

CREATE TABLESPACE uber
DATAFILE 'UBER' SIZE 2G
EXTENT MANAGEMENT LOCAL AUTOALLOCATE;


CREATE UNDO TABLESPACE bdUndo
DATAFILE 'bdUndo' SIZE 25M;


CREATE BIGFILE TABLESPACE bigUber
DATAFILE 'bigUber' SIZE 5G;



ALTER SYSTEM SET UNDO_TABLESPACE = bdUndo;


----------------------------

--Punto 3

--CREATE ROLE new_dba;

CREATE USER DBAuser 
IDENTIFIED BY DBAuser
DEFAULT TABLESPACE uber 
QUOTA UNLIMITED ON uber;
    
    
GRANT DBA TO DBAuser;   
    
GRANT new_dba TO DBAuser WITH ADMIN OPTION;

GRANT CONNECT TO DBAuser;


----------------------------------------------------------------

--4. create 2 profile
--A


CREATE PROFILE clerk  LIMIT
SESSIONS_PER_USER       1
IDLE_TIME               10
PASSWORD_LIFE_TIME      40
FAILED_LOGIN_ATTEMPTS   4;


--B

CREATE PROFILE development  LIMIT
SESSIONS_PER_USER            2
IDLE_TIME                   30
PASSWORD_LIFE_TIME         100
FAILED_LOGIN_ATTEMPTS      UNLIMITED;



----------------------------------------------------------------

--punto 5 del taller

CREATE USER anchetotti 
IDENTIFIED BY anchetotti
DEFAULT TABLESPACE uber 
QUOTA UNLIMITED ON uber
PROFILE clerk;


CREATE USER piedad 
IDENTIFIED BY piedad
DEFAULT TABLESPACE uber 
QUOTA UNLIMITED ON uber
PROFILE clerk;

CREATE USER jham 
IDENTIFIED BY jham
DEFAULT TABLESPACE uber 
QUOTA UNLIMITED ON uber
PROFILE development;


CREATE USER alberto 
IDENTIFIED BY alberto
DEFAULT TABLESPACE uber 
QUOTA UNLIMITED ON uber
PROFILE development;


GRANT CONNECT TO anchetotti,piedad,jham,alberto;

ALTER USER anchetotti ACCOUNT LOCK;





















