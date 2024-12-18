# Importar los datos
datos <- read.table("clipboard", header = TRUE, sep = "\t")
#  Pasar tamaño a Kb
datos$Tamaño <- datos$Tamaño / (1024)


#La diferencia de compressió si que necessita ser ajustada ja que no segueix una normal, en canvi, la de descompressió no.

diferencia_compresion <- log(datos$TiempoCompresionGzip/datos$TiempoCompresionZip)
diferencia_descompresion <- datos$TiempoDescompresionGzip-datos$TiempoDescompresionZip

#Calcul de mitjanes i desviacions tipiques:
mean(datos$TiempoCompresionZip)
mean(datos$TiempoCompresionGzip)
mean(datos$TiempoDescompresionZip)
mean(datos$TiempoDescompresionGzip)

sd(datos$TiempoCompresionZip)
sd(datos$TiempoCompresionGzip)
sd(datos$TiempoDescompresionZip)
sd(datos$TiempoDescompresionGzip)

#Gràfics de dispersió
windows()
plot(datos$TiempoCompresionZip,datos$TiempoCompresionGzip)
abline(a = 0,b = 1,col ="red")
plot(datos$TiempoDescompresionZip,datos$TiempoDescompresionGzip)
abline(a = 0,b = 1,col ="red")

# Calcular la mitjana entre temps
means_comp <- (datos$TiempoCompresionGzip + datos$TiempoCompresionZip) / 2
means_descomp <- (datos$TiempoDescompresionGzip + datos$TiempoDescompresionZip) / 2

# Gràfic de Bland-Altman
windows()
plot(means_comp, diferencia_compresion, 
     main = "Gràfic de Bland-Altman (Compressió)", 
     xlab = "(GZIP + ZIP) / 2", 
     ylab = "log(GZIP / ZIP)", 
     pch = 19, col = "black")

# Afegir linia mitjana de les diferències
abline(h = mean(diferencia_compresion), col = "red", lwd = 2)

# Afegir límits
sd_diferencia <- sd(diferencia_compresion)
abline(h = mean(diferencia_compresion) + 1.96 * sd_diferencia, col = "blue", lty = 2)
abline(h = mean(diferencia_compresion) - 1.96 * sd_diferencia, col = "blue", lty = 2)

# Afegir línia a y = 0
abline(h = 0, col = "gray", lwd = 2)

windows()
#DESCOMPRESSIÓ:
plot(means_comp, diferencia_compresion, 
     main = "Gràfic de Bland-Altman (Descompressió)", 
     xlab = "(GZIP + ZIP) / 2", 
     ylab = "GZIP-ZIP", 
     pch = 19, col = "black",
     ylim = c(-0.7, 1.5))  

# Afegir linia mitjana de les diferències
abline(h = mean(diferencia_descompresion), col = "red", lwd = 2)

# Afegir límits
sd_diferencia <- sd(diferencia_descompresion)
abline(h = mean(diferencia_descompresion) + 1.96 * sd_diferencia, col = "blue", lty = 2)
abline(h = mean(diferencia_descompresion) - 1.96 * sd_diferencia, col = "blue", lty = 2)

# Afegir línia a y = 0
abline(h = 0, col = "gray", lwd = 2)

t.test(datos$TiempoCompresionGzip,datos$TiempoCompresionZip,paired = T)
plot(means_descomp, diferencia_descompresion, 
     main = "Gràfic de Bland-Altman (Descompressió)", 
     xlab = "(GZIP + ZIP) / 2", 
     ylab = "GZIP- ZIP", 
     pch = 19, col = "black")

#Qqplots
qqnorm(diferencia_compresion, main = "QQ-plot de la Diferència de Compressió")
qqline(diferencia_compresion, col = "red")

qqnorm(diferencia_descompresion, main = "QQ-plot de la Diferència de Descompressió")
qqline(diferencia_descompresion, col = "red")


#IC:
#Hem de destransformar el interval de confiança
mean(diferencia_compresion)

#Tcompgzip = tcompzip + mean(diferencia_compresion) en mitjana

summary(lm(diferencia_compresion ~ 1))
0.09272+qt(0.975,79)*0.02073
0.09272-qt(0.975,79)*0.02073

t.test(datos$TiempoCompresionGzip,datos$TiempoCompresionZip,paired = T)
summary(lm(diferencia_descompresion~1))
0.06221+qt(0.975,79)*0.04404
0.06221-qt(0.975,79)*0.04404
#Para probar las 2 formas de calcularlo
t.test(datos$TiempoDescompresionGzip,datos$TiempoDescompresionZip,paired = T)
attach(datos)
#lm:
# Valores ajustados y residuos
compresion_zip<-lm(TiempoCompresionZip~Tamaño)
compresion_gzip<-lm(TiempoCompresionGzip~Tamaño)
descompresion_zip<-lm(TiempoDescompresionZip~Tamaño)
descompresion_gzip<-lm(TiempoDescompresionGzip~Tamaño)
summary(compresion_zip)
summary(compresion_gzip)
summary(descompresion_zip)
summary(descompresion_gzip)

plot(compresion_zip, c(2,1))
plot(compresion_gzip, c(2,1))

plot(descompresion_zip, c(2,1))
plot(descompresion_gzip,c(2,1))

