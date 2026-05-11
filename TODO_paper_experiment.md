# 论文实验复现待办清单

本文档记录当前 MATLAB 工程的实验复现进度，以及接下来要做的工作。当前重点已经从“序列构造验证”推进到“Section IV 训练矩阵性能对比”和“Fig. 6 图像复现”。

## 当前已完成内容

- Section II-A：非周期相关、周期相关、自相关、互相关等基础函数。
- Section II-B：GBF、GCP、q 元复指数序列等基础构造。
- Section III：CZCP 定义、性质、示例、完美 CZCP 构造、CZCS 验证。
- Section IV 基础框架：训练矩阵 `X`、Gram 矩阵 `X' * X`、LS-MSE 理论计算。
- 已新增普通对比图脚本：`plot_section4_comparison.m`。
- 已新增 Fig. 6 风格复现脚本：`reproduce_fig6.m`。

## 现有核心文件

### 序列构造与验证

- `q_ray_czcp.m`：由 GBF 构造完美 q 元 CZCP。
- `generate_czcp_set.m`：论文公式(22)，由 GCP 生成 4 组 CZCP。
- `verify_perfect_czcp.m`：验证完美 CZCP 的 C1/C2 条件。
- `czcs_from_czcp.m`：由 CZCP 构造 CZCS。
- `verify_czcs.m`：验证 CZCS 条件。
- `example6.m`：验证 q 元 CZCP 构造。
- `definite6.m`：验证 CZCS 构造。

### Section IV 训练矩阵与 MSE

- `build_circular_toeplitz.m`：由单根天线训练序列生成循环 Toeplitz 矩阵。
- `build_training_matrix.m`：拼接所有天线的 Toeplitz 块，得到总训练矩阵 `X`。
- `build_czcp_sm_training.m`：由 CZCP 构造稀疏 SM 训练矩阵 `Omega`。
- `build_random_sm_training.m`：构造同支撑随机 q-PSK 训练矩阵。
- `training_mse_metrics.m`：计算 `X' * X`、最优性误差、归一化 MSE 和理论下界。
- `main_section4_experiment.m`：Section IV 主实验脚本。
- `plot_section4_comparison.m`：绘制普通 CZCP vs Random 对比图。
- `monte_carlo_channel_simulation.m`：随机信道 Monte Carlo LS 估计验证。
- `run_all_paper_experiments.m`：一键运行全部主实验、检查输出文件，并保留/展示生成的图窗。

### Fig. 6 复现

- `reproduce_fig6.m`：复现论文 Fig. 6(a) 和 Fig. 6(b) 风格的两个对比图。

运行：

```matlab
reproduce_fig6
```

预期输出：

- `fig6_reproduction_results.mat`
- `图6_复现总览.png`
- `图6a_MSE随EbNo变化.png`
- `图6b_MSE随多径数变化.png`

## 当前实验逻辑

整体性能比较流程如下：

```text
不同训练序列
    -> 构造稀疏训练矩阵 Omega
    -> 构造信道训练矩阵 X
    -> 计算 Gram = X' * X
    -> 判断是否接近 E * I
    -> 计算 LS-MSE = sigma2 * trace(inv(X' * X)) / 参数数
    -> 画 MSE-SNR 或 MSE-多径数曲线
```

如果某个序列构造出的 `X' * X` 越接近 `E * I`，说明训练矩阵正交性越好，信道估计 MSE 越低。CZCP 的目标是达到理论下界：

```matlab
MSE_min = noise_var / E
```

## 普通 Section IV 对比图

运行：

```matlab
main_section4_experiment
plot_section4_comparison
```

会得到：

- `section4_experiment_results.mat`
- `第4节_MSE性能对比.png`
- `第4节_Gram正交性误差对比.png`

图中比较：

- CZCP training
- Theoretical lower bound
- Random same-support training

检查重点：

- CZCP 的 MSE 是否贴近 lower bound。
- CZCP 的 `max |X^H X - E I|` 是否远小于随机序列。

## Fig. 6 复现目标

### Fig. 6(a)

目标：固定多径数为 5，比较不同 `J` 下的 MSE-SNR 曲线。

当前脚本设置：

- `Nt = 4`
- 多径数 `paths = 5`
- `J = 2, 6, 18`
- 使用 Table I 中的完美二元 `(8,4)-CZCP`
- 对比 CZCP、随机稀疏训练、理论最小 MSE

输出：

- `图6a_MSE随EbNo变化.png`

### Fig. 6(b)

目标：固定 EbNo = 16 dB，比较不同多径数下的 MSE。

当前脚本设置：

- `Nt = 4`
- `EbNo = 16 dB`
- 训练能量归一到 `E = 32`
- 多径数范围：`3:13`

当前对比序列：

- CZCP
- GCP
- m-sequence
- Barker
- Gold
- Zadoff-Chu
- Random
- Minimum MSE

输出：

- `图6b_MSE随多径数变化.png`

说明：当前脚本保留 Gold 曲线，但已去掉 CAN 曲线。由于暂未找到作者官方 Fig. 6 MATLAB 代码或官方 CAN 系数，本文不再绘制 CAN 对照，避免引入非官方性能分析。

## 已完成更新

### 1. 总控运行入口

已新增：

```matlab
run_all_paper_experiments
```

该脚本会依次运行：

- `example6`
- `definite6`
- `main_section4_experiment`
- `plot_section4_comparison`
- `reproduce_fig6`
- `monte_carlo_channel_simulation`

并检查所有主要 `.png` 和 `.mat` 文件是否生成。

执行记录：

- 已开启图窗保留模式，避免后续脚本中的 `close all` 关闭前面生成的图。
- 运行结束后会把主要 PNG 结果重新打开为持久预览窗口。
- 运行日志保存为 `paper_experiment_run_log.txt`。

当前状态：

- 已在本机 PowerShell 中成功运行 `matlab -batch "run_all_paper_experiments"`。
- 运行时间：2026-05-06 18:52:00 至 18:52:27。
- 所有主脚本均为 `PASS`。
- 所有主要 `.mat` 和中文名 `.png` 输出文件均检查通过。
- 运行结束后所有主要输出图均已自动展示。

### 2. 中文图片文件名

已将生成图片统一改为中文文件名：

- `第4节_MSE性能对比.png`
- `第4节_Gram正交性误差对比.png`
- `图6_复现总览.png`
- `图6a_MSE随EbNo变化.png`
- `图6b_MSE随多径数变化.png`
- `蒙特卡洛_信道估计MSE验证.png`

说明：旧的英文 PNG 文件如果已经存在，不会自动删除；重新运行实验后会生成中文名版本。

### 3. Fig. 6 参数核对状态

需要继续确认：

- 论文 Fig. 6(a) 的 EbNo 横轴范围是否完全一致。
- 论文 Fig. 6(b) 的多径数范围是否完全一致。
- 论文中 `E = 32`、`Nt = 4`、`J`、序列长度的设置是否全部匹配。
- Fig. 6(a) 随机基线是否与论文的随机序列生成方式完全一致。

当前代码中已设置：

- Fig. 6(a)：`Nt = 4`，多径数为 `5`，`J = [2, 6, 18]`，`EbNo = 0:2:20`。
- Fig. 6(b)：`EbNo = 16 dB`，`E = 32`，多径数范围为 `3:13`。

仍需和论文原图逐项核对横轴范围、纵轴单位、随机序列生成方式、每条曲线的训练矩阵长度和能量归一化方式。

### 4. CAN/Gold 对比

当前 `reproduce_fig6.m` 中已经包含：

- CZCP
- GCP
- m-sequence
- Barker
- Gold
- Zadoff-Chu
- Random
- Minimum MSE

执行记录：

- 已补入 Gold sequence 训练矩阵。
- 已删除非官方 CAN 替代曲线及其性能对比分析。
- 未找到作者官方 Fig. 6 MATLAB 代码或官方 CAN 系数，因此当前结果不再包含 CAN 对照。
- 当前结果应标注为“按论文结构复现的 Fig. 6 对照”，但不包含论文原图中的 CAN 官方曲线。

后续可选工作：

- 若找到作者官方 Fig. 6 代码或 CAN 系数，可单独补回官方 CAN 曲线。

### 5. Barker 对照结构

论文中 Barker 对照使用的是特殊的稀疏训练矩阵结构，和当前 `reproduce_fig6.m` 中的通用单块结构不完全一致。

原先代码：

```matlab
Omega_barker = normalize_training_energy( ...
    build_structure48_from_rows(repmat(barker, Nt, 1)), E_target);
```

该结构已经被替换为 `build_barker104_training`。

执行记录：

- 已在 `reproduce_fig6.m` 中新增 `build_barker104_training`。
- Barker 现在使用 `4 x 104` 稀疏训练矩阵结构，并归一化到 `E = 32`。

### 6. Monte Carlo 信道仿真

当前主要使用理论 LS-MSE：

```matlab
MSE = sigma2 * trace(inv(X' * X)) / num_params
```

后续可增加真实随机信道仿真：

```matlab
h = randn(num_params,1) + 1i * randn(num_params,1);
y = X * h + noise;
h_hat = (X' * X) \ (X' * y);
mse = norm(h_hat - h)^2 / num_params;
```

然后对多次 trial 求平均。

执行记录：

- 已新增 `monte_carlo_channel_simulation.m`。
- 输出文件：
  - `monte_carlo_channel_results.mat`
  - `蒙特卡洛_信道估计MSE验证.png`
- 该脚本会比较 CZCP/Random 的理论 LS-MSE 和 Monte Carlo 经验 MSE。

### 7. 整理最终实验结果

最终建议保留：

- 一份复现说明：本文档。
- 一个普通 Section IV 主实验：`main_section4_experiment.m`。
- 一个 Fig. 6 复现实验：`reproduce_fig6.m`。
- 一个 Monte Carlo 随机信道验证实验：`monte_carlo_channel_simulation.m`。
- 一个总控运行脚本：`run_all_paper_experiments.m`。
- 结果图：
  - `第4节_MSE性能对比.png`
  - `第4节_Gram正交性误差对比.png`
  - `图6_复现总览.png`
  - `图6a_MSE随EbNo变化.png`
  - `图6b_MSE随多径数变化.png`
  - `蒙特卡洛_信道估计MSE验证.png`
- 结果数据：
  - `section4_experiment_results.mat`
  - `fig6_reproduction_results.mat`
  - `monte_carlo_channel_results.mat`

最终说明中建议明确区分：

- 完全跑通的基础序列验证实验。
- Section IV 理论 LS-MSE 对比实验。
- Fig. 6 风格复现实验。
- 因缺少 CAN 官方参数或官方代码而暂未完全一比一复现的部分。

## 当前剩余工作

1. 核对 Fig. 6(a)、Fig. 6(b) 的横轴范围、纵轴单位和论文截图是否完全一致。
2. 若后续找到作者官方 Fig. 6 代码或 CAN 系数，可单独补回官方 CAN 曲线。
3. 在最终论文/报告中明确标注：当前 Fig. 6(b) 不包含 CAN 曲线，因为缺少作者官方 CAN 参数。

## 本机验证记录

命令：

```powershell
matlab -batch "run_all_paper_experiments"
```

运行结果：

- `example6`：PASS。
- `definite6`：PASS。
- `main_section4_experiment`：PASS。
- `plot_section4_comparison`：PASS。
- `reproduce_fig6`：PASS。
- `monte_carlo_channel_simulation`：PASS。

关键数值：

- CZCP Gram 最大误差：`1.42e-15`。
- Random Gram 最大误差：`8.94e+00`。
- 每根发射天线训练能量：`E = 32`。
- SNR=0 dB 时，CZCP MSE 与 Bound 均为 `3.1250e-02`。
- SNR=30 dB 时，CZCP MSE 与 Bound 均为 `3.1250e-05`。
- Monte Carlo 在 SNR=0 dB 时 CZCP empirical/theory 为 `3.1176e-02 / 3.1250e-02`。
- Monte Carlo 在 SNR=30 dB 时 CZCP empirical/theory 为 `3.1515e-05 / 3.1250e-05`。
