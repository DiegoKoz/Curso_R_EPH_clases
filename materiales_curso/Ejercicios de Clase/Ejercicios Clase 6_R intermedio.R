#Reiniciar R

library(tidyverse)
library(openxlsx)
library(ggthemes)
library(ggplot2)


Individual_t117 <- read.table("Fuentes/usu_individual_t117.txt",
                              sep=";", dec=",", header = TRUE, fill = TRUE)
Regiones <- read.xlsx("Fuentes/Regiones.xlsx")
Aglomerados <- read.xlsx("Fuentes/Aglomerados EPH.xlsx")

Base<- Individual_t117 %>% 
  left_join(Regiones) %>% 
  left_join(Aglomerados)

for(Reg in unique(Base$Region)){
  
  #Filtro la base restringiendola a una región
  Base_reg <- Base %>%
    filter(Region == Reg)
  
  Calculo_Ing_Prom <- Base_reg %>% 
    filter(P21>0) %>% 
    group_by(ANO4,TRIMESTRE,Sexo = CH04,Region) %>% 
    summarise(Ing_Prom_Ocup_Ppal = weighted.mean(P21, PONDIIO)) %>% 
    ungroup() %>% 
    mutate(Sexo = case_when(Sexo == 1 ~"Varones",
                            Sexo == 2 ~ "Mujeres"))
Graf <- Calculo_Ing_Prom %>% 
    ggplot(., aes(Sexo, Ing_Prom_Ocup_Ppal, fill = Sexo, 
                            label = round(Ing_Prom_Ocup_Ppal,2)))+
    geom_col(position = "stack", alpha=0.6) + 
    geom_text(position = position_stack(vjust = 0.5), size=3)+
    labs(x="",y="Porcentaje",
         title = unique(Calculo_Ing_Prom$Region))+
    theme_minimal()+
    scale_y_continuous()+
    theme(legend.position = "bottom",
          legend.title=element_blank(),
          axis.text.x = element_text(angle=25))    
print(Graf)  
}
# Crear una **función** llamada _HolaMundo_ que imprima el texto "Hola mundo"
HolaM <- function(){
  print("Hola mundo")
  }

HolaM()

#Crear una **función** que devuelva la sumatoria de los números enteros comprendidos entre 1 y un parámetro _x_ a definir
Sumatoria_enteros <- function(x){
  Vector <- 1:x
  return(sum(Vector))
}

Sumatoria_enteros(x = 10)

# Guardar la base Individual del 1er trimestre de 2017 como un archivo de extensión .RDS
# Volver a levantar la base, pero como .RDS y asignarla con el nombre _BaseRDS_ ¿tarda más o menos?
saveRDS(Individual_t117,"Resultados/Base_formato_r.RDS")
Base_RDS <- readRDS("Resultados/Base_formato_r.RDS")

