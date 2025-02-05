library(genefilter)
HostData0 = read.csv("vstBY04_host.csv", row.names = 1);
HostData0 <- data.matrix(HostData0, rownames.force = TRUE);
HostData <-varFilter(HostData0, var.func=IQR, var.cutoff=0.5, filterByQuantile=TRUE)
dim(HostData)
#var.cutoff=0.8 keep only top 20th percentile of genes
write.table(HostData, file="vstBY04_host_var50.csv", sep = ",")
