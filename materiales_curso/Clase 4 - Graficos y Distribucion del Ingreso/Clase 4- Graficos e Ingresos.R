#RESTART R

# iris es un set de datos clásico, que ya viene incorporado en R
iris
plot(iris)

data(iris)
plot(iris$Sepal.Length,type = "p")
plot(iris$Sepal.Length,type = "l")
plot(iris$Sepal.Length,type = "b")
hist(iris$Sepal.Length, col = "lightsalmon1", main = "Histograma")

archivo <- "Resultados/grafico1.PNG"
archivo
png(archivo)
plot(iris$Sepal.Length,type = "b")
dev.off()

library(ggplot2)
ggplot(data = iris, aes(x = Sepal.Length, fill = Species))+
  geom_histogram(alpha=0.75, binwidth = .5)+
  facet_wrap(~Species)+
  labs("Histograma por especie")+
  theme(legend.position = 'none')

##"Capa del gráfico 1"
ggplot(data = iris, aes(x = Petal.Length, Petal.Width, color = Species))

##"Capa del gráfico 2"
ggplot(data = iris, aes(x = Petal.Length, Petal.Width, color = Species))+
  geom_point(alpha=0.25)

##"Capa del gráfico 3 a 5"
ggplot(data = iris, aes(x = Petal.Length, Petal.Width, color = Species))+
  geom_point(alpha=0.25)+
  labs(title = "Medidas de los pétalos por especie")+
  theme(legend.position = 'none')+
  facet_wrap(~Species)

library(tidyverse) # tiene ggplot, dplyr, tidyr, y otros
library(ggthemes)  # estilos de gráficos
library(ggrepel)   # etiquetas de texto más prolijas que las de ggplot

####Levanto Bases####
Individual_t117 <- read.table("Fuentes/usu_individual_t117.txt",
                              sep=";", dec=",", header = TRUE, fill = TRUE)
Individual_t216 <- read.table("Fuentes/usu_individual_t216.txt",
                              sep=";", dec=",", header = TRUE, fill = TRUE) %>% 
  select(ANO4,TRIMESTRE,P21,PONDIIO,IPCF, PONDIH)

Individual_t316 <- read.table("Fuentes/usu_individual_t316.txt",
                              sep=";", dec=",", header = TRUE, fill = TRUE)%>% 
  select(ANO4,TRIMESTRE,P21,PONDIIO,IPCF, PONDIH)

Individual_t416 <- read.table("Fuentes/usu_individual_t416.txt",
                              sep=";", dec=",", header = TRUE, fill = TRUE)%>% 
  select(ANO4,TRIMESTRE,P21,PONDIIO,IPCF, PONDIH)


####GINI####
Union_Bases <- bind_rows(Individual_t216, 
                         Individual_t316,
                         Individual_t416,
                         Individual_t117) %>% 
  mutate(periodo = paste(ANO4, TRIMESTRE, sep = "_")) 

IOppal <-Union_Bases   %>% 
  filter(P21>0) %>% 
  group_by(periodo) %>% 
  summarise(IOppal_prom = weighted.mean(P21, PONDIIO)) 

####GRAFICOS####
ggplot(data = IOppal, aes(x = periodo, y = IOppal_prom)) + 
  geom_point()

IOppal %>% #Podemos usar los "pipes" para llamar al Dataframe que continen la info
  ggplot(aes(x = periodo,
             y = IOppal_prom,
             group = 'IOppal_prom',#Agrupar nos permitirá generar las lineas del gráfico
             label= round(IOppal_prom,2))) +  #Agregamos una etiqueta a los datos (Redondeando la variable a 2 posiciones decimales)
  labs(x = "Trimestre",
       y = "IPCF promedio",
       title = "Ingreso promedio por la ocupación principal", subtitle = "Serie 2trim_2016 - 1trim_2017", caption = "Fuente: EPH")+ #Agregamos titulo y modificamos  ejes
  geom_point(size= 3)+ #puedo definir tamaño de las lineas
  geom_line( size= 1 )+
  geom_text_repel(nudge_y = 500, nudge_x = 0.25)+ #Agrego etiquetas con el texto. Las corro hacia arriba (nudge_y) y a la izquierda(nudge_x)
  theme_minimal()+ #Elijo un tema para el gráfico
  theme(legend.position = "none") #Elimino la leyenda

ggsave(filename = "Resultados/IPCF_prom.png") #Guardo el Grafico


##Ingreso per capita familiar
Ing_prom_hogar <- bind_rows(Individual_t216, 
                            Individual_t316,
                            Individual_t416,
                            Individual_t117) %>%
  select(ANO4,TRIMESTRE, IPCF, PONDIH) %>% 
  mutate(periodo = paste(ANO4, TRIMESTRE, sep = "\n")) %>% 
  group_by(periodo) %>% 
  summarise(IPCF_prom = weighted.mean(IPCF, PONDIH)) %>% 
  ungroup()

####Grafico
Ing_prom_hogar %>% 
  ggplot(aes(x = periodo,
             y = IPCF_prom,
             group = 'IPCF_prom',
             label= round(IPCF_prom,2))) +
  labs(x = "Trimestre",
       y = "IPCF promedio",
       title = "Ingreso per capita familiar promedio", subtitle = "Serie 2trim_2016 - 1trim_2017", caption = "Fuente: EPH")+ 
  geom_line( size= 1 )+
  geom_point(size= 3)+ 
  geom_label_repel(nudge_y = 250,fill="gray80")+ #Aplico otro tipo de etiqueta,
  theme_light()+ #Elijo otro tema para el grafico
  theme(legend.position = "none")

ggsave(filename = "Resultados/IPCF_prom.png") #Guardo el Grafico


## Distribución de los ingresos laborales y no laborales por sexo
datagraf_2 <-Individual_t117 %>% 
  select(P47T,T_VI, TOT_P12, P21 , PONDII, CH04,NIVEL_ED) %>% 
  filter(!is.na(P47T), P47T > 0 ) %>% 
  mutate(ingreso_laboral    = as.numeric(TOT_P12 + P21),
         ingreso_no_laboral = as.numeric(T_VI),
         ingreso_total      = ingreso_laboral + ingreso_no_laboral,
         CH04               = case_when(CH04 == 1 ~ "Varon",
                                        CH04 == 2 ~ "Mujer")) %>% 
  group_by(CH04) %>% 
  summarise('ingreso laboral'    = sum(ingreso_laboral*PONDII)/sum(ingreso_total*PONDII),
            'ingreso no laboral' = sum(ingreso_no_laboral*PONDII)/sum(ingreso_total*PONDII))

datagrafico <- datagraf_2 %>%
  gather(tipo_ingreso, monto,2:3 ) 

ggplot(datagrafico, aes(CH04, monto, fill = tipo_ingreso, 
                        label = sprintf("%1.1f%%", 100*monto)))+
  #facet_grid(.~Educacion)+
  geom_col(position = "stack", alpha=0.6) + 
  geom_text(position = position_stack(vjust = 0.5), size=3)+
  labs(x="",y="Porcentaje")+
  theme_tufte()+
  scale_y_continuous()+
  theme(legend.position = "bottom",
        legend.title=element_blank(),
        axis.text.x = element_text(angle=25))


ggsave(filename = "Resultados/ingresos laborales y no laborales.png",scale = 2)

##Agrego al procedimiento anterior una clasificación de las edades
datagraf_3 <-Individual_t117 %>% 
  select(P47T,T_VI, TOT_P12, P21 , PONDII, CH04,CH06) %>% 
  filter(!is.na(P47T), P47T > 0 , CH06 %in% c(18:60)) %>% 
  mutate(ingreso_laboral    = as.numeric(TOT_P12 + P21),
         ingreso_no_laboral = as.numeric(T_VI),
         ingreso_total      = ingreso_laboral + ingreso_no_laboral,
         CH04               = case_when(CH04 == 1 ~ "Varon",
                                        CH04 == 2 ~ "Mujer"),
         EDAD = case_when(CH06 %in% c(18:30) ~ "18 a 30",
                          CH06 %in% c(31:45) ~"31 a 45",
                          CH06 %in% c(46:60) ~ "46 a 60")) %>% 
  group_by(CH04,EDAD) %>% 
  summarise('ingreso laboral'    = sum(ingreso_laboral*PONDII)/sum(ingreso_total*PONDII),
            'ingreso no laboral' = sum(ingreso_no_laboral*PONDII)/sum(ingreso_total*PONDII)) %>%
  gather(tipo_ingreso, monto,3:4) 

ggplot(datagraf_3, aes(CH04, monto, fill = tipo_ingreso, 
                       label = sprintf("%1.1f%%", 100*monto)))+
  #facet_grid(.~Educacion)+
  geom_col(position = "stack", alpha=0.6) + 
  geom_text(position = position_stack(vjust = 0.5), size=3)+
  labs(x="",y="Porcentaje")+
  theme_tufte()+
  scale_y_continuous()+
  theme(legend.position = "bottom",
        legend.title=element_blank(),
        axis.text.x = element_text(angle=25))+
  facet_wrap(~EDAD)

#### Boxplot de ingresos de la ocupación principal, según nivel educativo
# Las variables sexo( CH04 ) y Nivel educativo están codificadas como números, y el R las entiende como numéricas.
class(Individual_t117$NIVEL_ED)
class(Individual_t117$CH04)

ggdata <- Individual_t117 %>% 
  filter(P21>0, !is.na(NIVEL_ED)) %>% 
  mutate(NIVEL_ED = as.factor(NIVEL_ED),
         CH04     = as.factor(CH04))

ggplot(ggdata, aes(x = NIVEL_ED, y = P21)) +
  geom_boxplot()+
  scale_y_continuous(limits = c(0, 40000))#Restrinjo el gráfico hasta ingresos de $40000

#Si queremos agregar la dimensión _sexo_, podemos hacer un facet_wrap()
ggplot(ggdata, aes(x= NIVEL_ED, y = P21, group = NIVEL_ED, fill = NIVEL_ED )) +
  geom_boxplot()+
  scale_y_continuous(limits = c(0, 40000))+
  facet_wrap(~ CH04, labeller = "label_both")

##Foco en las diferencias opr sexo
ggplot(ggdata, aes(x= CH04, y = P21, group = CH04, fill = CH04 )) +
  geom_boxplot()+
  scale_y_continuous(limits = c(0, 40000))+
  facet_wrap(~ NIVEL_ED, labeller = "label_both")

### [Histogramas]
hist_data <-Individual_t117 %>%
  filter(P21>0) 

ggplot(hist_data, aes(x = P21,weights = PONDIIO))+ 
  geom_histogram()+
  scale_x_continuous(limits = c(0,50000))

### [Kernels]

kernel_data <-Individual_t117 %>%
  filter(P21>0) 

ggplot(kernel_data, aes(x = P21,weights = PONDIIO))+ 
  geom_density()+
  scale_x_continuous(limits = c(0,50000))
##**El eje y no tiene demasiada interpretabilidad en los Kernel, porque hace a la forma en que se construyen las distribuciones

ggplot(kernel_data, aes(x = P21,weights = PONDIIO))+ 
  geom_density(adjust = 2)+
  scale_x_continuous(limits = c(0,50000))


ggplot(kernel_data, aes(x = P21,weights = PONDIIO))+ 
  geom_density(adjust = 0.01)+
  scale_x_continuous(limits = c(0,50000))

kernel_data_2 <- kernel_data %>% 
  mutate(CH04= case_when(CH04 == 1 ~ "Varon",
                         CH04 == 2 ~ "Mujer"))

ggplot(kernel_data_2, aes(x = P21,
                          weights = PONDIIO,
                          group = CH04,
                          fill = CH04)) +
  geom_density(alpha=0.7,adjust =2)+
  labs(x="Distribución del ingreso", y="",
       title=" Total según tipo de ingreso y género", 
       caption = "Fuente: Encuesta Permanente de Hogares")+
  scale_x_continuous(limits = c(0,50000))+
  theme_tufte()+
  scale_fill_gdocs()+
  theme(legend.position = "bottom",
        plot.title      = element_text(size=12))

ggsave(filename = "Resultados/Kernel_1.png",scale = 2)