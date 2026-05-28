# CZCP-SM 训练序列实验实现总结

本文档总结当前 MATLAB 工程中 CZCP-SM 训练序列实验的实现状态、输出文件、已知限制和本地验证记录。

## 运行入口

在 MATLAB 中运行完整实验套件：

```matlab
run_all_experiments
```

该入口脚本会依次执行：

- `golay_pair_definition`
- `gbf_definition_sequence`
- `qary_gbf_czcp_conditions_report`
- `czcs_from_czcp_construction_report`
- `run_training_mse_experiment`
- `plot_training_mse_comparison`
- `plot_training_mse_baselines`
- `monte_carlo_channel_simulation`

脚本会检查主要 `.mat` 和 `.png` 输出文件是否生成。通过该入口运行时，会保留图窗，避免后续脚本关闭前面生成的图；运行结束后，还会重新打开主要 PNG 图像作为预览。

运行日志保存为：

- `experiment_run_log.txt`

如果单独运行某个绘图脚本，并希望保留图窗，可先执行：

```matlab
setappdata(0, 'KEEP_EXPERIMENT_FIGURES', true)
```

## 已实现内容

- 第二、三节相关函数工具：非周期相关、循环相关、自相关、互相关等。
- GBF、GCP、q 元复指数序列等基础构造工具。
- CZCP 定义、性质示例、完美 CZCP 构造与 CZCS 条件验证。
- 训练矩阵 `X`、Gram 矩阵 `X' * X` 和理论 LS-MSE 计算。
- CZCP 训练与同支撑随机训练的性能对比。
- `Nt = 4`、路径数为 `5`、`J = 2, 6, 18` 时的 MSE-EbNo 曲线。
- `EbNo = 16 dB`、`E = 32` 时的 MSE-路径数曲线。
- 路径数对比中的 CZCP、GCP、m 序列、Barker、Gold、Zadoff-Chu、Random 和 Minimum MSE 曲线。
- Barker 基线采用指定的 `4 x 104` 稀疏训练结构。
- 随机信道下 LS 信道估计的 Monte Carlo 验证。

## 输出文件

当前脚本生成英文命名的结果文件：

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

旧版本运行产生的中文命名 PNG 可能仍留在目录中，但当前脚本不再生成这些旧文件名。

## 已知限制
- Gold 曲线使用标准 length-31 Gold 序列构造。


## 实验逻辑

整体计算流程为：

```text
训练序列
    -> 稀疏训练矩阵 Omega
    -> 信道训练矩阵 X
    -> Gram 矩阵 X' * X
    -> 与 E * I 对比
    -> LS-MSE = sigma2 * trace(inv(X' * X)) / 参数个数
    -> 生成 MSE-SNR 或 MSE-路径数曲线
```

当 `X' * X` 接近 `E * I` 时，训练矩阵近似正交，LS 信道估计 MSE 较低。CZCP 训练的目标是达到理论下界：

```matlab
MSE_min = noise_var / E
```

## 本地验证状态

完整实验套件曾通过以下命令在本地运行：

```powershell
matlab -batch "run_all_experiments"
```

验证时间：2026-05-06 18:52:00 至 18:52:27。

运行结果：

- `golay_pair_definition`：PASS。
- `gbf_definition_sequence`：PASS。
- `qary_gbf_czcp_conditions_report`：PASS。
- `czcs_from_czcp_construction_report`：PASS。
- `run_training_mse_experiment`：PASS。
- `plot_training_mse_comparison`：PASS。
- `plot_training_mse_baselines`：PASS。
- `monte_carlo_channel_simulation`：PASS。
- 所有主要 `.mat` 和 `.png` 输出文件均已生成。
- 主要输出图像在运行结束时均已显示。

关键数值：

- CZCP Gram 最大误差：`1.42e-15`。
- 随机训练 Gram 最大误差：`8.94e+00`。
- 每根发射天线训练能量：`E = 32`。
- CZCP 理论 MSE 与下界一致，例如 SNR = 0 dB 时为 `3.1250e-02`，SNR = 30 dB 时为 `3.1250e-05`。
- Monte Carlo 结果与理论 LS-MSE 趋势一致，例如 CZCP 在 SNR = 0 dB 时经验值/理论值为 `3.1176e-02 / 3.1250e-02`，在 SNR = 30 dB 时为 `3.1515e-05 / 3.1250e-05`。
