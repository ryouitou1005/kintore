import Foundation
import SwiftData

@Model
final class WorkoutSession {
    var date: Date
    var memo: String

    @Relationship(deleteRule: .cascade, inverse: \WorkoutSet.session)
    var sets: [WorkoutSet]? = []

    init(date: Date = .now, memo: String = "") {
        self.date = date
        self.memo = memo
    }

    var totalVolume: Double {
        (sets ?? []).reduce(0) { $0 + $1.volume }
    }

    var exercisesUsed: [Exercise] {
        let exercises = (sets ?? []).sorted { $0.order < $1.order }.compactMap { $0.exercise }
        var seen = Set<PersistentIdentifier>()
        var result: [Exercise] = []
        for exercise in exercises where !seen.contains(exercise.persistentModelID) {
            seen.insert(exercise.persistentModelID)
            result.append(exercise)
        }
        return result
    }
}

struct ExerciseSetGroup: Identifiable {
    let exercise: Exercise
    let sets: [WorkoutSet]
    var id: PersistentIdentifier { exercise.persistentModelID }
}

extension WorkoutSession {
    var setsGroupedByExercise: [ExerciseSetGroup] {
        let sortedSets = (sets ?? []).sorted { $0.order < $1.order }
        var order: [Exercise] = []
        var dict: [PersistentIdentifier: [WorkoutSet]] = [:]
        for set in sortedSets {
            guard let exercise = set.exercise else { continue }
            if dict[exercise.persistentModelID] == nil {
                order.append(exercise)
            }
            dict[exercise.persistentModelID, default: []].append(set)
        }
        return order.map { ExerciseSetGroup(exercise: $0, sets: dict[$0.persistentModelID] ?? []) }
    }
}
