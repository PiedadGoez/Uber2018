CREATE TABLESPACE uber
DATAFILE 'UBER' SIZE 2G
EXTENT MANAGEMENT LOCAL AUTOALLOCATE;


CREATE UNDO TABLESPACE bdUndo
DATAFILE 'bdUndo' SIZE 25M;


CREATE BIGFILE TABLESPACE bigUber
DATAFILE 'bigUber' SIZE 5G;















