#!/bin/bash

set -e

CODE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &&pwd )"


# By default download to the data directory
read -p "Specify download path or enter to use default (data/corenlp)" path
if [ ! -n "$path" ];
then
DOWNLOAD_PATH=$CODE_DIR/data/corenlp
else
DOWNLOAD_PATH=$CODE_DIR/$path
fi

#echo $CODE_DIR
#echo $DOWNLOAD_PATH

:<<!
echo "CorNLP Will download to :"  $DOWNLOAD_PATH

mkdir -p "$DOWNLOAD_PATH"
corenlp="/stanford-corenlp-full-2017-06-09.zip"
#echo ${DOWNLOAD_PATH}${corenlp}

# Download zip , unzip
wget -P $DOWNLOAD_PATH "http://nlp.stanford.edu/software/stanford-corenlp-full-2017-06-09.zip"
unzip $DOWNLOAD_PATH/stanford-corenlp-full-2017-06-09.zip
rm  $DOWNLOAD_PATH/stanford-corenlp-full-2017-06-09.zip


# Append to bashrc , classpath instructions
:<<!
while read -p "Add to ~/.bashrc CLASSPATH (recommender)? [yes/no]: " choice; do
    case "$choice" in
        yes )
            echo "export CLASSPATH=\$CLASSPATH:$DOWNLOAD_PATH/*" >> ~/.bashrc;
            break;;
        no )
            break;;
        * )
            echo "please answer yes or no.";;
    esac
done

printf "\n***** NOW RUN *****\n"
printf "\n*** export CLASSPATH=\$CLASSPATH:$DOWNLOAD_PATH/* ***\n"
printf "\n********************\n"
!

# Configure download location
DOWNLOAD_DATA=$CODE_DIR/data


# Get AWS hosted data
DOWNLOAD_DATA_AWS=$DOWNLOAD_DATA/aws
AWS="/data.tar.gz"
echo "AWS Will download to :"  $DOWNLOAD_DATA_AWS
mkdir -p "$DOWNLOAD_DATA_AWS"

# DOWNLOAD main hosted data
wget -P $DOWNLOAD_DATA_AWS "https://s3.amazonaws.com/fair-data/drqa/data.tar.gz"
# Untar
tar -xvf $DOWNLOAD_DATA_AWS/data.tar.gz
# Remove tar ball
#rm  $DOWNLOAD_DATA_AWS/data.tar.gz


# GET externally hosted data
DATASET_PATH=$DOWNLOAD_DATA/datasets

:<<!
echo "SQuAD train Will download to :"  $DATASET_PATH
mkdir -p $DATASET_PATH
# GET SQuAD train
#wget -P $DATASET_PATH "https://rajpurkar.github.io/SQuAD-explorer/dataset/train-v1.1.json"
python3 $CODE_DIR/scripts/convert/squad.py $DATASET_PATH/train-v1.1.json $DATASET_PATH/train.txt
!

:<<!
echo "SQuAD dev Will download to :"  $DATASET_PATH
# GET SQuAD dev
wget -P $DATASET_PATH "https://rajpurkar.github.io/SQuAD-explorer/dataset/dev-v1.1.json"
python3 $CODE_DIR/scripts/convert/squad.py $DATASET_PATH/dev-v1.1.json $DATASET_PATH/dev.txt
!

:<<!
# Download official eval for SQuAD
curl "https://worksheets.codalab.org/rest/bundles/0xbcd57bee090b421c982906709c8c27e1/contents/blob/"  >  "./scripts/reader/official_eval.py"
!

:<<!
# GET WebQuestion train
wget -P $DATASET_PATH "http://nlp.stanford.edu/static/software/sempre/release-emnlp2013/lib/data/webquestions/dataset_11/webquestions.examples.train.json.bz2"
bunzip2 -f $DATASET_PATH/webquestions.examples.train.json.bz2
python3 $CODE_DIR/scripts/convert/webquestions.py $DATASET_PATH/webquestions.examples.train.json $DATASET_PATH/WebQuestions-train.txt
rm $DATASET_PATH/webquestions.examples.train.json
!


:<<!
# GET WebQuestion test
wget -P $DATASET_PATH "http://nlp.stanford.edu/static/software/sempre/release-emnlp2013/lib/data/webquestions/dataset_11/webquestions.examples.test.json.bz2"
bunzip2 -f $DATASET_PATH/webquestions.examples.test.json.bz2
python3 $CODE_DIR/scripts/convert/webquestions.py $DATASET_PATH/webquestions.examples.test.json $DATASET_PATH/WebQuestions-test.txt
rm $DATASET_PATH/webquestions.examples.test.json
!


:<<!
# GET freebase entities for WebQuestions
wget -P $DATASET_PATH "https://s3.amazonaws.com/fair-data/drqa/freebase-entities.txt.gz"
gzip -d $DATASET_PATH/freebase-entities.txt.gz
!


echo "DrQA download done!"



