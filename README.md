# Bayes Card-Suit Classifier

Optimal Bayes classifiers for card-suit recognition from Hu moment invariants, comparing three
probability-density estimators (independent-feature Gaussian, multivariate Gaussian, Parzen window)
against a 1-NN baseline. Written for EPART Lab 2 ("Optimal Bayes Classification"), implemented in
MATLAB (Octave-compatible).

## Overview

Each training/test sample is a feature vector of 7 [Hu moment invariants](https://en.wikipedia.org/wiki/Image_moment)
computed from scanned images of playing-card suits (clubs, diamonds, hearts, spades), printed with two
different methods (with/without halftone raster). The task is to:

1. Clean the training set of corrupted/outlier samples.
2. Pick a pair of features that separates the classes well.
3. Build and compare three Bayes density estimators on that feature pair.
4. Study how training-set size and Parzen window width affect accuracy.
5. Study the effect of asymmetric class priors.
6. Compare against a 1-NN classifier, with and without feature normalization.

Full methodology, numbers, and discussion are in [`report/report.pdf`](report/report.pdf)
(source: [`report/report.tex`](report/report.tex)).

### Headline results

| Classifier | Test error (full train set, selected features) |
|---|---|
| Independent-Gaussian (`pdf_indep`) | 2.63% |
| Multivariate-Gaussian (`pdf_multi`) | **0.49%** |
| Parzen window (`pdf_parzen`, h₁=0.001) | 2.41% |
| 1-NN, raw features | 1.75% |
| 1-NN, normalized features | 0.49% |

See the report for the training-set-size ablation, the Parzen-width sweep, and the asymmetric-prior
experiment.

## Repository structure

```
.
├── mainscript.m              # main experiment script — run this
├── bayescls.m                 # generic Bayes classifier (pdf + priors -> decision)
├── cls1nn.m                   # 1-nearest-neighbour classifier
├── load_cardsuits_data.m      # loads train.txt/test.txt, remaps labels 1-4 -> 1-8
├── reduce.m                   # randomly subsamples a dataset per-class
├── plot2features.m            # scatter-plots two features, one marker per class
├── para_indep.m / pdf_indep.m     # independent-feature Gaussian density
├── para_multi.m / pdf_multi.m     # multivariate Gaussian density
├── para_parzen.m / pdf_parzen.m   # Parzen-window density estimate
├── normpdf.m / mvnpdf.m       # local Gaussian pdf implementations (no toolbox required)
├── rows.m / columns.m         # small Octave-compatibility shims (MATLAB has no rows()/columns())
├── pdf_test.txt               # tiny synthetic 2-class/2-feature set used to sanity-check the pdf_* functions
└── report/
    ├── report.tex             # report source (LaTeX)
    ├── report.pdf             # compiled report
    └── fig_*.png              # figures referenced by the report
```

`train.txt` and `test.txt` (the real card-suit data, one sample per row: `label, Hu1, ..., Hu7`) are
**not included** in this repository at the original course's request — see [Data](#data) below.

## Getting started

Requires MATLAB (tested on R2025a) or GNU Octave. No toolboxes are required — `normpdf.m` and
`mvnpdf.m` are self-contained local implementations.

```matlab
% from inside the repo folder
mainscript
```

`mainscript.m` walks through: verifying the three `pdf_*` functions against `pdf_test.txt`, loading
and cleaning the card-suit data, selecting features, and running all of the experiments described in
the report.

### Data

This repo ships only the small `pdf_test.txt` verification fixture. To reproduce the card-suit
experiments, supply your own `train.txt` / `test.txt` in the repo root, each a whitespace-separated
matrix with the class label (1-4) in column 1 and 7 Hu moments in columns 2-8;
`load_cardsuits_data.m` remaps labels 1-4 to 1-8 for samples 77-152 of every 152-row block, to
distinguish the two printing methods.

## License

[MIT](LICENSE)
