# Getting and Cleaning Data - Course Project

This is the course project for the Getting and Cleaning Data Coursera course.
The R script, `run_analysis.R`, does the following:

1. Loads the required libraries
2. Downloads the dataset if it does not already exist in the working directory and unzip the corresponding files
2. Loads the activity and feature info
3. Loads both the training and test datasets, keeping only mean and standard deviation data
4. Loads the activity and subject data for each dataset, then merges those columns with the dataset
5. Merges the two corresponding datasets
6. Converts the `activity` and `subject` columns into factors
7. Creates a tidy dataset that consists of the average (mean) value of each variable, for each subject and activity pair.

The result is saved to the file `tidy.txt` in the working directory.

