rm(list=ls())

A <- 1

A 
A+6
B = 2
B
A <- B
A   #Ahora A toma el valor de B, y B continua conservando el mismo valor
B
## R base

#Redefinimos los valores A y B
A <-  10
B  <-  20
#Realizamos comparaciones lógicas

A >  B
A >= B
A <  B
A <= B
A == B
A != B

C <- A != B
C
## Operadores aritméticos:

#suma
A <- 5+6
A
#Resta
B <- 6-8
B
#cociente
C <- 6/2.5
C
#multiplicacion
D <- 6*2.5
D

## Funciones:
paste("Pega","estas",4,"palabras", sep = " ")

#Puedo concatenar caracteres almacenados en objetos
paste(A,B,C,sep = "**")

# Paste0 pega los caracteres sin separador
paste0(A,B,C)

1:5

sum(1:5)
mean(1:5,na.rm = TRUE)


A <-  1
class(A)


A <-  paste('Soy', 'una', 'concatenación', 'de', 'caracteres', sep = " ")
A
class(A)

A <- factor("Soy un factor, con niveles fijos")
class(A)


### Vectores

C <- c(1, 3, 4)
C

C <- C + 2
C

D <- C + 1:3 #esto es equivalente a hacer 3+1, 5+2, 6+9 
D



E <- c("Carlos","Federico","Pedro")
E


E[2]

elemento2 <-  E[2]
elemento2
rm(elemento2)
elemento2
E[2] <- "Pablo"
E

### Data Frames

INDICE  <- c(100,   100,   100,
             101.8, 101.2, 100.73,
             102.9, 102.4, 103.2)

FECHA  <-  c("Oct-16", "Oct-16", "Oct-16",
             "Nov-16", "Nov-16", "Nov-16",
             "Dic-16", "Dic-16", "Dic-16")


GRUPO  <-  c("Privado_Registrado","Público","Privado_No_Registrado",
             "Privado_Registrado","Público","Privado_No_Registrado",
             "Privado_Registrado","Público","Privado_No_Registrado")


Datos <- data.frame(INDICE, FECHA, GRUPO)
Datos


Datos$FECHA
Datos[3,2]
Datos$FECHA[3]

Datos$FECHA[3,2]

Datos[Datos$FECHA=="Dic-16",]

###Por separado
Indices_Dic <- Datos$INDICE[Datos$FECHA=="Dic-16"]
Indices_Dic

mean(Indices_Dic)

### Todo junto
mean(Datos$INDICE[Datos$FECHA=="Dic-16"])

### Listas
superlista <- list(A,B,C,D,E,FECHA, DF = Datos, INDICE, GRUPO)
superlista

superlista$DF$FECHA[2]


# Lectura y escritura de archivos

## .csv  y  .txt
individual_t117 <- read.table(file = 'Fuentes/usu_individual_t117.txt',sep=";", dec=",", header = TRUE, fill = TRUE)


#View(individual_t117)
names(individual_t117)
summary(individual_t117)[,c(8,10,31,133)]
head(individual_t117)[,1:5]

## Excel 
# install.packages("openxlsx") # por única vez
library(openxlsx) #activamos la librería

#creamos una tabla cualquiera de prueba
x <- 1:10
y <- 11:20
tabla_de_R <- data.frame(x,y)

# escribimos el archivo
write.xlsx( x = tabla_de_R, file = "archivo.xlsx",row.names = FALSE)
#Donde lo guardó? Hay un directorio por default en caso de que no hayamos definido alguno.
getwd()

#Si queremos exportar multiples dataframes a un Excel, debemos armar previamente una lista de ellos. Cada dataframe, se guardará en una pestaña de excel, cuyo nombre correspondera al que definamos para cada Dataframe a la hora de crear la lista.
Lista_a_exportar <- list("Indices Salarios" = Datos,
                         "Tabla Numeros" = tabla_de_R)

write.xlsx( x = Lista_a_exportar, file = "archivo_2_hojas.xlsx",row.names = FALSE)

#leemos el archivo especificando la ruta (o el directorio por default) y el nombre de la hoja que contiene los datos
Indices_Salario <- read.xlsx(xlsxFile = "archivo_2_hojas.xlsx",sheet = "Indices Salarios")
#alternativamente podemos especificar el número de orden de la hoja que deseamos levantar
Indices_Salario <- read.xlsx(xlsxFile = "archivo_2_hojas.xlsx",sheet = 1)
Indices_Salario

