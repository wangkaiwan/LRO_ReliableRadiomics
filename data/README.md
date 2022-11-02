# LRO_ReliabelRadiomics: Data
Data for generating the reported results and our final models described in manuscript: Towards Reliable Head and Neck Cancers Locoregional Recurrence Prediction using Delta-radiomics and Learning with Rejection Option.

## Folders:
1. Features: Deidentified patient locoreginal recurrence label, clinical data, and PET/CT pre- and post-treatment radiomics features. For feature extraction code, please check **src/FeatureExtractor**.
2. Models: Models including feature selection vector, classifier parameters and weights for clinical, PET, and CT modalities. We actually saved all the parameters and variables used/generated during model training process to model.mat files. Please run codes in different modality folders of **src/ModelConstruction** to generate them. Data in this folder is needed to run model fusion codes in **src/ModelConstruction/Fusion** and uncertainty score estimation codes in **src/UncertaintyEstimation**.
3. AleatoricUncertainty: Folder for saving the output from **src/UncertaintyEstimation/Aleatoric**.
4. EpistemicUncertainty: Folder for saving the output from **src/UncertaintyEstimation/Epistemic**.
5. PredictionWithRejectionResults: Data for repeating our resutls for the prediction with rejection option part described in our manuscript. All the needed data files are already in this folder, please run the codes in **src/PredictionWithRejection** to generate the figures and values reported in our manuscript. You can also replace the files with data generated from previous steps.
