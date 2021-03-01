#!/bin/bash

BIDS_dir="/blue/stevenweisberg/share/ai_catalyst_silcton"
source_dir="${BIDS_dir}/sourcedata/rawT1"

# loops through subjects
for SUB in {1001..1100}
do
  # if the subject number has a defaced brain associated with it
  if [ -f $source_dir/${SUB}brain.nii ]; then
    old_name="${SUB}brain.nii"
    new_name="sub-${SUB}_ses-01_T1w.nii"
  elif [ -f $source_dir/${SUB}_mprage.nii.gz ]; then
    old_name="${SUB}_mprage.nii.gz"
    new_name="sub-${SUB}_ses-01_T1w.nii.gz"
  elif [ -f $source_dir/${SUB}_mprage.nii ]; then
    old_name="${SUB}_mprage.nii"
    new_name="sub-${SUB}_ses-01_T1w.nii"
  else
    echo "No data found for $SUB"
    continue
  fi

  # Set a BIDS-specific subject directory
  subj_dir=$BIDS_dir/"sub-${SUB}/ses-01/anat"
  rm -r $subj_dir
  mkdir -p $subj_dir
  # Copy the file over in BIDS naming convention
  cp $source_dir/$old_name $subj_dir/$new_name

  # Add a line to the participants.tsv file
  echo "sub-${SUB}" >> $BIDS_dir/participants.tsv
  echo "${SUB}"

done
