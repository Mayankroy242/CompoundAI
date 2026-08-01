#!/bin/bash

###############################################
# CompoundAI v0.1
# Author: Mayank Roy Chowdhury
# Description:
# Generates a QSAR-ready dataset from
# PubChem Compound IDs.
###############################################

echo "========================================"
echo "         CompoundAI v0.2"
echo "========================================"
echo

# Locate CompoundAI project directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"

# Define input and output files
INPUT="$BASE_DIR/data/compound_list.txt"
OUTPUT="$BASE_DIR/output/Compound_Library.csv"

# Create output directory if it does not exist
mkdir -p "$BASE_DIR/output"

# Check whether curl is installed
if ! command -v curl >/dev/null 2>&1
then
    echo "Error: curl is not installed."
    echo "Please install curl and try again."
    exit 1
fi

echo "Starting CompoundAI..."
echo

echo "Input file : $INPUT"
echo "Output file: $OUTPUT"
echo

# Check whether input file exists
if [ ! -f "$INPUT" ]; then
    echo "Error: Input file not found!"
    exit 1
fi

echo "Input file found."
echo

# Convert Windows line endings to Linux
echo "Checking input file format..."
echo "Converting Windows line endings (if required)..."

sed -i 's/\r$//' "$INPUT"

echo "Input file format verified."
echo

# Create QSAR-ready dataset
echo "Creating QSAR-ready dataset..."

echo "CID,Compound_Name,Molecular_Formula,Molecular_Weight,Canonical_SMILES" > "$OUTPUT"

echo "Dataset initialized."
echo

# Check PubChem connectivity
echo "Checking PubChem connectivity..."

if ! curl -Is https://pubchem.ncbi.nlm.nih.gov >/dev/null
then
    echo "Unable to connect to PubChem."
    exit 1
fi

echo "Connection successful."
echo

# Read unique compounds (CID or Name)
tail -n +2 "$INPUT" | sort | uniq | while IFS= read -r COMPOUND
do

    # Check if input is numeric (CID)
    if [[ "$COMPOUND" =~ ^[0-9]+$ ]]
    then
        CID="$COMPOUND"

    else
        echo "Searching PubChem for compound: $COMPOUND"

        CID=$(curl -fs \
"https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/name/$COMPOUND/cids/TXT" \
| head -n 1)

        if [ -z "$CID" ]
        then
            echo "Compound not found: $COMPOUND"
            continue
        fi
    fi

# Skip duplicate CIDs
if [[ -n "${processed_cids[$CID]}" ]]
then
    echo "Skipping duplicate compound: $COMPOUND (CID: $CID)"
    continue
fi

processed_cids[$CID]=1

    echo "Downloading compound: $CID"
    curl -fs \
"https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/$CID/property/Title,MolecularFormula,MolecularWeight,CanonicalSMILES/CSV" \
| tail -n +2 \
| while IFS= read -r line
do
    echo "$line"
done >> "$OUTPUT"

done

echo
echo "QSAR-ready dataset generated successfully."
echo "Output saved to: $OUTPUT"
echo
echo "Thank you for using CompoundAI."
