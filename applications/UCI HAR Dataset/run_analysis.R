##(1) Required libraries for running run_analysis.R
## on RStudio Version 0.98.1091
## This function installs the dplyr library if not available on the running
## environment, whichever the case the includes it in to the libraries pack
pkgReady <- function(pkgName) is.element(pkgName, installed.packages()[,1])
if(!pkgReady('dplyr')){install.packages('dplyr')}
library(dplyr)

##(2) Transform the features column names into easier ones
easierNames <- function(varName){
    varName %>%
    gsub(pattern="[^a-zA-Z]", replacement="_", perl=TRUE) %>%
    sub(pattern="^t", replacement="Time_", perl=TRUE) %>%
    sub(pattern="^f", replacement="Freq_", perl=TRUE) %>%
    sub(pattern="BodyBody", replacement="Body", perl=TRUE) %>%
    sub(pattern="Body", replacement="Body_", perl=TRUE) %>%
    sub(pattern="Acc", replacement="Acceleration_", perl=TRUE) %>%
    sub(pattern="Gravity", replacement="Gravity.", perl=TRUE) %>%
    sub(pattern="Jerk", replacement="_Jerk_", perl=TRUE) %>%
    sub(pattern="Gyro", replacement="Gyroscope_", perl=TRUE) %>%
    sub(pattern="Mag", replacement="Magnitude_", perl=TRUE) %>%
    sub(pattern="mean", replacement="Mean", perl=TRUE) %>%
    sub(pattern="std", replacement="Std", perl=TRUE) %>%
    gsub(pattern="(___)", replacement="_", perl=TRUE) %>%
    gsub(pattern="(__)", replacement="_", perl=TRUE) %>%
    sub(pattern="(_$)", replacement="", perl=TRUE)
}

##(3) Getting the 561 measurements attributes(features)
features <- read.table('features.txt',col.names=c('fId','fName'), header=FALSE)

##(4) Retrieving the Mean and Std features only
meanStdIds <- grep('(\\bmean()\\b)|(\\bstd()\\b)', features$fName)
meanStdNames <- sapply(as.character(features[meanStdIds,'fName']), easierNames)

##(5)Getting the Test obvservations and filtering the Means and Stds columns
testObs <- read.table('./test/X_test.txt', header=FALSE)[, meanStdIds]

##(6) Getting the Train obvservations and filtering the Means and Stds columns
trainObs <- read.table('./train/X_train.txt', header=FALSE)[, meanStdIds]

##(7) Getting the Test and Train Activity Names
activsLabels = c('WALKING','WALKING_UPSTAIRS','WALKING_DOWNSTAIRS','SITTING',
    'STANDING','LAYING')
##(8) Converting the numeric activities to friendlier factor labels
testActivs <- as.character(factor(labels=activsLabels,
    x=as.integer(read.table('./test/y_test.txt', header=FALSE)[,1])))
trainActivs <- as.character(factor(labels=activsLabels,
    x=as.integer(read.table('./train/y_train.txt', header=FALSE)[,1])))

##(9) Getting the Test and Train subjects (persons on the experiment)
testSubjects <- read.table('./test/subject_test.txt', header=FALSE)
trainSubjects <- read.table('./train/subject_train.txt', header=FALSE)

##(10) Gathering Test activities, subjects and Observations/features
## into a sinle DataSet
extraColumns <- c('Type', 'Subject', 'Activity')
testData <- as.data.frame(cbind(rep('Test',length(testActivs)),
    testSubjects[,1], testActivs, testObs[,]))
colnames(testData) <- append(extraColumns, meanStdNames, after=3)

##(11) Gathering Train activities, subjects and Observations/features
## into a single DataSet
trainData <- as.data.frame(cbind(rep('Train', length(trainActivs)),
    trainSubjects[,1],trainActivs,trainObs[,]))
colnames(trainData) <- append(extraColumns, meanStdNames, after=3)

##(12) Gathering Test and Train Data
totalData <- rbind(testData, trainData)
totalData <- cbind('Id'= 1:nrow(totalData), totalData)

##(13) Function that calculates the averages for Means and Stds
## per groups of Subjects and Activities
subjectsActivsAverages <- function(x){
    subjAvgs <- NULL

    for(a in activsLabels){
        subData <- select(filter(totalData, Subject==x, Activity==a),
            2:ncol(totalData))
        cMeans <- t(colMeans(subData[,meanStdNames]))
        if(is.null(subjAvgs))
        {
            subjAvgs <- as.data.frame(cbind('Subject'=x,
                'Type'=as.character(subData[1,'Type']), 'Activity'=a, cMeans))
            next
        }
        nextAvgs <- as.data.frame(cbind('Subject'=x,
            'Type'=as.character(subData[1,'Type']), 'Activity'=a, cMeans))
        
        subjAvgs <- rbind(subjAvgs, nextAvgs)
    }
    if(is.null(totalAvgs)) { totalAvgs <<- subjAvgs }
    else { totalAvgs <<- rbind(totalAvgs, subjAvgs)}
}

##(14) Getting the unique subjects (30), sorting them from minimum to maximum
subjects <- sort(unique(totalData$Subject))

##(15) Declaring the variable which will hold the final data
totalAvgs <<- NULL

##(16) Calculating and saving the final averages per groups
sapply(subjects, subjectsActivsAverages)

##(17) Creating the output text file
write.table(totalAvgs,file='avgsPerSubjActiv.txt',append=FALSE,row.names=FALSE)