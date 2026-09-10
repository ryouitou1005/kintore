import Foundation
import SwiftData

enum SeedData {
    static let defaultExercises: [(String, MuscleGroup)] = [
        ("ベンチプレス", .chest),
        ("インクラインダンベルプレス", .chest),
        ("ダンベルフライ", .chest),
        ("懸垂", .back),
        ("ラットプルダウン", .back),
        ("ベントオーバーロウ", .back),
        ("デッドリフト", .back),
        ("ショルダープレス", .shoulder),
        ("サイドレイズ", .shoulder),
        ("バーベルスクワット", .leg),
        ("レッグプレス", .leg),
        ("レッグカール", .leg),
        ("アームカール", .arm),
        ("トライセプスエクステンション", .arm),
        ("クランチ", .abs),
        ("プランク", .abs)
    ]

    static func insertDefaultExercisesIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<Exercise>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        guard count == 0 else { return }

        for (name, group) in defaultExercises {
            context.insert(Exercise(name: name, muscleGroup: group))
        }
        try? context.save()
    }
}
