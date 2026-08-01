from rdkit.Chem import Descriptors

def calc_descriptors(mol):
    """
    Calculate six 2D molecular descriptors from an RDKit molecule.

    Returns:
        [MolWt, LogP, HDonors, HAcceptors, TPSA, RotBonds]
    """

    if mol is None:
        return [None] * 6

    return [
        Descriptors.MolWt(mol),
        Descriptors.MolLogP(mol),
        Descriptors.NumHDonors(mol),
        Descriptors.NumHAcceptors(mol),
        Descriptors.TPSA(mol),
        Descriptors.NumRotatableBonds(mol)
        ]
