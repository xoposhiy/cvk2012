require(maptools)

gpclibPermit()

udata <- read.csv("../data/user-answers.csv", encoding="UTF-8")
pdf("../results/upca.pdf")

upca <- princomp(udata[,1:25])

ux <- upca$scores[,1]
uy <- upca$scores[,2]

write.csv(upca$loadings, file="../results/upca_components.csv")


plot(ux, uy, pch=4, asp=1, col="grey")

dev.off()
