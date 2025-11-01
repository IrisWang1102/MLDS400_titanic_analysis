# MLDS400_titanic_analysis

Overview
Predicting passenger survival on the Kaggle Titanic data with logistic regression in **Python** and **R** seperately.  


Folder Map
MLDS400_Titanic_Analysis/
├── Dockerfile              # Python Dockerfile
├── DockerfileR             # R Dockerfile
├── requirements.txt        # Python dependency
├── install_packages.R      # R dependency
├── README.md              
└── src/
    ├── app/
    │   └── main.py         # Python Script
    ├── appR/
    │   └── main.R          # R Script
    ├── data/
    │   ├── train.csv
    │   ├── test.csv
    ├── predictions.csv     # Python prediction
    └── predictionsR.csv    # R prediction

Data Setup
1. Donwload titanic dataset from Kaggle: https://www.kaggle.com/competitions/titanic/data?select=gender_submission.csv

2. Place the files in src/data/ directory: 
-train.csv src/data/train.csv
-test.csv src/data/test.csv


Running the Python Pipeline
1. Build the Python Image
docker build -t titanic-py .

2. Run the Python container
docker run --rm -v "$(pwd)/src:/app/src" titanic-model

3. Results
Messages: Data preprocessing steps 
Results: Training accuracy
Predictions are saved as csv file to: src/predictions.csv


Running the R Pipeline
1. Build the R Image
docker build -t titanic-r -f DockerfileR .

2. Run the R container
docker run --rm -v "$(pwd)/src/data:/app/src/data" titanic-r

3. Results
Messages: Data preprocessing steps 
Results: Training accuracy
Predictions are saved as csv file to: src/predictionsR.csv


Author
Yinghong Wang
Northwestern University MLDS Program
MLDS400 Introduction to Data Engineering