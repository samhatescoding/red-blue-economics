library(gridExtra)
library(grid)
library(vcd)
library(ggplot2)
library(GGally)
library(psych)

# Preliminaries
varp = function(x) {
  n = 0
  for (t in x) {
    n = n + 1 
  }
  var(x)*(n - 1)/n
}

growth = function(x) {
  v = c()
  j = 1
  for(i in x){
    v = append(v, 100*as.numeric(i)/j - 100)
    j = as.numeric(i)
  }
  as.numeric(v)
}

histFunction = function(x, title, xtitle, v = c()){
  if (length(v) == 0) {
    hist(x, col="lightblue1", border="dodgerblue3",
         main=title, xlab=xtitle)
  } else {
    hist(x, col="lightblue1", border="dodgerblue3",
         main=title, xlab=xtitle, breaks = v)
  }
  abline(v = var(x), col='blue', lwd = 2)
  abline(v = varp(x), col='lightblue', lwd = 2)
  abline(v = sqrt(var(x)), col='purple', lwd = 2)
  abline(v = sqrt(varp(x)), col='pink', lwd = 2)  
  abline(v = mean(x), col='red', lwd = 2)
  abline(v = median(x), col='green', lwd = 2)
}

freq = function(x){
  t = as.data.frame(table(x))
  t = transform(t, 
                Freq.Rela = prop.table(Freq), 
                Freq.Cum = cumsum(Freq),
                Freq.Rela.Cum = cumsum(prop.table(Freq)))
  grid.newpage()
  grid.table(t, rows = NULL)
}

summary = function(x) {
  v = c()
  for(i in x){
    v = append(v, 
               c(round(min(i),2), round(max(i),2), 
                 round(mean(i),2), median(round(i)),
                 round(var(i),2), round(varp(i),2), 
                 round(sqrt(var(i)),2), round(sqrt(varp(i)),2)))
  }
  m = matrix(v, ncol = 8, byrow = TRUE)
  colnames(m) = c('min', 'max', 'mean', 'median', 
                  'var', 'varp', 'sd', 'sdp')
  rownames(m) = colnames(x)
  grid.newpage()
  grid.table(m)
}

# Data is read
data = read.csv("data.csv")

# Data is extracted
pcgdp = as.numeric(unname(data[1,-1])[2:59])
gdp = as.numeric(unname(data[2,-1])[2:59])
gini = growth(unname(data[3,-1]))[2:59]
pov = growth(unname(data[4,-1]))[2:59]
une = growth(unname(data[5,-1]))[2:59]
rep = as.numeric(unname(data[6, -1]))[2:59]
sen = as.numeric(unname(data[7, -1]))[2:59]
pre = as.numeric(unname(data[8, -1]))[2:59]
ele = rep + sen + pre

# Histograms
histFunction(pcgdp,
             "per capita GDP",
             "per capita GDP growth (annual %)")
histFunction(gdp, "GDP", "GDP growth (annual %)")
histFunction(gini, "Gini Index",
             "Gini Index growth (annual %)")
histFunction(pov, "Poverty rate",
             "Poverty headcount ratio growth at $2.15 a day (2017 PPP) (% of population) (annual %)",
             seq(-125,125,by=50))
histFunction(une, "Unemployment rate",
             "Unemployment rate growth (% of total labor force) (annual %)")
histFunction(rep, "House of Representatives",
             "House of Representatives under Control of Democratic Party",
             c(0,1,by=0.5))
histFunction(sen, "Senate",
             "Senate under Control of Democratic Party",
             c(0,1,by=0.5))
histFunction(pre, "President",
             "President is member of Democratic Party",
             c(0,1,by=0.5))
histFunction(ele, "Electability of Democratic Party",
             "Number of Branches under Democratic Party Control",
             seq(-0.5,3.5,by=1))

# Frequency tables
freq(round(gdp))
freq(round(pcgdp))
freq(round(gini))
freq(round(pov))
freq(round(une/10)*10)
freq(rep)
freq(sen)
freq(pre)
freq(ele)

# Summary of variables
quan = data.frame(pcgdp, gdp, gini, pov, une)
summary(quan)
qual = data.frame(rep, sen, pre, ele)
summary(qual)

# Bivariate study
d = data.frame(pcgdp, gdp, gini, pov, une, ele)
matrix = ggpairs(d, columns = c(1:6), title = "Scatterplot Matrix",
                 axisLabels = "show")
ggsave("scatter.png", matrix, width = 7, height = 7, units = "in")
matrix





