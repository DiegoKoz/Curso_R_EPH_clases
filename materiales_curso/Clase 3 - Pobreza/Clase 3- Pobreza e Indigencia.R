#Reiniciar R

library(tidyverse, warn = FALSE)
library(openxlsx, warn = FALSE)

###Selecciono variables
var.ind <- c('CODUSU','NRO_HOGAR' ,'COMPONENTE','ANO4','TRIMESTRE','REGION',
             'AGLOMERADO', 'PONDERA', 'CH04', 'CH06', 'ITF', 'PONDIH','P21')

###Levanto Bases y otros archivos necesarios
individual.316 <- read.table("Fuentes/usu_individual_t316.txt", sep=";", dec=",", header = TRUE, fill = TRUE) %>% 
  select(var.ind)
individual.416 <- read.table("Fuentes/usu_individual_t416.txt", sep=";", dec=",", header = TRUE, fill = TRUE) %>% 
  select(var.ind)

Bases <- bind_rows(individual.316,individual.416)


Adequi <- read.xlsx("Fuentes/ADEQUI.xlsx")
CBA    <- read.xlsx("Fuentes/CANASTAS.xlsx",sheet = "CBA")
CBT    <- read.xlsx("Fuentes/CANASTAS.xlsx",sheet = "CBT")
dic.regiones <- read.xlsx("Fuentes/Regiones.xlsx")


## Calculamos Canastas Trimestrales por Región
CBA <- CBA %>% 
  mutate(Canasta = 'CBA')

CBT <- CBT %>% 
  mutate(Canasta = 'CBT')

Canastas_Reg <- bind_rows(CBA,CBT)                       %>% 
  gather(.,Region, Valor, c(3:(ncol(.)-1) ))             %>%
  mutate(Trimestre = case_when(Mes %in% c(1:3)   ~1,
                               Mes %in% c(4:6)   ~2,
                               Mes %in% c(7:9)   ~3,
                               Mes %in% c(10:12) ~4),
         Periodo = paste(Año, Trimestre, sep='.'))      

Canastas_Reg_2 <- Canastas_Reg %>% 
  group_by(Canasta, Region, Periodo)                     %>% 
  summarise(Valor = mean(Valor))                         %>% 
  spread(., Canasta,Valor)                               %>% 
  left_join(., dic.regiones, by = "Region")              %>% 
  ungroup()                                              


###Aplicamos sucesivos pasos para el calculo de Poberza e Indigencia por Periodo
Pobreza_Individual <- Bases %>% 
  mutate(Periodo = paste(ANO4, TRIMESTRE, sep='.')) %>% 
  left_join(., Adequi, by = c("CH04", "CH06")) %>% 
  left_join(., Canastas_Reg_2, by = c("REGION", "Periodo"))    


Pobreza_Individual_paso2 <- Pobreza_Individual %>%  
  group_by(CODUSU, NRO_HOGAR, Periodo)                          %>% 
  mutate(Adequi_hogar = sum(adequi))                            %>%
  ungroup()                                                      

Pobreza_Individual_paso3 <-  Pobreza_Individual_paso2 %>% 
 mutate(CBA = CBA*Adequi_hogar,
        CBT = CBT*Adequi_hogar,
        Situacion = case_when(ITF<CBA            ~ 'Indigente',
                               ITF>=CBA & ITF<CBT ~ 'Pobre',
                               ITF>=CBT           ~ 'No.Pobre'))  

##Cálculo de Tasas de Pobreza e Indigencia

Pobreza_resumen <- Pobreza_Individual_paso3 %>% 
  group_by(Periodo) %>% 
  summarise(Tasa_pobreza    = sum(PONDIH[Situacion %in% c('Pobre', 'Indigente')],na.rm = TRUE)/
                              sum(PONDIH,na.rm = TRUE),
            
            Tasa_indigencia = sum(PONDIH[Situacion == 'Indigente'],na.rm = TRUE)/
                              sum(PONDIH,na.rm = TRUE)) 

###Abierto por Regiones
Pobreza_resumen_region <- Pobreza_Individual_paso3 %>% 
  group_by(Periodo,Region) %>% 
  summarise(Tasa_pobreza    = sum(PONDIH[Situacion %in% c('Pobre', 'Indigente')],na.rm = TRUE)/
                              sum(PONDIH,na.rm = TRUE),
            
            Tasa_indigencia = sum(PONDIH[Situacion == 'Indigente'],na.rm = TRUE)/
                              sum(PONDIH,na.rm = TRUE)) 
