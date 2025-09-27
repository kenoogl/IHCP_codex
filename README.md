# Python > Julia 変換　by codex

\> **方針概要**

 \- **対象範囲の分割**: 既存 Python の全体構成を 基礎ユーティリティ → 物性計算 → 離散化ユーティリティ → DHCP → Adjoint → CGM → スライディング処理 → main I/O の順にモジュール化し、それぞれを Julia に段階移植します。単純な定数やデータ構造定義を先に写し、依存順序に沿って進めることで、移植途中でも Python 版で残りの処理を代替できます。

 \- **ファイル構成**: julia/ ディレクトリを新設し、IHCP.jl をエントリポイント、サブモジュールを polyfit_utils.jl, grid_setup.jl, dhcp.jl, adjoint.jl, cgm.jl などに分割。各モジュールは include と module を用い、名前空間を整理します。Python の NumPy/SciPy 対応は LinearAlgebra, SparseArrays, IterativeSolvers.jl（または標準 CG 実装）で置換する方針です。

 \- **逐次検証プロトコル**:

1. **ステップ準備**: Python 側に 5 タイムステップ・20×20 領域のデータ生成関数を用意し（既に採取した縮小データセットを .npz化）、Julia からも同じデータが読み込めるよう NPZ.jl などを利用。

2. **関数単位で変換→テスト**: 各関数（例: thermal_properties_calculator）を Julia へ移植したら、Python と Julia の結果を比較するスクリプトを用意。比較は max(abs(diff)) と数値統計（min/max/mean）で確認し、一致が取れたら次に進む。

3. **依存境界の固定**: 移植済み関数は Julia 実装を呼び、未移植部分は Python 実装を PyCall.jl 経由で呼ぶ、または Python 側で中間出力を保存して Julia で再利用。これにより段階的移行中の整合性を保つ。

 \- **並列化オフ**: Numba の parallel=True を解除／Python 側でシリアル実行に統一し、Julia 実装もシングルスレッドで進めます。最終的な性能チューニングは全関数移植後に LoopVectorization.jl や Threads.@threads を検討。

 \- **高度関数の順序**:

1. スカラー／単純ベクトル関数 (polyval_numba 相当 → Julia では多項式評価を普通に書く)。
2. 物性計算 (thermal_properties_calculator)。
3. グリッド生成・係数計算 (coeffs_and_rhs_*, assemble_A_*)。
4. multiple_time_step_solver_DHCP（CG を IterativeSolvers.cg! などで実装）。
5. multiple_time_step_solver_Adjoint。
6. global_CGM_time と関連する勾配計算・ラインサーチ。
7. sliding_window_CGM_q_saving や main() の I/O。

 \- **テストドライバー**: Julia 側に test/test_shrinked_case.jl を用意し、各段階で Python の参照データ（.npz）を読み込み、Julia 関数の出力と比較。Python 側でも同じドライバーを残し、差異をログに残す。

 \- **ドキュメントと進捗管理**: docs/conversion_log.md などに、変換済み関数・比較結果・未解決事項を記録。変換ごとに Git でコミットし、差分と検証ログを明示。

 \- **依存ライブラリ**: Julia では CSV.jl, DataFrames.jl は不要（物性 CSV は直接 Arrays に格納）。NPZ.jl, LinearAlgebra, SparseArrays, IterativeSolvers.jl を Project.toml に追加。Python との比較に PyCall.jl を用いる場合は互換性確認。



 この段階的フローを採用することで、各移植ステップで Python 版との数値一致を確認しながら Julia 化を進められます。
