# 参数归类与物理含义说明

本文档汇总本工程各 MATLAB 文件中反复使用的主要参数，并按功能模块说明其数学含义和物理含义。代码中的函数名、变量名和文件名保持英文，便于和源码对应。

## 序列长度与相关区参数

| 参数 | 常见文件 | 含义 | 物理/数学解释 |
| --- | --- | --- | --- |
| `N` | `q_ray_czcp.m`, `perfect_czcp_condition_check.m`, `length9_czcp_*`, `length22_czcp_*` | 序列长度 | CZCP、GCP、测试序列或相位序列的总长度。对 GBF 构造，通常有 `N = 2^mu`。 |
| `theta` | `build_czcp_sm_training.m`, `run_training_mse_experiment.m`, `plot_training_mse_baselines.m` | CZCP 单段长度 | 训练矩阵中每个非零块的长度，也等于 CZCP 序列对 `a,b` 的长度。 |
| `Z` | `q_ray_czcp.m`, `czcs_condition_check.m`, `perfect_czcp_condition_check.m` | 零相关区宽度 | CZCP/CZCS 中要求相关和为零的时延区间宽度。完美 CZCP 通常满足 `Z = N/2`。 |
| `tau` | 相关函数与验证脚本 | 时延/相关滞后 | 自相关或互相关计算中的移位量。`tau > 0` 表示正时延，`tau < 0` 表示负时延。 |
| `T1`, `T2` | `czcs_condition_check.m`, `length9_czcp_correlation_zones.m` | 检查用时延集合 | CZCP/CZCS 条件中需要验证零相关性质的前端和尾端时延集合。 |

## GBF 与 q 元相位构造参数

| 参数 | 常见文件 | 含义 | 物理/数学解释 |
| --- | --- | --- | --- |
| `q` | `q_ray_czcp.m`, `gen_phi_q.m`, `gbf_*`, `run_training_mse_experiment.m` | 相位阶数 | q 元相位序列的阶数。`q = 4` 对应四相序列，符号来自单位圆上的 q 个相位点。 |
| `mu` | `q_ray_czcp.m`, `gbf_*`, `run_training_mse_experiment.m` | GBF 变量个数 | 二进制变量维数；GBF 生成的序列长度通常为 `2^mu`。 |
| `perm_vec` | `q_ray_czcp.m`, `run_training_mse_experiment.m` | 变量排列 | GBF 二次项中变量连接顺序的排列向量，决定相邻变量乘积项。 |
| `w_k` | `q_ray_czcp.m`, `run_training_mse_experiment.m` | 线性项系数 | GBF 中每个二进制变量的一阶线性系数。 |
| `w` | `q_ray_czcp.m`, `run_training_mse_experiment.m` | 常数项 | GBF 的相位偏置项，改变整体相位。 |
| `w_prime` | `q_ray_czcp.m`, `run_training_mse_experiment.m` | 第二条序列偏置 | 生成配对序列 `b` 时加入的额外相位偏置。 |
| `omega_q` / `omega` | `gen_phi_q.m`, `gbf_definition_sequence.m`, `phase_sequence_from_indices.m` | q 阶单位根 | 将整数相位指数映射到复平面单位圆上的相位符号。 |
| `g`, `h`, `g_values` | `gbf_*`, `phase_sequence_*` | 相位指数序列 | 先在整数模 `q` 空间中生成，再映射为复相位序列。 |
| `kappa`, `kappa_bits` | `q_ray_czcp.m`, `gbf_czcp_generation_report.m` | 二进制输入编号及比特 | 遍历所有 GBF 输入点时使用的编号及其二进制表示。 |

## CZCP/CZCS 序列参数

| 参数 | 常见文件 | 含义 | 物理/数学解释 |
| --- | --- | --- | --- |
| `a`, `b` | 多数 CZCP/Golay/训练脚本 | 序列对 | CZCP、GCP 或测试序列中的两条配对序列，用于产生互补相关性质。 |
| `c`, `d` | `czcp_boundary_conditions.m`, `conjugate_reversal_pair_identity.m` | 变换后序列对 | 归一化、共轭反转或符号翻转后的序列，用于验证等价构造性质。 |
| `czcp_pair` | `q_ray_czcp.m`, `run_training_mse_experiment.m` | CZCP 序列对结构体 | 通常包含 `czcp_pair.a` 和 `czcp_pair.b`，作为后续训练矩阵构造的种子。 |
| `czcs_set` | `czcs_from_czcp.m`, `czcs_condition_check.m` | CZCS 序列集合 | 由 CZCP 序列对交替构造得到的零相关区序列集合。 |
| `M` | `czcs_from_czcp.m`, `gbf_czcp_generation_report.m` | 集合规模或半长参数 | 在 CZCS 中表示序列集合大小；在部分构造脚本中也作为 `N = 2*M` 的半长参数。 |
| `v1`, `v2`, `v` | `generate_czcp_set.m`, `length22_czcp_from_seed_sequences.m` | 相位旋转参数 | 对种子序列进行整体相位旋转，生成等价 CZCP 序列对。 |

## 空间调制与训练矩阵参数

| 参数 | 常见文件 | 含义 | 物理/数学解释 |
| --- | --- | --- | --- |
| `Nt` | `build_czcp_sm_training.m`, `run_training_mse_experiment.m`, `plot_training_mse_baselines.m` | 发射天线数 | 空间调制系统中的发射天线数量。代码中通常取 `Nt = 4`，且要求为偶数。 |
| `J` | `build_czcp_sm_training.m`, `plot_training_mse_baselines.m` | 训练重复因子 | 控制训练块重复次数；`J` 越大，训练长度和训练能量越高。代码中要求 `J` 为偶数。 |
| `J_list` | `plot_training_mse_baselines.m` | 重复因子列表 | 用于比较不同训练长度/重复次数下的 MSE-EbNo 曲线。 |
| `seed_type` | `build_czcp_sm_training.m`, `run_training_mse_experiment.m` | CZCP 种子排列方式 | `1` 表示所有天线使用同一 `[a,b]`；`2` 表示后半天线使用共轭反转构造。 |
| `Omega` | `build_*_sm_training.m`, `training_mse_metrics.m` | 稀疏训练矩阵 | 每一行对应一根发射天线的训练序列；非零块体现空间调制的稀疏激活结构。 |
| `Omega_e` | `build_czcp_sm_training.m`, `build_random_sm_training.m` | 基础训练块 | 重复前的训练矩阵模板，之后通过 `repmat` 按 `J/2` 扩展。 |
| `X` | `build_training_matrix.m`, `training_mse_metrics.m` | 信道训练矩阵 | 由各天线训练序列的循环 Toeplitz 块拼接而成，用于 LS 信道估计。 |
| `T` | `build_circular_toeplitz.m` | 循环 Toeplitz 块 | 单根天线训练序列生成的卷积矩阵，表示该天线训练信号与多径信道的卷积关系。 |
| `D` | `spatial_modulation_symbol_mapping.m` | 空间调制符号矩阵 | 每列只有一个非零元素，表示某个时刻被激活的天线及其调制符号。 |
| `M_SM` | `spatial_modulation_symbol_mapping.m` | 星座阶数 | 空间调制示例中的调制星座大小，如 `M_SM = 8` 对应 8-PSK。 |
| `K` | `spatial_modulation_symbol_mapping.m` | 符号个数 | 空间调制示例中生成的符号列数。 |

## 信道、噪声与 MSE 参数

| 参数 | 常见文件 | 含义 | 物理/数学解释 |
| --- | --- | --- | --- |
| `lambda` | `run_training_mse_experiment.m`, `monte_carlo_channel_simulation.m` | 最大信道时延阶数 | 频率选择性多径信道的最高延迟阶数。 |
| `channel_len` | `build_training_matrix.m`, `training_mse_metrics.m` | 信道长度 | 多径信道抽头数，通常 `channel_len = lambda + 1`。 |
| `paths`, `fixed_paths`, `path_grid` | `plot_training_mse_baselines.m` | 路径数 | 用于 MSE 随多径数量变化的实验；路径数越大，待估计信道参数越多。 |
| `snr_db` | `run_training_mse_experiment.m`, `monte_carlo_channel_simulation.m` | 信噪比网格 | 以 dB 表示的信噪比，用于生成 MSE-SNR 曲线。 |
| `ebno_db_grid`, `fixed_ebno_db` | `plot_training_mse_baselines.m` | 每发射天线 EbNo | 每根发射天线的能量噪声比，用于复现论文式 MSE 对比图。 |
| `noise_var` | `training_mse_metrics.m`, `plot_training_mse_baselines.m` | 噪声方差 | 由 SNR/EbNo 换算得到，直接决定 LS-MSE 大小。 |
| `E`, `E_target` | `training_mse_metrics.m`, `plot_training_mse_baselines.m` | 每天线训练能量 | 单根发射天线训练序列的能量；理论下界为 `noise_var / E`。 |
| `Gram` | `training_mse_metrics.m`, `plot_training_mse_baselines.m` | Gram 矩阵 | `X' * X`。若接近 `E * I`，说明训练矩阵近似正交，估计性能接近最优。 |
| `num_params` | `training_mse_metrics.m`, `plot_training_mse_baselines.m` | 待估计参数个数 | 通常等于 `Nt * channel_len`，即所有天线所有信道抽头的总数。 |
| `normalized_mse` | `training_mse_metrics.m` | 归一化 LS-MSE | `noise_var * trace(inv(X' * X)) / num_params`，用于比较不同训练方案。 |
| `lower_bound` / `bound` | `training_mse_metrics.m`, `run_training_mse_experiment.m` | 理论下界 | 当 `X' * X = E * I` 时达到的最小 MSE，即 `noise_var / E`。 |
| `gram_error_max`, `gram_error_fro` | `training_mse_metrics.m` | 正交性误差 | 衡量 `Gram` 与 `E * I` 的偏离程度；越小表示训练矩阵越接近最优。 |

## Monte Carlo 仿真参数

| 参数 | 常见文件 | 含义 | 物理/数学解释 |
| --- | --- | --- | --- |
| `num_trials` | `monte_carlo_channel_simulation.m` | Monte Carlo 试验次数 | 每个 SNR 点下随机生成信道和噪声的次数，次数越多经验 MSE 越稳定。 |
| `num_random_trials` | `plot_training_mse_baselines.m` | 随机基线平均次数 | 随机训练基线的重复采样次数，用于降低随机波动。 |
| `h` | `monte_carlo_channel_simulation.m` | 随机信道向量 | 模拟复高斯多径信道参数。 |
| `h_hat` | `monte_carlo_channel_simulation.m` | LS 信道估计 | 由观测 `y` 和训练矩阵 `X` 计算得到的信道估计。 |
| `y` | `monte_carlo_channel_simulation.m` | 接收训练观测 | 满足 `y = X*h + noise`，用于 LS 估计。 |
| `mse_accum` | `monte_carlo_channel_simulation.m` | MSE 累加量 | 多次随机试验的误差累加，用于计算经验平均 MSE。 |

## 基线序列参数

| 参数 | 常见文件 | 含义 | 物理/数学解释 |
| --- | --- | --- | --- |
| `gcp_a16`, `gcp_b16` | `plot_training_mse_baselines.m` | 长度 16 的 GCP 基线 | 用作路径数对比中的互补序列基线。 |
| `mseq31` | `plot_training_mse_baselines.m` | 长度 31 的 m 序列 | 伪随机二元序列基线。 |
| `barker13` | `plot_training_mse_baselines.m` | 长度 13 的 Barker 序列 | 低旁瓣经典序列基线，代码中扩展为 `4 x 104` 稀疏训练结构。 |
| `gold31` | `plot_training_mse_baselines.m` | 长度 31 的 Gold 序列 | 由优选 m 序列对生成的扩频序列基线。 |
| `zc32` | `plot_training_mse_baselines.m` | 长度 32 的 Zadoff-Chu 风格行 | 恒幅复序列基线，用于训练矩阵对比。 |
| `root` | `zadoff_chu_seq` | Zadoff-Chu 根参数 | 控制 Zadoff-Chu 序列相位结构的整数参数。 |

## 结果结构体字段

| 字段 | 常见文件 | 含义 |
| --- | --- | --- |
| `results.Nt`, `results.J`, `results.lambda`, `results.channel_len` | `run_training_mse_experiment.m`, `monte_carlo_channel_simulation.m` | 保存实验系统规模和信道长度设置。 |
| `results.theta`, `results.Z` | `run_training_mse_experiment.m` | 保存 CZCP 序列长度和零相关区宽度。 |
| `results.snr_db` | `run_training_mse_experiment.m`, `monte_carlo_channel_simulation.m` | 保存 SNR 采样网格。 |
| `results.mse_czcp`, `results.mse_random` | `run_training_mse_experiment.m` | 保存理论 CZCP 和随机训练 MSE。 |
| `results.theory_czcp`, `results.empirical_czcp` | `monte_carlo_channel_simulation.m` | 保存 CZCP 理论与 Monte Carlo 经验 MSE。 |
| `results.theory_random`, `results.empirical_random` | `monte_carlo_channel_simulation.m` | 保存随机训练理论与 Monte Carlo 经验 MSE。 |
| `results.bound` | 多个实验脚本 | 保存理论最小 MSE 下界。 |

## 文件到参数的快速索引

| 文件 | 主要参数 |
| --- | --- |
| `q_ray_czcp.m` | `q`, `mu`, `perm_vec`, `w_k`, `w`, `w_prime`, `N`, `Z` |
| `build_czcp_sm_training.m` | `a`, `b`, `Nt`, `J`, `seed_type`, `theta`, `Omega` |
| `build_random_sm_training.m` | `Nt`, `theta`, `J`, `alphabet_order`, `Omega` |
| `build_training_matrix.m` | `Omega`, `channel_len`, `X` |
| `training_mse_metrics.m` | `Omega`, `channel_len`, `noise_var`, `Gram`, `E`, `normalized_mse` |
| `run_training_mse_experiment.m` | `Nt`, `J`, `lambda`, `channel_len`, `q`, `mu`, `snr_db`, `results` |
| `plot_training_mse_baselines.m` | `Nt`, `J_list`, `fixed_paths`, `ebno_db_grid`, `path_grid`, `E_target`, `num_random_trials` |
| `monte_carlo_channel_simulation.m` | `Nt`, `J`, `lambda`, `channel_len`, `snr_db`, `num_trials`, `h`, `h_hat` |
| `spatial_modulation_symbol_mapping.m` | `Nt`, `M_SM`, `K`, `input_bits`, `D` |
| `czcs_condition_check.m` | `czcs_set`, `Z`, `M`, `N`, `T1`, `T2` |
