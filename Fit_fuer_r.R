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

df_dyplr = filter(df,
                  Alter < 76,
                  Geschlecht != "diverse")


# Skalen umkodieren -------------------------------------------------------

# Item 1 der LQ Skala ist invertiert 

df_original = df

#df$LQ_01r = 6 - df$LQ_01
df$LQ_01 = 6 - df_original$LQ_01

#select(df, starts_with("LQ"))
#df[,c("LQ_02", "LQ_03")]

# df$LQ_01 = recode(df$LQ_01, "1" = 5, "2" = 4, "4" = 2, "5" = 1)

summary(df)

df$mean_LQ = rowMeans(select(df, starts_with("LQ")), na.rm = TRUE)
df$sum_STR = rowSums(select(df, starts_with("STR")))

write_rds(df, "df_clean.rds")
df2 = readRDS("df_clean.rds")


# Deskriptivstatistiken ---------------------------------------------------

#install.packages("psych")
library(psych)

psych::describe(df)
describeBy(df, group = df$Behandlungsgruppe)

#install.packages("report")
#install.packages("flextable")
library(report)
library(flextable)

sample_report = df[,c("Alter", "Geschlecht", "Bildungsgrad", "Behandlungsgruppe", 
                       "BMI", "mean_LQ", "sum_STR")]

table1 = report_sample(sample_report, by = "Behandlungsgruppe")

tab = flextable(table1)
tab = bold(tab, i = c(2,3), j = 3, part = "body")
tab = theme_apa(tab)
tab = add_header_lines(tab, values = "Tabelle.1 Stichprobenbeschreibung")
tab = align(tab, i = c(1,2), align = "left", part = "header")
tab = add_footer_lines(tab, values = "Anmerkung. n = Stichprobengröße, Mean = Mittelwert, SD = Standardabweichung")
tab = theme_apa(tab)
tab

save_as_docx(tab, path = "Table1.docx")











