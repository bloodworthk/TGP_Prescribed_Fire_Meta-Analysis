##########################################################################################################
#Project: Prescribed Fire in Tallgrass Priarie Meta-Analysis 

#Contributors: Kathryn Bloodworth, Dirac Twidwall, Alice Boyle, Ellen Welti, Marissa Ahlering, Brian Obermeyer, Chris Helzer, Bob Hamilton, Elizabeth Bach, Clare Kazanski, Sally Koerner 

#Coder: Kathryn Bloodworth, Sarah Gora
##########################################################################################################

#### Install and load libraries ####
#had to first download XQuartz on mac, then followed these steps https://www.andrewheiss.com/blog/2012/04/17/install-r-rstudio-r-commander-windows-osx/, then had to install Rcmdr 

install.packages("Rcmdr")
library(Rcmdr)
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install(version = "3.11")
BiocManager::install("EBImage")
#install.packages("Rcpp")
library(Rcpp)
#install.packages("tcltk2")
library(tcltk2)
#install.packages("metagear")
library(metagear)


#### Set Working Directories ####

#Bloodworth - Desktop
setwd("/Users/kjbloodw/Box/TNC_TGP_RxFire/Data")

#Bloodworth - Mac
setwd("/Users/kathrynbloodworth/Box/TNC_TGP_RxFire/Data")

#### Read in Data frame with first 10 papers ####

Web_of_Science_Articles<-read.csv("Papers/Articles_For_Screening_07_28_2020.csv", header = T)

#### Setting up screening tasks ####
#Following http://lajeunesse.myweb.usf.edu/metagear/metagear_basic_vignette.html#installation-and-dependencies 

#prime the study-reference dataset - function adds 4 new columns: Study_ID (unique number for each reference), Reviewers (an empty column with NAs that will populate later with reviewers), 2 columns for Include (will contain the screening efforts by both reviewers)

References_screening_ready<-effort_initialize(Web_of_Science_Articles)

names(References_screening_ready)

### Randomly delegate screening efforts to two reviewers (Kathryn and Sarah) ###
References_unscreened_<- effort_distribute(References_screening_ready, dual = TRUE, reviewers = c("Kathryn", "Sarah"), initialize = TRUE, save_split = TRUE,)


#From Initialization through assignment of papers (effort distribute) all in one step -- assigns 50/50
#References_unscreened<-effort_distribute(Web_of_Science_Articles, reviewers = c("Kathryn", "Sarah"), initialize = TRUE, save_split = TRUE)

### Randomly delegating screening efforts with two reviewers (Kathryn and Sarah), where Kathryn takes 80% of studies ### save_splot = TRUE allows this particular split to be saved to a file
#References_unscreened_60 <- effort_distribute(References_screening_ready, reviewers = Reviewers, effort = c(60,40), save_split = TRUE)

# show that files are saved in working directory by name of reviewer
list.files(pattern = "effort")

#Remerge files from both reviewers (do this if reviewers use data frames in the working directory to vet the references -- each reviewer must change the column "Include" to either a YES or NO)
#References_screened <- effort_merge()
#References_screened[c("STUDY_ID", "REVIEWERS", "INCLUDE")]

#See how many were vetted yes, no, not vetted. Review progress and check percentage of usable papers
#References_screened_Summary <- effort_summary(References_screened)

abstract_screener(file = file.choose("effort_Kathryn.csv"),
         aReviewer = "Kathryn",
         reviewerColumnName = "REVIEWERS_A",
         unscreenedColumnName = "INCLUDE_A",
         unscreenedValue = "not vetted",
         abstractColumnName = "Abstract",
         titleColumnName = "Article.Title",
         browserSearch = "https://www.google.com/search?q=",
         fontSize = 13,
         windowWidth = 70,
         windowHeight = 16,
         theButtons = c("YES", "maybe", "NO"),
         keyBindingToButtons = c("y", "m", "n"),
         buttonSize = 10,
         highlightColor = "powderblue",
         highlightKeywords = NA)
