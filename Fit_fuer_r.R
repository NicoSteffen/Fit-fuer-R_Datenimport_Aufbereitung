df = read.csv2("https://raw.githubusercontent.com/NicoSteffen/Fit-fuer-R_Datenimport_Aufbereitung/main/klinische_patientendaten.csv2")
df

#csv = read.csv("klinische_patientendaten.csv") # CSV Datensatz einlesen 

# install.packages("haven")
library(haven)
#sav = read_sav("klinische_patientendaten.sav")

library(openxlsx)
#xls = read.xlsx("klinische_patientendaten.xlsx")

?haven

head(df)
names(df)
View(df)

ncol(df)
nrow(df)

table(df$Geschlecht)

library(tidyverse)

summary(df)

str(df)

df$Geschlecht = factor(df$Geschlecht, labels = c("diverse", "male", "female"))
df$Bildungsgrad = factor(df$Bildungsgrad)
df$Behandlungsgruppe = factor(df$Behandlungsgruppe)
df$Raucher = factor(df$Raucher)

# geschlecht = c(1,2,1,2,3,2,1,2,1,1)
# geschlecht = factor(geschlecht, levels = c(1,2,3), labels = c("male", "female", "diverse"))

#skalar = 3
#vektor = c(2,1,3,4,5,6,6)
#vektor_char = c("Freud", "Simon", "Petra")

df$Bildungsgrad
df[1:6,]
df[2,3:5]

df$BMI[df$Behandlungsgruppe == "Kontrolle"]
mean(df$BMI[df$Behandlungsgruppe == "Intervention B"], na.rm = TRUE)
mean(df$Alter)
sd(df$Alter)
var(df$Alter)

InterventionA = df[df$Behandlungsgruppe == "Intervention A", ]
nrow(InterventionA)

table(df$Behandlungsgruppe)

select(df, starts_with("LQ"))
names(df)

# ID war ein Testlauf
df = df[df$Patienten_ID != "PAT_1001",]

table(df$Geschlecht)

df = df[df$Geschlecht != "diverse", ]

df$Geschlecht = droplevels(df$Geschlecht)









