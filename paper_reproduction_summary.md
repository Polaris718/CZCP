# CZCP-SM Paper Reproduction Summary

This document summarizes the current MATLAB reproduction status for the CZCP-SM training-sequence paper.

## Run Entry Point

Run the full experiment suite in MATLAB with:

```matlab
run_all_paper_experiments
```

The runner executes:

- `verify_czcp_conditions`
- `definite6`
- `run_training_mse_experiment`
- `plot_training_mse_comparison`
- `reproduce_mse_comparison`
- `monte_carlo_channel_simulation`

It checks the main `.mat` and `.png` outputs. When launched through this entry point, figure windows are preserved so later scripts do not close earlier plots. At the end, the main PNG outputs are reopened as persistent preview figures.

The run log is saved as:

- `paper_experiment_run_log.txt`

To preserve figure windows when running a single script, execute:

```matlab
setappdata(0, 'KEEP_PAPER_FIGURES', true)
```

## Implemented Content

- Section II/III correlation utilities and CZCP/CZCS construction checks.
- Training matrix `X`, Gram matrix `X' * X`, and theoretical LS-MSE computation.
- CZCP versus random same-support performance comparison.
- MSE versus EbNo comparison with `Nt = 4`, path number `5`, and `J = 2, 6, 18`.
- MSE versus path-number comparison curves for CZCP, GCP, m-sequence, Barker, Gold, Zadoff-Chu, Random, and Minimum MSE.
- Barker baseline with the paper-described `4 x 104` sparse training structure.
- Monte Carlo random-channel LS estimation validation.

## Output Files

Output images now use English filenames:

- `training_mse_experiment_results.mat`
- `training_mse_experiment.png`
- `training_mse_comparison.png`
- `training_gram_error_comparison.png`
- `mse_comparison_results.mat`
- `mse_comparison_both.png`
- `mse_vs_ebno.png`
- `mse_vs_paths.png`
- `monte_carlo_channel_results.mat`
- `monte_carlo_channel_mse.png`

Older Chinese-named PNG files may still exist from previous runs; they are no longer produced by the current scripts.

## Limitations

- The authors' official MATLAB code was not available.
- The Gold curve uses a standard length-31 Gold sequence construction.
- The CAN curve is omitted because the official CAN coefficients are unavailable.
- Therefore, the path-number comparison should be described as a paper-structure reproduction rather than a one-to-one reproduction of every official curve.

## Verification Status

The full suite was successfully run locally with:

```powershell
matlab -batch "run_all_paper_experiments"
```

Verification time: 2026-05-06 18:52:00 to 18:52:27.

Run result:

- `verify_czcp_conditions`: PASS.
- `definite6`: PASS.
- `run_training_mse_experiment`: PASS.
- `plot_training_mse_comparison`: PASS.
- `reproduce_mse_comparison`: PASS.
- `monte_carlo_channel_simulation`: PASS.
- All main `.mat` and `.png` output artifacts were generated.
- All main output figures were displayed at the end of the run.

Key values:

- CZCP Gram maximum error: `1.42e-15`.
- Random Gram maximum error: `8.94e+00`.
- Per-transmit-antenna training energy: `E = 32`.
- The CZCP theoretical MSE matches the lower bound, e.g. `3.1250e-02` at SNR = 0 dB and `3.1250e-05` at SNR = 30 dB.
- Monte Carlo results match the theoretical LS-MSE trend, e.g. CZCP empirical/theory values are `3.1176e-02 / 3.1250e-02` at SNR = 0 dB and `3.1515e-05 / 3.1250e-05` at SNR = 30 dB.
