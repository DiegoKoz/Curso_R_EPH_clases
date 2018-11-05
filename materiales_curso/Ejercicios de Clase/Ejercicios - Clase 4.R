# Ejercicios para practicar
# RESTART
library(tidyverse)
library(ggthemes)
library(ggplot2)

Individual_t117 <- read.table("Fuentes/usu_individual_t117.txt",
                              sep=";", dec=",", header = TRUE, fill = TRUE)

### - Primer ejercicio.

data_graf_1 <- Individual_t117 %>% 
  select(P21, CAT_OCUP, PONDIIO, PP07H) %>% 
  filter(P21>0, CAT_OCUP == 3) %>% 
  mutate(Calidad_vinculo  = as.factor(case_when(PP07H == 1 ~ "Protegidos",
                                                PP07H == 2 ~ "Precarios",
                                                FALSE      ~ "Ns/Nr"))) %>% 
  group_by(Calidad_vinculo) %>% 
  summarise(Ing_prom = weighted.mean(P21, PONDIIO))




ggplot(data_graf_1, aes(x = Calidad_vinculo,y = Ing_prom,
                        group = Calidad_vinculo, fill = Calidad_vinculo,
                        label = round(Ing_prom,2))) +
  geom_col(alpha=0.6)+
  geom_text(nudge_y = -1000)+
  labs(x="", y="",
       title="Ingreso por ocupación principal promedio de los asalariados",
       subtitle = "Según calidad del vínculo ", 
       caption = "Fuente: Encuesta Permanente de Hogares")+
  theme_tufte()+
  scale_fill_gdocs()+
  theme(legend.position = "bottom",
        legend.title = element_blank(),
        plot.title   = element_text(size = 12))


### - Graficar la distribución del ingreso por ocupación principal según categoría 
###   ocupacional, con el tipo de gráfico Kernel.
data_graf_2 <- Individual_t117 %>% 
  select(P21, CAT_OCUP, PONDIIO) %>% 
  filter(P21>0) %>% 
  mutate(CAT_OCUP = as.factor(case_when(CAT_OCUP == 1 ~ "Patrón",
                                        CAT_OCUP == 2 ~ "Cuenta propia",
                                        CAT_OCUP == 3 ~ "Asalariado",
                                        FALSE         ~ "RESTO")))


ggplot(data_graf_2, aes(x = P21, weights = PONDIIO, 
                        group = CAT_OCUP, fill = CAT_OCUP)) +
  geom_density(alpha=0.6, adjust= 2)+
  labs(x="", y="",
       title="Distribución del ingreso por ocupación principal",
       subtitle = "según categoría ocupacional", 
       caption = "Fuente: Encuesta Permanente de Hogares")+
  scale_x_continuous(limits = c(0,50000))+
  theme_tufte()+
  scale_fill_gdocs()+
  theme(legend.position = "bottom",
        legend.title = element_blank(),
        plot.title   = element_text(size = 12))+
  facet_wrap(~CAT_OCUP,ncol = 1,scales = "free")


