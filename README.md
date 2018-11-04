# Curso R EPH

Curso de R para procesamiento de datos de la Encuesta Permanente de Hogares

## Ediciones:

Edición actual: INDEC + CEPED 2018 (Guido Weksler, Diego Kozlowski y Natsumi Shokida)

Ediciones anteriores:

- CEPED (Diego Kozlowski y Guido Weksler)-2017
- INDEC (Guido Weksler y Natsumi Shokida)-2017
- UNGS (Guido Weksler y Matias Lioni)-2018


## Programa actual

### Clase 1 - Conceptos Principales de EPH y R Base:

- Encuesta Permanente de Hogares: Lineamientos conceptuales y metodología
    - Abordaje del marco teórico de la EPH y sus aplicaciones prácticas.
    - Síntesis del operativo de campo, cobertura y periodicidad de la Encuesta
    - Definiciones de las principales variables de interés a abordar en el curso: Estados, categorías ocupacionales, ingresos y ponderadores. 
    - Metodología usuaria de las Bases de microdatos. Utilización del Diseño de Registro.

- Descripción del programa “R”. Lógica sintáctica del lenguaje R y comandos básicos:
    - Características del “R” y Comparación con software similares
    - Caracteres especiales en “R”
    - Operadores lógicos y aritméticos
    - Definición de Objetos: Valores, Vectores y DataFrames
    - Lectura y Escritura de Archivos  

Ejercicios de práctica a realizar por los participantes en clase, a partir de los conceptos abordados

### Clase 2 - Manipulación de Bases de Datos y Mercado de Trabajo:

- Funciones principales para el trabajo con bases de datos (paquete “tidyverse”):
    - Renombrar, recodificar y seleccionar variables
    - Ordenar y agrupar la base de datos para realizar cálculos
    - Creación de nuevas variables
    - Aplicar filtros sobre la base de datos
    - Construir medidas de resumen de la información

- Ejemplo práctico: Réplica del Informe Técnico de Mercado de Trabajo (EPH-INDEC)
    - Cálculo de las tasas básicas del mercado de trabajo (Tasa de Actividad, Empleo, Desempleo, etc).
    - Cálculo de las tasas para distintos subconjuntos poblacionales (Según aglomerado, sexo, grupos de edad)

Ejercicios de práctica a realizar por los participantes en clase, a partir de los conceptos abordados

### Clase 3: Cálculo de tasas de Pobreza e Indigencia.

Metodología del cálculo de pobreza por línea (para personas y hogares). Abordaje de los conceptos involucrados en la medición:

- Umbrales de necesidades energéticas y proteicas establecidas en función de la edad y el sexo.
- Unidades de Adulto Equivalente
- Definición de la canastas: Población de Referencia, composición de la Canasta Básica Alimentaria, coeficiente de Engel y Canasta Básica Total, Diferenciación regional.
- Pobreza como fenómeno propio al hogar: utilización de la variable y el ponderador correspondiente a los ingresos del hogar

Ejercicios de estimaciones trimestrales de tasas de pobreza e indigencia: 

- Pasos a seguir para realizar el cálculo, y utilización de las funciones provistas en la clase 2 para desarrollar el código correspondiente.
- Ejercicio de estimación Trimestral de tasas de Pobreza e Indigencia para distintos subgrupos poblacionales (Género, Edad, Regiones)

Ejercicios de práctica a realizar por los participantes en clase, a partir de los conceptos abordados y entrega de la consigna para el trabajo práctico final.

### Clase 4 - Gráficos y variables de ingresos en la EPH:

- Procesamiento de la base para indicadores agregados sobre las variables de ingresos (Ingresos Laborales, No laborales, de Ocupación Principal, Total Familiar)
- Gráficos básicos de R (función “plot”): Comandos para la visualización ágil de la información
-  Gráficos elaborados de R (función “ggplot”):
  -  Gráficos de línea, barras, Boxplots y distribuciones de densidad.
  -  Definición de parámetros de los gráficos: Leyendas, ejes, títulos, notas, colores.
  -  Gráficos con múltiples cruces de variables.

Ejercicios de práctica a realizar por los participantes en clase, a partir de los conceptos abordados 

###  Clase 5 - Elaboración de documentos en R e indicadores de desigualdad de género:

- Manejo de las extensiones del software “Rmarkdown” y “RNotebook” para elaborar documentos de trabajo, presentaciones interactivas e informes. 
-  Opciones para mostrar u ocultar código en los reportes

-  Definición de tamaño, títulos y formato con el cual se desplegan los gráficos y tablas en el informe.

    -  Caracteres especiales para incluir múltiples recursos en el texto del informe: Links a páginas web, notas al pie, enumeraciones, cambios en el formato de letra (tamaño, negrita, cursiva)

 -  Código embebido en el texto para automatización de reportes

- Utilización de la herramienta para el armado de un informe trimestral de indicadores de género.
     -  Cálculo de múltiples indicadores desagregados por sexo: Indicadores de participación laboral, calidad del vínculo laboral, acceso a cargos jerárquicos, brechas de ingresos, distribución del ingreso y de las tareas del hogar.

     -  Visualización gráfica de los resultados dentro del documento y métodos para la publicación directa del documento desde el programa


###  Clase 6 - R intermedio y Pool de Datos en Panel:

- Abordaje de técnicas más sofisticadas en R útiles para automatizar el procesamiento periódico de la información:
-  Loops
-  Creación de funciones a medida del usuario
-  Estructuras condicionales
- Ayudas del R: Foros reconocidos de usuarios de R, comandos para acceder a la descripción de funciones desconocidas.

- Introducción a la técnica de datos en panel para la realización de estudios longitudinales:
    - Conceptos y metodología necesaria para el trabajo de panel con la EPH: Esquema de rotación de la encuesta, variables para la identificación de los individuos y hogares en distintos períodos, armado de consistencias
    - Procesamiento para la construcción de pools de datos en panel en R.
    - Cálculo de Frecuencias de transiciones de estados (Categorías Ocupacionales, Situaciones de Pobreza/Indigencia)
    - Gráficos de Transición de estados

Ejercicios de práctica a realizar por los participantes en clase, a partir de los conceptos abordados