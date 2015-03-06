library(dplyr)

run_analysis<- function() {
    #load and merge
    testData <- getData('test')
    trainData <- getData('train')
    totalData <- rbind(testData, trainData)
    
    #filter mean and stds only
    n <- names(totalData)
    cols <- c(1, 2, grep('-mean\\(\\)', n), grep('-std\\(\\)', n))
    filteredData <- totalData[, cols]
    
    #set friendlier variable names
    activityLabels <- read.table('activity_labels.txt', header=FALSE)
    activityLabels <- as.vector(activityLabels[, 2])
    
    filteredData <- mutate(filteredData, activity=factor(activity, labels=activityLabels))
}

# read and combine the data:test, train Subject
# and add the respective columns Subject and
# activity
getData <- function(type) {
    #gets the path to retrieve data from
    dataPath <- sprintf('./%s/', type)
    
    #gets the measurements features (X)
    measurements <- read.table(sprintf('%sX_%s.txt', dataPath, type), header=FALSE)
    features <- read.table('features.txt', header=FALSE)
    names(measurements) <- as.vector(features[,2])
    
    subjectsActivities <- read.table(sprintf('%sy_%s.txt', dataPath, type), header=FALSE)
    names(subjectsActivities) <- 'activity'

    subjects <- read.table(sprintf('%ssubject_%s.txt', dataPath, type), header=FALSE)
    names(subjects) <- 'subject'
    
    cbind(subjects, subjectsActivities, measurements)
}

#summarise and generate the output
summGenerate <- function(mergedData, fileName) {
    #generate teh average of each mean and std
    #per subject and activity
    mergedData %>% group_by(subject, activity) %>%
        summarise_each(funs(mean)) %>%
            write.table(file=fileName, row.name=FALSE)
    
}