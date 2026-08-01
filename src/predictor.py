"""
Predictor module for CompoundAI.

This module will load the trained QSAR model
and predict the activity of new compounds.
"""

import pickle
from pathlib import Path
import pandas as pd

from rdkit import Chem

from descriptor_generator import calc_descriptors

def load_model(model_path: Path):
    """
    Load a trained QSAR model from a pickle file.
    """

    with model_path.open("rb") as file:
        model = pickle.load(file)

    return model


if __name__ == "__main__":
    model_path = Path("models/Alzheimer/AChE/model.pkl")
    model = load_model(model_path)
    
    scaler = load_model(Path("models/Alzheimer/AChE/scaler.pkl"))

    top_features = load_model(Path("models/Alzheimer/AChE/top_features.pkl"))

    print("Model loaded successfully!")
    print(type(model))
    print(type(scaler))
    print(top_features)

    compound_df = pd.read_csv("output/Compound_Library.csv")

    print("\nCompounds loaded successfully!")
    print(compound_df.head())
    compound_df["Mol"] = compound_df["Canonical_SMILES"].apply(Chem.MolFromSmiles)

    print("\nRDKit molecules created successfully!")
    print(compound_df[["Compound_Name", "Mol"]].head())
    compound_df["Descriptors"] = compound_df["Mol"].apply(calc_descriptors)

    print("\nDescriptors calculated successfully!")
    print(compound_df[["Compound_Name", "Descriptors"]].head())

    descriptor_df = pd.DataFrame(
        compound_df["Descriptors"].tolist(),
        columns=[
            "MolWt",
            "LogP",
            "HDonors",
            "HAcceptors",
            "TPSA",
            "RotBonds",
        ],
    )

    print("\nDescriptor DataFrame")
    print(descriptor_df.head())

    descriptor_df = descriptor_df[top_features]

    print("\nReordered Descriptor DataFrame")
    print(descriptor_df.head())

    scaled_descriptors = scaler.transform(descriptor_df)

    print("\nScaled Descriptors")
    print(scaled_descriptors[:5])

    predictions = model.predict(scaled_descriptors)

    compound_df["Prediction"] = predictions

    print("\nPrediction Results")
    print(compound_df[["Compound_Name", "Prediction"]].head(10))
