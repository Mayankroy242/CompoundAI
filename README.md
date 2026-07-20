# CompoundAI

CompoundAI is an open-source cheminformatics toolkit for automating the generation of QSAR-ready compound libraries from PubChem.

## Version

Current Version: **v0.1**

---

## Project Goal

Manual retrieval of molecular information from PubChem is time-consuming and error-prone.

CompoundAI automates this process by converting a list of PubChem Compound IDs (CIDs) into a structured QSAR-ready dataset.

---

## Input

A text file containing PubChem Compound IDs.

Example:

CID
5280343
5280863
5280443
5280445

---

## Output

Compound_Library.csv containing:

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

Compound List

↓

CompoundAI

↓

PubChem REST API

↓

Compound Library

↓

QSAR-ready Dataset

---

## Future Roadmap

Version 0.2
- GC-MS PDF support

Version 0.3
- LC-MS PDF support

Version 0.4
- Automatic PubChem CID detection

Version 0.5
- RDKit Descriptor Calculation

Version 0.6
- QSAR Dataset Builder

Version 1.0
- AI-assisted Drug Discovery Platform

---

## Author

Dr. Mayank Roy Chowdhury
