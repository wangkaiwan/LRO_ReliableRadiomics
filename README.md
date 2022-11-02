# LRO_ReliableRadiomics
Implementation for manuscript: [**Towards Reliable Head and Neck Cancers Locoregional Recurrence Prediction using Delta-radiomics and Learning with Rejection Option**](https://arxiv.org/abs/2208.14452).

## Description
A reliable locoregional recurrence (LRR) prediction model is important for the personalized management of head and neck cancers (HNC) patients who received radiotherapy. This work aims to develop a delta-radiomics feature-based multi-classifier, multi-objective, and multi-modality (Delta-mCOM) model for post-treatment HNC LRR prediction. Furthermore, we aim to adopt a learning with rejection option (LRO) strategy to boost the reliability of Delta-mCOM model by rejecting prediction for samples with high prediction uncertainties. According to our retrospective study which collected PET/CT image and clinical data from 224 HNC patients who received radiotherapy (RT) at our institution, the inclusion of the delta-radiomics feature improved the accuracy of HNC LRR prediction, and the proposed Delta-mCOM model can give more reliable predictions by rejecting predictions for samples of high uncertainty using the LRO strategy.

In this repo, we shared the extracted radiomics features and collected clinical feature needed to generate the reported results in our mansucripts in the **data** folder. Feature extraction, model construction, uncertainty estimation, and prediction with rejection codes are shared in the **src** folder.


## Step by step
1. Download/collect CT data and corresponding GTV contour.
2. Data preprocessing and feature extraction.
3. Feature pre-selection, delta-radiomics feature calculation.
4. Radiomics model construction.
5. Epistemic uncertainty and aleatoric uncertainty estimation.
6. Sample rejection and model performance re-evaluation.


## Authors
```yaml
Kai Wang (wangkaiwan), Jing Wang
```
## Citation

If you find our work useful in your research, please cite:

```latex
@article{wang2022towards,
  title={Towards reliable head and neck cancers locoregional recurrence prediction using delta-radiomics and learning with rejection option},
  author={Wang, Kai and Dohopolski, Michael and Zhang, Qiongwen and Sher, David and Wang, Jing},
  journal={arXiv preprint arXiv:2208.14452},
  year={2022}
}
```
