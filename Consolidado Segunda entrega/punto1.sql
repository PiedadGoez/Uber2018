CREATE VIEW MEDIOS_PAGO_CLIENTES AS
    SELECT usuarios.ID AS CLIENTE_ID, usuarios.nombre, medios_de_pagos.ID AS MEDIO_PAGO_ID, medios_de_pagos.NOMBRE AS TIPO, 
    usuarios_medios_pagos.detalle_forma_pago, usuarios_medios_pagos.EMPRESARIAL, usuarios_medios_pagos.nombre_empresa
    FROM usuarios
    INNER JOIN usuarios_medios_pagos 
    ON usuarios.ID = usuarios_medios_pagos.fk_usuario
    INNER JOIN medios_de_pagos ON 
    usuarios_medios_pagos.fk_medio_pago = medios_de_pagos.ID
WITH CHECK OPTION;