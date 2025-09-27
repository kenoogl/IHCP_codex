# Julia 変換ログ

| 日付       | 対象コンポーネント          | ステータス | メモ |
|------------|-----------------------------|-----------|------|
| YYYY-MM-DD | プロジェクト骨格の初期化     | ✅ 計画済み | `julia/` 配下に Project.toml と各モジュール雛形、テスト雛形を作成。以後、関数単位で移植・検証結果をここに追記すること。 |
| YYYY-MM-DD | PolyUtils.polyval_descending | 🟡 実装済み・要手動検証 | Python 基準データ: `artifacts/python_baseline/polyval_cp_coeffs.txt`, `polyval_cp_samples_results.csv`。Julia テスト `Pkg.test()` で比較。環境制約で自動実行不可のためローカルで要確認。 |

> 変換を進める際は、各ステップで Python/Julia の比較結果（最大差・平均差など）と確認に使用したリファレンスデータのパスを必ず記録してください。
