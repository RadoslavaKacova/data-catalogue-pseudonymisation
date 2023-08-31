FILES="/home/houfek/Work/MMCI/data-catalogue-playground/seq/TRANSFER/*" #$1
#FULL_EXPORT="/home/houfek/work/NGS-DATA-FAIRIFICATION/patient_exports/"
PREDICTIVE_EXPORT="/home/houfek/Work/MMCI/data-catalogue-playground/patient_predictive" #$2
PSEUDO_TABLE="/home/houfek/Work/MMCI/data-catalogue-playground/pseudonimisation_table/" #$3
#BH_SERVER_TRANSFER="sequencing@bridgehead01.int.mou.cz:/home/mou/patient_data/"
SC_FOLDER="/home/houfek/Work/MMCI/data-catalogue-playground/muni-sc/MiSEQ"


#pull image
#rsync -vdru --min-size=350 $BH_SERVER $FULL_EXPORT
#filter
#grep -lEir $FULL_EXPORT -e 'predictive_number="[0-9]{4}/[0-9]{1,4}"' | xargs cp -t $PREDICTIVE_EXPORT
#remove duplicates
#fdupes -dN $PREDICTIVE_EXPORT

for f in $FILES; do
    echo $f
    bash /home/houfek/Work/MMCI/data-catalogue-pseudonymisation/MiSEQ/pseudonymization/remove_files.sh $f
    python /home/houfek/Work/MMCI/data-catalogue-pseudonymisation/MiSEQ/pseudonymization/pseudonymization.py -r $f -e $PREDICTIVE_EXPORT -p $PSEUDO_TABLE 
    bash  /home/houfek/Work/MMCI/data-catalogue-pseudonymisation/MiSEQ/pseudonymization/replace_predictive.sh "${PSEUDO_TABLE}predictive.json.temp" $f
    rm "${PSEUDO_TABLE}predictive.json.temp"
    mv $f "${SC_FOLDER}/."
done
