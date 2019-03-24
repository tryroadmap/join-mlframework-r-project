# Kaggle alchemy

[header img](README_files/kaggle_alchemy_art.png)
The goal of this package is to build a:
- standard file system for Kaggle participation.
- versioning and documentation built in code.
- connects to as many ML APIs as possible.


### Setup Kaggle Alchemy
Download all your data to folder input. Kaggle Alchemy sees csv files inside folder input.

```
git clone https://github.com/lotusxai/kaggle-alchemy.git
cd kaggle-alchemy
wget https://s3.amazonaws.com/h20-lotusx/train_df.csv
wget  https://s3.amazonaws.com/h20-lotusx/test_df.csv
wget https://s3.amazonaws.com/al-chemy/microsoft-malware-prediction/train.csv.zip

Rscript script/run.R
```

# name-of-the-project-competition-or-demo

version 0.0:
Features:
* builds cache, submit, data folder.
* runs unit tests on dynamoDB, data S3 buckets and local data files.
* prepares a base model and submits result in submit folder.






### Acknowledgment
[Data Source for CCFraud Demo](https://www.kaggle.com/mlg-ulb/creditcardfraud)
