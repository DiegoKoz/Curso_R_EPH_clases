#Reiniciar R

Individual_t117 <-
  read.table("Fuentes/usu_individual_t117.txt",
    sep = ";",
    dec = ",",
    header = TRUE,
    fill = TRUE )

### - Crear un vector que contenga los nombres de las siguientes variables de interés para realizar algunos ejercicios:
### Edad, Sexo, Ingreso de la ocupación principal, Categoría ocupacional, ESTADO, PONDERA y PONDIH
Variables <- c("ANO4","TRIMESTRE","CH04","CH06","P21","ESTADO","CAT_OCUP","PONDERA","PONDIH")

### - Acotar la Base únicamente a las variables de interés 

Individual_t117 <- Individual_t117 %>% 
  select(Variables)

### Calcular las tasas de actividad, empleo y desempleo según sexo, para jóvenes entre 18 y 35 años
Tasas_ej_1 <- Individual_t117 %>% 
  filter(CH06 >= 18  & CH06<= 35) %>% 
  group_by(CH04) %>% 
  summarise(Poblacion         = sum(PONDERA),
            Ocupados          = sum(PONDERA[ESTADO == 1]),
            Desocupados       = sum(PONDERA[ESTADO == 2]),
            PEA               = Ocupados + Desocupados,
            'Tasa Actividad'                  = PEA/Poblacion,
            'Tasa Empleo'                     = Ocupados/Poblacion,
            'Tasa Desocupacion'               = Desocupados/PEA) %>% 
  select(-c(2:5)) %>% 
  mutate(CH04 = case_when(CH04 == 1 ~ "Hombre",
                          CH04 == 2 ~ "Mujer"))

###Calcular el salario promedio por sexo, para dos grupos de edad: 18 a 35 años y 36 a 70 años.
###Recordatorio: La base debe filtrarse para contener únicamente OCUPADOS ASALARIADOS
Tasas_ej_2 <- Individual_t117 %>% 
  mutate(GruposEdad = case_when(CH06 %in% (18:35) ~ "18a35",
                                CH06 %in% (36:70) ~ "36a70")) %>% 
  filter(ESTADO == 1, CAT_OCUP ==3, GruposEdad %in% c("18a35","36a70")) %>% 
  group_by(GruposEdad,CH04) %>% 
  summarise(Salario_Medio = weighted.mean(P21,w = PONDIH)) %>% 
  mutate(CH04 = case_when(CH04 == 1 ~ "Hombre",
                          CH04 == 2 ~ "Mujer"))



###Grabar los resultados en un excel (Creando un objeto que contenga el directorio a utilizar).
write.xlsx(as.data.frame(Tasas_ej_1),
           file = "Resultados/Ejercicios-Clase-2.xlsx",
           sheetName = "Ejercicio1",
           row.names = FALSE,
           append = FALSE)

write.xlsx(as.data.frame(Tasas_ej_2),
           file = "Resultados/Ejercicios-Clase-2.xlsx",
           sheetName = "Ejercicio2",
           row.names = FALSE,
           append = TRUE)

### Replicar ambos ejercicios anteriores para distintos trimestres,
### levantando las bases desde el segundo trimestre 2016 hasta la última.
Individual_t216 <-
  read.table(
    file = "Fuentes/usu_individual_t216.txt",
    sep = ";",
    dec = ",",
    header = TRUE,
    fill = TRUE )

Individual_t316 <-
  read.table(
    file = "Fuentes/usu_individual_t316.txt",
    sep = ";",
    dec = ",",
    header = TRUE,
    fill = TRUE )

Individual_t416 <-
  read.table(
    file = "Fuentes/usu_individual_t416.txt",
    sep = ";",
    dec = ",",
    header = TRUE,
    fill = TRUE )


Tasas_ej_1b  <- bind_rows(Individual_t117 %>% select(Variables),
                                       Individual_t216 %>% select(Variables),
                                       Individual_t316 %>% select(Variables),
                                       Individual_t416 %>% select(Variables)) %>% 
  filter(CH06 >= 18  & CH06<= 35) %>% 
  group_by(CH04,ANO4,TRIMESTRE) %>% 
  summarise(Poblacion         = sum(PONDERA),
            Ocupados          = sum(PONDERA[ESTADO == 1]),
            Desocupados       = sum(PONDERA[ESTADO == 2]),
            PEA               = Ocupados + Desocupados,
            'Tasa Actividad'                  = PEA/Poblacion,
            'Tasa Empleo'                     = Ocupados/Poblacion,
            'Tasa Desocupacion'               = Desocupados/PEA) %>% 
  select(-c(Poblacion,Ocupados,Desocupados,PEA)) %>%
  ungroup() %>% 
  mutate(CH04 = case_when(CH04 == 1 ~ "Hombre",
                          CH04 == 2 ~ "Mujer"))


Tasas_ej_2b <- bind_rows(Individual_t117 %>% select(Variables),
                       Individual_t216 %>% select(Variables),
                       Individual_t316 %>% select(Variables),
                       Individual_t416 %>% select(Variables)) %>% 
  mutate(GruposEdad = case_when(CH06 %in% (18:35) ~ "18a35",
                                CH06 %in% (36:70) ~ "36a70")) %>% 
  filter(ESTADO == 1, CAT_OCUP ==3, GruposEdad %in% c("18a35","36a70")) %>% 
  group_by(ANO4,TRIMESTRE,GruposEdad,CH04) %>% 
  summarise(Salario_Medio = weighted.mean(P21,w = PONDIH)) %>% 
  mutate(CH04 = case_when(CH04 == 1 ~ "Hombre",
                          CH04 == 2 ~ "Mujer"))

