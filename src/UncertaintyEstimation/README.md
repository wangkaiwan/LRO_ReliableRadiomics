# LRO_ReliabelRadiomics
Code implementation for manuscript: Towards Reliable Head and Neck Cancers Locoregional Recurrence Prediction using Delta-radiomics and Learning with Rejection Option.

Full version will be available once this work was accepted for publish.

## step by step:
1. Download the extracted features (You can also extract features with other dataset using our **FeatureExtractor** code).
2. Feature pre-selection, delta-radiomics feature calculation.
3. Radiomics model construction (Step 2 and 3 are combined in **ModelConstruction**).
4. Epistemic uncertainty and aleatoric uncertainty estimation.
5. Sample rejection and model performance re-evaluation.
