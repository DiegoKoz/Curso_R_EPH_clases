####Ejercicios Clase 1 ####
library(openxlsx)
# - Crear un OBJETO llamado _OBJETO_ definido como el resultado de la suma: 5 + 6
OBJETO <- 5+6

# - Crear un VECTOR _VEC0_ que contenga los numeros 1, 3, 4.
VEC0 <- c(1,3,4)

# - Crear 3 vectores ( _VEC1_, _VEC2_, _VEC3_) que sean transformaciones del anterior.
VEC1 <- VEC0*2 
VEC2 <- VEC0^2 
VEC3 <- VEC0-2 

# - Crear 3 vectores con la misma cantidad de elementos que VEC0, pero con variables string (texto) ( _VEC4_, _VEC5_, _VEC6_),  
VEC4 <- c("NO","NO","SI") 
VEC5 <- c("PAGO","PAGO","LIBRE")
VEC6 <- c("SAS","SPSS","R")

# - Crear un dataframe _DFRAME_ como combinación de todos los vectores creados previamente
DFRAME <- data.frame(VEC0,VEC1,VEC2,VEC3,VEC4,VEC5,VEC6)

# - Levantar la base Individual del 1er trimestre de 2017, de la EPH


individual_t117 <- read.table("Fuentes/usu_individual_t117.txt",
                              sep=";",
                              dec=",",
                              header = TRUE,
                              fill = TRUE)


Hoja_CBT <- read.xlsx(xlsxFile ="Fuentes/CANASTAS.xlsx",
                       sheet = "CBT")