# --- Simulation eines klinischen Datensatzes ---

# 1. Reproduzierbarkeit sicherstellen
# set.seed() sorgt dafür, dass die "zufälligen" Daten bei jedem Ausführen 
# des Skripts identisch sind. Wichtig für die Lehre!
set.seed(123)

# 2. Anzahl der Patienten festlegen
n_patienten <- 150

# 3. Soziodemografische Variablen erstellen
pat_id <- paste0("PAT_", 1001:(1000 + n_patienten))
alter <- sample(18:85, n_patienten, replace = TRUE) # Alter zwischen 18 und 85
geschlecht <- sample(c("Weiblich", "Männlich", "Divers"), n_patienten, 
                     replace = TRUE, prob = c(0.51, 0.48, 0.01)) # Mit Wahrscheinlichkeiten
bildung <- sample(c("Niedrig", "Mittel", "Hoch"), n_patienten, 
                  replace = TRUE, prob = c(0.2, 0.5, 0.3))

# 4. Klinische Gruppen- und Basisvariablen
gruppe <- sample(c("Kontrolle", "Intervention A", "Intervention B"), n_patienten, 
                 replace = TRUE)
bmi <- round(rnorm(n_patienten, mean = 28, sd = 6), 1) # Body-Mass-Index
raucher_status <- sample(c("Nie", "Ehemalig", "Ja"), n_patienten, 
                         replace = TRUE, prob = c(0.6, 0.25, 0.15))
diagnose_jahr <- sample(2015:2024, n_patienten, replace = TRUE) # Jahr der Diagnose

# 5. Fragebogen-Items (Rohwerte)
# Fiktiver Fragebogen "Lebensqualität" (LQ_01 bis LQ_05)
# Annahme: Likert-Skala von 1 (stimme gar nicht zu) bis 5 (stimme voll zu)
lq_01 <- sample(1:5, n_patienten, replace = TRUE)
lq_02 <- sample(1:5, n_patienten, replace = TRUE)
lq_03 <- sample(1:5, n_patienten, replace = TRUE)
lq_04 <- sample(1:5, n_patienten, replace = TRUE)
lq_05 <- sample(1:5, n_patienten, replace = TRUE)

# Fiktiver Fragebogen "Stress-Skala" (STR_01 bis STR_03)
# Annahme: Skala von 0 (nie) bis 4 (sehr oft)
str_01 <- sample(0:4, n_patienten, replace = TRUE)
str_02 <- sample(0:4, n_patienten, replace = TRUE)
str_03 <- sample(0:4, n_patienten, replace = TRUE)


# 6. Alles zu einem Data Frame zusammenfügen
patienten_daten <- data.frame(
  Patienten_ID = pat_id,
  Alter = alter,
  Geschlecht = geschlecht,
  Bildungsgrad = bildung,
  Behandlungsgruppe = gruppe,
  Diagnosejahr = diagnose_jahr,
  BMI = bmi,
  Raucher = raucher_status,
  LQ_01 = lq_01,
  LQ_02 = lq_02,
  LQ_03 = lq_03,
  LQ_04 = lq_04,
  LQ_05 = lq_05,
  STR_01 = str_01,
  STR_02 = str_02,
  STR_03 = str_03
)

# 7. (SEHR WICHTIG!) Realismus durch fehlende Werte (NAs)
# Echte Datensätze sind selten vollständig. Das ist wichtig für die Datenaufbereitung.
# Wir fügen 10 zufällige NAs in die BMI-Spalte ein
patienten_daten$BMI[sample(1:n_patienten, 10)] <- NA
# Wir fügen 5 zufällige NAs in das Item LQ_03 ein
patienten_daten$LQ_03[sample(1:n_patienten, 5)] <- NA

###

# 8. Kategoriale Variablen in Faktoren umwandeln (Good Practice)
patienten_daten$Geschlecht <- as.factor(patienten_daten$Geschlecht)
patienten_daten$Bildungsgrad <- as.factor(patienten_daten$Bildungsgrad)
patienten_daten$Behandlungsgruppe <- as.factor(patienten_daten$Behandlungsgruppe)
patienten_daten$Raucher <- as.factor(patienten_daten$Raucher)

# --- Überprüfung und Export ---

# Zeige die ersten 6 Zeilen des Datensatzes an
print("Kopfzeilen des Datensatzes:")
print(head(patienten_daten))

# Zeige die Struktur des Datensatzes (Variablentypen, etc.)
print("Struktur des Datensatzes:")
str(patienten_daten)

# --- Speichern des Datensatzes für den Kurs ---
# Deine Studierenden können diesen Teil dann zum "Laden" verwenden.

# 1. Als CSV-Datei (das gängigste Format)
# row.names = FALSE verhindert, dass R die Zeilennummern mitspeichert.
write.csv(patienten_daten, "klinische_patientendaten.csv", row.names = FALSE)
write.csv2(patienten_daten, "klinische_patientendaten.csv2", row.names = FALSE)


# 2. Als R-eigenes Format (schnellstes Laden/Speichern in R)
saveRDS(patienten_daten, "klinische_patientendaten.rds")

# 3. Als Excel-Datei (dafür braucht man ein Paket)
install.packages("openxlsx") # Muss einmalig installiert werden
library(openxlsx)
write.xlsx(patienten_daten, "klinische_patientendaten.xlsx")

write_sav(patienten_daten, "klinische_patientendaten.sav")

# Zuerst muss das Paket "haven" installiert sein (falls noch nicht geschehen)
install.packages("haven")

# Lade das Paket, um die Funktion nutzen zu können
library(haven)

