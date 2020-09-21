##########################################################################################################
#Project: Prescribed Fire in Tallgrass Priarie Meta-Analysis 

#Contributors: Kathryn Bloodworth, Dirac Twidwall, Alice Boyle, Ellen Welti, Marissa Ahlering, Brian Obermeyer, Chris Helzer, Bob Hamilton, Sarah Gora, Elizabeth Bach, Clare Kazanski, Sally Koerner 

#Coder: Kathryn Bloodworth, Sarah Gora
##########################################################################################################

#### Install and load libraries ####
#had to first download XQuartz on mac, then followed these steps https://www.andrewheiss.com/blog/2012/04/17/install-r-rstudio-r-commander-windows-osx/, then had to install Rcmdr 

###Gora version Install packages, latest R version
###For pc Desktop, only metagear is needed, no other packages

#install.packages("zip")
library(zip)
#install.packages("mgcv")
library(mgcv)
#Needed on all computers
#install.packages("Rcmdr")
library(Rcmdr)
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install(version = "3.11")
BiocManager::install("EBImage")
#install.packages("Rcpp")
library(Rcpp)
#install.packages("tcltk2")
library(tcltk2)
#install.packages("data.table-package ")
library(data.table)
#install.packages("tidyverse")
library(tidyverse)
#install.packages("arsenal")
library(arsenal)
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
         highlightKeywords = c("fire","burn","grassland","tallgrass prairie","prairie", "savanna", "rangeland"))

###This does not work with dual reviewers -- cannot get effort summary to work without error 

#Remerge files from both reviewers (do this if reviewers use data frames in the working directory to vet the references -- each reviewer must change the column "Include" to either a YES or NO)
#References_screened <- effort_merge()
#References_screened[c("STUDY_ID", "REVIEWERS_A", "INCLUDE_A", "REVIEWERS_B", "INCLUDE_B")]

#References_screened_1<-as.array(References_screened)


#See how many were vetted yes, no, not vetted. Review progress and check percentage of usable papers
#References_screened_Summary <- effort_summary(References_screened, dual = TRUE)

 ##### trying something different #####

#To get this to work I had to remove columns that interfered with merging, including the unused Reviewer in each dataframe

Kathryn<-read.csv("~/Box/TNC_TGP_RxFire/Data/effort_Kathryn1.csv")%>%
  select("STUDY_ID","REVIEWERS_A","INCLUDE_A") #%>% 
  #rename("INCLUDE"="INCLUDE_A") %>% 
    #rename("REVIEWERS"="REVIEWERS_A")

Sarah<-read.csv("~/Box/TNC_TGP_RxFire/Data/effort_Sarah.csv")%>% 
  select(-"REVIEWERS_A",-"INCLUDE_A") #%>% 
  #rename("INCLUDE"="INCLUDE_B")%>% 
    #rename("REVIEWERS"="REVIEWERS_B")

theRefs_screened <- Kathryn %>% 
  left_join(Sarah)

#instead of using effort_summary -- we looked together at each individual outcome and if we dissagreed, we went into excel and manually changed the answer of one of our reviews to match the other
theRefs_screened[c("STUDY_ID", "REVIEWERS_A", "INCLUDE_A","REVIEWERS_B","INCLUDE_B")]


## Sarah and Kathryn reviewed each paper together and decided on final answer when original answers were disagreed on, then each cell was changed individually

#figure out why NA isn't changin to NO
theRefs_screened[1,5]<-"NO"
theRefs_screened[2,3]<-"NO"
theRefs_screened[2,5]<-"NO"
theRefs_screened[9,3]<-"NO"
theRefs_screened[10,5]<-"NO"
theRefs_screened[17,3]<-"NO"
theRefs_screened[19,5]<-"NO"
theRefs_screened[35,3]<-"NO"
theRefs_screened[37,3]<-"NO"
theRefs_screened[39,3]<-"NO"
theRefs_screened[39,5]<-"NO"
theRefs_screened[40,3]<-"NO"
theRefs_screened[44,3]<-"YES"
theRefs_screened[47,5]<-"NO"
theRefs_screened[52,5]<-"NO"
theRefs_screened[63,3]<-"NO"
theRefs_screened[65,5]<-"NO"
theRefs_screened[66,5]<-"YES"
theRefs_screened[68,5]<-"YES"
theRefs_screened[73,5]<-"NO"
theRefs_screened[76,5]<-"NO"


theRefs_screened[c("STUDY_ID", "REVIEWERS_A", "INCLUDE_A","REVIEWERS_B","INCLUDE_B")]

#Determining how many differences

Compare_Kathryn<- theRefs_screened %>% 
  select("INCLUDE_A") %>% 
  rename(Include="INCLUDE_A")

Compare_Sarah<- theRefs_screened %>% 
  select("INCLUDE_B") %>% 
  rename(Include="INCLUDE_B")

#install.packages("arsenal")
#library(arsenal)

summary(comparedf(Compare_Kathryn,Compare_Sarah))
                             