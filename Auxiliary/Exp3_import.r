# Dieses Script liest eine CSV-Datendatei in GNU R ein.
# Beim Einlesen werden für alle Variablen Beschriftungen (comment) angelegt.
# Die Beschriftungen für Werte wird ebenfalls als Attribute (attr) abgelegt.

# data3_file = file.choose()
# setwd("./")
data3_file = here("Data/Exp3_data.csv")

data3 = read.table(
  file=data3_file, encoding="UTF-8",
  header = FALSE, sep = "\t", quote = "\"",
  dec = ".", row.names = "CASE",
  col.names = c(
    "CASE","SERIAL","REF","QUESTNNR","MODE","STARTED","TR01_01","TR01_01a",
    "TR01_02","TR01_02a","TR01_03","TR01_03a","TR01_04","TR01_04a","TR02_01",
    "TR02_01a","TR02_02","TR02_02a","TR02_03","TR02_03a","TR02_04","TR02_04a",
    "TR02_05","TR02_05a","TR02_06","TR02_06a","TR02_07","TR02_07a","TR02_08",
    "TR02_08a","TR02_09","TR02_09a","TR02_10","TR02_10a","TR02_11","TR02_11a",
    "TR02_12","TR02_12a","TR02_13","TR02_13a","TR02_14","TR02_14a","TR02_15",
    "TR02_15a","TR02_16","TR02_16a","TR02_17","TR02_17a","TR02_18","TR02_18a",
    "TR02_19","TR02_19a","TR02_20","TR02_20a","TR02_21","TR02_21a","TR02_22",
    "TR02_22a","TR02_23","TR02_23a","TR02_24","TR02_24a","TR02_25","TR02_25a",
    "TR02_26","TR02_26a","TR02_27","TR02_27a","TR02_28","TR02_28a","TR02_29",
    "TR02_29a","TR02_30","TR02_30a","TR02_31","TR02_31a","TR02_32","TR02_32a",
    "TR02_33","TR02_33a","TR02_34","TR02_34a","TR02_35","TR02_35a","TR02_36",
    "TR02_36a","TR02_37","TR02_37a","TR02_38","TR02_38a","TR02_39","TR02_39a",
    "TR02_40","TR02_40a","TR02_41","TR02_41a","TR02_42","TR02_42a","TR02_43",
    "TR02_43a","TR02_44","TR02_44a","TR02_45","TR02_45a","TR02_46","TR02_46a",
    "TR02_47","TR02_47a","TR02_48","TR02_48a","TR02_49","TR02_49a","TR02_50",
    "TR02_50a","TR02_51","TR02_51a","TR02_52","TR02_52a","TR02_53","TR02_53a",
    "TR02_54","TR02_54a","TR02_55","TR02_55a","TR02_56","TR02_56a","TR02_57",
    "TR02_57a","TR02_58","TR02_58a","TR02_59","TR02_59a","TR02_60","TR02_60a",
    "TR02_61","TR02_61a","TR02_62","TR02_62a","TR02_63","TR02_63a","TR02_64",
    "TR02_64a","TR02_65","TR02_65a","TR02_66","TR02_66a","TR02_67","TR02_67a",
    "TR02_68","TR02_68a","TR02_69","TR02_69a","TR02_70","TR02_70a","TR02_71",
    "TR02_71a","TR02_72","TR02_72a","TR02_73","TR02_73a","TR02_74","TR02_74a",
    "TR02_75","TR02_75a","TR02_76","TR02_76a","TR02_77","TR02_77a","TR02_78",
    "TR02_78a","TR02_79","TR02_79a","TR02_80","TR02_80a","TR02_81","TR02_81a",
    "TR02_82","TR02_82a","TR02_83","TR02_83a","TR02_84","TR02_84a","TR02_85",
    "TR02_85a","TR02_86","TR02_86a","TR02_87","TR02_87a","TR02_88","TR02_88a",
    "TR02_89","TR02_89a","TR02_90","TR02_90a","TR02_91","TR02_91a","TR02_92",
    "TR02_92a","TR02_93","TR02_93a","TR02_94","TR02_94a","TR02_95","TR02_95a",
    "TR02_96","TR02_96a","UR01_CP","UR01","UR02_CP","UR02","UR03_01","IV01_01",
    "IV01_02","IV01_03","IV02_01","IV02_02","IV02_03","IV02_04","IV03_01","IV03_02",
    "IV03_03","IV03_04","IV03_05","IV03_06","IV03_07","IV03_08","IV03_09","IV03_10",
    "IV03_11","IV03_12","IV03_13","IV03_14","IV03_15","IV03_16","IV03_17","IV03_18",
    "IV03_19","IV03_20","IV03_21","IV03_22","IV03_23","IV03_24","IV03_25","IV03_26",
    "IV03_27","IV03_28","IV03_29","IV03_30","IV03_31","IV03_32","IV03_33","IV03_34",
    "IV03_35","IV03_36","IV03_37","IV03_38","IV03_39","IV03_40","IV03_41","IV03_42",
    "IV03_43","IV03_44","IV03_45","IV03_46","IV03_47","IV03_48","IV03_49","IV03_50",
    "IV03_51","IV03_52","IV03_53","IV03_54","IV03_55","IV03_56","IV03_57","IV03_58",
    "IV03_59","IV03_60","IV03_61","IV03_62","IV03_63","IV03_64","IV03_65","IV03_66",
    "IV03_67","IV03_68","IV03_69","IV03_70","IV03_71","IV03_72","IV03_73","IV03_74",
    "IV03_75","IV03_76","IV03_77","IV03_78","IV03_79","IV03_80","IV03_81","IV03_82",
    "IV03_83","IV03_84","IV03_85","IV03_86","IV03_87","IV03_88","IV03_89","IV03_90",
    "IV03_91","IV03_92","IV03_93","IV03_94","IV03_95","IV03_96","IV04_RV1",
    "IV04_REF","DV01_01","DV02_01","DV02_02","DV04_01","DV04_02","DV05_01",
    "DV05_02","DV03_01","DV03_02","DM01","DM02","DM03","DM04_01","DM06","DM07",
    "TIME001","TIME002","TIME003","TIME004","TIME005","TIME006","TIME007","TIME008",
    "TIME009","TIME010","TIME011","TIME012","TIME013","TIME014","TIME015","TIME016",
    "TIME_SUM","MAILSENT","LASTDATA","FINISHED","Q_VIEWER","LASTPAGE","MAXPAGE",
    "MISSING","MISSREL","TIME_RSI","DEG_TIME"
  ),
  as.is = TRUE,
  colClasses = c(
    CASE="numeric", SERIAL="character", REF="character", QUESTNNR="character",
    MODE="character", STARTED="POSIXct", TR01_01="numeric", TR01_01a="numeric",
    TR01_02="numeric", TR01_02a="numeric", TR01_03="numeric",
    TR01_03a="numeric", TR01_04="numeric", TR01_04a="numeric",
    TR02_01="numeric", TR02_01a="numeric", TR02_02="numeric",
    TR02_02a="numeric", TR02_03="numeric", TR02_03a="numeric",
    TR02_04="numeric", TR02_04a="numeric", TR02_05="numeric",
    TR02_05a="numeric", TR02_06="numeric", TR02_06a="numeric",
    TR02_07="numeric", TR02_07a="numeric", TR02_08="numeric",
    TR02_08a="numeric", TR02_09="numeric", TR02_09a="numeric",
    TR02_10="numeric", TR02_10a="numeric", TR02_11="numeric",
    TR02_11a="numeric", TR02_12="numeric", TR02_12a="numeric",
    TR02_13="numeric", TR02_13a="numeric", TR02_14="numeric",
    TR02_14a="numeric", TR02_15="numeric", TR02_15a="numeric",
    TR02_16="numeric", TR02_16a="numeric", TR02_17="numeric",
    TR02_17a="numeric", TR02_18="numeric", TR02_18a="numeric",
    TR02_19="numeric", TR02_19a="numeric", TR02_20="numeric",
    TR02_20a="numeric", TR02_21="numeric", TR02_21a="numeric",
    TR02_22="numeric", TR02_22a="numeric", TR02_23="numeric",
    TR02_23a="numeric", TR02_24="numeric", TR02_24a="numeric",
    TR02_25="numeric", TR02_25a="numeric", TR02_26="numeric",
    TR02_26a="numeric", TR02_27="numeric", TR02_27a="numeric",
    TR02_28="numeric", TR02_28a="numeric", TR02_29="numeric",
    TR02_29a="numeric", TR02_30="numeric", TR02_30a="numeric",
    TR02_31="numeric", TR02_31a="numeric", TR02_32="numeric",
    TR02_32a="numeric", TR02_33="numeric", TR02_33a="numeric",
    TR02_34="numeric", TR02_34a="numeric", TR02_35="numeric",
    TR02_35a="numeric", TR02_36="numeric", TR02_36a="numeric",
    TR02_37="numeric", TR02_37a="numeric", TR02_38="numeric",
    TR02_38a="numeric", TR02_39="numeric", TR02_39a="numeric",
    TR02_40="numeric", TR02_40a="numeric", TR02_41="numeric",
    TR02_41a="numeric", TR02_42="numeric", TR02_42a="numeric",
    TR02_43="numeric", TR02_43a="numeric", TR02_44="numeric",
    TR02_44a="numeric", TR02_45="numeric", TR02_45a="numeric",
    TR02_46="numeric", TR02_46a="numeric", TR02_47="numeric",
    TR02_47a="numeric", TR02_48="numeric", TR02_48a="numeric",
    TR02_49="numeric", TR02_49a="numeric", TR02_50="numeric",
    TR02_50a="numeric", TR02_51="numeric", TR02_51a="numeric",
    TR02_52="numeric", TR02_52a="numeric", TR02_53="numeric",
    TR02_53a="numeric", TR02_54="numeric", TR02_54a="numeric",
    TR02_55="numeric", TR02_55a="numeric", TR02_56="numeric",
    TR02_56a="numeric", TR02_57="numeric", TR02_57a="numeric",
    TR02_58="numeric", TR02_58a="numeric", TR02_59="numeric",
    TR02_59a="numeric", TR02_60="numeric", TR02_60a="numeric",
    TR02_61="numeric", TR02_61a="numeric", TR02_62="numeric",
    TR02_62a="numeric", TR02_63="numeric", TR02_63a="numeric",
    TR02_64="numeric", TR02_64a="numeric", TR02_65="numeric",
    TR02_65a="numeric", TR02_66="numeric", TR02_66a="numeric",
    TR02_67="numeric", TR02_67a="numeric", TR02_68="numeric",
    TR02_68a="numeric", TR02_69="numeric", TR02_69a="numeric",
    TR02_70="numeric", TR02_70a="numeric", TR02_71="numeric",
    TR02_71a="numeric", TR02_72="numeric", TR02_72a="numeric",
    TR02_73="numeric", TR02_73a="numeric", TR02_74="numeric",
    TR02_74a="numeric", TR02_75="numeric", TR02_75a="numeric",
    TR02_76="numeric", TR02_76a="numeric", TR02_77="numeric",
    TR02_77a="numeric", TR02_78="numeric", TR02_78a="numeric",
    TR02_79="numeric", TR02_79a="numeric", TR02_80="numeric",
    TR02_80a="numeric", TR02_81="numeric", TR02_81a="numeric",
    TR02_82="numeric", TR02_82a="numeric", TR02_83="numeric",
    TR02_83a="numeric", TR02_84="numeric", TR02_84a="numeric",
    TR02_85="numeric", TR02_85a="numeric", TR02_86="numeric",
    TR02_86a="numeric", TR02_87="numeric", TR02_87a="numeric",
    TR02_88="numeric", TR02_88a="numeric", TR02_89="numeric",
    TR02_89a="numeric", TR02_90="numeric", TR02_90a="numeric",
    TR02_91="numeric", TR02_91a="numeric", TR02_92="numeric",
    TR02_92a="numeric", TR02_93="numeric", TR02_93a="numeric",
    TR02_94="numeric", TR02_94a="numeric", TR02_95="numeric",
    TR02_95a="numeric", TR02_96="numeric", TR02_96a="numeric",
    UR01_CP="numeric", UR01="numeric", UR02_CP="numeric", UR02="numeric",
    UR03_01="character", IV01_01="character", IV01_02="character",
    IV01_03="character", IV02_01="character", IV02_02="character",
    IV02_03="character", IV02_04="character", IV03_01="character",
    IV03_02="character", IV03_03="character", IV03_04="character",
    IV03_05="character", IV03_06="character", IV03_07="character",
    IV03_08="character", IV03_09="character", IV03_10="character",
    IV03_11="character", IV03_12="character", IV03_13="character",
    IV03_14="character", IV03_15="character", IV03_16="character",
    IV03_17="character", IV03_18="character", IV03_19="character",
    IV03_20="character", IV03_21="character", IV03_22="character",
    IV03_23="character", IV03_24="character", IV03_25="character",
    IV03_26="character", IV03_27="character", IV03_28="character",
    IV03_29="character", IV03_30="character", IV03_31="character",
    IV03_32="character", IV03_33="character", IV03_34="character",
    IV03_35="character", IV03_36="character", IV03_37="character",
    IV03_38="character", IV03_39="character", IV03_40="character",
    IV03_41="character", IV03_42="character", IV03_43="character",
    IV03_44="character", IV03_45="character", IV03_46="character",
    IV03_47="character", IV03_48="character", IV03_49="character",
    IV03_50="character", IV03_51="character", IV03_52="character",
    IV03_53="character", IV03_54="character", IV03_55="character",
    IV03_56="character", IV03_57="character", IV03_58="character",
    IV03_59="character", IV03_60="character", IV03_61="character",
    IV03_62="character", IV03_63="character", IV03_64="character",
    IV03_65="character", IV03_66="character", IV03_67="character",
    IV03_68="character", IV03_69="character", IV03_70="character",
    IV03_71="character", IV03_72="character", IV03_73="character",
    IV03_74="character", IV03_75="character", IV03_76="character",
    IV03_77="character", IV03_78="character", IV03_79="character",
    IV03_80="character", IV03_81="character", IV03_82="character",
    IV03_83="character", IV03_84="character", IV03_85="character",
    IV03_86="character", IV03_87="character", IV03_88="character",
    IV03_89="character", IV03_90="character", IV03_91="character",
    IV03_92="character", IV03_93="character", IV03_94="character",
    IV03_95="character", IV03_96="character", IV04_RV1="character",
    IV04_REF="character", DV01_01="numeric", DV02_01="numeric",
    DV02_02="numeric", DV04_01="numeric", DV04_02="numeric", DV05_01="numeric",
    DV05_02="numeric", DV03_01="numeric", DV03_02="numeric", DM01="numeric",
    DM02="numeric", DM03="numeric", DM04_01="character", DM06="numeric",
    DM07="numeric", TIME001="integer", TIME002="integer", TIME003="integer",
    TIME004="integer", TIME005="integer", TIME006="integer", TIME007="integer",
    TIME008="integer", TIME009="integer", TIME010="integer", TIME011="integer",
    TIME012="integer", TIME013="integer", TIME014="integer", TIME015="integer",
    TIME016="integer", TIME_SUM="integer", MAILSENT="POSIXct",
    LASTDATA="POSIXct", FINISHED="logical", Q_VIEWER="logical",
    LASTPAGE="numeric", MAXPAGE="numeric", MISSING="numeric", MISSREL="numeric",
    TIME_RSI="numeric", DEG_TIME="numeric"
  ),
  skip = 1,
  check.names = TRUE, fill = TRUE,
  strip.white = FALSE, blank.lines.skip = TRUE,
  comment.char = "",
  na.strings = ""
)

rm(data3_file)

attr(data3, "project") = "ao3"
attr(data3, "description") = "Action-Outcome 3"
attr(data3, "date") = "2017-10-04 11:31:18"
attr(data3, "server") = "https://www.soscisurvey.de"

# Variable und Value Labels
data3$TR01_01 = factor(data3$TR01_01, levels=c("1"), labels=c("%forced%"), ordered=FALSE)
data3$TR01_02 = factor(data3$TR01_02, levels=c("1"), labels=c("%forced%"), ordered=FALSE)
data3$TR01_03 = factor(data3$TR01_03, levels=c("1"), labels=c("%forced%"), ordered=FALSE)
data3$TR01_04 = factor(data3$TR01_04, levels=c("1"), labels=c("%forced%"), ordered=FALSE)
data3$TR02_01 = factor(data3$TR02_01, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_02 = factor(data3$TR02_02, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_03 = factor(data3$TR02_03, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_04 = factor(data3$TR02_04, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_05 = factor(data3$TR02_05, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_06 = factor(data3$TR02_06, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_07 = factor(data3$TR02_07, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_08 = factor(data3$TR02_08, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_09 = factor(data3$TR02_09, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_10 = factor(data3$TR02_10, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_11 = factor(data3$TR02_11, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_12 = factor(data3$TR02_12, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_13 = factor(data3$TR02_13, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_14 = factor(data3$TR02_14, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_15 = factor(data3$TR02_15, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_16 = factor(data3$TR02_16, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_17 = factor(data3$TR02_17, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_18 = factor(data3$TR02_18, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_19 = factor(data3$TR02_19, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_20 = factor(data3$TR02_20, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_21 = factor(data3$TR02_21, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_22 = factor(data3$TR02_22, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_23 = factor(data3$TR02_23, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_24 = factor(data3$TR02_24, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_25 = factor(data3$TR02_25, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_26 = factor(data3$TR02_26, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_27 = factor(data3$TR02_27, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_28 = factor(data3$TR02_28, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_29 = factor(data3$TR02_29, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_30 = factor(data3$TR02_30, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_31 = factor(data3$TR02_31, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_32 = factor(data3$TR02_32, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_33 = factor(data3$TR02_33, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_34 = factor(data3$TR02_34, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_35 = factor(data3$TR02_35, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_36 = factor(data3$TR02_36, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_37 = factor(data3$TR02_37, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_38 = factor(data3$TR02_38, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_39 = factor(data3$TR02_39, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_40 = factor(data3$TR02_40, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_41 = factor(data3$TR02_41, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_42 = factor(data3$TR02_42, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_43 = factor(data3$TR02_43, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_44 = factor(data3$TR02_44, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_45 = factor(data3$TR02_45, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_46 = factor(data3$TR02_46, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_47 = factor(data3$TR02_47, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_48 = factor(data3$TR02_48, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_49 = factor(data3$TR02_49, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_50 = factor(data3$TR02_50, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_51 = factor(data3$TR02_51, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_52 = factor(data3$TR02_52, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_53 = factor(data3$TR02_53, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_54 = factor(data3$TR02_54, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_55 = factor(data3$TR02_55, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_56 = factor(data3$TR02_56, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_57 = factor(data3$TR02_57, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_58 = factor(data3$TR02_58, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_59 = factor(data3$TR02_59, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_60 = factor(data3$TR02_60, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_61 = factor(data3$TR02_61, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_62 = factor(data3$TR02_62, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_63 = factor(data3$TR02_63, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_64 = factor(data3$TR02_64, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_65 = factor(data3$TR02_65, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_66 = factor(data3$TR02_66, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_67 = factor(data3$TR02_67, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_68 = factor(data3$TR02_68, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_69 = factor(data3$TR02_69, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_70 = factor(data3$TR02_70, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_71 = factor(data3$TR02_71, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_72 = factor(data3$TR02_72, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_73 = factor(data3$TR02_73, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_74 = factor(data3$TR02_74, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_75 = factor(data3$TR02_75, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_76 = factor(data3$TR02_76, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_77 = factor(data3$TR02_77, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_78 = factor(data3$TR02_78, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_79 = factor(data3$TR02_79, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_80 = factor(data3$TR02_80, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_81 = factor(data3$TR02_81, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_82 = factor(data3$TR02_82, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_83 = factor(data3$TR02_83, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_84 = factor(data3$TR02_84, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_85 = factor(data3$TR02_85, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_86 = factor(data3$TR02_86, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_87 = factor(data3$TR02_87, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_88 = factor(data3$TR02_88, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_89 = factor(data3$TR02_89, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_90 = factor(data3$TR02_90, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_91 = factor(data3$TR02_91, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_92 = factor(data3$TR02_92, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_93 = factor(data3$TR02_93, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_94 = factor(data3$TR02_94, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_95 = factor(data3$TR02_95, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$TR02_96 = factor(data3$TR02_96, levels=c("1","2"), labels=c("%place1%","%place2%"), ordered=FALSE)
data3$DM01 = factor(data3$DM01, levels=c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","-9"), labels=c("18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99","100","[NA] Not answered"), ordered=FALSE)
data3$DM02 = factor(data3$DM02, levels=c("1","2","3","-9"), labels=c("male","female","other","[NA] Not answered"), ordered=FALSE)
data3$DM03 = factor(data3$DM03, levels=c("1","2","-9"), labels=c("Yes","No","[NA] Not answered"), ordered=FALSE)
data3$DM06 = factor(data3$DM06, levels=c("1","2","-9"), labels=c("I agree","I disagree","[NA] Not answered"), ordered=FALSE)
data3$DM07 = factor(data3$DM07, levels=c("1","2","3","4","5","6","-9"), labels=c("No formal education","Secondary school/GCSE","College/A levels","Undergraduate degree (BA, BSc or comparable)","Graduate degree (MA, MSc or comparable)","Doctorate degree (PhD, MD, or comparable)","[NA] Not answered"), ordered=FALSE)
attr(data3$TR01_01a,"-1") = "Mensuration impossible"
attr(data3$TR01_02a,"-1") = "Mensuration impossible"
attr(data3$TR01_03a,"-1") = "Mensuration impossible"
attr(data3$TR01_04a,"-1") = "Mensuration impossible"
attr(data3$TR02_01a,"-1") = "Mensuration impossible"
attr(data3$TR02_02a,"-1") = "Mensuration impossible"
attr(data3$TR02_03a,"-1") = "Mensuration impossible"
attr(data3$TR02_04a,"-1") = "Mensuration impossible"
attr(data3$TR02_05a,"-1") = "Mensuration impossible"
attr(data3$TR02_06a,"-1") = "Mensuration impossible"
attr(data3$TR02_07a,"-1") = "Mensuration impossible"
attr(data3$TR02_08a,"-1") = "Mensuration impossible"
attr(data3$TR02_09a,"-1") = "Mensuration impossible"
attr(data3$TR02_10a,"-1") = "Mensuration impossible"
attr(data3$TR02_11a,"-1") = "Mensuration impossible"
attr(data3$TR02_12a,"-1") = "Mensuration impossible"
attr(data3$TR02_13a,"-1") = "Mensuration impossible"
attr(data3$TR02_14a,"-1") = "Mensuration impossible"
attr(data3$TR02_15a,"-1") = "Mensuration impossible"
attr(data3$TR02_16a,"-1") = "Mensuration impossible"
attr(data3$TR02_17a,"-1") = "Mensuration impossible"
attr(data3$TR02_18a,"-1") = "Mensuration impossible"
attr(data3$TR02_19a,"-1") = "Mensuration impossible"
attr(data3$TR02_20a,"-1") = "Mensuration impossible"
attr(data3$TR02_21a,"-1") = "Mensuration impossible"
attr(data3$TR02_22a,"-1") = "Mensuration impossible"
attr(data3$TR02_23a,"-1") = "Mensuration impossible"
attr(data3$TR02_24a,"-1") = "Mensuration impossible"
attr(data3$TR02_25a,"-1") = "Mensuration impossible"
attr(data3$TR02_26a,"-1") = "Mensuration impossible"
attr(data3$TR02_27a,"-1") = "Mensuration impossible"
attr(data3$TR02_28a,"-1") = "Mensuration impossible"
attr(data3$TR02_29a,"-1") = "Mensuration impossible"
attr(data3$TR02_30a,"-1") = "Mensuration impossible"
attr(data3$TR02_31a,"-1") = "Mensuration impossible"
attr(data3$TR02_32a,"-1") = "Mensuration impossible"
attr(data3$TR02_33a,"-1") = "Mensuration impossible"
attr(data3$TR02_34a,"-1") = "Mensuration impossible"
attr(data3$TR02_35a,"-1") = "Mensuration impossible"
attr(data3$TR02_36a,"-1") = "Mensuration impossible"
attr(data3$TR02_37a,"-1") = "Mensuration impossible"
attr(data3$TR02_38a,"-1") = "Mensuration impossible"
attr(data3$TR02_39a,"-1") = "Mensuration impossible"
attr(data3$TR02_40a,"-1") = "Mensuration impossible"
attr(data3$TR02_41a,"-1") = "Mensuration impossible"
attr(data3$TR02_42a,"-1") = "Mensuration impossible"
attr(data3$TR02_43a,"-1") = "Mensuration impossible"
attr(data3$TR02_44a,"-1") = "Mensuration impossible"
attr(data3$TR02_45a,"-1") = "Mensuration impossible"
attr(data3$TR02_46a,"-1") = "Mensuration impossible"
attr(data3$TR02_47a,"-1") = "Mensuration impossible"
attr(data3$TR02_48a,"-1") = "Mensuration impossible"
attr(data3$TR02_49a,"-1") = "Mensuration impossible"
attr(data3$TR02_50a,"-1") = "Mensuration impossible"
attr(data3$TR02_51a,"-1") = "Mensuration impossible"
attr(data3$TR02_52a,"-1") = "Mensuration impossible"
attr(data3$TR02_53a,"-1") = "Mensuration impossible"
attr(data3$TR02_54a,"-1") = "Mensuration impossible"
attr(data3$TR02_55a,"-1") = "Mensuration impossible"
attr(data3$TR02_56a,"-1") = "Mensuration impossible"
attr(data3$TR02_57a,"-1") = "Mensuration impossible"
attr(data3$TR02_58a,"-1") = "Mensuration impossible"
attr(data3$TR02_59a,"-1") = "Mensuration impossible"
attr(data3$TR02_60a,"-1") = "Mensuration impossible"
attr(data3$TR02_61a,"-1") = "Mensuration impossible"
attr(data3$TR02_62a,"-1") = "Mensuration impossible"
attr(data3$TR02_63a,"-1") = "Mensuration impossible"
attr(data3$TR02_64a,"-1") = "Mensuration impossible"
attr(data3$TR02_65a,"-1") = "Mensuration impossible"
attr(data3$TR02_66a,"-1") = "Mensuration impossible"
attr(data3$TR02_67a,"-1") = "Mensuration impossible"
attr(data3$TR02_68a,"-1") = "Mensuration impossible"
attr(data3$TR02_69a,"-1") = "Mensuration impossible"
attr(data3$TR02_70a,"-1") = "Mensuration impossible"
attr(data3$TR02_71a,"-1") = "Mensuration impossible"
attr(data3$TR02_72a,"-1") = "Mensuration impossible"
attr(data3$TR02_73a,"-1") = "Mensuration impossible"
attr(data3$TR02_74a,"-1") = "Mensuration impossible"
attr(data3$TR02_75a,"-1") = "Mensuration impossible"
attr(data3$TR02_76a,"-1") = "Mensuration impossible"
attr(data3$TR02_77a,"-1") = "Mensuration impossible"
attr(data3$TR02_78a,"-1") = "Mensuration impossible"
attr(data3$TR02_79a,"-1") = "Mensuration impossible"
attr(data3$TR02_80a,"-1") = "Mensuration impossible"
attr(data3$TR02_81a,"-1") = "Mensuration impossible"
attr(data3$TR02_82a,"-1") = "Mensuration impossible"
attr(data3$TR02_83a,"-1") = "Mensuration impossible"
attr(data3$TR02_84a,"-1") = "Mensuration impossible"
attr(data3$TR02_85a,"-1") = "Mensuration impossible"
attr(data3$TR02_86a,"-1") = "Mensuration impossible"
attr(data3$TR02_87a,"-1") = "Mensuration impossible"
attr(data3$TR02_88a,"-1") = "Mensuration impossible"
attr(data3$TR02_89a,"-1") = "Mensuration impossible"
attr(data3$TR02_90a,"-1") = "Mensuration impossible"
attr(data3$TR02_91a,"-1") = "Mensuration impossible"
attr(data3$TR02_92a,"-1") = "Mensuration impossible"
attr(data3$TR02_93a,"-1") = "Mensuration impossible"
attr(data3$TR02_94a,"-1") = "Mensuration impossible"
attr(data3$TR02_95a,"-1") = "Mensuration impossible"
attr(data3$TR02_96a,"-1") = "Mensuration impossible"
attr(data3$DV01_01,"1") = "%place1%"
attr(data3$DV01_01,"101") = "%place2%"
attr(data3$DV02_01,"1") = "0 %"
attr(data3$DV02_01,"101") = "100 %"
attr(data3$DV02_02,"1") = "0 %"
attr(data3$DV02_02,"101") = "100 %"
attr(data3$DV04_01,"1") = "0 %"
attr(data3$DV04_01,"101") = "100 %"
attr(data3$DV04_02,"1") = "0 %"
attr(data3$DV04_02,"101") = "100 %"
attr(data3$DV05_01,"1") = "0 %"
attr(data3$DV05_01,"101") = "100 %"
attr(data3$DV05_02,"1") = "0 %"
attr(data3$DV05_02,"101") = "100 %"
attr(data3$DV03_01,"1") = "not confident at all"
attr(data3$DV03_01,"101") = "very confident"
attr(data3$DV03_02,"1") = "not confident at all"
attr(data3$DV03_02,"101") = "very confident"
attr(data3$FINISHED,"F") = "Canceled"
attr(data3$FINISHED,"F") = "Finished"
attr(data3$Q_VIEWER,"F") = "Respondent"
attr(data3$Q_VIEWER,"F") = "Spectator"
comment(data3$SERIAL) = "Serial number (if provided)"
comment(data3$REF) = "Reference (if provided in link)"
comment(data3$QUESTNNR) = "Questionnaire that has been used in the interview"
comment(data3$MODE) = "Interview mode"
comment(data3$STARTED) = "Time the interview has started"
comment(data3$TR01_01) = "ForcedSelection: "
comment(data3$TR01_01a) = "ForcedSelection:  response time [ms]"
comment(data3$TR01_02) = "ForcedSelection: "
comment(data3$TR01_02a) = "ForcedSelection:  response time [ms]"
comment(data3$TR01_03) = "ForcedSelection: "
comment(data3$TR01_03a) = "ForcedSelection:  response time [ms]"
comment(data3$TR01_04) = "ForcedSelection: "
comment(data3$TR01_04a) = "ForcedSelection:  response time [ms]"
comment(data3$TR02_01) = "FreeSelection: "
comment(data3$TR02_01a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_02) = "FreeSelection: "
comment(data3$TR02_02a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_03) = "FreeSelection: "
comment(data3$TR02_03a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_04) = "FreeSelection: "
comment(data3$TR02_04a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_05) = "FreeSelection: "
comment(data3$TR02_05a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_06) = "FreeSelection: "
comment(data3$TR02_06a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_07) = "FreeSelection: "
comment(data3$TR02_07a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_08) = "FreeSelection: "
comment(data3$TR02_08a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_09) = "FreeSelection: "
comment(data3$TR02_09a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_10) = "FreeSelection: "
comment(data3$TR02_10a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_11) = "FreeSelection: "
comment(data3$TR02_11a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_12) = "FreeSelection: "
comment(data3$TR02_12a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_13) = "FreeSelection: "
comment(data3$TR02_13a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_14) = "FreeSelection: "
comment(data3$TR02_14a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_15) = "FreeSelection: "
comment(data3$TR02_15a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_16) = "FreeSelection: "
comment(data3$TR02_16a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_17) = "FreeSelection: "
comment(data3$TR02_17a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_18) = "FreeSelection: "
comment(data3$TR02_18a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_19) = "FreeSelection: "
comment(data3$TR02_19a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_20) = "FreeSelection: "
comment(data3$TR02_20a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_21) = "FreeSelection: "
comment(data3$TR02_21a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_22) = "FreeSelection: "
comment(data3$TR02_22a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_23) = "FreeSelection: "
comment(data3$TR02_23a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_24) = "FreeSelection: "
comment(data3$TR02_24a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_25) = "FreeSelection: "
comment(data3$TR02_25a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_26) = "FreeSelection: "
comment(data3$TR02_26a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_27) = "FreeSelection: "
comment(data3$TR02_27a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_28) = "FreeSelection: "
comment(data3$TR02_28a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_29) = "FreeSelection: "
comment(data3$TR02_29a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_30) = "FreeSelection: "
comment(data3$TR02_30a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_31) = "FreeSelection: "
comment(data3$TR02_31a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_32) = "FreeSelection: "
comment(data3$TR02_32a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_33) = "FreeSelection: "
comment(data3$TR02_33a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_34) = "FreeSelection: "
comment(data3$TR02_34a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_35) = "FreeSelection: "
comment(data3$TR02_35a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_36) = "FreeSelection: "
comment(data3$TR02_36a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_37) = "FreeSelection: "
comment(data3$TR02_37a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_38) = "FreeSelection: "
comment(data3$TR02_38a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_39) = "FreeSelection: "
comment(data3$TR02_39a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_40) = "FreeSelection: "
comment(data3$TR02_40a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_41) = "FreeSelection: "
comment(data3$TR02_41a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_42) = "FreeSelection: "
comment(data3$TR02_42a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_43) = "FreeSelection: "
comment(data3$TR02_43a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_44) = "FreeSelection: "
comment(data3$TR02_44a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_45) = "FreeSelection: "
comment(data3$TR02_45a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_46) = "FreeSelection: "
comment(data3$TR02_46a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_47) = "FreeSelection: "
comment(data3$TR02_47a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_48) = "FreeSelection: "
comment(data3$TR02_48a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_49) = "FreeSelection: "
comment(data3$TR02_49a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_50) = "FreeSelection: "
comment(data3$TR02_50a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_51) = "FreeSelection: "
comment(data3$TR02_51a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_52) = "FreeSelection: "
comment(data3$TR02_52a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_53) = "FreeSelection: "
comment(data3$TR02_53a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_54) = "FreeSelection: "
comment(data3$TR02_54a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_55) = "FreeSelection: "
comment(data3$TR02_55a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_56) = "FreeSelection: "
comment(data3$TR02_56a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_57) = "FreeSelection: "
comment(data3$TR02_57a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_58) = "FreeSelection: "
comment(data3$TR02_58a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_59) = "FreeSelection: "
comment(data3$TR02_59a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_60) = "FreeSelection: "
comment(data3$TR02_60a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_61) = "FreeSelection: "
comment(data3$TR02_61a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_62) = "FreeSelection: "
comment(data3$TR02_62a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_63) = "FreeSelection: "
comment(data3$TR02_63a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_64) = "FreeSelection: "
comment(data3$TR02_64a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_65) = "FreeSelection: "
comment(data3$TR02_65a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_66) = "FreeSelection: "
comment(data3$TR02_66a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_67) = "FreeSelection: "
comment(data3$TR02_67a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_68) = "FreeSelection: "
comment(data3$TR02_68a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_69) = "FreeSelection: "
comment(data3$TR02_69a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_70) = "FreeSelection: "
comment(data3$TR02_70a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_71) = "FreeSelection: "
comment(data3$TR02_71a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_72) = "FreeSelection: "
comment(data3$TR02_72a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_73) = "FreeSelection: "
comment(data3$TR02_73a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_74) = "FreeSelection: "
comment(data3$TR02_74a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_75) = "FreeSelection: "
comment(data3$TR02_75a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_76) = "FreeSelection: "
comment(data3$TR02_76a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_77) = "FreeSelection: "
comment(data3$TR02_77a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_78) = "FreeSelection: "
comment(data3$TR02_78a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_79) = "FreeSelection: "
comment(data3$TR02_79a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_80) = "FreeSelection: "
comment(data3$TR02_80a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_81) = "FreeSelection: "
comment(data3$TR02_81a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_82) = "FreeSelection: "
comment(data3$TR02_82a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_83) = "FreeSelection: "
comment(data3$TR02_83a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_84) = "FreeSelection: "
comment(data3$TR02_84a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_85) = "FreeSelection: "
comment(data3$TR02_85a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_86) = "FreeSelection: "
comment(data3$TR02_86a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_87) = "FreeSelection: "
comment(data3$TR02_87a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_88) = "FreeSelection: "
comment(data3$TR02_88a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_89) = "FreeSelection: "
comment(data3$TR02_89a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_90) = "FreeSelection: "
comment(data3$TR02_90a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_91) = "FreeSelection: "
comment(data3$TR02_91a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_92) = "FreeSelection: "
comment(data3$TR02_92a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_93) = "FreeSelection: "
comment(data3$TR02_93a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_94) = "FreeSelection: "
comment(data3$TR02_94a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_95) = "FreeSelection: "
comment(data3$TR02_95a) = "FreeSelection:  response time [ms]"
comment(data3$TR02_96) = "FreeSelection: "
comment(data3$TR02_96a) = "FreeSelection:  response time [ms]"
comment(data3$UR01_CP) = "Condition: Complete clearances of the ballot, yet"
comment(data3$UR01) = "Condition: Code drawn"
comment(data3$UR02_CP) = "Primacy: Complete clearances of the ballot, yet"
comment(data3$UR02) = "Primacy: Code drawn"
comment(data3$UR03_01) = "VP: VP"
comment(data3$IV01_01) = "IVs: Bankaccount"
comment(data3$IV01_02) = "IVs: Choice1"
comment(data3$IV01_03) = "IVs: Choice2"
comment(data3$IV02_01) = "Sold_Forced: Day1"
comment(data3$IV02_02) = "Sold_Forced: Day2"
comment(data3$IV02_03) = "Sold_Forced: Day3"
comment(data3$IV02_04) = "Sold_Forced: Day4"
comment(data3$IV03_01) = "Sold_Free: Day5"
comment(data3$IV03_02) = "Sold_Free: Day6"
comment(data3$IV03_03) = "Sold_Free: Day7"
comment(data3$IV03_04) = "Sold_Free: Day8"
comment(data3$IV03_05) = "Sold_Free: Day9"
comment(data3$IV03_06) = "Sold_Free: Day10"
comment(data3$IV03_07) = "Sold_Free: Day11"
comment(data3$IV03_08) = "Sold_Free: Day12"
comment(data3$IV03_09) = "Sold_Free: Day13"
comment(data3$IV03_10) = "Sold_Free: Day14"
comment(data3$IV03_11) = "Sold_Free: Day15"
comment(data3$IV03_12) = "Sold_Free: Day16"
comment(data3$IV03_13) = "Sold_Free: Day17"
comment(data3$IV03_14) = "Sold_Free: Day18"
comment(data3$IV03_15) = "Sold_Free: Day19"
comment(data3$IV03_16) = "Sold_Free: Day20"
comment(data3$IV03_17) = "Sold_Free: Day21"
comment(data3$IV03_18) = "Sold_Free: Day22"
comment(data3$IV03_19) = "Sold_Free: Day23"
comment(data3$IV03_20) = "Sold_Free: Day24"
comment(data3$IV03_21) = "Sold_Free: Day25"
comment(data3$IV03_22) = "Sold_Free: Day26"
comment(data3$IV03_23) = "Sold_Free: Day27"
comment(data3$IV03_24) = "Sold_Free: Day28"
comment(data3$IV03_25) = "Sold_Free: Day29"
comment(data3$IV03_26) = "Sold_Free: Day30"
comment(data3$IV03_27) = "Sold_Free: Day31"
comment(data3$IV03_28) = "Sold_Free: Day32"
comment(data3$IV03_29) = "Sold_Free: Day33"
comment(data3$IV03_30) = "Sold_Free: Day34"
comment(data3$IV03_31) = "Sold_Free: Day35"
comment(data3$IV03_32) = "Sold_Free: Day36"
comment(data3$IV03_33) = "Sold_Free: Day37"
comment(data3$IV03_34) = "Sold_Free: Day38"
comment(data3$IV03_35) = "Sold_Free: Day39"
comment(data3$IV03_36) = "Sold_Free: Day40"
comment(data3$IV03_37) = "Sold_Free: Day41"
comment(data3$IV03_38) = "Sold_Free: Day42"
comment(data3$IV03_39) = "Sold_Free: Day43"
comment(data3$IV03_40) = "Sold_Free: Day44"
comment(data3$IV03_41) = "Sold_Free: Day45"
comment(data3$IV03_42) = "Sold_Free: Day46"
comment(data3$IV03_43) = "Sold_Free: Day47"
comment(data3$IV03_44) = "Sold_Free: Day48"
comment(data3$IV03_45) = "Sold_Free: Day49"
comment(data3$IV03_46) = "Sold_Free: Day50"
comment(data3$IV03_47) = "Sold_Free: Day51"
comment(data3$IV03_48) = "Sold_Free: Day52"
comment(data3$IV03_49) = "Sold_Free: Day53"
comment(data3$IV03_50) = "Sold_Free: Day54"
comment(data3$IV03_51) = "Sold_Free: Day55"
comment(data3$IV03_52) = "Sold_Free: Day56"
comment(data3$IV03_53) = "Sold_Free: Day57"
comment(data3$IV03_54) = "Sold_Free: Day58"
comment(data3$IV03_55) = "Sold_Free: Day59"
comment(data3$IV03_56) = "Sold_Free: Day60"
comment(data3$IV03_57) = "Sold_Free: Day61"
comment(data3$IV03_58) = "Sold_Free: Day62"
comment(data3$IV03_59) = "Sold_Free: Day63"
comment(data3$IV03_60) = "Sold_Free: Day64"
comment(data3$IV03_61) = "Sold_Free: Day65"
comment(data3$IV03_62) = "Sold_Free: Day66"
comment(data3$IV03_63) = "Sold_Free: Day67"
comment(data3$IV03_64) = "Sold_Free: Day68"
comment(data3$IV03_65) = "Sold_Free: Day69"
comment(data3$IV03_66) = "Sold_Free: Day70"
comment(data3$IV03_67) = "Sold_Free: Day71"
comment(data3$IV03_68) = "Sold_Free: Day72"
comment(data3$IV03_69) = "Sold_Free: Day73"
comment(data3$IV03_70) = "Sold_Free: Day74"
comment(data3$IV03_71) = "Sold_Free: Day75"
comment(data3$IV03_72) = "Sold_Free: Day76"
comment(data3$IV03_73) = "Sold_Free: Day77"
comment(data3$IV03_74) = "Sold_Free: Day78"
comment(data3$IV03_75) = "Sold_Free: Day79"
comment(data3$IV03_76) = "Sold_Free: Day80"
comment(data3$IV03_77) = "Sold_Free: Day81"
comment(data3$IV03_78) = "Sold_Free: Day82"
comment(data3$IV03_79) = "Sold_Free: Day83"
comment(data3$IV03_80) = "Sold_Free: Day84"
comment(data3$IV03_81) = "Sold_Free: Day85"
comment(data3$IV03_82) = "Sold_Free: Day86"
comment(data3$IV03_83) = "Sold_Free: Day87"
comment(data3$IV03_84) = "Sold_Free: Day88"
comment(data3$IV03_85) = "Sold_Free: Day89"
comment(data3$IV03_86) = "Sold_Free: Day90"
comment(data3$IV03_87) = "Sold_Free: Day91"
comment(data3$IV03_88) = "Sold_Free: Day92"
comment(data3$IV03_89) = "Sold_Free: Day93"
comment(data3$IV03_90) = "Sold_Free: Day94"
comment(data3$IV03_91) = "Sold_Free: Day95"
comment(data3$IV03_92) = "Sold_Free: Day96"
comment(data3$IV03_93) = "Sold_Free: Day97"
comment(data3$IV03_94) = "Sold_Free: Day98"
comment(data3$IV03_95) = "Sold_Free: Day99"
comment(data3$IV03_96) = "Sold_Free: Day100"
comment(data3$IV04_RV1) = "POST/GET Variable: PROLIFIC_PID"
comment(data3$IV04_REF) = "Referer (HTTP_REFERER)"
comment(data3$DV01_01) = "Estimates: %place1%/%place2%"
comment(data3$DV02_01) = "Conditionals: ...you chose the location %loc1%?"
comment(data3$DV02_02) = "Conditionals: ...you chose the location %loc2%?"
comment(data3$DV04_01) = "Control: ...you chose the location %loc1%?"
comment(data3$DV04_02) = "Control: ...you chose the location %loc2%?"
comment(data3$DV05_01) = "Prediction: ...you chose the location %loc1%?"
comment(data3$DV05_02) = "Prediction: ...you chose the location %loc2%?"
comment(data3$DV03_01) = "Confidence: How confident are you that you can make a reasonable estimate regarding %loc1%?"
comment(data3$DV03_02) = "Confidence: How confident are you that you can make a reasonable estimate regarding %loc2%?"
comment(data3$DM01) = "Age"
comment(data3$DM02) = "Gender"
comment(data3$DM03) = "Psychstudent"
comment(data3$DM04_01) = "ProlificID: [01]"
comment(data3$DM06) = "AttentionCheck"
comment(data3$DM07) = "Education"
comment(data3$TIME001) = "Time spent on page 1"
comment(data3$TIME002) = "Time spent on page 2"
comment(data3$TIME003) = "Time spent on page 3"
comment(data3$TIME004) = "Time spent on page 4"
comment(data3$TIME005) = "Time spent on page 5"
comment(data3$TIME006) = "Time spent on page 6"
comment(data3$TIME007) = "Time spent on page 7"
comment(data3$TIME008) = "Time spent on page 8"
comment(data3$TIME009) = "Time spent on page 9"
comment(data3$TIME010) = "Time spent on page 10"
comment(data3$TIME011) = "Time spent on page 11"
comment(data3$TIME012) = "Time spent on page 12"
comment(data3$TIME013) = "Time spent on page 13"
comment(data3$TIME014) = "Time spent on page 14"
comment(data3$TIME015) = "Time spent on page 15"
comment(data3$TIME016) = "Time spent on page 16"
comment(data3$TIME_SUM) = "Time spent overall (except outliers)"
comment(data3$MAILSENT) = "Time when the invitation mailing was sent (non-anonymous recipients, only)"
comment(data3$LASTDATA) = "Time when the data3 was most recently updated"
comment(data3$FINISHED) = "Has the interview been finished (reached last page)?"
comment(data3$Q_VIEWER) = "Did the respondent only view the questionnaire, omitting mandatory questions?"
comment(data3$LASTPAGE) = "Last page that the participant has handled in the questionnaire"
comment(data3$MAXPAGE) = "Hindmost page handled by the participant"
comment(data3$MISSING) = "Missing answers in percent"
comment(data3$MISSREL) = "Missing answers (weighted by relevance)"
comment(data3$TIME_RSI) = "Degradation points for being very fast"
comment(data3$DEG_TIME) = "Degradation points for being very fast"



# Assure that the comments are retained in subsets
as.data.frame.avector = as.data.frame.vector
`[.avector` <- function(x,i,...) {
  r <- NextMethod("[")
  mostattributes(r) <- attributes(x)
  r
}
data3_tmp = data.frame(
  lapply(data3, function(x) {
    structure( x, class = c("avector", class(x) ) )
  } )
)
mostattributes(data3_tmp) = attributes(data3)
data3 = data3_tmp
rm(data3_tmp)

