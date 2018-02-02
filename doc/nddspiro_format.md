# nddspiro output format

Details of the format of extracted data 

## General principles

Generally, data are extracted at 'Test' level from the ndd database.
'Trials' (the component parts of 'Tests') are returned as sets of columns in descending order of their 'Rank' (1 being the best). The 'Rank' is given to them either automatically, or as a result of user review in the ndd software.
Each row therefore represents the results of a single test. The exception is that for tests which incorporate a 'Pre' and 'Post' stage (before and after reversibility testing, for example), each stage appears as a separate row. 

## Format

Columns within the dataframe describe the following details:
* __nddTestID__ Character vector. ndd database internal (unique) identifier for the test.
* __patientID__ Character vector. Entered by the user at the point of testing.
* __nddPatientID__ Character vector. ndd database internal (unique) identifier for the patient.
* __lastName__ Character vector. Entered by the user at the point of testing.
* __firstName__ Character vector. Entered by the user at the point of testing.
* __height__ Double. Height in meters, entered by the user at the point of testing.
* __weight__ Double. Weight in kilograms, entered by the user at the point of testing.
* __ethnicity__ Character vector with levels. Entered by the user at the point of testing.
* __gender__ Character vector with 2 levels. Entered by the user at the point of testing.
* __dob__ Date. Date of birth. Entered by the user at the point of testing.
* __calcdob__ Logical. ndd parameter which is TRUE if date of birth has been calculated from age.
* __testDate__ Date. Date of the test.
* __testType__ Character vector with levels. ndd database identifier for type of test performed e.g. "MVV", "SVC", "DLCO", "FRC", "FVC"
* __testStage__ Character vector with levels. ndd database identifier for stage of test e.g. "Pre", "Post", "Base", "Level"
* __nddTrialID__ Character vector. ndd database internal (unique) identifier for the trial (which represents a single manoeuvre within a test).
* __deviceID__ Character vector. ndd equipment (unique) identifier.
* __age__ Double. Calculated age at the time of the test (years).
* __PredictedSet__ Character vector. Identifies the reference range used by ndd software to generate lower limit of normal (lln) and predicted (pred) values for each measurement.

For each requested measure, 4 columns. Column titles are appended by "_1", "_2", "_3"... to indicate 1st, 2nd and 3rd... ranked trial. The number of trials given can be altered using the `nddspiro.read(... traces=n)` parameter.

[repeating block begins]
* __*measure*_value__ Double. Values for given measure
* __*measure*_unit__ Character vector. Unit for given measure.
* __*measure*_pred__ Double. Predicted value for given measure, based on the __PredictedSet__
* __*measure*_lln__ Double. Lower limit of normal for given measure, based on the __PredictedSet__
[repeating block ends]

Optional- z scores based on GLI-2012 (Quanjer) references are given if requested using `nddspiro-read(... add_gli=TRUE)` parameter. Z scors represent the number of standard deviations from the predicted (population mean) value. Typically z=-1.64 (10th centile) is considered abnormal for spirometry. The given values are calculated from Rank=1 trial. 
* __gli_z_fev1__ FEV1 z score
* __gli_z_fvc__ FVC z score
* __gli_z_fev1fvc__ FEV1/FVC z score
* __gli_z_fef2575__ FEF25-75 z score

## ndd measurement identifiers
These can be passed to `nddspiro.read()` as a list, and may be one or more of:
* FEV1
* FEV6
* FVC
* FEV1_FVC
* PEFR
* FEF2575
* FET
* BEV
* EOTV
* VCmax
* ...*other measures according to ndd equipment*
