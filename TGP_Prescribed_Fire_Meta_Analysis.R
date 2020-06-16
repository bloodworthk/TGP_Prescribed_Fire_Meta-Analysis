##########################################################################################################
#Project: Prescribed Fire in Tallgrass Priarie Meta-Analysis 

#Contributors: Kathryn Bloodworth, Dirac Twidwall, Alice Boyle, Ellen Welti, Marissa Ahlering, Brian Obermeyer, Chris Helzer, Bob Hamilton, Elizabeth Bach, Clare Kazanski, Sally Koerner, 

#Coder: Kathryn Bloodworth
##########################################################################################################

#### Install and load libraries ####

#install.packages("BiocManager")
library(BiocManager)
#BiocManager::install("EBImage")
library(metagear)

#### Set Working Directories ####

#Bloodworth - Desktop
setwd("/Users/kjbloodw/Box/TNC_TGP_RxFire/Data")


#### Read in Data frame with first 500 papers ####

Web_of_Science_First500<-read.csv("Papers/Web_of_Science_06_16_20_Papers1-500.csv")
