# CZCP MATLAB 复现实验项目

本项目包含基于 CZCP 的最优训练序列实验 MATLAB 代码。

仓库内容包括序列构造、条件验证脚本、训练矩阵实验、MSE 基线对比图，以及 Monte Carlo LS 信道估计验证。

## 快速运行

在 MATLAB 中执行：

```matlab
run_all_experiments
```

运行后会生成主要 `.mat` 结果文件和 `.png` 图像文件，并将运行日志保存到 `experiment_run_log.txt`。

## 主要输出

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

更多实现说明和验证记录见 `experiment_summary.md`；当前任务和后续计划见 `experiment_todo.md`。
