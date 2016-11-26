#!/usr/bin/Rscript
data<-read.table('result.dat', header=T)
ts<-data$ts
ts = ts-ts[1]
# Create PNG device
png(
    filename = "Rplot.png",
    width = 480, height = 480, units = "px", pointsize = 12,
    bg = "white",  res = NA
   )
ylim=c(-pi, pi)
plot(ts, data$Euler_x, type='l', col='red', ylim=ylim, xlab='Relative timestamp, sec', ylab='Euler angles, deg')
lines(ts, data$Euler_y, type='l', col='green')
lines(ts, data$Euler_z, type='l', col='blue')


dev.off()
