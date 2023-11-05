# Grafica


# v1.1 4/11/2023  

# Qui, come per gli altri capitoli, ho trasformato in codice tutto quello che 
# c'era di eseguibile nel testo o nei chunk di R.
# Per commenti e spiegazioni fai riferimento al libro.
# Se stai leggendo il libro sai già come esegui gruppi di comandi (se no vai
# al capitolo 2 del libro...)


# setup -------------------------------------------------------------------

# installo i pacchetti se necessario e li carico

# questo chunk è disponibile, con commenti, nelle lezioni 1 e 2

.cran_packages <- c( "vcd", "tidyverse", "RColorBrewer",  "car", "cowplot",
                     "beepr", "tictoc", "MASS", "viridis", "skimr", "knitr",
                     "kableExtra", "lattice", "ggpubr")

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


#  cosa c'è da imparare in questo capitolo --------------------------------

# per avere un'idea rapida della potenzialità della grafica di base di R

demo(graphics)

# Sistemi grafici in R----------------------------------------------------------
# un grafico con la grafica di base
data(mpg)
plot(x = mpg$displ, y = mpg$hwy)

# lo stesso grafico con lattice
xyplot(hwy ~ displ | class, data = mpg)

# ancora con ggplot2

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  facet_wrap(~class) 


#  visualizzare o salvare i grafici ---------------------------------------

library(tidyverse) # potrebbe non essere necessario, se hai già caricato tidyverse
plot(x = mpg$displ, y = mpg$hwy)


# salvare i grafici -------------------------------------------------------

mpg %>% dplyr::filter(class %in% c("compact", "suv", "midsize", "subcompact")) %>%
  ggplot(mapping = aes(x = cty, y = hwy)) +
  geom_smooth(se = F) +
  geom_point(mapping = aes(shape = class, color = displ), size = I(2)) +
  labs(title = "Consumo di carburante per 32 modelli di auto",
       subtitle = "anni 1999 - 2008",
       x = "miglia per gallone in città",
       y = "miglia per gallone in autostrada",
       shape = "categoria",
       color = "cilindrata, L",
       caption = "Fonte: EPA, https://fueleconomy.gov/"
  ) +
  scale_shape_manual(values = c(16,17,15,18)) +
  scale_colour_continuous(type = "viridis") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5))

# qual'è il device attivo?
dev.cur()
# creiamo il plot e assegnamolo ad un oggetto
mpg_plot <- mpg %>% dplyr::filter(class %in% c("compact", "suv", "midsize", "subcompact")) %>%
  ggplot(mapping = aes(x = cty, y = hwy)) +
  geom_smooth(se = F) +
  geom_point(mapping = aes(shape = class, color = displ), size = I(2)) +
  labs(title = "Consumo di carburante per 32 modelli di auto",
       subtitle = "anni 1999 - 2008",
       x = "miglia per gallone in città",
       y = "miglia per gallone in autostrada",
       shape = "categoria",
       color = "cilindrata, L",
       caption = "Fonte: EPA, https://fueleconomy.gov/"
  ) +
  scale_shape_manual(values = c(16,17,15,18)) +
  scale_colour_continuous(type = "viridis") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5))
# inviamo il plot al device di default, il plot pane
mpg_plot
# ora inviamo ad un device pdf, con le opzioni di default
?pdf
# ATTENZIONE IL FILE PDF VIENE SALVATO CORRETTAMENTE SOLO SE VENGONO ESEGUITI 
# ENTRAMBI I COMANDI SUCCESSIVI
pdf(file = "mpg_plot.pdf")
mpg_plot
# chiudiamo il device e restituisce l'output al device di default (il plot pane)
dev.off()       

# ora apriamo un device png con le opzioni di default e una risoluzione di 72 dpi
?png
png(file = "mpg_plot.png", width = 7, height = 5, res = 72, units = "in")
# la lista dei device si ottiene con dev.list()
cat("the list of devices","\n", dev.list())
dev_list <- dev.list() # è un vettore con nomi
dev_list
# salviamo il grafico come .png, 72 dpi, 7x5 pollici
mpg_plot
# chiudiamo il device (non è necessario)
dev.off()
# ora .jpeg a due diverse risoluzioni, stessa dimensione, con la compressione 
# di default (quality = 75)
jpeg(file = "mpg_plot_150.jpg", res = 150, width = 7, height = 5, units = "in")
mpg_plot
dev.off()
jpeg(file = "mpg_plot_300.jpg", res = 300, width = 7, height = 5, units = "in")
mpg_plot
dev.off()
# ora .tiff, non compresso, stessa dimensione
tiff(file = "mpg_plot_300.tiff", res = 300, width = 7, height = 5, units = "in")
mpg_plot
dev.off()


#  salvare con ggsave -----------------------------------------------------

# l'aiuto su ggsave
?ggsave
ggsave(mpg_plot, filename = "mpg_plot_150.tiff", dpi = 150)


#  le dimensioni del device e le opzioni grafiche -------------------------

jpeg(file = "mpg_plot_150_480.jpg", res = 150)
mpg_plot
dev.off()

# salva i parametri grafici correnti per poterli resettare facilmente
opar <- par(no.readonly = T)
# dividi il device in una riga con due colonne e riempi per righe 
# (prima la prima colonna e poi la seconda)
par(mfrow = c(1,2))
# un grafico a dispersione
plot(hwy ~ cty, data = mpg)
# un grafico a barre
barplot(xtabs(~ class, data = mpg), las = 2)
# resetta il device
par(opar)


# R a colori --------------------------------------------------------------

# i primi 20 e gli ultimi 20 colori (cambia il codice per visualizzare un 
# elenco diverso dei 657 colori disponibili)
colors()[c((1:20), (length(colors())-20):length(colors()))]
# ottieni i nomi dei colori della palette in uso
# (quella di default all'avvio di R, può essere cambiata)
palette()
?palette
# per saperne di più sulle palette di grDevices
?rainbow

opar <- par(no.readonly = T)
par(mfrow=c(2,3))
# la palette di default
pie(rep(1, length(palette())), col = palette(), labels = palette(),
    main = "la palette di default")

# una palette arcobaleno a 6 colori
palette(rainbow(6))
lamiapalette <- palette()
pie(rep(1, length(lamiapalette)), col = palette(), labels = lamiapalette,
    main = "una palette arcobaleno")

# una palette di 20 colori a gradiente di calore
palette(heat.colors(20))
lamiapalette <- palette()
pie(rep(1, length(lamiapalette)), col = palette(), labels = lamiapalette,
    main = "una palette a gradiente di calore")

# una palette toporgrafica di 20 colori
palette(topo.colors(20))
lamiapalette <- palette()
pie(rep(1, length(lamiapalette)), col = palette(), labels = lamiapalette,
    main = "una palette topografica")

# colori adatti per mappe
palette(terrain.colors(20))
lamiapalette <- palette()
pie(rep(1, length(lamiapalette)), col = palette(), labels = lamiapalette,
    main = "una palette 'terreno'")

# una palette ciano-magenta, adatta a daltonici
palette(cm.colors(20))
lamiapalette <- palette()
pie(rep(1, length(lamiapalette)), col = palette(), labels = lamiapalette,
    main = "una palette cyano-magenta")

# resetla palette
palette("default")
# resetta i parametri grafici
par(opar)


# la grammatica della grafica con ggplot2 ---------------------------------

# library(ggplot2)
mpg %>%
  dplyr::filter(class %in% c("compact", "suv", "pickup", "subcompact")) %>%
  ggplot(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(se = F) +
  geom_smooth(method = "lm", formula = y~x, color = "red", linetype = 2, se = F) +
  geom_point(mapping = aes(size = cyl, shape = class)) +
  labs(
    title = "Consumi in autostrada di alcuni modelli di autovetture, 1999 - 2008",
    caption = "https://fueleconomy.gov/",
    x = "cilindrata, litri",
    y = "consumo in autostrada, km per gallone",
    size = " n. cil.",
    shape = "classe"
  ) +
  scale_size(range = c(1,2.5)) +
  scale_x_continuous(limits = c (1,7), breaks = seq(1,7), minor_breaks = seq(1,7,0.5)) +
  scale_y_continuous(limits = c(10,50), breaks = seq(10,50,10), minor_breaks = seq(10,50,5)) +
  scale_shape_manual( values = c(15, 16, 17, 18)) +
  theme(title = element_text(hjust = 0.5))


#  Grafici per variabili qualitative --------------------------------------


# Diagrammi a barre -------------------------------------------------------

data("Arthritis")

# creo un fattore che divide in pazienti in tre gruppi usando la variabile Age, 
# usando cut()
# i gruppi, arbitrariamente, sono con Age<=22, 22<Age≤40, 40<Age≤59, Age>59
Arthritis2 <- Arthritis
Arthritis2$ageClass <- cut(Arthritis2$Age, 
                           c(22, 40, 59, max(Arthritis$Age)), 
                           right = T, 
                           labels = c("young","middle aged", "elder"))
# un bar chart minimo
# prima di tutto, creo una lista che può essere facilmente riciclata e che 
# contiene i dati e solo un estetico, quello che andrà sull'asse delle x 

artbar1 <- ggplot(data = Arthritis2, aes(x= Treatment))

# aggiungo il secondo strato con in geoma gem_bar, in cui passo un ulteriore
# estetico, Improved, che verrà mappato sul colore 

artbar1 +
  geom_bar(mapping = aes(fill = Improved))

ggplot(data = Arthritis2, aes(x= Treatment, fill = Improved)) +
  geom_bar()

# barchart semplice
artbar_semplice <- artbar1 +
  geom_bar(mapping = aes(fill = Improved))

# uso il comando labs per cambiare l'etichetta dell'asse y,  aggiungere un 
# titolo, sottotitolo e una legenda
artbar_semplice <- artbar_semplice +
  labs(y = "Numero di pazienti",
       title = "Effetto del farmaco x sui sintomi dell'artrite reumatoide",
       subtitle = "Un esperimento randomizzato, con placebo e doppio cieco",
       caption = "Koch & Edwards, 1988")

# cambio le scale, per usare termini in Italiano, aggiungere dei trattini 
# diversi per l'asse y e cambiare la palette dei colori
artbar_semplice <- artbar_semplice +
  scale_x_discrete("Trattamento", 
                   labels = c("Placebo" = "Placebo", "Treated" = "Farmaco x")) +
  scale_y_continuous(limits = c(0, 50), breaks = seq(0,50,10), 
                     minor_breaks = seq(0,50,2)) +
  scale_fill_brewer("Miglioramenti", 
                    labels = c("None" = "0","Some"="+", "Marked" = "+++"), 
                    type = "qual", palette = "Paired")
# cambio il tema, e centro i titoli, cambiandone font e dimensione
artbar_semplice <- artbar_semplice +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
        plot.subtitle = element_text(hjust = 0.5, face = "italic", size = 12))

artbar_semplice

# uso di position nei barplot
barre_impilate <- artbar1 +
  geom_bar(mapping = aes(fill = Improved)) +
  labs(y = "Numero di pazienti") +
  scale_x_discrete("Trattamento", 
                   labels = c("Placebo" = "Placebo", "Treated" = "Farmaco x")) +
  scale_fill_brewer("Miglioramenti", 
                    labels = c("None" = "0","Some"="+", "Marked" = "+++"), 
                    type = "qual", palette = "Paired") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
        plot.subtitle = element_text(hjust = 0.5, face = "italic", size = 12),
        legend.position = "none")
barre_raggruppate <- artbar1 +
  geom_bar(mapping = aes(fill = Improved), position = "dodge") +
  labs(y = "Numero di pazienti") +
  scale_x_discrete("Trattamento", 
                   labels = c("Placebo" = "Placebo", "Treated" = "Farmaco x")) +
  scale_fill_brewer("Miglioramenti", 
                    labels = c("None" = "0","Some"="+", "Marked" = "+++"), 
                    type = "qual", palette = "Paired") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
        plot.subtitle = element_text(hjust = 0.5, face = "italic", size = 12),
        legend.position = c(0.50,0.85), legend.text = element_text(size = 6))
barre_proporzioni <- artbar1 +
  geom_bar(mapping = aes(fill = Improved), position = "fill") +
  labs(y = "Frazione dei pazienti") +
  scale_x_discrete("Trattamento", 
                   labels = c("Placebo" = "Placebo", "Treated" = "Farmaco x")) +
  scale_fill_brewer("Miglioramenti", 
                    labels = c("None" = "0","Some"="+", "Marked" = "+++"), 
                    type = "qual", palette = "Paired") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
        plot.subtitle = element_text(hjust = 0.5, face = "italic", size = 12),
        legend.position = "none")
plot_grid(barre_impilate, barre_raggruppate, barre_proporzioni, 
          labels = c("A", "B", "C"),
          ncol = 3, nrow = 1)

Genera_bar_plot <- function(bpos = "stack", 
                            yl = "Numero di pazienti", 
                            lpos = "right"){
  artbar1 +
    geom_bar(mapping = aes(fill = Improved), position = bpos) +
    labs(y = yl) +
    scale_x_discrete("Trattamento", 
                     labels = c("Placebo" = "Placebo", "Treated" = "Farmaco x")) +
    scale_fill_brewer("Miglioramenti", 
                      labels = c("None" = "0","Some"="+", "Marked" = "+++"), 
                      type = "qual", palette = "Paired") +
    theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
          plot.subtitle = element_text(hjust = 0.5, face = "italic", size = 12),
          legend.position = lpos)
}
# cambia gli argomenti della funzione fra parentesi; 
# yl può essere qualsiasi testo, 
# bpos può essere "stack", "dodge" o "fill"
# lpos può essere "bottom", "top", "right", "left" 
# o un vettore numerico di lunghezza 2
# che definisce la posizione della legenda
# qui vengono usati gli argomenti di default
il_mio_bar_plot <- Genera_bar_plot()
il_mio_bar_plot
# qui invece viene generato l'equivalente del grafico C nella figura precedente,
il_mio_bar_plot <- Genera_bar_plot(bpos = "fill", 
                                   yl = "frazione dei pazienti", 
                                   lpos = "bottom")
il_mio_bar_plot

# uso di facet

i_nomi_dei_sessi <- as_labeller(
  c("Female" = "Femmine", "Male" = "Maschi"))
ggplot(data = Arthritis2, aes(x= Treatment)) +
  geom_bar(mapping = aes(fill = Improved), position = "fill") +
  geom_text(aes(label = after_stat(count)), stat = "count", 
            position = "fill", colour = "white", vjust = 1.5) +
  facet_wrap(~Sex, labeller = i_nomi_dei_sessi) +
  labs(y = "Frazione dei pazienti") +
  scale_x_discrete("Trattamento", 
                   labels = c("Placebo" = "Placebo", "Treated" = "Farmaco x")) +
  scale_fill_brewer("Miglioramenti", 
                    labels = c("None" = "0","Some"="+", "Marked" = "+++"), 
                    type = "qual", palette = "Paired") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
        plot.subtitle = element_text(hjust = 0.5, face = "italic", size = 12))

Arthritis2 %>% ggplot(mapping = aes(x=Treatment, fill = Improved)) +
  facet_grid(Sex ~ ageClass) +
  geom_bar()


# Fare di più con i grafici per variabili qualitative ---------------------

artbar1 + geom_bar(aes(fill = Improved)) + coord_flip()
artbar1 + geom_bar(aes(fill= Improved), show.legend = F) + coord_polar()

# Grafici per variabili quantitative --------------------------------------


# Istogrammi ed altre rappresentazioni della densità ----------------------

data("diamonds")
dfpoly <- ggplot(data = diamonds, aes(x=carat))
dfpoly + geom_histogram(bins = 100) + 
  labs(x = "peso in carati",
       y = "conta",
       title = "distribuzione del peso in carati di diamanti") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

dfpoly + geom_histogram(bins = 100) + 
  labs(x = "peso in carati",
       y = "conta",
       title = "distribuzione del peso in carati di diamanti") +
  scale_y_log10() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

dfpoly + geom_histogram(bins = 100) + 
  labs(x = "peso in carati",
       y = "conta",
       title = "distribuzione del peso in carati di diamanti") +
  scale_y_log10(limits = c(1,10^4), breaks = scales::trans_breaks("log10", function(x) 10^x),
                labels = scales::trans_format("log10", scales::math_format(10^.x))) +
  scale_x_continuous(breaks = seq(0,5,0.5), minor_breaks = seq(0,5,0.1)) +
  annotation_logticks(sides = "l") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

dfpoly + geom_histogram(aes(fill = cut), bins = 100) + 
  labs(x = "peso in carati",
       y = "conta",
       fill = "taglio",
       title = "distribuzione del peso in carati di diamanti") +
  scale_y_continuous(limits = c(0,6000), minor_breaks = seq(0,6000,200)) +
  scale_x_continuous(breaks = seq(0,5,0.5), minor_breaks = seq(0,5,0.1)) +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

dfpoly + geom_histogram(bins = 100) + 
  facet_grid(cut ~ clarity) +
  labs(x = "peso in carati",
       y = "conta",
       fill = "taglio",
       title = "distribuzione del peso in carati di diamanti, in funzione di taglio e chiarezza") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# aggiungere funzioni di densità teorica
data("survey")
male_students <- dplyr::filter(survey, Sex == "Male" & !is.na(Height))
ggplot(male_students) +
  geom_histogram(aes(x = Height, y = after_stat(density)), bins = 10) +
  stat_function(fun = dnorm,
                args = list(mean = mean(male_students$Height),
                            sd = sd(male_students$Height))) +
  geom_vline(xintercept = mean(male_students$Height)) +
  geom_vline(xintercept = c(mean(male_students$Height)-sd(male_students$Height),
                            mean(male_students$Height)+sd(male_students$Height)), 
             linetype = I(2)) +
  labs(x = "altezza, cm",
       y = "densità") +
  theme_bw()

# poligoni di freque za
dfpoly <- ggplot(data = diamonds, aes(x=carat))
dfpoly + geom_freqpoly(aes(colour = cut)) + 
  ggtitle("Distribuzione del peso di diamandi, carati, per diamanti con qualità di taglio diverso") +
  labs(x = "carati", y = "conta") +
  scale_colour_brewer(type = "qual", palette = "Dark2") +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# grafici ad area
dfpoly + geom_area(aes(fill= cut), stat = "bin", position = "stack") +
  ggtitle("Distribuzione del peso di diamandi, carati, in funzione del taglio") +
  labs(x = "carati", y = "conta") +
  scale_fill_brewer(type = "qual", palette = "Dark2") +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

ggplot(diamonds, aes(x= carat, y = price)) + 
  geom_bin2d(bins = c(20,20)) + 
  facet_grid(~ cut) +
  ggtitle("distribuzione dei diamanti, per prezzo e peso in carati") +
  scale_fill_gradientn(colours = heat.colors(10), trans = "log1p",
                       breaks = scales::trans_breaks("log10", function(x) 10^x)) +  
  labs(title = "distribuzione dei diamanti, per prezzo e peso in carati",
       x = "Prezzo, US$",
       y = "Peso, carati") +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

dfpoly + 
  geom_density(aes(colour = cut), kernel = "e") +
  labs(x = "peso in carati", y = "densità", colour = "taglio") +
  scale_colour_brewer(type = "qual", palette = "Dark2") +
  theme_bw()

# un grafico a dispersione con due rappresentazioni della densità:
# dei rug plot sugli assi e un contour plot
# prova a sperimentare con vari valori di n in geom_density_2d
ggplot(dplyr::filter(diamonds, carat<3), aes(x= carat, y = price)) + 
  geom_point(size = I(0.05), alpha = 0.1) + 
  geom_rug(sides = "bl", alpha = 0.005) +
  geom_density_2d(n = 100, colour = "red") +
  labs(x = "peso in carati", y = "densità") +
  theme_bw()

# qui escludo i diamanti più grandi che sono pochissimi
ggplot(dplyr::filter(diamonds, carat<1.5, price <5000), aes(x= carat, y = price)) + 
  geom_density_2d_filled(alpha = 0.5, contour_var = "count") + 
  scale_x_continuous(limits = c(0,1.5), breaks = seq(0,1.5,0.1), 
                     minor_breaks = seq(0,3, 0.1))+
  labs(x = "peso in carati", y = "prezzo, US$") +
  theme_bw()

# un'altra possibilità è usare una scala continua
ggplot(dplyr::filter(diamonds, carat<1.5, price <5000), aes(x= carat, y = price)) + 
  stat_density_2d_filled(geom = "raster",
                         aes(fill = after_stat(density)),
                         contour = FALSE,
                         n=200
  ) + 
  scale_fill_viridis_b(direction = -1, option = "C")+ 
  scale_x_continuous(limits = c(0,1.5), breaks = seq(0,1.5,0.1), 
                     minor_breaks = seq(0,3, 0.1))+
  labs(x = "peso in carati", y = "prezzo, US$") +
  theme_bw()


#  boxplot ----------------------------------------------------------------

survey_dati_completi <- survey %>% tidyr::drop_na()
ggplot(survey_dati_completi, aes(x=Sex, y=Height)) +
  geom_boxplot() +
  labs(
    title = "Altezza in cm di studenti della Univ. Adelaide",
    caption = "Venables, W. N. and Ripley, B. D. (2002) Modern Applied Statistics with S-PLUS. Fourth Edition. Springer.",
    x = "Sesso",
    y = "Altezza, cm") +
  scale_x_discrete("Sesso", labels = c("Female" = "Femmine", "Male" = "Maschi")) +
  theme(plot.title = element_text(hjust = 0.5))

ggplot(survey_dati_completi, aes(x=Sex, y=Height)) +
  geom_violin() +
  geom_boxplot(width = 0.4, colour = "blue", notch = T) +
  geom_jitter(colour = I("blue"), alpha = I(0.2), width = 0.2) +
  labs(
    title = "Altezza in cm di studenti della Univ. Adelaide",
    caption = "Venables, W. N. and Ripley, B. D. (2002) Modern Applied Statistics with S-PLUS. Fourth Edition. Springer.",
    x = "Sesso",
    y = "Altezza, cm") +
  scale_x_discrete("Sesso", labels = c("Female" = "Femmine", "Male" = "Maschi")) +
  theme(plot.title = element_text(hjust = 0.5))


# Rappresentazioni di indicatori di tendenza centrale e variabilità -------

# uso funzioni di `dplyr` per calcolare statistiche per gruppi con `summarise`
# devst è la deviazione standard, IQR il range interquartile e n_oss il
# numero di osservazioni, q25 e q75 il 25° e 75° quantile
data("iris")
iris_stat <- iris %>%
  group_by(Species) %>%
  dplyr::summarise(mediaPW = mean(Petal.Width),
                   medianaPW = median(Petal.Width),
                   devstPW = sd(Petal.Width),
                   q25 = quantile(Petal.Width, 0.25),
                   q75 = quantile(Petal.Width, 0.75),
                   n_oss = n())
# calcolo errore standard e limiti inferiori e superiori dell'intervallo di 
# confidenza usando alpha = 0.05
# con gdl = n_oss-1 gradi di libertà
alpha = 0.05
iris_stat <- iris_stat %>%
  mutate(errstPW = devstPW/sqrt(n_oss),
         gdl = n_oss-1) %>%
  mutate(conf_min = mediaPW-qt(alpha/2, df = gdl, lower.tail = F)*errstPW,
         conf_max = mediaPW+qt(alpha/2, df = gdl, lower.tail = F)*errstPW
  )
# nota come è possibile anche ottenere l'intervallo di confidenza della media 
# con t.test() ma occorre estrarre i risultati dalla lista ottenuta con il test

# uso geom_point range con l'intervallo di confidenza
ggplot(iris_stat, aes(x = Species)) +
  geom_pointrange(aes(y = mediaPW, ymin = conf_min, ymax = conf_max), size = I(0.2)) +
  labs(x = "Specie", 
       y = str_wrap("Larghezza dei petali, media con intervallo di confidenza, alpha = 0.05", 50))

# qui uso il colore ma sopprimo la legenda, perché inutile
ggplot(iris_stat, aes(x = Species, y = mediaPW)) +
  geom_linerange(aes(ymin = conf_min, ymax = conf_max)) +
  geom_col(aes(fill = Species), alpha = 0.5, show.legend = F) + 
  labs(x = "Specie", 
       y = str_wrap("Larghezza dei petali, media con intervallo di confidenza, alpha = 0.05", 50))


# Grafici a dispersione ---------------------------------------------------

irisggplot <- iris %>% 
  ggplot(aes(x=Sepal.Length, y=Sepal.Width, shape = Species, colour = Species)) +
  geom_point()
irisggplot

# un rugplot
irisggplot + geom_rug(sides = "tr")
# uno smoother non parametrico diverso per ciascuno dei gruppi
irisggplot + 
  geom_rug(sides = "tr") +
  geom_smooth()

irisggplot + 
  geom_smooth(se = F, linewidth = I(0.5)) +
  geom_smooth(method = "lm", formula = y ~ x, se = F, linetype = I(2), linewidth = I(0.5))

irisggplot  + 
  geom_smooth(se = F, linewidth = I(0.5)) +
  geom_smooth(method = "lm", formula = y ~ x, se = F, linetype = I(2), 
              linewidth = I(0.5)) +
  stat_ellipse(
    type = "t",
    level = 0.95,
    linewidth = I(0.5)
  )

# install.packages("ggpubr") necessario solo se non è già presente nella libreria
library(ggpubr)
ggpubr::show_point_shapes()

mpg_ridotto <- mpg %>%
  dplyr::filter(class %in% c("compact", "midsize", "subcompact", "suv"))

mpg_layer_base <- ggplot(mpg_ridotto, mapping = aes(x=cty, y = hwy))


my_shapes <- c("compact" = 16, "midsize" = 17, "subcompact" = 15, "suv" = 18)

mpg_cty_hwy_displ <- mpg_layer_base +
  geom_point(aes(shape = class, size = displ, colour = fl)) +
  scale_shape_manual(values = my_shapes) +
  scale_colour_brewer(type = "qual", palette = "Paired") +
  labs(title = "geom_point") +
  guides(size = guide_legend(ncol = 2), 
         colour = guide_legend(ncol = 2)) +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5),
        legend.position = "right")

mpg_cty_hwy_displ

mpg_cty_hwy_displ_2 <- mpg_layer_base +
  geom_jitter(aes(shape = class, colour = displ)) +
  scale_shape_manual(values = my_shapes) +
  scale_colour_viridis(option = "B") +
  labs(title = "geom_jitter") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5),
        legend.position = "bottom")
mpg_cty_hwy_displ_2

mpg_cty_hwy_displ_3 <- mpg_layer_base +
  facet_wrap(~class) +
  geom_jitter(aes(colour = displ, shape = as.factor(cyl))) +
  scale_colour_viridis(option = "B") +
  labs(title = "geom_jitter e facets", shape = "cyl") +
  scale_shape_manual(values = c(16,17,15,18)) +
  theme(plot.title = element_text(hjust = 0.5))
mpg_cty_hwy_displ_3


# Personalizzare i grafici con ggplot2 ------------------------------------

mpg_cty_hwy_displ_3 + theme_bw()
mpg_cty_hwy_displ_3 + theme_classic()
mpg_cty_hwy_displ_3 + theme_dark()
mpg_cty_hwy_displ_3 + theme_light()
mpg_cty_hwy_displ_3 + theme_minimal()


#  veloce veloce: qplot ---------------------------------------------------


qplot(x, y, ..., data, facets,margins, geom, xlim, ylim, log, main, xlab, ylab, asp)

# uno scatterplot (generato in automatico perché x e y sono quantitative)
data(mpg)
qplot(x = displ, y = hwy, data = mpg)
# con qualche personalizzazione in più
qplot(x = displ, y = hwy, shape = factor(cyl), data = mpg)
# un barplot (il default per una sola variabile x qualitativa)
qplot(x = class, data = mpg)
# un istogramma (il default per una sola variabile x quantitativa)
qplot(x = displ, data = mpg)
# diventa un density plot se si indica il geoma
qplot(x = displ, data = mpg, geom = "density")
# con facets
qplot(x = displ, data = mpg, geom = "density", facets = ~factor(cyl))
# altri estetici e etichette e titoli, 
qplot(displ, hwy, data = mpg, colour = factor(cyl),  
      main = "cilindrata e consumo in autostrada", 
      xlab = "cilindrata",
      ylab = "miglia per gallone in autostrada")
# un bubble plot
qplot(displ, hwy, data = mpg, colour = factor(cyl), size = cty)
# una combinazione di grafici
qplot(class, hwy, data = mpg, geom = c("jitter", "boxplot"), alpha = I(0.6))
qplot(displ, hwy, data = mpg, geom = c("point", "smooth"))


#  La grafica di base di R ------------------------------------------------

# un barplot
# bisogna prima ricavare la tabella delle conte
Arthritis_tabulazione <- xtabs( ~ Improved + Treatment, data = Arthritis)
# poi lo strato ocn il barplot
barplot(Arthritis_tabulazione, col = rainbow(3), ylim = c(0,50))
# poi la legenda
legend(x = "top", legend = levels(Arthritis$Improved), pch = 15, col = rainbow(3), ncol = 3)


# uno scatterplot ---------------------------------------------------------

# puoi farti un'idea del range ideale con
# range(iris$Sepal.Length)
# range(iris$Sepal.Width)
plot(Sepal.Length ~ Sepal.Width, data = subset(iris, Species == "setosa"), 
     pch = 16, col = "red", las = 1,
     xlab = "larghezza dei sepali", ylab = "lunghezza dei sepali",  
     main = "relazione fra larghezza e lunghezza dei sepali in tre specie di Iris",
     xlim = c(2,5), ylim = c(4,8))
abline(lm(Sepal.Length ~ Sepal.Width, data = subset(iris, Species == "setosa")), 
       col = "red", lty = 1)
points(Sepal.Length ~ Sepal.Width, data = subset(iris, Species == "versicolor"), 
       pch = 17, col = "blue", xlab="", ylab="", las = 1)
abline(lm(Sepal.Length ~ Sepal.Width, data = subset(iris, Species == "versicolor")), 
       col = "blue", lty = 2)
points(Sepal.Length ~ Sepal.Width, data = subset(iris, Species == "virginica"), 
       pch = 15, col = "cyan", xlab="", ylab="", las = 1)
abline(lm(Sepal.Length ~ Sepal.Width, data = subset(iris, Species == "virginica")), 
       col = "cyan", lty = 3)
legend(x = "bottomright", 
       legend = levels(iris$Species), pch = c(16,17,15), col = c("red", "blue", "cyan"))

# diagnostici nell'analisi della varianza
par(mfrow=c(2,2))
plot(aov(Petal.Length ~ Species, data = iris))
par(opar)

