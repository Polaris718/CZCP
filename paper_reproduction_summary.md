# CZCP-SM 论文实验复现说明

本文档总结当前 MATLAB 工程对论文实验的复现状态。

## 运行入口

推荐在 MATLAB 中运行：

```matlab
run_all_paper_experiments
```

该脚本会依次执行：

- `example6`
- `definite6`
- `main_section4_experiment`
- `plot_section4_comparison`
- `reproduce_fig6`
- `monte_carlo_channel_simulation`

并检查主要 `.mat` 和 `.png` 输出文件是否生成。通过该入口运行时，脚本会开启图窗保留模式，避免后续实验中的 `close all` 关闭前面已经生成的图。运行结束后还会把主要 PNG 结果重新打开为持久预览窗口。

运行日志保存为：

- `paper_experiment_run_log.txt`

如果只运行单个脚本，但也想保留旧图窗，可以先执行：

```matlab
setappdata(0, 'KEEP_PAPER_FIGURES', true)
```

## 已实现内容

- Section II/III 的相关函数、CZCP/CZCS 构造与验证。
- Section IV 的训练矩阵 `X`、Gram 矩阵 `X' * X`、理论 LS-MSE 计算。
- CZCP 与随机同支撑训练的 Section IV 性能对比。
- Fig. 6(a) 风格复现：`Nt = 4`，多径数为 `5`，`J = 2, 6, 18`。
- Fig. 6(b) 对照曲线：CZCP、GCP、m-sequence、Barker、Gold、Zadoff-Chu、Random、Minimum MSE。
- Barker 对照已改为论文描述的 `4 x 104` 稀疏训练矩阵结构。
- Monte Carlo 随机信道 LS 估计验证。

## 输出文件

图片文件已统一改为中文名：

- `section4_experiment_results.mat`
- `第4节_MSE性能对比.png`
- `第4节_Gram正交性误差对比.png`
- `fig6_reproduction_results.mat`
- `图6_复现总览.png`
- `图6a_MSE随EbNo变化.png`
- `图6b_MSE随多径数变化.png`
- `monte_carlo_channel_results.mat`
- `蒙特卡洛_信道估计MSE验证.png`

旧的英文 PNG 文件如果已经存在，不会被自动删除；重新运行实验后会生成中文名版本。

## 需要标注的限制

- 暂未找到作者官方 Fig. 6 MATLAB 代码。
- Gold 曲线使用标准 length-31 Gold sequence 构造。
- 由于缺少作者官方 CAN 序列参数，本文不再绘制 CAN 曲线，避免引入非官方对照。
- 因此 Fig. 6(b) 可称为“按论文结构复现的对照实验”，但不包含论文原图中的 CAN 官方曲线。

## 验证状态

本机 PowerShell 中已成功运行：

```powershell
matlab -batch "run_all_paper_experiments"
```

验证时间：2026-05-06 18:52:00 至 18:52:27。

运行结果：

- `example6`：PASS。
- `definite6`：PASS。
- `main_section4_experiment`：PASS。
- `plot_section4_comparison`：PASS。
- `reproduce_fig6`：PASS。
- `monte_carlo_channel_simulation`：PASS。
- 所有主要 `.mat` 和中文名 `.png` 输出文件均检查通过。
- 运行结束后已自动展示所有主要输出图。

关键数值：

- CZCP Gram 最大误差：`1.42e-15`。
- Random Gram 最大误差：`8.94e+00`。
- 每根发射天线训练能量：`E = 32`。
- CZCP 理论 MSE 与 lower bound 完全贴合，例如 SNR=0 dB 时均为 `3.1250e-02`，SNR=30 dB 时均为 `3.1250e-05`。
- Monte Carlo 结果与理论 LS-MSE 一致，例如 SNR=0 dB 时 CZCP empirical/theory 为 `3.1176e-02 / 3.1250e-02`，SNR=30 dB 时为 `3.1515e-05 / 3.1250e-05`。

最终检查标准：

- 已满足：所有主脚本显示 `PASS`。
- 已满足：上述中文名 PNG 均已生成并在运行结束后持续显示。
- 已满足：CZCP 曲线贴近 Minimum MSE / Lower bound。
- 已满足：Monte Carlo 曲线与理论 LS-MSE 曲线趋势一致。
