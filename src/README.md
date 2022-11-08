# LRO_ReliabelRadiomics: Code
Code implementation for manuscript: Towards Reliable Head and Neck Cancers Locoregional Recurrence Prediction using Delta-radiomics and Learning with Rejection Option.

## Step by step:
1. Download/collect CT data and corresponding GTV contour.
2. Data preprocessing and feature extraction.
3. Feature pre-selection, delta-radiomics feature calculation.
4. Radiomics model construction.
5. Epistemic uncertainty and aleatoric uncertainty estimation.
6. Sample rejection and model performance re-evaluation.

## Folders:
1. FeatureExtactor: Feature extraction code based on https://github.com/mvallieres/radiomics. The extracted PET CT features are provided in the data folder. Of note, an **Image Biomarker Standardization Initiative (IBSI)** compliant version of the feature extactor is available at https://github.com/mvallieres/radiomics-develop, please use the new version for better model generalizability and reproducibility.
2. ModelConstruction: Single-modality model construction codes, the generated model .mat files would be saved to the data folder. You can run code in **Fusion** folder to calcualted the multi-modality fusion model performance.
3. UncertaintyEstimation: Codes for aleatoric and epistemic uncertainty esitmation. Model .mat files generated from folder **ModelConstruction** are need to run codes in this folder.
4. PredictionWithRejection: Predict LR for HNC patients with rejection options. The rejection process can be based on either aleatoric uncertainty only, epistemic uncertainty only, or combination of these two uncertainty scores. Data for testing codes in this folder is provided in **data/PredictionWithRejectionResults**. 
