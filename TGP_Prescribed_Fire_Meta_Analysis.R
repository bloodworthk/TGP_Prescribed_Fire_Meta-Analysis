##########################################################################################################
#Project: Prescribed Fire in Tallgrass Priarie Meta-Analysis 

#Contributors: Kathryn Bloodworth, Dirac Twidwall, Alice Boyle, Ellen Welti, Marissa Ahlering, Brian Obermeyer, Chris Helzer, Bob Hamilton, Elizabeth Bach, Clare Kazanski, Sally Koerner, 

#Coder: Kathryn Bloodworth
##########################################################################################################

#### Install and load libraries ####

#install.packages("BiocManager")
library(BiocManager)
#BiocManager::install("EBImage")
install.packages("Rcpp")
#install.packages("metagear")
library(metagear)

#### Set Working Directories ####

#Bloodworth - Desktop
setwd("/Users/kjbloodw/Box/TNC_TGP_RxFire/Data")


#### Read in Data frame with first 500 papers ####

Web_of_Science_First500<-read.csv("Papers/Web_of_Science_06_16_20_Papers1-500.csv")
names(Web_of_Science_First500)

Web_of_Science_FirstPage<-read.csv("Papers/Web_of_Science_06_16_20_Page1.csv")

#### Setting up screening tasks ####
#Following http://lajeunesse.myweb.usf.edu/metagear/metagear_basic_vignette.html#installation-and-dependencies 

#prime the study-reference dataset - function adds three new columns: Study_ID (unique number for each reference), Reviewers (an empty column with NAs that will populate later with reviewers), Include (will contain the screening efforts by reviewers)

References_screening_ready<-effort_initialize(Web_of_Science_FirstPage)

#Create a list with reviewer names to be assigned papers
Reviewers<-c("Kathryn", "Sarah")

### Randomly delegate screening efforts to two reviewers (Kathryn and Sarah) ###
References_unscreened_random <- effort_distribute(References_screening_ready, reviewers = Reviewers)

#check to make sure it worked: display screening tasks
References_unscreened_random[c("STUDY_ID","REVIEWERS")]

#From Initialization through assignment of papers (effort distribute) all in one step -- assigns 50/50
References_unscreened<-effort_distribute(Web_of_Science_FirstPage, reviewers = c("Kathryn", "Sarah"), initialize = TRUE)

### Randomly delegating screening efforts with two reviewers (Kathryn and Sarah), where Kathryn takes 80% of studies ### save_splot = TRUE allows this particular split to be saved to a file
References_unscreened_60 <- effort_distribute(References_screening_ready, reviewers = Reviewers, effort = c(60,40), save_split = TRUE)

# save files in working directory by name of reviewer
list.files(pattern = "effort")

#Remerge files from both reviewers (do this if reviewers use data frames in the working directory to vet the references -- each reviewer must change the column "Include" to either a YES or NO)
#References_screened <- effort_merge()
#References_screened[c("STUDY_ID", "REVIEWERS", "INCLUDE")]

#See how many were vetted yes, no, not vetted. Review progress and check percentage of usable papers
#References_screened_Summary <- effort_summary(References_screened)

abstract_screener("effort_Kathryn.csv", aReviewer = "Kathryn")
