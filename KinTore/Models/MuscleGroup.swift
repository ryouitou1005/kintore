import Foundation

enum MuscleGroup: String, Codable, CaseIterable, Identifiable, Hashable {
    case chest = "胸"
    case back = "背中"
    case shoulder = "肩"
    case arm = "腕"
    case leg = "脚"
    case abs = "腹"
    case other = "その他"

    var id: String { rawValue }

    var symbolName: String {
        switch self {
        case .chest: return "figure.strengthtraining.traditional"
        case .back: return "figure.rower"
        case .shoulder: return "figure.arms.open"
        case .arm: return "dumbbell.fill"
        case .leg: return "figure.squat"
        case .abs: return "figure.core.training"
        case .other: return "star.fill"
        }
    }
}

struct MuscleGroupSection: Identifiable {
    let group: MuscleGroup
    let exercises: [Exercise]
    var id: MuscleGroup { group }
}

extension Array where Element == Exercise {
    func groupedByMuscle() -> [MuscleGroupSection] {
        MuscleGroup.allCases.compactMap { group in
            let items = self.filter { $0.muscleGroup == group }
            return items.isEmpty ? nil : MuscleGroupSection(group: group, exercises: items)
        }
    }
}
