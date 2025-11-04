library(haven)
library(openxlsx)

getwd()
setwd("/Users/nicosteffen/Documents/01 Arbeit/01 CFH/06 Lehre/Fit für R/Fit-fuer-R_Datenimport_Aufbereitung")


df = read.csv("klinische_patientendaten.csv")
df = read.csv2("klinische_patientendaten.csv2")

df = read_sav("klinische_patientendaten.sav")

df = read.xlsx("klinische_patientendaten.xlsx")

df = read_sav("https://raw.githubusercontent.com/NicoSteffen/Fit-fuer-R_Datenimport_Aufbereitung/main/klinische_patientendaten.sav")



View(df)
head(df)
names(df)

df$Patienten_ID
df$Alter

df[1,]
df[,3]
df[10,3]

str(df)

df$Geschlecht = as.factor(df$Geschlecht)
df$Bildungsgrad = as.factor(df$Bildungsgrad)
df$Behandlungsgruppe = as.factor(df$Behandlungsgruppe)
df$Raucher = as.factor(df$Raucher)


table(df$Geschlecht)

mean(df$Alter)
mean(df$BMI, na.rm = T)

# Zeilen auswählen 

df[3,]
df[6:8,]

df[c(2,4,7),]

mean(df[df$Behandlungsgruppe == "Intervention A",]$BMI, na.rm = T)

mean(df$BMI[df$Geschlecht == "Weiblich"], na.rm=T)














