# install.packages("haven")
#install.packages("openxlsx")

library(haven)
library(openxlsx)
library(dplyr)
library(psych)
library(report)
library(flextable)

#getwd()
#setwd("/Users/nicosteffen/Documents/01 Arbeit/01 CFH/06 Lehre/Fit für R/Fit-fuer-R_Datenimport_Aufbereitung")

df = read.csv("klinische_patientendaten.csv")
df = read.csv2("klinische_patientendaten.csv2")

df_sav = read_sav("klinische_patientendaten.sav")

df_xl = read.xlsx("klinische_patientendaten.xlsx")

df = read.csv2("https://raw.githubusercontent.com/NicoSteffen/Fit-fuer-R_Datenimport_Aufbereitung/main/klinische_patientendaten.csv2")

View(df)
head(df)
names(df)
str(df)


df[1:10,4]

df$Alter[4]

# Char in Faktor Variablen umwandeln 

df$Geschlecht = as.factor(df$Geschlecht)
df$Bildungsgrad = as.factor(df$Bildungsgrad)
df$Behandlungsgruppe = as.factor(df$Behandlungsgruppe)
df$Raucher = as.factor(df$Raucher)

# basics 

mean(df$Alter)

mean(df$Alter[df$Behandlungsgruppe == "Intervention A"])
mean(df[df$Behandlungsgruppe == "Intervention A",]$Alter)

sd(df$Alter)
var(df$Alter)

table(df$Geschlecht)
table(df$Bildungsgrad)


# grep

df[,grep("LQ_", names(df))]

select(df, starts_with("LQ_"))



# Daten Aufbereiten 

# ID1 Testlauf

df = df[df$Patienten_ID != "PAT_1001",]

table(df$Geschlecht)

df = df[df$Geschlecht != "Divers",]

table(df$Geschlecht)

df$Geschlecht = droplevels(df$Geschlecht)

# Alter < 75

df = df[df$Alter < 76,]

range(df$Alter)


df_dplyr = filter(df,
                  Patienten_ID != "PAT_1001",
                  Alter < 76,
                  Geschlecht != "Divers")

mean(df$BMI, na.rm = T)

# Datenaggregation, Umkodieren

# LQ_1 invertiert 

df$LQ_01 = 6 - df$LQ_01

df$LQ_01 = dplyr::recode(df$LQ_01, `1` = 5, `2` = 3, `4` = 2, `5` = 1)

# Skalen aggregieren 

df$LQ_total = rowMeans(df[,grep("LQ_", names(df))], na.rm = T)

# STR -> Summe 

colSums(is.na(df[,grep("STR", names(df))]))

df$STR_sum = rowSums(df[,grep("STR", names(df))])


write.csv2(df, "df_sauber.csv2")
saveRDS(df, "df_sauber.rds")

# Deskreptivstatistiken 


psych::describe(df)
describeBy(df, group = df$Behandlungsgruppe)

report_sample(df, by = "Behandlungsgruppe")

sample_report = df[,c("Alter", "Geschlecht", "Bildungsgrad", "Behandlungsgruppe", "BMI", "Raucher", "LQ_total", "STR_sum" )]

report_sample(sample_report, by = "Behandlungsgruppe")

flextable(report_sample(sample_report, by = "Behandlungsgruppe"))

flextable::save_as_docx(flextable(report_sample(sample_report, by = "Behandlungsgruppe")), path = "Table1.docx")


























































