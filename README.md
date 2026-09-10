# 筋トレノート（KinTore）

筋トレの記録・管理をするiPhoneアプリです。SwiftUI + SwiftDataで実装しています。

## 機能

- **ホーム**: 今週のボリューム、連続記録日数、最近のワークアウト一覧、ワークアウト開始ボタン
- **ワークアウト記録**: 種目を選んで重量×回数のセットを記録（種目ごとにグループ表示）
- **種目管理**: 部位別（胸/背中/肩/腕/脚/腹/その他）に種目を一覧・追加・削除。初回起動時に代表的な種目を自動登録
- **履歴**: 過去のワークアウトを日付順に一覧、タップで詳細（セット内容・合計ボリューム・メモ）を表示
- **統計**: Swift Chartsによるボリューム推移グラフ（直近30日）、種目ごとの自己ベスト（最大重量）一覧

## ファイル構成

```
KinTore/
  KinToreApp.swift          … アプリエントリーポイント（SwiftDataのModelContainer設定）
  Models/
    MuscleGroup.swift        … 部位enumとグルーピング用の補助
    Exercise.swift           … 種目モデル
    WorkoutSet.swift         … 1セット（重量・回数）のモデル
    WorkoutSession.swift     … 1回のワークアウト全体のモデル
  Data/
    SeedData.swift           … 初回起動時のデフォルト種目データ
  Views/
    ContentView.swift        … タブ構成（ホーム/履歴/種目/統計）
    Components/              … 再利用パーツ（カード、行など）
    Home/HomeView.swift
    Workout/ActiveWorkoutView.swift, AddSetSheet.swift
    Exercises/ExerciseListView.swift, ExercisePickerView.swift, AddExerciseSheet.swift
    History/HistoryView.swift, SessionDetailView.swift
    Stats/StatsView.swift
```

## Xcodeで開く方法

このコードはWindows環境で作成したため、**Mac + Xcode 15以降**が必要です（Xcodeプロジェクトファイル自体はMac上で生成してください）。

### 方法A: XcodeGenを使う（おすすめ・一番早い）

1. Macに [XcodeGen](https://github.com/yonaskolb/XcodeGen) を入れる
   ```sh
   brew install xcodegen
   ```
2. このフォルダ（`project.yml`がある場所）で実行
   ```sh
   xcodegen generate
   ```
3. 生成された `KinTore.xcodeproj` をXcodeで開き、シミュレータを選んで実行（⌘R）

### 方法B: 手動でXcodeプロジェクトを作る

1. Xcodeで新規プロジェクト作成: iOS → App → 
   - Product Name: `KinTore`
   - Interface: SwiftUI
   - Storage: SwiftData
   - Language: Swift
2. 生成された `ContentView.swift` や `KinToreApp.swift` を、このフォルダの `KinTore/` 以下にある同名ファイルの中身で置き換える
3. `KinTore/` フォルダ内の他のファイル（Models, Data, Views）をすべてXcodeプロジェクトにドラッグ&ドロップで追加する（"Copy items if needed"にチェック）
4. Deployment Targetを **iOS 17.0以上** に設定する（SwiftData/Observable/Chartsを使用しているため）

## 補足

- Windows環境のため、実機のXcodeでのビルド確認はできていません。開いてみて出たエラーや直したい点があれば教えてください。
- 今後のHealthKit連携（体重・運動記録）は未実装です。まずはアプリ内記録のみで動く状態にしています。
