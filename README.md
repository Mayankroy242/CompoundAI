# 🧬 CompoundAI

**Current Version: v0.2**

CompoundAI is an open-source computational drug discovery framework designed to automate compound retrieval, molecular descriptor generation, QSAR preprocessing, machine-learning model development, model selection, and activity prediction.

**CompoundAI v0.2** introduces the first working end-to-end QSAR inference architecture, with **acetylcholinesterase (AChE)** as the initial implemented therapeutic target.

> **Development Status:** CompoundAI is under active development. Version 0.2 is a functional backend and educational release designed to expose the individual stages of a computational QSAR and machine-learning workflow.

---

# 🚀 What's New in v0.2

CompoundAI has evolved beyond its original Bash-based PubChem compound retrieval system.

Version 0.2 currently supports:

- Compound input using PubChem CIDs and compound names
- Automated PubChem REST API retrieval
- Automatic resolution of compound names to PubChem CIDs
- Duplicate compound handling
- Generation of a structured compound library
- Canonical SMILES retrieval
- RDKit molecular structure parsing
- Automated molecular descriptor calculation
- QSAR feature preparation
- Model-specific feature ordering
- Preprocessing using the scaler generated during model development
- Evaluation of five machine-learning algorithms during model development
- Selection of the best-performing model using held-out/external test data
- Loading of the exported best-performing ML model
- Batch prediction of previously unseen compounds
- Initial AChE activity-prediction module for Alzheimer's disease research
- Reproducible Conda environment

---

# 🧠 CompoundAI Architecture

CompoundAI separates **model development** from **prediction/inference**.

This ensures that trained models are developed and evaluated independently before being deployed for screening new compounds.

```text
                    COMPOUNDAI
                         │
          ┌──────────────┴──────────────┐
          │                             │
          ▼                             ▼
   MODEL DEVELOPMENT              USER INFERENCE
          │                             │
          │                       Compound List
          │                       CID / Name
          │                             │
          ▼                             ▼
    QSAR Dataset                  PubChem Retrieval
          │                             │
          ▼                             ▼
 Descriptor Generation          Compound Library
          │                             │
          ▼                             ▼
 Feature Preparation            RDKit Parsing
          │                             │
          ▼                             ▼
     Five ML Models              Descriptor Generation
          │                             │
          ▼                             ▼
 Model Training                 Feature Alignment
          │                             │
          ▼                             ▼
 External/Test Evaluation        Saved Scaler
          │                             │
          ▼                             │
 Best Model Selection                   │
          │                             │
          └──────────► Exported Model ◄─┘
                              │
                              ▼
                       Activity Prediction
```

---

# 🤖 Machine-Learning Model Selection

CompoundAI does **not** rely on an arbitrarily pre-selected machine-learning algorithm.

During the current AChE QSAR model-development workflow, **five supervised machine-learning algorithms** are evaluated:

1. Logistic Regression
2. Random Forest
3. Support Vector Machine (SVM)
4. Gradient Boosting
5. K-Nearest Neighbors (KNN)

The general model-selection workflow is:

```text
Prepared QSAR Dataset
        │
        ▼
Training Dataset
        │
        ├──────── Logistic Regression
        │
        ├──────── Random Forest
        │
        ├──────── Support Vector Machine
        │
        ├──────── Gradient Boosting
        │
        └──────── K-Nearest Neighbors
                         │
                         ▼
               Model Performance
                         │
                         ▼
              Held-Out/External
                Test Evaluation
                         │
                         ▼
                Model Comparison
                         │
                         ▼
              Best Model Selection
                         │
                         ▼
                 Exported Model
```

This architecture allows the prediction engine to use the model identified as the best-performing candidate during model development rather than hard-coding a particular ML algorithm as the universal predictor.

---

# 🎯 Current AChE Model

### Disease Area

**Alzheimer's Disease**

### Therapeutic Target

**Acetylcholinesterase (AChE)**

For the current AChE implementation, **Random Forest was identified as the best-performing model on the held-out/external test dataset and was therefore exported for prediction of new compounds.**

The deployed model is stored at:

```text
models/Alzheimer/AChE/model.pkl
```

The associated preprocessing components are stored alongside the model:

```text
models/Alzheimer/AChE/
│
├── model.pkl
├── scaler.pkl
├── top_features.pkl
└── config.json
```

These files allow the inference pipeline to reproduce the feature preparation used during model development.

The prediction pipeline therefore does **not retrain the model every time a user screens compounds**.

Instead, it loads the previously selected model and its preprocessing components and applies them to new molecules.

---

# 📊 Model Evaluation

The model-development workflow evaluates candidate ML algorithms before selecting a model for deployment.

The next reporting layer of CompoundAI is being developed to automatically preserve and report the complete evidence underlying model selection, including:

- Accuracy
- Precision
- Recall
- F1-score
- ROC-AUC
- Cross-validation performance
- Confusion matrix
- ROC curve
- Precision–Recall curve
- Feature importance
- Model-comparison tables
- Best-model selection rationale

These results will be exported with each target-specific model so that future CompoundAI reports can explain not only **what model generated a prediction**, but also **why that model was selected**.

---

# 🔬 Current End-User Workflow

CompoundAI v0.2 intentionally retains a transparent **two-step backend workflow**.

This is particularly useful for students and researchers who want to understand the individual stages involved in computational QSAR prediction.

```text
data/compound_list.txt
        │
        ▼
scripts/compoundai.sh
        │
        ▼
PubChem REST API
        │
        ▼
output/Compound_Library.csv
        │
        ▼
src/predictor.py
        │
        ▼
RDKit Descriptors
        │
        ▼
Feature Alignment
        │
        ▼
Scaling
        │
        ▼
Exported AChE Model
        │
        ▼
Activity Prediction
```

Future production releases will progressively automate these stages into a simplified user-facing interface while retaining the transparent backend architecture for research and teaching.

---

# 💻 Installation

## 1. Clone CompoundAI

```bash
git clone https://github.com/Mayankroy242/CompoundAI.git
cd CompoundAI
```

---

## 2. Install System Requirements

For Ubuntu/WSL:

```bash
sudo apt update
sudo apt install git curl
```

An active internet connection is required for PubChem retrieval.

---

## 3. Create the CompoundAI Conda Environment

CompoundAI v0.2 provides a reproducible Conda environment.

Run:

```bash
conda env create -f environment.yml
```

Activate the environment:

```bash
conda activate compoundai
```

The current environment includes:

- Python 3.12
- RDKit
- pandas
- NumPy
- scikit-learn
- Matplotlib
- Jupyter Notebook
- IPython kernel

---

# 🧪 Input

The user provides compounds through:

```text
data/compound_list.txt
```

CompoundAI accepts both:

- PubChem CIDs
- Compound names

Example:

```text
Compound
2353
5280343
Apigenin
Curcumin
Berberine
```

Therefore, users do not need to manually retrieve the PubChem CID for every compound before using CompoundAI.

---

# ♻️ Duplicate Handling

CompoundAI performs duplicate handling at multiple stages.

Identical entries in the input are filtered before PubChem retrieval.

In addition, different input representations that resolve to the same PubChem CID can be recognized during compound processing.

For example:

```text
5280443
Apigenin
```

both represent the same PubChem compound.

This helps prevent duplicate molecules from unnecessarily entering the downstream QSAR workflow.

---

# 🧪 Step 1 — Generate the Compound Library

From the CompoundAI root directory:

```bash
bash scripts/compoundai.sh
```

The Bash pipeline:

1. Reads the user's compound list
2. Checks the input file
3. Handles Windows/Linux line endings
4. Checks PubChem connectivity
5. Resolves compound names to PubChem CIDs
6. Retrieves molecular information
7. Handles duplicate compounds
8. Generates the compound library

The resulting file is:

```text
output/Compound_Library.csv
```

The current compound library contains:

- PubChem CID
- Compound Name
- Molecular Formula
- Molecular Weight
- Canonical SMILES

The script is designed using project-relative path detection so that it can locate the CompoundAI project structure independently of the user's current working directory.

---

# 🧠 Step 2 — Run AChE QSAR Prediction

From the CompoundAI project directory:

```bash
python src/predictor.py
```

The predictor performs the following operations:

```text
Load AChE Model
        │
        ▼
Load Saved Scaler
        │
        ▼
Load Selected Feature Order
        │
        ▼
Read Compound_Library.csv
        │
        ▼
Canonical SMILES
        │
        ▼
RDKit Molecular Objects
        │
        ▼
Calculate Molecular Descriptors
        │
        ▼
Create Descriptor DataFrame
        │
        ▼
Reorder Features
        │
        ▼
Apply Saved StandardScaler
        │
        ▼
Random Forest Prediction
        │
        ▼
Active / Inactive Classification
```

The terminal currently displays a preview of the prediction results.

The complete reporting and export layer is under development.

---

# 🧮 Molecular Descriptors

The current AChE prediction model uses six RDKit molecular descriptors:

| Descriptor | Description |
|---|---|
| MolWt | Molecular Weight |
| LogP | Octanol/water partition coefficient |
| TPSA | Topological Polar Surface Area |
| RotBonds | Number of rotatable bonds |
| HAcceptors | Hydrogen-bond acceptors |
| HDonors | Hydrogen-bond donors |

Descriptors are initially generated by RDKit and then reordered according to the feature configuration stored during model development.

For the current AChE model, the deployed feature order is:

```text
LogP
MolWt
TPSA
RotBonds
HAcceptors
HDonors
```

The saved scaler is subsequently applied before model inference.

---

# 📁 Project Structure

```text
CompoundAI/
│
├── config/
│
├── data/
│   ├── compound_list.txt
│   └── qsar_ready_final_ACHE.csv
│
├── docs/
│
├── models/
│   └── Alzheimer/
│       └── AChE/
│           ├── config.json
│           ├── model.pkl
│           ├── scaler.pkl
│           └── top_features.pkl
│
├── output/
│   └── Compound_Library.csv
│
├── scripts/
│   └── compoundai.sh
│
├── src/
│   ├── descriptor_generator.py
│   └── predictor.py
│
├── train_models/
│   ├── ACHE/
│   └── train_AChE_QSAR.ipynb
│
├── environment.yml
├── LICENSE
└── README.md
```

---

# 🎓 Educational Use

CompoundAI v0.2 deliberately exposes intermediate stages such as:

- Compound retrieval
- Molecular representation
- Descriptor generation
- Feature ordering
- Feature scaling
- Model loading
- Prediction

This makes the current release suitable for demonstrating the backend architecture of a QSAR/ML pipeline to students.

A future production interface will simplify these operations for users who only require final predictions.

---

# 🗺️ Development Roadmap

## v0.3 — Model Evidence & Prediction Reporting

The next development phase will focus on automatically exporting the evidence associated with model development and prediction.

Planned additions include:

- Five-model comparison report
- Automatic best-model identification
- Confusion matrix
- ROC curve
- ROC-AUC
- Precision–Recall analysis
- Accuracy
- Precision
- Recall
- F1-score
- Cross-validation statistics
- Feature importance
- Prediction probability
- Prediction confidence
- Complete screening-result CSV export

Target-specific model directories are planned to contain artifacts such as:

```text
models/Alzheimer/AChE/
│
├── model.pkl
├── scaler.pkl
├── top_features.pkl
├── config.json
├── model_info.json
├── model_comparison.csv
├── confusion_matrix.png
├── roc_curve.png
└── feature_importance.png
```

---

# 📄 Scientific Reporting Layer

A future CompoundAI reporting layer is planned to generate comprehensive reports containing results for **all screened compounds**, even when only a preview is displayed in the terminal.

Planned report components include:

```text
CompoundAI Screening Report
│
├── Screening Summary
├── Target Information
├── Model Information
├── Model Selection Evidence
├── Model Performance
├── Confusion Matrix
├── ROC Curve
├── Feature Importance
│
├── Compound 1
│   ├── CID
│   ├── Compound Name
│   ├── Molecular Structure
│   ├── Prediction
│   ├── Probability
│   ├── Confidence
│   └── Molecular Descriptors
│
├── Compound 2
│
├── ...
│
└── Overall Screening Summary
```

Planned outputs include:

```text
output/
│
├── Prediction_Report.csv
├── Prediction_Report.pdf
├── figures/
└── molecular_structures/
```

---

# 🧬 Multi-Target Architecture

A major objective of CompoundAI is to avoid building a platform restricted to a single biological target.

The target-specific architecture is intended to support:

```text
models/
│
├── Alzheimer/
│   └── AChE/
│
├── Cancer/
│   ├── ESR1/
│   ├── PI3K/
│   ├── AKT/
│   └── MAPK/
│
└── Additional_Disease/
    └── Additional_Target/
```

Each target can ultimately maintain its own:

- Training dataset
- Model comparison
- Selected model
- Scaler
- Feature configuration
- Validation statistics
- Model-performance figures
- Prediction configuration

This will allow CompoundAI to evolve toward a modular multi-target computational drug-discovery platform.

---

# 🧠 Extended AI Architecture

In addition to conventional descriptor-based QSAR models, future development will investigate complementary AI approaches, including:

- Molecular embeddings
- Embedding-based vector regression
- Representation-learning approaches
- Deep-learning models
- Explainable AI
- Multi-target prediction
- Interactive dashboards

The objective is not necessarily to replace classical QSAR models, but to allow multiple computational representations to complement one another depending on the therapeutic discovery problem.

---

# 🐍 Protein and Peptide Therapeutic Extension

The modular CompoundAI architecture is also intended to explore applications beyond conventional small molecules.

Future research will investigate the use of:

- Protein sequence embeddings
- Structural embeddings
- Protein representation learning
- Therapeutic protein/peptide prioritization
- Venom-derived bioactive proteins and peptides

Such functionality could operate as an additional CompoundAI module or as a complementary therapeutic-discovery workflow alongside small-molecule prediction.

---

# 🔄 Future User Experience

The current v0.2 workflow intentionally exposes the backend:

```bash
bash scripts/compoundai.sh
python src/predictor.py
```

Future production releases are intended to simplify this to a unified interface conceptually similar to:

```bash
compoundai predict --target ACHE --input compounds.txt
```

with CompoundAI internally handling:

```text
Input
  ↓
Compound Retrieval
  ↓
Descriptor Generation
  ↓
Target Model Selection
  ↓
Preprocessing
  ↓
Prediction
  ↓
Confidence Estimation
  ↓
Visualization
  ↓
Scientific Report
```

---

# 🔁 Reproducibility

CompoundAI v0.2 includes:

```text
environment.yml
```

A new environment can be generated using:

```bash
conda env create -f environment.yml
conda activate compoundai
```

The v0.2 workflow has been tested in a freshly generated Conda environment, including:

- RDKit import
- pandas import
- NumPy import
- scikit-learn import
- Saved model loading
- Compound-library generation
- Descriptor generation
- Scaling
- End-to-end AChE prediction

---

# ⚠️ Research Use Notice

CompoundAI is currently a research and educational software project under active development.

Predictions generated by CompoundAI are **computational estimates**.

Predicted activity should not be interpreted as:

- Experimental validation
- Clinical evidence
- Medical advice
- Proof of therapeutic efficacy

Computational predictions should be independently validated using appropriate experimental methods.

---

# 📜 License

CompoundAI is distributed under the **MIT License**.

See:

```text
LICENSE
```

for details.

---

# 👨‍💻 Author

**Dr. Mayank Roy Chowdhury**

Assistant Professor (Bioinformatics)

Lead Developer, CompoundAI

### Connect with Me

- GitHub: https://github.com/Mayankroy242
- LinkedIn: https://www.linkedin.com/in/dr-mayank-roy-chowdhury-1b58b911b/
- Google Scholar: https://scholar.google.com/citations?user=eDXvgCQAAAAJ&hl=en

---

# Acknowledgements

CompoundAI is also supported by:

**Sriparna Roy**

Ph.D., Indian Institute of Technology Delhi

Project Lead

**Email:** Sriparna.Roy@civil.iitd.ac.in

---

## CompoundAI v0.2

**From compound retrieval to machine-learning-based activity prediction.**

More models, automated model evaluation, scientific reporting, and extended AI architectures are under active development.
