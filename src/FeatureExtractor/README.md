# Radiomics feature extractor
Radiomics feature extraction code for manuscript: Towards Reliable Head and Neck Cancers Locoregional Recurrence Prediction using Delta-radiomics and Learning with Rejection Option. Our implementation is based on https://github.com/mvallieres/radiomics which is the feature extractor for :

[1] Vallière, M. et al. (2017). Radiomics strategies for risk assessment of tumour failure in head-and-neck cancer. Scientific Reports, 7:10117. doi:10.1038/s41598-017-10371-5 

These four .m files are for radiomcis feature (including intensity, geometry and texture feature) extraction for pre- and post- treatment CT and PET, respectively. The extracted features and the corresponding feature names are saved in our data folder.

Dicom data including PET, CT and RT structure files should be converted to .mat file before using the feature extraction code. Please refer to this github repo for DICOM-RT to Matlab conversion https://github.com/ulrikls/dicomrt2matlab.