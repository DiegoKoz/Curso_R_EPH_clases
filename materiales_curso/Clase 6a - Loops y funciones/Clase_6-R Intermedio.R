# Reiniciar

library(tidyverse)
library(openxlsx)
library(ggthemes)

# Loops
for(i in 1:10){
  print(i^2)
  
}

for(Valores in 1:10){
  print(Valores^2)
  
}

Individual_t117 <- read.table("Fuentes/usu_individual_t117.txt",
                              sep=";", dec=",", header = TRUE, fill = TRUE)
Regiones <- read.xlsx("Fuentes/Regiones.xlsx")
Aglomerados <- read.xlsx("Fuentes/Aglomerados EPH.xlsx")


Base<- Individual_t117 %>% 
  left_join(Regiones) %>% 
  left_join(Aglomerados)

#Para iterar sobre la variable región, no necesitamos recorrer todos los valores de la misma, sino por los **valores únicos**. Es decir, que vamos a querer realizar un loop que realizará un mismo procedimiento 6 veces. Para ello, utilizaremos la función **unique** que nos permite obtener un vector con los únicos valores que toma determinada variable.
unique(Base$Region)

for(variable_itera in unique(Base$Region)){
  print(variable_itera)# No es necesario, permite ver por que Región estoy trabajando
  
  temp <- Base %>% # Aquí filtro la base cuando Region toma el valor de "variable_itera"
    filter(Region == variable_itera)
  
  ##Temp es un dataframe que será "pisado" en cada iteración.
  #La función assign me permite definir a un objeto utilizando como primer argumento el nombre deseado 
  assign(variable_itera,temp)
}

# Estructuras Condicionales

##if
if(2+2 == 4){
  print("Menos Mal")
}

if( 2+2 == 148.24){
  print("R, la estas pifiando")
}

##ifelse
resultado <- ifelse(2 + 2 == 4, yes =  "Joya",no = "Error")

ABC_123 <- data.frame(Letras = LETTERS[1:20],Num = 1:20)
ABC_123 %>% 
  mutate(Mayor_o_Menor = ifelse(Num<=5,"Menor o igual que 5","Mayor que 5"))

#Ejercicio práctico combinando Loops y estructuras condicionales
#Antes de comenzar el Loop, recodifico las variables 
Base_para_loop <- Base %>% 
  mutate(CH04 = case_when(CH04 == 1 ~ "Varon",
                          CH04 == 2 ~ "Mujer"),
         CAT_OCUP = case_when(CAT_OCUP == 1  ~ "Patron",
                              CAT_OCUP == 2  ~ "Cuenta Propia",
                              CAT_OCUP == 3  ~ "Asalariados",
                              CAT_OCUP == 4  ~ "TFSR"))


for(aglom_itera in unique(Base_para_loop$AGLOMERADO)){
  
  #Filtro la base restringiendola a un aglomerado
  Base_itera_xaglom <- Base_para_loop %>%
    filter(AGLOMERADO == aglom_itera)
  
  #Exijo los procedimientos a continuación sólo se realicen para aglomerados con más de 500.000 habitantes
  
  if(unique(Base_itera_xaglom$MAS_500)=="S"){
    
    Base_grafico  <- Base_itera_xaglom %>% 
      filter(CAT_OCUP != 0) %>% 
      group_by(Nom_Aglo,CAT_OCUP,CH04) %>% 
      summarise(Cantidad = sum(PONDERA,na.rm = TRUE)) %>% 
      group_by(CAT_OCUP) %>%     
      mutate(Porcentaje = Cantidad/sum(Cantidad))
    
    Grafico <- ggplot(Base_grafico, aes(CAT_OCUP, Porcentaje, fill = CH04, 
                                        label = sprintf("%1.1f%%", 100*Porcentaje)))+
      geom_col(position = "stack", alpha=0.6) + 
      geom_text(position = position_stack(vjust = 0.5), size=3)+
      labs(x="",y="Porcentaje",
           title = unique(Base_grafico$Nom_Aglo))+
      theme_minimal()+
      scale_y_continuous()+
      theme(legend.position = "bottom",
            legend.title=element_blank(),
            axis.text.x = element_text(angle=25))    
    
    Grafico 
    
    ggsave(paste0("Resultados/Aglomerado ",aglom_itera,".PNG"))
  }
}

#A continuación se muestra el último de los gráficos relizados por el loop. En la carpeta de __Resultados__ del curso, podran observarse cada uno de los gráficos correspondientes a los algomerados de más de 500.000 habitantes. 
Grafico

# Funciones del Usuario

funcion_prueba <- function(parametro1,parametro2) {
  paste(parametro1, parametro2, sep = " <--> ")
}

funcion_prueba(parametro1 = "A ver", parametro2 = "Que pasa")

Otra_funcion_prueba <- function(parametro1 ,parametro2 = "Te colgaste en ingresar algo") {
  paste(parametro1, parametro2, sep = " <--> ")
  
}
Otra_funcion_prueba(parametro1 = "Valor 1 ")



##### map ####


resultado <- map2(ABC_123$Letras,ABC_123$Num,funcion_prueba)
resultado[1:3]


ABC_123 %>% 
  mutate(resultado= map2(Letras,Num,funcion_prueba))


ABC_123 %>% 
  mutate(resultado= unlist(map2(Letras,Num,funcion_prueba)))


map(ABC_123$Letras,funcion_prueba,ABC_123$Num)[1:2]


ABC_123 %>% 
  mutate(resultado= map(Letras,funcion_prueba,Num))



# Lectura y escritura de archivos intermedia
## RData
x <- 1:15
y <- list(a = 1, b = TRUE, c = "oops")

#Para guardar
save(x, y, file = "Clase 6a - Loops y funciones/xy.RData")

#Para leer
load('Clase 6a - Loops y funciones/xy.RData')
## __RDS__
x
saveRDS(x, "Clase 6a - Loops y funciones/x.RDS")

Z <- readRDS("Clase 6a - Loops y funciones/x.RDS")
Z
