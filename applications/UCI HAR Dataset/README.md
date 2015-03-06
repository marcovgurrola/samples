###Course Project
The main goal of this project is to get data from internet, clean it, organize it and finally to create a file with the tidy data,
to perform this analisis an R script was created.


**Data Summary**

(*IMPORTANT!*) Download the experiment Data from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The downloaded zip contains data related to observations of Human Activity Using Smartphones:

- Experiments carried out with 30 volunteers within an age of 19-48 years, wearing a Samsung Galaxy S II on the waist.
- Activities performed: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING.
- Measurements: 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz.
- Using the smarthphone's embedded accelerometer and gyroscope.
- 70% of the is training data, 30% is the test data. 

For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

Included files on the zip:

- 'README.txt'.
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.
- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

Notes: 

- Features are normalized and bounded within [-1,1]. (No Units required)
- Each feature vector is a row on the text file.
- Inertial Signals Files are not required for the assigment.

For more details about please read the authors's 'README.txt' on the
same directory as this file.

-------------------------------------

**Environment and script execution**

1. Clone the repository *(https://github.com/marcovgurrola/uci-har-dataset.git)* using Git,
to a folder named 'uci-har-dataset'.
2. From the experiment data zip files, paste the following files in 'uci-har-dataset' folder:
	- *features.txt*
	- *activity_labels.txt*
	- *train/X_train.txt*
	- *train/y_train.txt*
	- *test/X_test.txt*
	- *test/y_test.txt*
	- *train/subject_train.txt*

3. In RStudio, set the Working Directory to 'uci-har-dataset'.
4. Open run_analysis.R from RStudio.
5. From the RStudio Menu, select Code, and click on Source File and select run_analysis.R
or from the Console type *source('run_analysis.R')* and hit ENTER.

-------------------------------------

**Results, view the in 3 possible ways**

- There will be 180 observations, from 30 persons(subjects), 6 activities, 66 averages of Means and Stds attributes,
every record is a single observation, each column is a single variable, and the resulting table contains information
of the same type, *this is Tidy Data!*

- Viewing the data in R
Type View(totalAvgs) and hit enter on the console, will be 180 observations, from 30 persons(subjects), 6 activities,
66 averages of the measurements attributes.

- Reading the file back into R
data <- read.table('./avgsPerSubjActiv.txt', header = TRUE).

- In a Text Editor by opening the output file on this directory: *avgsPerSubjActiv.txt*

- Understanding the variables: There is a file called *code book.txt* containing friendlier variable names.

*Coding the Grouping and Calculus is way much easier using package 'sqldf' if your are familiar with SQL langauge,
but the main goal is to use more Rable libraries.*

-------------------------------------

**Script description**

The code is divides into 17 steps, each one commented briefly on the file itself with
17 identification numbers:

1. Required libraries for running run_analysis.R on RStudio Version 0.98.1091
This function installs the dplyr library if not available on the running
environment, whichever the case the includes it in to the libraries pack

2. Transform the features column names into easier ones.

3. Getting the 561 measurements attributes(features).

4. Retrieving the Mean and Std features only.

5. Getting the Test obvservations and filtering the Means and Stds columns.

6. Getting the Train obvservations and filtering the Means and Stds columns.

7. Getting the Test and Train Activity Names.

8. Converting the numeric activities to friendlier factor labels.

9. Getting the Test and Train subjects (persons on the experiment).

10. Gathering Test activities, subjects and Observations/features into a single DataSet.

11. Gathering Train activities, subjects and Observations/features into a single DataSet.

12. Gathering Test and Train Data

*Gathered Data layout*

Head

| Id | Type | Subject | Activity | Features (Measurements Means and Stds)    |
|----|------|---------|----------|-------------------------------------------|
| 1  | Test | 2       | STANDING | 0.25717778   -2.328523e-02   -0.014653762 |
| 2  | Test | 2       | STANDING | 0.28602671   -1.316336e-02   -0.119082520 |
| 3  | Test | 2       | STANDING | 0.27548482   -2.605042e-02   -0.118151670 |

Tail

| Id    | Type  | Subject | Activity         | Features (Measurements Means and Stds)    |
|-------|-------|---------|------------------|-------------------------------------------|
| 10297 | Train | 30      | WALKING_UPSTAIRS | 0.2733874    -0.017010616	-0.04502183  |
| 10298 | Train | 30      | WALKING_UPSTAIRS | 0.2896542    -0.018843044	-0.15828059  |
| 10299 | Train | 30      | WALKING_UPSTAIRS | 0.3515035    -0.012423118	-0.20386717  |


13. Function that calculates the averages for Means and Stds
per groups of Subjects and Activities.

14. Getting the unique subjects (30), sorting them from minimum to maximum

15. Declaring the variable which will hold the final data

16. Calculating and saving the final averages per groups

17. Creating the output text file