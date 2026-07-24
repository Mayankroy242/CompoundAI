# CompoundAI

An open-source Bash toolkit for automating the generation of QSAR-ready compound libraries from PubChem.

---

## Version

Current Version: **v0.1**

---

## Project Goal

Manual retrieval of molecular information from PubChem is time-consuming and prone to errors.

CompoundAI automates this process by retrieving molecular properties from the PubChem REST API and generating a structured CSV file suitable for QSAR studies, cheminformatics, and computational drug discovery.

---

## Features

- Automated retrieval of molecular properties from PubChem
- Generates QSAR-ready CSV datasets
- Uses the PubChem REST API
- Removes duplicate Compound IDs (CIDs)
- Simple Bash-based workflow
- Open-source and lightweight

---

## Requirements

Before running CompoundAI, make sure you have:

- Ubuntu (or WSL Ubuntu on Windows)
- Bash Shell
- Git
- curl
- Internet connection

---

## Installation

Clone the repository from GitHub:

```bash
git clone https://github.com/Mayankroy242/CompoundAI.git
```

Move into the project directory:

```bash
cd CompoundAI
```

If Git or curl is not installed:

```bash
sudo apt update
sudo apt install git curl
```

---

## Input

CompoundAI accepts a text file containing PubChem Compound IDs (CIDs).

Example:

```
CID
5280343
5280863
5280443
5280445
```

---

## Running CompoundAI

Move to the scripts directory:

```bash
cd scripts
```

Run the program:

```bash
bash compoundai.sh
```

---

## Output

CompoundAI generates:

```
output/Compound_Library.csv
```

The output file contains:

- CID
- Compound Name
- Molecular Formula
- Molecular Weight
- Canonical SMILES
- Isomeric SMILES
- InChIKey
- XLogP
- TPSA
- Hydrogen Bond Donors
- Hydrogen Bond Acceptors
- Rotatable Bonds
- Exact Mass

---

## Workflow

```
PubChem Compound IDs
        │
        ▼
CompoundAI
        │
        ▼
PubChem REST API
        │
        ▼
Retrieve Molecular Properties
        │
        ▼
Compound_Library.csv
        │
        ▼
QSAR-ready Dataset
```

---

## Project Structure

```
CompoundAI/
│
├── data/
├── docs/
├── output/
├── scripts/
├── README.md
├── LICENSE
└── .gitignore
```

---

## Future Roadmap

### Version 0.2

- GC-MS PDF Support

### Version 0.3

- LC-MS PDF Support

### Version 0.4

- Automatic PubChem CID Detection

### Version 0.5

- RDKit Descriptor Calculation

### Version 0.6

- QSAR Dataset Builder

### Version 1.0

- AI-Assisted Drug Discovery Platform

---

## License

This project is distributed under the MIT License.

---

## Author

**Dr. Mayank Roy Chowdhury**

Assistant Professor (Bioinformatics)

Co-Founder & Chief Technology Officer (CTO), Singularity Life Sciences

Founder & Lead Developer, CompoundAI

### Connect with Me

- GitHub: https://github.com/Mayankroy242
- LinkedIn: https://www.linkedin.com/in/dr-mayank-roy-chowdhury-1b58b911b/
- Google Scholar: https://scholar.google.com/citations?user=eDXvgCQAAAAJ&hl=en

CEO $ Project lead 
"Sriparna Roy"
Phd, Indian Institute of Technology,Delhi
Sriparna.Roy@civil.iitd.ac.in
