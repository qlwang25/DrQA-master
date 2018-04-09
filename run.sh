#!/bin/bash

CODE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#echo $CODE_DIR

export PYTHONPATH=$PYTHONPATH:$CODE_DIR


################################ scripts retriever ####################################

# build_db
#python3 $CODE_DIR/scripts/retriever/build_db.py

# build tfidf
#python3 $CODE_DIR/scripts/retriever/build_tfidf.py

# the document retriever
#python3 $CODE_DIR/scripts/retriever/interactive.py

################################ scripts retriever ####################################


:<<!
# java classpath
while read -p "Add to ~/.bashrc CLASSPATH (recommended)? [yes/no]: " choice; do
    case "$choice" in
        yes )
            echo "export CLASSPATH=\$CLASSPATH:$CODE_DIR/data/corenlp/stanford-corenlp-full-2017-06-09/*" >> ~/.bashrc;
            break ;;
        no )
            break ;;
        * ) echo "Please answer yes or no." ;;
    esac
done

printf "\n*** NOW RUN: ***\n\nexport CLASSPATH=\$CLASSPATH:$CODE_DIR/data/corenlp/stanford-corenlp-full-2017-06-09/*\n\n****************\n"

!


################################ scripts reader ####################################


# preprocessing SQuAD-formatted dataset
#python3 $CODE_DIR/scripts/reader/preprocess.py --split train-v1.1

#python3 $CODE_DIR/scripts/reader/preprocess.py --split dev-v1.1

# main train script for the Document Reader
python3 $CODE_DIR/scripts/reader/train.py

# Use trained Document Reader model to make prefictions for an input dataset
#python3 $CODE_DIR/scripts/reader/predict.py

# The Document Reader can also be used interactively
#python3 $CODE_DIR/scripts/reader/interactive.py


################################ scripts reader ####################################



################################ scripts pipeline ####################################

# the full system is linked together
#python3 $CODE_DIR/scripts/pipeline/interactive.py

################################ scripts pipeline ####################################
