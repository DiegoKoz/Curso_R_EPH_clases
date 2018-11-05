#Datos De Panel 
rm(list=ls())

library(tidyverse, warn = FALSE)

individual.216 <- read.table("Fuentes/usu_individual_t216.txt", sep=";", dec=",", header = TRUE, fill = TRUE)
individual.316 <- read.table("Fuentes/usu_individual_t316.txt", sep=";", dec=",", header = TRUE, fill = TRUE)
individual.416 <- read.table("Fuentes/usu_individual_t416.txt", sep=";", dec=",", header = TRUE, fill = TRUE)
individual.117 <- read.table("Fuentes/usu_individual_t117.txt", sep=";", dec=",", header = TRUE, fill = TRUE)
## Pasos para la construccion del Panel
# 1. Creamos un Vector que contenga unicamente las variables de interés, para recortar luego la base con la funcion __select__.      
# 2. Unimos todas las bases con la función __bind_rows__, seleccionando solo las variables del vector.
# 3. Filtramos de la base los casos de no respuesta y acotaremos en este ejercicio el analisis a la población entre 18 y 65 años.  
# 4. Creamos las categorías de análisis que deseamos observar en distintos perídos.
# 5. Armamos un _identificador ordinal_ para los registros de cada trimestre.
# 6. Replicamos el dataframe construido y le cambiamos los nombres a todas las variables, a excepción de las que usaremos para identificar a un mismo individuo ( _CODUSU_, _NRO_HOGAR_, _COMPONENTE_).
# 7. En la base replicada, modificamos el _identificador ordinal_ en función de la amplitud que deseamos en las observaciones de panel. En nuestro caso como uniremos registros con distancia de 1 trimestre, le restamos _1_ a cada valor
# 8. Unimos ambas bases con la funcion __inner_join__ que solo nos dejará registros que en ambas bases contengan los mismos _CODUSU_, _NRO_HOGAR_, _COMPONENTE_ e _identificador ordinal_.
# 9. Creamos la columna para las consistencias, y luego filtramos la base para eliminar los registros inconsistentes

#Paso 1
var.ind <- c('CODUSU','NRO_HOGAR','COMPONENTE', 'ANO4','TRIMESTRE','ESTADO','CAT_OCUP','PONDERA', 'CH04', 'CH06','P21','PP3E_TOT')

#Paso 2  
Bases_Continua <- bind_rows(
  individual.216  %>% select(var.ind),
  individual.316  %>% select(var.ind),
  individual.416  %>% select(var.ind),
  individual.117  %>% select(var.ind))
#Pasos 3  y 4
Bases_Continua <-  Bases_Continua %>% 
      filter(CH06 %in% c(18:65),ESTADO !=0) %>% 
      mutate(Categoria = case_when(ESTADO %in%  c(3,4)~"Inactivos",
                                   ESTADO   ==  2 ~"Desocupados",
                                   ESTADO   ==  1 & CAT_OCUP == 1 ~"Patrones",
                                   ESTADO   ==  1 & CAT_OCUP == 2 ~"Cuenta Propistas",
                                   ESTADO   ==  1 & CAT_OCUP == 3 ~"Asalariados",
                                   ESTADO   ==  1 & CAT_OCUP == 4 ~"Trabajador familiar s/r",
                              TRUE ~ "Otros"))
#Paso  5
Bases_Continua <- Bases_Continua %>% 
    mutate(Trimestre = paste(ANO4, TRIMESTRE, sep="_")) %>% 
    arrange(Trimestre) %>% 
    mutate(Id_Trimestre = match(Trimestre,unique(Trimestre)))

#Paso 6
Bases_Continua_Replica <- Bases_Continua

names(Bases_Continua_Replica)

names(Bases_Continua_Replica)[4:(length(Bases_Continua_Replica)-1)] <- 
  paste0(names(Bases_Continua_Replica)[4:(length(Bases_Continua_Replica)-1)],"_t1")

names(Bases_Continua_Replica)

#Paso 7
Bases_Continua_Replica$Id_Trimestre <- Bases_Continua_Replica$Id_Trimestre - 1
#Pasos 8 y 9
Panel_Continua <- inner_join(Bases_Continua,Bases_Continua_Replica)
Panel_Continua <- Panel_Continua %>% 
    mutate(Consistencia = case_when(abs(CH06_t1-CH06) > 2 |
                                    CH04 != CH04_t1 ~ "inconsistente",
                                    TRUE ~ "consistente")) %>% 
    filter(Consistencia == "consistente")

#Matrices de transición
## Calculo de probabilidades de transición. 

Categorias_transiciones <- Panel_Continua %>% 
  #filter(Categoria != Categoria_t1) %>% 
  group_by(Categoria,Categoria_t1) %>% 
  summarise(frec_muestral = n(),
            frecuencia = sum((PONDERA+PONDERA_t1)/2)) %>% 
  ungroup() %>% 
  group_by(Categoria) %>% 
  mutate(Prob_salida = frecuencia/sum(frecuencia))

Categorias_transiciones

##Gráfico de Matriz de Transición

library(ggthemes)
ggplot(Categorias_transiciones, aes(x = Categoria_t1, 
                                    y = Categoria, fill = Prob_salida,
                                    label =round(Prob_salida*100,2))) +
  labs(title = "Probabilidades de Transicion de hacia las distintas Categorías")+
  geom_tile()+
  geom_text()+
  scale_fill_gradient(low = "grey100", high = "grey30")+
  theme_tufte()

