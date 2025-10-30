# https://stephangoerigk.github.io/CFH_R_bookdown/über-dieses-skript.html
# https://github.com/NicoSteffen/Fit-fuer-R_Datenimport_Aufbereitung


#neues Projekt starten 
getwd()
setwd("/Users/nicosteffen/Documents/01 Arbeit/01 CFH/06 Lehre/Fit für R/Fit-fuer-R_Datenimport_Aufbereitung")


# direkt über github --> r Kurs ordner studynte

# Grundfunktionen ect. Pakete lesen 


daten_csv <- read.csv("klinische_patientendaten.csv")
daten_csv2 <- read.csv2("klinische_patientendaten.csv2")

# install.packages("haven")
#library(haven)
daten_sav <- read_sav("klinische_patientendaten.sav")

# install.packages("openxlsx")
#library(openxlsx)
daten_xlsx <- read.xlsx("klinische_patientendaten.xlsx")

?read_sav

df = daten_csv2

View(df)
head(df)
names(df)

df$Patienten_ID

df[3,2]
df[3,]
df[,2]

str(df)

# chr (character / Zeichenkette): Das ist reiner Text.
# int (integer / Ganze Zahl): Dies sind ganze Zahlen ohne Nachkommastellen.
# num (numeric / Numerisch): Dies ist der Standardtyp für alle Zahlen
# dbl (double): Für Zahlen mit Dezimalstellen

# müssen in Faktor umwandeln 

df$Geschlecht <- as.factor(patienten_daten$Geschlecht)
df$Bildungsgrad <- as.factor(patienten_daten$Bildungsgrad)
df$Behandlungsgruppe <- as.factor(patienten_daten$Behandlungsgruppe)
df$Raucher <- as.factor(patienten_daten$Raucher)

table(df$Geschlecht)

mean(df$Alter)

mean(df$BMI)
mean(df$BMI, na.rm = T)

# Zeilen auswählen

df[1:5,]
df2 = df[1:5,]

df[df$Behandlungsgruppe == "Intervention A",]

df[df$Behandlungsgruppe == "Intervention A",]$BMI

mean(df[df$Behandlungsgruppe == "Intervention A",]$BMI, na.rm = T)

# dieser hier einfachster
mean(df$Alter[df$Geschlecht == "Weiblich"])


# Mit which

df$Geschlecht == "Männlich"
which(df$Geschlecht == "Männlich")
df$BMI[which(df$Geschlecht == "Männlich")]
mean(df$BMI[which(df$Geschlecht == "Männlich")], na.rm = T)
mean(df$BMI[which(df$Geschlecht == "Weiblich")], na.rm = T)

sd(df$BMI[which(df$Geschlecht == "Weiblich")], na.rm = T)
var(df$BMI[which(df$Geschlecht == "Weiblich")], na.rm = T)

# grep

df[, grep("LQ_", colnames(df))]

# Variablen / Spalten auswählen

library(dplyr)
select(df, starts_with("LQ_"))

# Daten aufbereiten 

#remove ID-1 (test run)
df <- df[df$Patienten_ID != "PAT_1001", ]

table(df$Geschlecht)

#remove ID-1 (test run)
df <- df[df$Geschlecht != "Divers", ]

table(df$Geschlecht)
df$Geschlecht <- droplevels(df$Geschlecht)

#excludion of age > 75
df <- df[df$Alter < 76, ]

range(df$Alter)


library(dplyr)
df_dplyr <- filter(df, 
                   Alter < 76, 
                   Geschlecht != "Divers",
                   !is.na(BMI)
)



# Umkodierung und Umbenennung:

df$LQ_01 = 6 - df$LQ_01

df$LQ_01 = dplyr::recode(df$LQ_01, `1` = 5, `2` = 4, `3` = 3, `4` = 2, `5` = 1)

# Skalen aggregieren 

df$LQ_total = rowMeans(df[, grep("LQ_0", colnames(df))], na.rm = TRUE)

# STR Summe!

df[,grep("STR", colnames(df))]

# wichtig auf NA checken!!!! 

colSums(is.na(df[,grep("STR", colnames(df))]))


df$STR_sum = rowSums(df[,grep("STR_0", colnames(df))])
# zeigen dass man nicht öfter drauf drücken darf


#mean_bmi <- mean(df$BMI, na.rm = TRUE)
#df$BMI[is.na(df$BMI)] <- mean_bmi
#sum(is.na(df$BMI))


# jetzt mal den bereinigten Datensatz speichern

write.csv2(df, "df_bereinigt.csv2", row.names = FALSE)
saveRDS(df, "df_bereinigt.rds")

df_neu_csv <- read.csv2("df_bereinigt.csv2")
df_neu_rds <- readRDS("df_bereinigt.rds")

str(df_neu_csv)
str(df_neu_rds)

# Deskriptivstatistiken

library(psych)
psych::describe(df)
describeBy(df, group = df$Behandlungsgruppe)

library(report)

report_sample(df, by = "Behandlungsgruppe")

sample_report = df[,c("Alter", "Geschlecht", "Bildungsgrad", "BMI", "Raucher", "LQ_total", "STR_sum", "Behandlungsgruppe")]

names(df)

report_sample(sample_report, by = "Behandlungsgruppe")

flextable::flextable(report_sample(sample_report, by = "Behandlungsgruppe"))

flextable::save_as_docx(flextable::flextable(report_sample(sample_report, by = "Behandlungsgruppe")), path = "Table1.docx")



