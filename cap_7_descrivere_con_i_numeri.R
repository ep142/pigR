# Descrivere con i numeri


# v1.1.1 5/11/2023  

# Qui, come per gli altri capitoli, ho trasformato in codice tutto quello che 
# c'era di eseguibile nel testo o nei chunk di R.
# Per commenti e spiegazioni fai riferimento al libro.
# Se stai leggendo il libro sai già come esegui gruppi di comandi (se no vai
# al capitolo 2 del libro...)


# setup -------------------------------------------------------------------

knitr::opts_chunk$set(echo = TRUE)

.cran_packages <- c("tidyverse", "MASS", "skimr", "doBy", "cowplot", "Hmisc", 
                    "pastecs", "psych", "nortest", "broom", "vcd", "gmodels", 
                    "knitr", "kableExtra", "car")

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


# statistiche riassuntive per dati continui -------------------------------

# ricordati di installare e caricare il pacchetto necessario
# library(MASS) 
data(survey)
View(survey)
# per far funzionare questo codice, se non lo hai già fatto hai bisogno anche 
# del pacchetto kableExtra
# install.packages("kableExtra")
# require(kableExtra)
data(survey)
knitr::kable(
  head(survey, 10), 
  booktabs = TRUE,
  caption = "Una parte dei dati del data frame survey. \nRisultati di un sondaggio fra studenti dell'Università di Adelaide. \nConsulta l'aiuto con help(survey) per dettagli",
  "html"
) %>% kable_styling("striped") %>% scroll_box(width = "100%")

survey_ridotto <- survey %>%
  dplyr::filter(Sex == "Male") %>%
  dplyr::select(Pulse, Exer, Smoke, Height, Age)
surv_summary <- summary(survey_ridotto)
surv_summary

str(surv_summary)

surv_skim <- skim(survey_ridotto)
kable(surv_skim, "html") %>% 
  kable_styling("striped") %>% 
  scroll_box(width = "100%")


#  misure di tendenza centrale e di variabilità ---------------------------


#  lavorare sui vettori ----------------------------------------------------

# applicare una singola funzione, una variabile alla volta può essere noioso ma utile
mean(survey_ridotto$Height, na.rm = T) 
#se vuoi arrotondare
round(mean(survey_ridotto$Height, na.rm = T), 2)
# oppure with(survey_ridotto, mean(Height, na.rm = T))
sd(survey_ridotto$Height, na.rm = T)
# se tutte le variabili fossero numeriche potrei "applicare" una funzione ad 
# un margine
medie <- apply(survey_ridotto[, c(1,4,5)], 2, mean, trim = 0.1, na.rm = T)
medie
class(medie)
# due alternative

# sapply, una funzione di base che, a differenza di apply semplifica l'output 
# e lavora per colonne
# qui calcolo le medie winsorizzate
medie_sapply <- sapply(survey_ridotto[, c(1,4,5)], mean, na.rm = T, trim = 0.1)
medie_sapply
class(medie_sapply)

# map_dbl, una funzione del pacchetto purrr del tidyverse
medie_purrr <- map_dbl(survey_ridotto[, c(1,4,5)], mean, na.rm = T, trim = 0.1)
medie_purrr
class(medie_purrr)


# Funzioni che producono statistiche riassuntive --------------------------

Hmisc::describe(survey_ridotto[, c(1,4,5)])
pastecs::stat.desc(survey_ridotto[, c(1,4,5)])
psych::describe(survey_ridotto[, c(1,4,5)])


# Statistiche, ordinate ---------------------------------------------------

# qui i risultati vengono solo stampati, non assegnati

survey_ridotto %>% dplyr::summarise(mpulse = mean(Pulse, na.rm = T, trim = 0.1),
                                    mheight = mean(Height, na.rm = T, trim = 0.1))

# ripetere i nomi delle variabili è tedioso
survey_ridotto %>% 
  dplyr::summarise(across(where(is.numeric), ~mean(.x, na.rm = T, trim = 0.1)))
# o, addirittura, con funzioni multiple, passate come lista
media_sd <- list(
  media_w = ~mean(.x, na.rm = T, trim = 0.1),
  sd = ~sd(.x, na.rm = T)
)
survey_ridotto %>% dplyr::summarise(across(where(is.numeric), media_sd))

# infine, con purrr; qui prima usiamo select per estrarre le colonne
# numeriche, poi passiamo la funzione di interesse e restituiamo un 
# data frame; i parametri sono passati all'esterno della funzione

survey_ridotto %>% 
  dplyr::select(where(is.numeric)) %>%
  map_df(mean, na.rm = T, trim = 0.1)    


# Statistiche riassuntive per gruppi --------------------------------------

# creo una funzione definita dall'utente con le funzioni che mi interessano
Fun_riass <- function(x, ...){
  c(
    media = mean(x, na.rm = T, ...),
    dev_st = sd(x, na.rm = T),
    num_non_na = length(!is.na(x))
  )
}
doBy::summaryBy(cbind(Pulse, Height, Age) ~ Sex, data = survey, FUN = Fun_riass)

psych::describeBy(Height + Pulse ~ Sex, data = survey)

# cosa fa group_by?
str(survey %>%
      group_by(Sex))

# un primo esempio con un paio di funzioni e summarise
survey %>%
  group_by(Sex) %>%
  dplyr::summarise(
    media_alt = mean(Height, na.rm = T),
    sd_alt = sd(Height, na.rm = T)
  )

# un secondo esempio: elimino gli NA da Sex e uso due variabili per raggruppare
survey %>%
  dplyr::filter(!is.na(Sex) & !is.na(Exer)) %>%
  group_by(Sex, Exer) %>%
  dplyr::summarise(
    media_alt = mean(Height, na.rm = T),
    sd_alt = sd(Height, na.rm = T)
  )

# un terzo esempio, con funzioni multiple e variabili multiple
# selezionate sulla base del nome, non del tipo
survey %>%
  dplyr::filter(!is.na(Sex) & !is.na(Exer)) %>%
  group_by(Sex, Exer) %>%
  dplyr::summarise(across(c(Height, Pulse), media_sd))

aggregate(cbind(Pulse, Height) ~ Sex + Exer, data = survey, FUN = mean, na.rm = T)



# ma è normale? -----------------------------------------------------------




# Normal probability plot -------------------------------------------------


iris %>% 
  ggplot(aes(sample = Sepal.Length, shape = Species)) +
  geom_qq() +
  geom_qq_line() +
  labs(
    x = "quantili teorici",
    y = "quantili del campione",
    caption = str_wrap("Fisher, R. A. (1936) The use of multiple measurements in taxonomic problems. Annals of Eugenics, 7, Part II, 179–188.",80)
  )


# Test statistici per la normalità ----------------------------------------

# estraggo il vettore test
vettore_test <- iris %>% 
  dplyr::filter(Species == "setosa") %>%
  dplyr::select(Sepal.Length) %>%
  pull()

# eseguo il test, assegnando i risultati ad un nome
test_shapiro <- shapiro.test(vettore_test)

# stampo i risultati del test
test_shapiro

# la struttura dell'oggetto
str(test_shapiro)


# Come fare di meglio con i risultati dei test ----------------------------

# prima di tutto creo una lista per ospitare i risultati del test
test_shapiro_multipli <- vector(mode = "list", length = nlevels(iris$Species))
for (i in 1:nlevels(iris$Species)){
  # assegno i risultati del test allo slot
  test_shapiro_multipli[[i]] <- shapiro.test(iris$Sepal.Length[iris$Species==levels(iris$Species)[i]])
  # dò il nome corretto allo slot della lista
  names(test_shapiro_multipli)[i] <- levels(iris$Species)[i]
}
# stampo la lista
test_shapiro_multipli

iris %>%
  nest(data = -Species) %>%
  mutate(
    test = map(data, ~ shapiro.test(.x$Sepal.Length)), 
    ordinato = map(test, tidy)
  ) %>%
  unnest(ordinato)

# creo una tibble annidata che contiene una colonna con le specie 
# e una colonna con delle tibble contenenti i dati per ciascuna specie
tibble_annidata <- iris %>%
  nest(data = -Species)
# uso mutate con la funzione map() di purrr per applicare il
# test ai tre livelli delle specie e poi uso tidy() di broom
# per rioridinare i risultati del test
tibble_risultati  <- tibble_annidata %>% mutate(
  test = map(data, ~ shapiro.test(.x$Sepal.Length)), 
  ordinato = map(test, tidy)
)
# uso unnest() per estrarre i risultati in un data frame
tibble_risultati %>% unnest(ordinato)


# intervalli di confidenza ------------------------------------------------

# estraggo 10000 numeri casuali da una distirbuzione normale con media 5 e 
# deviazione standard 2

numeri_casuali <- rnorm(10000, mean = 5, sd = 2)

# calcolo media e deviazione standard

mean(numeri_casuali)
sd(numeri_casuali)

# faccio lo stesso, con campioni più piccoli, creando un data frame con una 
# funzione di purrr

numeri_casuali <- map(rep(100,5), rnorm, mean = 5, sd = 2) 
medie_sd <- tibble(
  medie = map_dbl(numeri_casuali, mean),
  devst = map_dbl(numeri_casuali, sd)
)

t.test(vettore_test)

tidy(t.test(vettore_test))

medie_conf <- iris %>%
  group_by(Species) %>%
  nest(data = - Species) %>%
  mutate(
    test = map(data, ~ t.test(.x$Sepal.Length)), 
    ordinato = map(test, tidy)
  ) %>%
  unnest(ordinato) %>%
  dplyr::select(Species, media = estimate, conf.low, conf.high)
medie_conf

medie_conf %>% ggplot(aes(x = Species)) +
  geom_pointrange(aes(y = media, ymin = conf.low, ymax = conf.high)) +
  labs(x = "specie",
       caption = "Fisher, R. A. (1936) The use of multiple measurements in taxonomic problems. Annals of Eugenics, 7, Part II, 179–188.")


# Riassumere i dati per le variabili categoriche --------------------------

?Titanic
data("Titanic")
class(Titanic)
Titanic
Titanic_df <- as.data.frame.table(Titanic)


# Tabelle di frequenza e contingenza --------------------------------------

?table
# nota l'uso di with()
# una tabella di frequenza, a una via
una_tabella <- with(Arthritis, table(Improved))
# in alternativa table(Arthritis$Improved)
una_tabella
class(una_tabella)
# una funzione utile per aggiungere somme per le diverse vie o margini è
?addmargins
addmargins(una_tabella,1)
# invece, per trasformare le conte in proporzioni
?prop.table
prop.table(una_tabella)
# una tabella a due vie
tabella_2_vie <- with(Arthritis, table(Treatment,Improved))
# nota che con l'opzione useNA puoi decidere se includere la conta degli NAs 
# con le opzioni "no", "ifany", "always"; "ifany" 
tabella_2_vie
# per aggiungere margini
margin.table(tabella_2_vie,1)
margin.table(tabella_2_vie,2)
# add sums to all margins
addmargins(tabella_2_vie)
# solo per Treatment
addmargins(tabella_2_vie, 1)
# le due funzioni possono essere combinate
addmargins(prop.table(tabella_2_vie),c(1,2))
pie(una_tabella)
barplot(tabella_2_vie, beside = T, legend = T)

# con Arthritis
tabella_3_vie <- xtabs(~Treatment+Improved+Sex, data = Arthritis)
tabella_3_vie
# con il data frame ottenuto da Titanic
xtabs(Freq~Survived+Class, data = Titanic_df)

tabella_3_vie <- xtabs(~Treatment+Improved+Sex, data = Arthritis)
is.array(tabella_3_vie)
dim(tabella_3_vie)
tabella_3_vie[1,,]
tabella_3_vie[1,2,]


# Grafici a mosaico -------------------------------------------------------

mosaicplot(xtabs(~Treatment+Improved+Sex, data = Arthritis), color = 2:3,
           main = "Effetto del trattamento sui sintomi dell'artrite")


# Veloce veloce -----------------------------------------------------------

data("iris")

# esplora brevemente i dati
# ometto questi comandi perché ti basta cliccare sulla riga corrispondente
# nel tab Environment
# View(iris)
# str(iris)

# una selezione casuale dei dati
car::some(iris)

# concentriamoci su una sola variabile ma il codice si applica anche alle altre
iris %>% 
  ggplot(aes(x = Species, y = Sepal.Length)) +
  geom_boxplot(notch = T) +
  geom_jitter()
iris %>% 
  ggplot(aes(x = Sepal.Length)) +
  facet_wrap(~Species) +
  geom_histogram() 
iris %>% 
  ggplot(aes(x = Sepal.Length, color = Species)) + 
  geom_density()




