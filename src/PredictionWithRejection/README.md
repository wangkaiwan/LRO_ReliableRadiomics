# Reject prediction based on uncertainty scores
Code implementation of the prediction with rejection part described in manuscript: Towards Reliable Head and Neck Cancers Locoregional Recurrence Prediction using Delta-radiomics and Learning with Rejection Option. 

Data:
1) The **output probabilities** of validation and testing samples calculated from the **ModelConstruction** (5 times of 5-fold-CV).
2) The **epistemic uncertainty scores** for validation and testing samples: anamaly score from an Auto Encoder Style anomaly detection mdoel. Please find the codes for calcuation from **UncertaintyEstimation**.
3)  The **aleatoric  uncertainty scores** for validation and testing samples: entropy of mean class probabilities obtained from the augmented data. Please find the codes for calcuation from **UncertaintyEstimation**.

## scripts:
1. RejectOptionAccording_EpistemicUncertainty_Only: Reject prediction of testing samples based on epistemic uncertainty score.
2. RejectOptionAccording_AleatoricUncertainty_Only: Reject testing samples based on aleatoric uncertainty score.
3. RejectOptionAccording_AleatoricEpistemicUncertainty: Reject testing samples based on the combination of epistemic uncertainty and aleatoric uncertainty score.
4. RejectionMethodComparasion: plot ROC curves of different methods/results.

