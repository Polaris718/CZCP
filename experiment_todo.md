# training-sequence study Experiment implementation TODO

This document records the current MATLAB project status and remaining tasks for implementing the CZCP-SM training-sequence training-sequence study.

## Completed Work

- Section II-A correlation functions: aperiodic correlation, cyclic correlation, autocorrelation, and cross-correlation.
- Section II-B basic construction utilities for GBF, GCP, and q-ary complex exponential sequences.
- Section III CZCP definitions, properties, examples, perfect CZCP construction, and CZCS verification.
- Training matrix framework: `X`, Gram matrix `X' * X`, and theoretical LS-MSE.
- Training comparison plotting script: `plot_training_mse_comparison.m`.
- MSE comparison implementation script: `plot_training_mse_baselines.m`.
- Monte Carlo random-channel LS verification script: `monte_carlo_channel_simulation.m`.
- Full experiment runner: `run_all_experiments.m`.

## Core Files

### Sequence Construction and Verification

- `q_ray_czcp.m`: constructs perfect q-ary CZCPs from GBFs.
- `generate_czcp_set.m`: implements the construction-rule-based construction from a GCP.
- `verify_perfect_czcp.m`: verifies perfect CZCP C1/C2 conditions.
- `czcs_from_czcp.m`: constructs CZCSs from CZCPs.
- `verify_czcs.m`: verifies CZCS conditions.
- `verify_czcp_conditions.m`: verifies q-ary CZCP construction.
- `verify_czcs_construction.m`: verifies CZCS construction.

### Training Matrix and MSE

- `build_circular_toeplitz.m`: builds a circular Toeplitz matrix from one antenna training sequence.
- `build_training_matrix.m`: concatenates Toeplitz blocks into the full training matrix `X`.
- `build_czcp_sm_training.m`: builds sparse SM training matrices from a CZCP.
- `build_random_sm_training.m`: builds a same-support random q-PSK baseline.
- `training_mse_metrics.m`: computes `X' * X`, optimality errors, normalized MSE, and the theoretical lower bound.
- `run_training_mse_experiment.m`: main training experiment script.
- `plot_training_mse_comparison.m`: plots CZCP versus random training comparisons.

### MSE Comparison implementation

- `plot_training_mse_baselines.m`: generates MSE comparison plots.

Expected outputs:

- `mse_comparison_results.mat`
- `mse_comparison_both.png`
- `mse_vs_ebno.png`
- `mse_vs_paths.png`

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

## Current MSE Comparison Settings

### MSE versus EbNo

- `Nt = 4`
- path number `5`
- `J = [2, 6, 18]`
- Table I perfect binary `(8,4)-CZCP`
- curves: CZCP, random sparse training, and theoretical minimum MSE

Output:

- `mse_vs_ebno.png`

### MSE versus Number of Paths

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

- `mse_vs_paths.png`

Note: the CAN curve is omitted because the authors' official CAN coefficients or official code were not available. This avoids including a non-official CAN substitute in the performance analysis.

## Completed Updates

### Full Runner

Run:

```matlab
run_all_experiments
```

The script executes all main experiments, checks outputs, preserves figure windows, and reopens the main PNG outputs at the end.

### Output Filenames

The current scripts generate English-named image files:

- `training_mse_experiment.png`
- `training_mse_comparison.png`
- `training_gram_error_comparison.png`
- `mse_comparison_both.png`
- `mse_vs_ebno.png`
- `mse_vs_paths.png`
- `monte_carlo_channel_mse.png`

Older Chinese-named PNG files may still remain from previous runs.

### CAN/Gold Comparison

- Gold sequence training is included.
- The non-official CAN substitute curve has been removed.
- The current path-number comparison does not contain a CAN curve.
- If official CAN coefficients become available later, the official CAN curve can be added separately.

### Barker Baseline

- Barker now uses the specified `4 x 104` sparse training structure.
- The energy is normalized to `E = 32`.

### Monte Carlo Channel Simulation

The script `monte_carlo_channel_simulation.m` compares theoretical LS-MSE and empirical Monte Carlo MSE for CZCP and random training.

Outputs:

- `monte_carlo_channel_results.mat`
- `monte_carlo_channel_mse.png`

## Remaining Work

1. Compare the MSE comparison axis ranges and units against the original MSE plot.
2. Add the official CAN curve only if the authors' CAN coefficients or official MSE code become available.
3. Clearly state in any final report that the path-number comparison does not include the CAN curve because official CAN parameters are unavailable.

## Local Verification Record

Command:

```powershell
matlab -batch "run_all_experiments"
```

Run result:

- `verify_czcp_conditions`: PASS.
- `verify_czcs_construction`: PASS.
- `run_training_mse_experiment`: PASS.
- `plot_training_mse_comparison`: PASS.
- `plot_training_mse_baselines`: PASS.
- `monte_carlo_channel_simulation`: PASS.

Key values:

- CZCP Gram maximum error: `1.42e-15`.
- Random Gram maximum error: `8.94e+00`.
- Per-transmit-antenna training energy: `E = 32`.
- At SNR = 0 dB, CZCP MSE and Bound are both `3.1250e-02`.
- At SNR = 30 dB, CZCP MSE and Bound are both `3.1250e-05`.
- At SNR = 0 dB, CZCP Monte Carlo empirical/theory values are `3.1176e-02 / 3.1250e-02`.
- At SNR = 30 dB, CZCP Monte Carlo empirical/theory values are `3.1515e-05 / 3.1250e-05`.

