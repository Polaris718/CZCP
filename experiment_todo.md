# CZCP-SM 训练序列实验 TODO

本文档记录当前 MATLAB 工程的实现状态、核心文件、实验设置和后续工作。

## 已完成工作

- 第二节相关函数：非周期相关、循环相关、自相关和互相关。
- GBF、GCP 和 q 元复指数序列等基础构造工具。
- CZCP 定义、性质示例、完美 CZCP 构造和 CZCS 条件验证。
- 训练矩阵框架：`X`、Gram 矩阵 `X' * X` 和理论 LS-MSE。
- 训练性能对比脚本：`plot_training_mse_comparison.m`。
- MSE 基线对比脚本：`plot_training_mse_baselines.m`。
- 随机信道 LS 估计的 Monte Carlo 验证脚本：`monte_carlo_channel_simulation.m`。
- 完整实验入口脚本：`run_all_experiments.m`。

## 核心文件

### 序列构造与验证

- `q_ray_czcp.m`：由 GBF 构造完美 q 元 CZCP。
- `generate_czcp_set.m`：根据构造规则由种子序列生成等价 CZCP 序列对。
- `perfect_czcp_condition_check.m`：验证完美 CZCP 的 C1/C2 条件。
- `czcs_from_czcp.m`：由 CZCP 序列对构造 CZCS 集合。
- `czcs_condition_check.m`：验证 CZCS 条件。
- `qary_gbf_czcp_conditions_report.m`：验证 q 元 GBF-CZCP 构造条件。
- `czcs_from_czcp_construction_report.m`：验证由 CZCP 构造 CZCS 的过程。

### 训练矩阵与 MSE

- `build_circular_toeplitz.m`：由单根天线训练序列构造循环 Toeplitz 矩阵。
- `build_training_matrix.m`：拼接 Toeplitz 块，形成完整训练矩阵 `X`。
- `build_czcp_sm_training.m`：由 CZCP 构造稀疏 SM 训练矩阵。
- `build_random_sm_training.m`：构造同支撑随机 q-PSK 训练基线。
- `training_mse_metrics.m`：计算 `X' * X`、最优性误差、归一化 MSE 和理论下界。
- `run_training_mse_experiment.m`：主训练实验脚本。
- `plot_training_mse_comparison.m`：绘制 CZCP 与随机训练对比图。

### MSE 基线对比

- `plot_training_mse_baselines.m`：生成 MSE 基线对比图。

预期输出：

- `mse_comparison_results.mat`
- `mse_comparison_both.png`
- `mse_vs_ebno.png`
- `mse_vs_paths.png`

## 实验逻辑

整体流程如下：

```text
训练序列
    -> 稀疏训练矩阵 Omega
    -> 信道训练矩阵 X
    -> Gram 矩阵 X' * X
    -> 与 E * I 对比
    -> LS-MSE = sigma2 * trace(inv(X' * X)) / 参数个数
    -> MSE-SNR 或 MSE-路径数曲线
```

如果 `X' * X` 接近 `E * I`，训练矩阵近似正交，LS 信道估计 MSE 会较低。CZCP 训练的目标是达到：

```matlab
MSE_min = noise_var / E
```

## 当前 MSE 对比设置

### MSE 随 EbNo 变化

- `Nt = 4`
- 路径数为 `5`
- `J = [2, 6, 18]`
- 使用表 I 中的完美二元 `(8,4)-CZCP`
- 曲线包括：CZCP、随机稀疏训练和理论最小 MSE

输出：

- `mse_vs_ebno.png`

### MSE 随路径数变化

- `Nt = 4`
- `EbNo = 16 dB`
- 训练能量归一化到 `E = 32`
- 路径数范围为 `3:13`

当前曲线包括：

- CZCP
- GCP
- m 序列
- Barker
- Gold
- Zadoff-Chu
- Random
- Minimum MSE

输出：

- `mse_vs_paths.png`

说明：由于没有论文作者的官方 CAN 系数或官方代码，当前未加入 CAN 曲线，以避免在性能分析中使用非官方替代曲线。

## 已完成更新

### 完整运行入口

运行：

```matlab
run_all_experiments
```

该脚本会执行主要实验、检查输出文件、保留图窗，并在最后重新打开主要 PNG 输出图。

### 输出文件名

当前脚本生成英文命名的图像文件：

- `training_mse_experiment.png`
- `training_mse_comparison.png`
- `training_gram_error_comparison.png`
- `mse_comparison_both.png`
- `mse_vs_ebno.png`
- `mse_vs_paths.png`
- `monte_carlo_channel_mse.png`

旧版本运行产生的中文命名 PNG 可能仍保留在目录中。

### CAN/Gold 对比

- 已加入 Gold 序列训练曲线。
- 已移除非官方 CAN 替代曲线。
- 当前路径数对比图不包含 CAN 曲线。
- 如果后续获得官方 CAN 系数，可单独补充官方 CAN 曲线。

### Barker 基线

- Barker 基线采用指定的 `4 x 104` 稀疏训练结构。
- 能量归一化到 `E = 32`。

### Monte Carlo 信道仿真

`monte_carlo_channel_simulation.m` 对比 CZCP 和随机训练下的理论 LS-MSE 与 Monte Carlo 经验 MSE。

输出：

- `monte_carlo_channel_results.mat`
- `monte_carlo_channel_mse.png`

## 后续工作

1. 对照原论文 MSE 图，检查坐标轴范围和单位。
2. 仅在获得作者官方 CAN 系数或官方 MSE 代码后，加入官方 CAN 曲线。
3. 在最终报告中明确说明：由于缺少官方 CAN 参数，当前路径数对比不包含 CAN 曲线。

## 本地验证记录

命令：

```powershell
matlab -batch "run_all_experiments"
```

运行结果：

- `golay_pair_definition`：PASS。
- `gbf_definition_sequence`：PASS。
- `qary_gbf_czcp_conditions_report`：PASS。
- `czcs_from_czcp_construction_report`：PASS。
- `run_training_mse_experiment`：PASS。
- `plot_training_mse_comparison`：PASS。
- `plot_training_mse_baselines`：PASS。
- `monte_carlo_channel_simulation`：PASS。

关键数值：

- CZCP Gram 最大误差：`1.42e-15`。
- 随机训练 Gram 最大误差：`8.94e+00`。
- 每根发射天线训练能量：`E = 32`。
- SNR = 0 dB 时，CZCP MSE 和下界均为 `3.1250e-02`。
- SNR = 30 dB 时，CZCP MSE 和下界均为 `3.1250e-05`。
- SNR = 0 dB 时，CZCP Monte Carlo 经验值/理论值为 `3.1176e-02 / 3.1250e-02`。
- SNR = 30 dB 时，CZCP Monte Carlo 经验值/理论值为 `3.1515e-05 / 3.1250e-05`。
