# Lottare con i dati

# v1.1.1 5/11/2023  

# setup -------------------------------------------------------------------

# questo chunk è disponibile, con commenti, nelle lezioni 1 e 2

.cran_packages <- c("plyr", "tidyverse", "purrr", "reshape2", "magrittr", 
                    "vcd", "nycflights13", "knitr", "kableExtra")

.inst <- .cran_packages %in% installed.packages()

if(any(!.inst)) {
  install.packages(.cran_packages[!.inst], repos = "https://cloud.r-project.org")
}

sapply(.cran_packages, require, character.only = TRUE)

opar <- par(no.readonly=TRUE) 

par(ask=F) 
# set.seed(1234) 

play_audio <- T

keep_time <- T

verbose_output <- T

# if(play_audio) beep(sound = 6) 


#  rendere tidy i dati ----------------------------------------------------

require(tidyverse)
# tidyr fa fa parte del tidyverse
data(cms_patient_care)
?cms_patient_care
View(cms_patient_care)
data(billboard)
?billboard
View(billboard)
data(who)
?who
View(who)
data(relig_income)
?relig_income
View(relig_income)


# riordinare con tidyr e dplyr --------------------------------------------


mlab <- tribble(
  ~Specie,              ~Specie_b, ~Ceppo_specie, ~Repl, ~niente, ~H,   ~HM,  ~M,
  "Lb_brevis",          "L_br",    "L_br_E06",    "a",   0.40,    0.40, 0.36, 0.41,
  "Lb_brevis",          "L_br",    "L_br_E06",    "b",   0.30,    0.35, 0.35, 0.36,
  "Leuc_mesenteroides", "Le_me",   "Le_me_E08",   "a",   0.73,    0.82, 0.74, 0.76,
  "Leuc_mesenteroides", "Le_me",   "Le_me_E08",   "b",   0.63,    0.71, 0.61, 0.68,
  "Leuc_mesenteroides", "Le_me",   "Le_me_E09",   "a",   0.65,    0.78, 0.89, 0.63,
  "Leuc_mesenteroides", "Le_me",   "Le_me_E09",   "b",   0.62,    0.81, 0.82, 0.61,
  "Leuc_citreum",       "Le_ci",   "Le_ci_E05",   "a",   0.65,    0.86, 0.86, 0.70,
  "Leuc_citreum",       "Le_ci",   "Le_ci_E05",   "b",   0.79,    0.83, 0.86, 0.66
)
chiave_lab <- tribble(
  ~abbr_genere, ~abbr_specie, ~genere,            ~specie,
  "L",         "br",         "Levilactobacillus", "brevis",
  "Le",         "me",         "Leuconostoc",       "mesenteroides",
  "Le",         "ci",         "Leuconostoc",       "citreum"
)

require(kableExtra)
knitr::kable(mlab, digits =2, 
             caption = "Crescita di batteri lattici (assorbanza a 650 nm) in presenza di diversi supplementi.", "html") %>% kable_styling("striped") %>% scroll_box(width = "100%") 

knitr::kable(chiave_lab, 
             caption = "Abbreviazioni di genere e specie per alcuni batteri lattici.",
             "html") %>% kable_styling("striped") %>% scroll_box(width = "100%")

# da largo a lungo
mlab_lungo <- mlab %>% 
  pivot_longer(cols = niente:M, names_to = "trattamenti", values_to = "A650")
# le prime 8 righe
head(mlab_lungo, 8)
# e ora le medie, creando, in più una variabile che contenga solo 
# la sigla del ceppo
mlab_medie <- mlab_lungo %>%
  separate(Ceppo_specie, into = c("gen","sp","ceppo"), remove = F) %>%
  dplyr::summarise(mediaA650 = mean (A650), 
                   .by = c("Ceppo_specie", "trattamenti"))

# le prime 8 righe
head(mlab_medie, 8)

# unite
chiave_lab <- chiave_lab %>% 
  unite(col = "gen_specie_abbr", abbr_genere:abbr_specie, remove = F, sep = "_")
chiave_lab

# da lungo a largo
# questo restituisce un errore
mlab_lungo %>% 
  dplyr::select(!Repl) %>% 
  pivot_wider(names_from = trattamenti, values_from = A650)

mlab_medie %>% 
  pivot_wider(names_from = trattamenti, values_from = mediaA650)

mlab_lungo %>% 
  dplyr::select(!Repl) %>% 
  pivot_wider(names_from = trattamenti, values_from = A650, values_fn = mean)

vignette("pivot", package = "tidyr")


# funzioni avanzate con tidyr ---------------------------------------------

data(mpg)
glimpse(mpg)
mpg %>% group_by(class) %>% nest()
# o anche
mpg %>% nest(.by = class)

vignette("rectangle", package = "tidyr")


# il cavallo da battaglia del data wrangling: dplyr -----------------------

library(dplyr)
vignette("base", package="dplyr")


# estrarre gruppi di righe e colonne --------------------------------------

data(mpg, verbose = F)
glimpse(mpg)

# le auto con 4 cilindri
audi4 <- mpg %>% dplyr::filter(cyl == 4 & manufacturer == "audi")
glimpse(audi4)

# auto che percorrono almeno 25 km con un gallone in autostrada
hwy25 <- mpg %>% dplyr::filter(hwy >= 25 )
glimpse(hwy25)

# selezionare le colonne per nome
mpg %>% dplyr::select(model, year, cyl)
# selezionare per posizione (e riordinare le colonne) usando l'operatore OR (|)
mpg %>% dplyr::select(11 | 2 | 9:8)
# escludere colonne con l'operatore NOT (!)
mpg %>% dplyr::select(!year & !trans)
# ma anche
mpg %>% dplyr::select(!c(year,trans))
# selezionare e rinominare
mpg %>% dplyr::select(modello = model, anno = year, cilindri = cyl)

# la colonna model e tutte le colonne numeriche
mpg %>% dplyr::select(model | where(is.numeric))
# le colonne che contengono la lettera y 
mpg %>% dplyr::select(contains("y"))


# riordinare i dati -------------------------------------------------------

# non ordinato
head(mpg, 10)
# ordinato in ordine crescente di numero di cilindri e decrescente per 
# miglia per gallone in autostrada
mpg %>% arrange(cyl, desc(hwy)) %>% head()


# trasformare con mutate --------------------------------------------------

library(tidyverse)
library(magrittr) # per la assignment pipe
data(mpg, verbose = F)
# usando $
mpg$hwyl100km <- mpg$hwy*235.21
mpg$ctyl100km <- mpg$cty*235.21
# usando transform
mpg <- base::transform(mpg, 
                       hwyl100km = 235.21/hwy, 
                       ctyl100km = 235.21/cty)
# usando mutate
mpg <- mpg %>%
  mutate(
    hwyl100km = 235.21/hwy, 
    ctyl100km = 235.21/cty 
  )
# usando la assignment pipe, anch'essa disponibile nel pacchetto magrittr 
mpg %<>% mutate(
  hwyl100km = 235.21/hwy, 
  ctyl100km = 235.21/cty
)
# creando una nuova tibble in cui le colonne usate 
# per il calcolo sono rimosse (si potrebbe fare con select)
mpg2 <- mpg %>% mutate(
  hwyl100km = 235.21/hwy, 
  ctyl100km = 235.21/cty,
  .keep = "unused"
)

mpg3 <- mpg %>% mutate(across(displ:year, ~.x*1000))
mpg4 <- mpg %>% mutate(across(displ:year, log10))

# con funzioni anonime
# lambda
mpg3 <- mpg %>% mutate(across(displ:year, function(x) x*1000))
# le funzioni anonime di R >4.2
mpg3 <- mpg %>% mutate(across(displ:year, \(x) x*1000))

# uso di across
mpg5 <- mpg %>% mutate(across(where(is.character), as.factor))


# riassumere i dati con summarise -----------------------------------------

mpg_riassunto <- mpg %>%
  group_by(manufacturer, class) %>%
  summarise(
    media_hwy = mean(hwy, na.rm = T),
    devst_why = sd(hwy, na.rm = T),
    media_cty = mean(hwy, na.rm = T),
    devst_cty_cty = sd(hwy, na.rm = T)
  ) %>%
  ungroup()
mpg_riassunto
# con across e where
mpg %>%
  dplyr::summarise(across(where(is.numeric),
                          list(media = mean, devst = sd)),
                   .by = class)


# unire le tabelle con join -----------------------------------------------


data(Arthritis)
# il comando slice() consente di selezionare righe
A1 <- Arthritis %>% slice(1:52)
A2 <- Arthritis %>% slice(53:84)
A3 <- bind_rows(A1,A2)
head(A3)
identical(A3, Arthritis)
# è possibile perché sono presenti le stesse colonne
A4 <- Arthritis %>% dplyr::select(ID:Sex) 
A5 <- Arthritis %>% dplyr::select(Age:Improved) 
A6 <- bind_cols(A4,A5)
head(A6)
identical(A6,Arthritis)

chiave_lab_2 <- chiave_lab %>%
  unite("Specie_b", abbr_genere, abbr_specie, sep = "_") %>%
  dplyr::select(Specie_b, genere, specie)
mlab_2 <- left_join(mlab,chiave_lab_2)
head(mlab_2)

# prova a capire come sono collegate queste tabelle

data(airlines)
head(airlines)
data(airports)
head(airports)
data(flights)
head(flights)
data(planes)
head(planes)
data(weather)
head(weather)


# strutture di controllo --------------------------------------------------


# loop e cose simili ------------------------------------------------------

# loop for
# uso set.seed per impostare il seme del generatore di numeri casuali, 
# in modo che l'operazione sia riproducibile (soltanto per scopi 
# didattici)
set.seed(1234) 

# creo manualmente una prima iterazione, 10 righe, tutte con l'indice 1

subsample10 <- as.data.frame(
  cbind(
    indice = rep(1,10),
    eta = sample(Arthritis$Age, size=10, replace = T)
  )
)

for (i in 2:50){ # la sequenza
  subsample <- cbind(indice = rep(i,10), 
                     eta = sample(Arthritis$Age, size=10, replace = T))
  subsample10 <- rbind(subsample10, subsample)
  # questo è il corpo del loop
}
subsample10$indice <- as.factor(subsample10$indice)
glimpse(subsample10)

iterazioni <- 50
subcampioni <- 10
contenitore <- vector("list", iterazioni)
for(i in 1:iterazioni){
  contenitore[[i]] <- sample(Arthritis$Age, size=10, replace = T)
}
subsamples_2 <- tibble(
  indice = rep(1:iterazioni, each = subcampioni),
  eta = unlist(contenitore)
)

#sequenze con seq_along()
seq_along(Arthritis$ID)
seq_along(Arthritis$Sex)
# ma che succede se genero una sequenza sui livelli di un fattore?
seq_along(levels(Arthritis$Sex))

#annidare i loop
for(i in 1:10){
  for(j in 1:5){
    for(k in 1:2) print(i*j*k)
  }
}


# while e repeat ----------------------------------------------------------

# un esempio stuèido (devi rispondere 42)
Readanswer <- function(){
  ans <- readline(prompt="Per favore, immetti la tua RISPOSTA: ")
}
answer <- as.character(Readanswer())
while(answer != 42){
  cat("Scusa, ho bisogno della risposta alla domanda fondamentale sulla vita, l'universo e tutto quanto",
      "\n","Riprova...", sep = "")
  answer <- as.character(Readanswer())
}
?cat
# un altro esempio stupido
n <- 0
hour <- as.numeric(format(Sys.time(),"%H"))
repeat {
  if (hour<=12 & n<5){
    print("Buongiorno!")
    hour <- as.numeric(format(Sys.time(),"%H"))
    n<-n+1
  } else {
    print("Accidenti, è già pomeriggio oppure ho eseguito il loop 5 volte!")
    break
  }
}


# functional --------------------------------------------------------------


# creo un data frame (in realtà una tibble) con numeri casuali 
n_casi <- 10000
df <- tibble( a = rnorm(n_casi), b = rnorm(n_casi),
              c = rnorm(n_casi), d = rnorm(n_casi),
              e = rnorm(n_casi), f = rnorm(n_casi),
              g = rnorm(n_casi), h =rnorm(n_casi))
# calcolo le mediane con un loop
output <- vector("double", length = ncol(df))
for (i in seq_along(df)) { # la sequenza 
  output[[i]] <- median(df[[i]]) # il corpo del loop 
} 
output
# uso apply()
(mediane_apply <- apply(df, 2, median))
# uso la funzione map_dbl() del pacchetto purrr
# map_dbl "applica" la funzione median alle colonne di df
(le_mie_mediane <- map_dbl(df, median))


# esecuzione condizionale -------------------------------------------------

if(exists("cinque")) rm(cinque) # per eliminare l'oggetto col nome cinque, se esiste
cinquenumeri <- c(1,2,3,4,5)
for(i in seq_along(cinquenumeri)){
  if(cinquenumeri[i]%%2==0){
    cat("la posizione", i, "vale", cinquenumeri[i], " ed è pari\n", sep = " ")
  } else {
    cat("la posizione", i, "vale", cinquenumeri[i], "ed è dispari\n", sep = " ")
    if(cinquenumeri[i] == 5) {
      cinque<-"cinque è il numero perfetto"
      print(cinque)
    }
  }
}

# casi multipli
# cerca switch nell'aiuto, se vuoi
# ?switch
xx <- 1:15
# un altro esempio stupido con la funzione modulo
case_when(
  xx %% 15 == 0 ~ "divisibile per 15, 5 e 3",
  xx %% 5 == 0 ~ "divisibile per 5",
  xx %% 3 == 0 ~ "divisibile per 3",
  TRUE ~ as.character(xx)
)

# vettori di condizioni
x <- c(-1,1,-1,1,0)
y <- ifelse(x>0,1,0)
z <- if_else(x>=0,"positivo o zero","negativo")
# nota che i due comandi trattano lo 0 in modi diversi
y
z
# guarda come ifelse() o if_else() possono essere usati per gestire 
# condizioni che causano dei warning
sqrt(x) # genera dei warning
sqrt(ifelse(x>=0,x,NA)) # niente warning, ma restituisce, NA per i valori negativi


# la soluzione dell'esercizio ---------------------------------------------

mpg %>%
  dplyr::summarise(across(c(hwy,cty),
            .fns = list(media = mean, devst = sd)),
            .by = class) %>%
  mutate(across(where(is.numeric), ~round(.x, digits = 2))) %>%
  unite("hwy",starts_with("hwy"), sep="±") %>%
  unite("cty",starts_with("cty"), sep="±")



