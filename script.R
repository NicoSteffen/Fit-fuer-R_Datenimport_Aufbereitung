# https://stephangoerigk.github.io/CFH_R_bookdown/über-dieses-skript.html
# https://github.com/NicoSteffen/Fit-fuer-R_Datenimport_Aufbereitung

https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fforms.cloud.microsoft%2Fe%2F69P2gaDDSi&data=05%7C02%7Cnico.steffen%40charlotte-fresenius-uni.de%7Cbabb153c1fb24934209708df43d044af%7C2ed718a0fb7d466d9595cfef0d253184%7C0%7C0%7C639304234112894928%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=dh0vq47mSHidG2Wk0DMRt9OOeJdpktVGs9U9tr9g0NI%3D&reserved=0

#neues Projekt starten 


# install.packages("haven")
#install.packages("openxlsx")

library(haven)
library(openxlsx)
library(dplyr)
library(psych)
library(report)
library(flextable)




# direkt über github --> r Kurs ordner studynte

# Grundfunktionen ect. Pakete lesen 

daten_csv <- read.csv("klinische_patientendaten.csv")
daten_csv2 <- read.csv2("klinische_patientendaten.csv2")
daten_csv2 <- read.csv2("https://raw.githubusercontent.com/NicoSteffen/Fit-fuer-R_Datenimport_Aufbereitung/main/klinische_patientendaten.csv2")

# install.packages("haven")
library(haven)
daten_sav <- read_sav("klinische_patientendaten.sav")
daten_sav <- read_sav("https://raw.githubusercontent.com/NicoSteffen/Fit-fuer-R_Datenimport_Aufbereitung/main/klinische_patientendaten.sav")

# install.packages("openxlsx")
library(openxlsx)
daten_xlsx <- read.xlsx("klinische_patientendaten.xlsx")

?read_sav

df = daten_csv2

View(df)
head(df)
names(df)

df$Patienten_ID

str(df)

# chr (character / Zeichenkette): Das ist reiner Text.
# int (integer / Ganze Zahl): Dies sind ganze Zahlen ohne Nachkommastellen.
# num (numeric / Numerisch): Dies ist der Standardtyp für alle Zahlen
# dbl (double): Für Zahlen mit Dezimalstellen

# müssen in Faktor umwandeln 

df$Geschlecht <-factor(df$Geschlecht)
df$Bildungsgrad <- as.factor(df$Bildungsgrad)
df$Behandlungsgruppe <- as.factor(df$Behandlungsgruppe)
df$Raucher <- as.factor(df$Raucher)

table(df$Geschlecht)


df[3,2]
df[3,]
df[,2]

mean(df$Alter)

mean(df$BMI)
mean(df$BMI, na.rm = T)

# Zeilen auswählen

df[1:5,]
df2 = df[1:5,]
df[c(2,4,7),]

df[df$Behandlungsgruppe == "Intervention A",]

df[df$Behandlungsgruppe == "Intervention A",]$BMI

mean(df[df$Behandlungsgruppe == "Intervention A",]$BMI, na.rm = T)

# dieser hier einfachster
mean(df$Alter[df$Geschlecht == "Weiblich"])


# Mit which

which(df$Geschlecht == "Männlich")
df$BMI[which(df$Geschlecht == "Männlich")]
mean(df$BMI[which(df$Geschlecht == "Männlich")], na.rm = T)
mean(df$BMI[which(df$Geschlecht == "Weiblich")], na.rm = T)

sd(df$BMI[which(df$Geschlecht == "Weiblich")], na.rm = T)
var(df$BMI[which(df$Geschlecht == "Weiblich")], na.rm = T)



# Variablen / Spalten auswählen

# grep
df[, grep("LQ_", colnames(df))]

library(dplyr)
select(df, starts_with("LQ_"))

# Daten aufbereiten 

#remove ID-1 (test run)
df <- df[df$Patienten_ID != "PAT_1001", ]

table(df$Geschlecht)

#remove Divers
df <- df[df$Geschlecht != "Divers", ]

table(df$Geschlecht)
df$Geschlecht <- droplevels(df$Geschlecht)

#excludion of age > 75
df <- df[df$Alter < 76, ]

range(df$Alter)


# return before 

df_dplyr <- filter(df, 
                   Alter < 76, 
                   Geschlecht != "Divers",
                   !is.na(BMI)
)



# Umkodierung und Umbenennung:

# LQ Skala 1 - 5
# STR Skala 0 - 4

# Item 1 Invertieren
df$LQ_01 = 6 - df$LQ_01


# Skalen aggregieren 

# LQ Fragebogen Mittelwerte

colSums(is.na(df[,grep("LQ", colnames(df))]))

# LQ_3 5 NAs

df$LQ_03

df$total_LQ = rowMeans(select(df, starts_with("LQ_")), na.rm = TRUE)

# STR Summe!


# wichtig auf NA checken!!!! 

colSums(is.na(select(df, starts_with("STR"))))


df$STR_sum = rowSums(df[,grep("STR_0", colnames(df))])




# jetzt mal den bereinigten Datensatz speichern

write.csv2(df, "df_bereinigt.csv2")
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
library(flextable)

sample_report = df[,c("Alter", "Geschlecht", "Bildungsgrad", "BMI", "Raucher", "LQ_total", "STR_sum", "Behandlungsgruppe")]

names(df)

table1 = report_sample(sample_report, by = "Behandlungsgruppe")

APA_table = flextable::flextable(table1)

flextable::save_as_docx(APA_table, path = "Table1.docx")

APA_table = flextable::flextable(tab)
APA_table = add_header_lines(APA_table, values = "Tabelle 1. Stichprobenbeschreibung")
APA_table = add_footer_lines(APA_table, values = "Anmerkung. Mean = Mittelwert, SD = Standardabweichung")
APA_table = theme_apa(APA_table)
APA_table = align(APA_table, i = c(1,2), align = "left", part = "header")

