#Reiniciar R


library(tidyverse)

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

Datos %>% 
  filter(INDICE>101 , GRUPO == "Privado_Registrado")

Datos %>% 
  filter(INDICE>101 | GRUPO == "Privado_Registrado")

Datos %>% 
  rename(Periodo = FECHA)

Datos <- Datos %>% 
  mutate(Doble=INDICE*2)

Datos <- Datos %>% 
  mutate(Caso_cuando = case_when(GRUPO == "Privado_Registrado"   ~ INDICE*2,
                                 GRUPO == "Público"              ~ INDICE*3,
                                 GRUPO == "Privado_No_Registrado"~ INDICE*5))

Datos2 <- Datos %>% 
  select(INDICE, FECHA, GRUPO)


Datos <- Datos %>% 
  select(-c(Doble,Caso_cuando))

Datos <- Datos %>% 
  arrange(GRUPO, INDICE)

Datos %>% 
  summarise(Indprom = mean(INDICE))

Datos %>% 
  group_by(FECHA) %>%
  summarise(Indprom = mean(INDICE))

Encadenado <- Datos %>% 
  filter(GRUPO == "Privado_Registrado") %>% 
  rename(Periodo = FECHA) %>% 
  mutate(Doble = INDICE*2) %>% 
  select(-INDICE)


Ponderadores <- data.frame(GRUPO = c("Privado_Registrado","Público","Privado_No_Registrado"),
                           PONDERADOR = c(50.16,29.91,19.93))

Datos_join <- Datos %>% 
  left_join(.,Ponderadores, by = "GRUPO")
Datos_join

Datos_Indice_Gral <- Datos_join %>% 
  group_by(FECHA) %>% 
  summarise(Indice_Gral = weighted.mean(INDICE,w = PONDERADOR))


#__Gather__ es una función que nos permite pasar los datos de forma horizontal a una forma vertical. 
#__spread__ es una función que nos permite pasar los datos de forma vertical a una forma horizontal.
Datos_Spread <- Datos %>% 
  spread(.,       # el . llama a lo que esta atras del %>% 
         key = GRUPO,    #la llave es la variable cuyos valores van a dar los nombres de columnas
         value = INDICE) #los valores con que se llenan las celdas

Datos_Spread  


Datos_gather <- Datos_Spread %>%  
  gather(.,         # el . llama a lo que esta atras del %>% 
         key   = GRUPO,   # como se llamará la variable que toma los nombres de las columnas 
         value = INDICE,  # como se llamará la variable que toma los valores de las columnas
         2:4)             #le indico que columnas juntar

Datos_gather

####EPH####

list.files("Fuentes/")
Individual_t117 <-
  read.table("/Fuentes/usu_individual_t117.txt",
    sep = ";",
    dec = ",",
    header = TRUE,
    fill = TRUE )

library(openxlsx) 

Aglom <- read.xlsx("Fuentes/Aglomerados EPH.xlsx")


###### Variables ###### 

# ESTADO: CONDICIÓN DE ACTIVIDAD 

# 0 = Entrevista individual no realizada ( no respuesta al Cuestionario Individual)
# 1 = Ocupado
# 2 = Desocupado
# 3 = Inactivo
# 4 = Menor de 10 años

# PONDERA: Ponderador 

# INTENSI: 

# 1 = Subocupado por insuficiencia horaria
# 2 = Ocupado pleno
# 3 = Sobreocupado
# 4 = Ocupado que no trabajó en la semana
# 9 = Ns./Nr.

# PP03J:

# Aparte de este/os trabajo/s,¿estuvo buscando algún
# empleo/ocupación/ actividad?
# 1 = Si
# 2 = No
# 9 = Ns./Nr.


#### 1. Principales Indicadores del Mdo de Trabajo #### 
Poblacion_ocupados <- Individual_t117 %>% 
  summarise(Poblacion         = sum(PONDERA),
            Ocupados          = sum(PONDERA[ESTADO == 1]))

Poblacion_ocupados

Empleo <- Individual_t117 %>% 
  summarise(Poblacion         = sum(PONDERA),
            Ocupados          = sum(PONDERA[ESTADO == 1]),
            Tasa_Empleo    = Ocupados/Poblacion)

Empleo

Empleo %>% 
  select(-(1:2))
####Cuadro 1.1 Principales indicadores. Total 31 aglomerados urbanos

Cuadro_1.1a <- Individual_t117 %>% 
  summarise(Poblacion         = sum(PONDERA),
            Ocupados          = sum(PONDERA[ESTADO == 1]),
            Desocupados       = sum(PONDERA[ESTADO == 2]),
            PEA               = Ocupados + Desocupados,
            Ocupados_demand   = sum(PONDERA[ESTADO == 1 & PP03J ==1]),
            Suboc_demandante  = sum(PONDERA[ESTADO == 1 & INTENSI ==1 & PP03J==1]),
            Suboc_no_demand   = sum(PONDERA[ESTADO == 1 & INTENSI ==1 & PP03J %in% c(2,9)]),
            Subocupados       = Suboc_demandante + Suboc_no_demand ,
            # También podemos llamar a las variables entre comillas, incluyendo nombres compuestos
            # A su vez, podemos utilizar la variable recién creada en la definción de otra varible
            'Tasa Actividad'                  = PEA/Poblacion,
            'Tasa Empleo'                     = Ocupados/Poblacion,
            'Tasa Desocupacion'               = Desocupados/PEA,
            'Tasa ocupados demandantes'       = Ocupados_demand/PEA,
            'Tasa Subocupación'               = Subocupados/PEA,
            'Tasa Subocupación demandante'    = Suboc_demandante/PEA,
            'Tasa Subocupación no demandante' = Suboc_no_demand/PEA) 
Cuadro_1.1a 
#### Me quedo unicametne con las columnas que contienen las tasas
Cuadro_1.1a <- Cuadro_1.1a %>% 
  select(-c(1:8))

Cuadro_1.1a
####Doy Vuelta la Tabla para tener en una sola columna las tasas 
Cuadro_1.1a <- Cuadro_1.1a %>% 
  gather(Tasas, Valor, 1:ncol(.))

Cuadro_1.1a
####Aplico un "truco" para agregarle el valor en %
Cuadro_1.1a <- Cuadro_1.1a %>% 
  mutate(Valor = sprintf("%1.1f%%", 100*Valor))

Cuadro_1.1a

########### Cuadro 1.2
Cuadro_1.2a <- Individual_t117 %>% 
  group_by(AGLOMERADO) %>% 
  summarise(Poblacion         = sum(PONDERA),
            Ocupados          = sum(PONDERA[ESTADO == 1]),
            Desocupados       = sum(PONDERA[ESTADO == 2]),
            PEA               = Ocupados + Desocupados,
            Ocupados_demand   = sum(PONDERA[ESTADO == 1 & PP03J == 1]),
            Suboc_demandante  = sum(PONDERA[ESTADO == 1 & INTENSI == 1 & PP03J == 1]),
            Suboc_no_demand   = sum(PONDERA[ESTADO == 1 & INTENSI == 1 & PP03J %in% c(2, 9)]),
            Subocupados       = Suboc_demandante + Suboc_no_demand,
            'Tasa Actividad'                  = PEA/Poblacion,
            'Tasa Empleo'                     = Ocupados/Poblacion,
            'Tasa Desocupacion'               = Desocupados/PEA,
            'Tasa ocupados demandantes'       = Ocupados_demand/PEA,
            'Tasa Subocupación'               = Subocupados/PEA,
            'Tasa Subocupación demandante'    = Suboc_demandante/PEA,
            'Tasa Subocupación no demandante' = Suboc_no_demand/PEA)

####Aplico de forma encadenada los procedimientos para emprolijar los resultados
Cuadro_1.2a <- Cuadro_1.2a %>% 
  select(-c(2:9)) %>%    # Eliminamos las variables de nivel
  left_join(.,Aglom) %>% # Agregamos el nombre de los aglomerados, que teniamos en otro DF
  select(Nom_Aglo,everything(.),-AGLOMERADO) #Eliminamos el código de los aglomerados

Cuadro_1.2a


####Exportamos archivos####
Lista_a_exportar <- list("Cuadro 1.1" = Cuadro_1.1a,
                         "Cuadro 1.2" = Cuadro_1.2a)

write.xlsx(Lista_a_exportar, "Resultados/Informe Mercado de Trabajo.xlsx")

