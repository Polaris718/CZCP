# Paper Experiment Reproduction TODO

This document records the current MATLAB project status and remaining tasks for reproducing the CZCP-SM training-sequence paper.

## Completed Work

- Section II-A correlation functions: aperiodic correlation, cyclic correlation, autocorrelation, and cross-correlation.
- Section II-B basic construction utilities for GBF, GCP, and q-ary complex exponential sequences.
- Section III CZCP definitions, properties, examples, perfect CZCP construction, and CZCS verification.
- Section IV training matrix framework: `X`, Gram matrix `X' * X`, and theoretical LS-MSE.
- Section IV comparison plotting script: `plot_section4_comparison.m`.
- Fig. 6 style reproduction script: `reproduce_fig6.m`.
- Monte Carlo random-channel LS verification script: `monte_carlo_channel_simulation.m`.
- Full experiment runner: `run_all_paper_experiments.m`.

## Core Files

### Sequence Construction and Verification

- `q_ray_czcp.m`: constructs perfect q-ary CZCPs from GBFs.
- `generate_czcp_set.m`: implements the paper formula-based construction from a GCP.
- `verify_perfect_czcp.m`: verifies perfect CZCP C1/C2 conditions.
- `czcs_from_czcp.m`: constructs CZCSs from CZCPs.
- `verify_czcs.m`: verifies CZCS conditions.
- `example6.m`: verifies q-ary CZCP construction.
- `definite6.m`: verifies CZCS construction.

### Section IV Training Matrix and MSE

- `build_circular_toeplitz.m`: builds a circular Toeplitz matrix from one antenna training sequence.
- `build_training_matrix.m`: concatenates Toeplitz blocks into the full training matrix `X`.
- `build_czcp_sm_training.m`: builds sparse SM training matrices from a CZCP.
- `build_random_sm_training.m`: builds a same-support random q-PSK baseline.
- `training_mse_metrics.m`: computes `X' * X`, optimality errors, normalized MSE, and the theoretical lower bound.
- `main_section4_experiment.m`: main Section IV experiment script.
- `plot_section4_comparison.m`: plots CZCP versus random training comparisons.

### Fig. 6 Reproduction

- `reproduce_fig6.m`: generates Fig. 6(a) and Fig. 6(b) style comparison plots.

Expected outputs:

- `fig6_reproduction_results.mat`
- `fig6_reproduction_both.png`
- `fig6a_reproduction.png`
- `fig6b_reproduction.png`

## Experiment Logic

The overall workflow is:

```text
training sequences
    -> sparse training matrix Omega
    -> channel training matrix X
    -> Gram matrix X' * X
    -> comparison with E * I
    -> LS-MSE = sigma2 * trace(inv(X' * X)) / number_of_parameters
    -> MSE-SNR or MSE-path-number curves
```

If `X' * X` is close to `E * I`, the training matrix is nearly orthogonal and the LS channel-estimation MSE is low. The CZCP objective is to reach:

```matlab
MSE_min = noise_var / E
```

## Current Fig. 6 Settings

### Fig. 6(a)

- `Nt = 4`
- path number `5`
- `J = [2, 6, 18]`
- Table I perfect binary `(8,4)-CZCP`
- curves: CZCP, random sparse training, and theoretical minimum MSE

Output:

- `fig6a_reproduction.png`

### Fig. 6(b)

- `Nt = 4`
- `EbNo = 16 dB`
- training energy normalized to `E = 32`
- path-number range `3:13`

Current curves:

- CZCP
- GCP
- m-sequence
- Barker
- Gold
- Zadoff-Chu
- Random
- Minimum MSE

Output:

- `fig6b_reproduction.png`

Note: the CAN curve is omitted because the authors' official CAN coefficients or Fig. 6 code were not available. This avoids including a non-official CAN substitute in the performance analysis.

## Completed Updates

### Full Runner

Run:

```matlab
run_all_paper_experiments
```

The script executes all main experiments, checks outputs, preserves figure windows, and reopens the main PNG outputs at the end.

### Output Filenames

The current scripts generate English-named image files:

- `section4_mse_comparison.png`
- `section4_gram_error_comparison.png`
- `fig6_reproduction_both.png`
- `fig6a_reproduction.png`
- `fig6b_reproduction.png`
- `monte_carlo_channel_mse.png`

Older Chinese-named PNG files may still remain from previous runs.

### CAN/Gold Comparison

- Gold sequence training is included.
- The non-official CAN substitute curve has been removed.
- The current Fig. 6(b) does not contain a CAN curve.
- If official CAN coefficients become available later, the official CAN curve can be added separately.

### Barker Baseline

- Barker now uses the paper-described `4 x 104` sparse training structure.
- The energy is normalized to `E = 32`.

### Monte Carlo Channel Simulation

The script `monte_carlo_channel_simulation.m` compares theoretical LS-MSE and empirical Monte Carlo MSE for CZCP and random training.

Outputs:

- `monte_carlo_channel_results.mat`
- `monte_carlo_channel_mse.png`

## Remaining Work

1. Compare the Fig. 6(a) and Fig. 6(b) axis ranges and units against the original paper figure.
2. Add the official CAN curve only if the authors' CAN coefficients or official Fig. 6 code become available.
3. Clearly state in any final report that Fig. 6(b) does not include the CAN curve because official CAN parameters are unavailable.

## Local Verification Record

Command:

```powershell
matlab -batch "run_all_paper_experiments"
```

Run result:

- `example6`: PASS.
- `definite6`: PASS.
- `main_section4_experiment`: PASS.
- `plot_section4_comparison`: PASS.
- `reproduce_fig6`: PASS.
- `monte_carlo_channel_simulation`: PASS.

Key values:

- CZCP Gram maximum error: `1.42e-15`.
- Random Gram maximum error: `8.94e+00`.
- Per-transmit-antenna training energy: `E = 32`.
- At SNR = 0 dB, CZCP MSE and Bound are both `3.1250e-02`.
- At SNR = 30 dB, CZCP MSE and Bound are both `3.1250e-05`.
- At SNR = 0 dB, CZCP Monte Carlo empirical/theory values are `3.1176e-02 / 3.1250e-02`.
- At SNR = 30 dB, CZCP Monte Carlo empirical/theory values are `3.1515e-05 / 3.1250e-05`.
