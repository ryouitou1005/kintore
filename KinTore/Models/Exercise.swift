import Foundation
import SwiftData

@Model
final class Exercise {
    var name: String
    var muscleGroupRaw: String
    var createdAt: Date

    @Relationship(deleteRule: .nullify, inverse: \WorkoutSet.exercise)
    var sets: [WorkoutSet]? = []

    var muscleGroup: MuscleGroup {
        get { MuscleGroup(rawValue: muscleGroupRaw) ?? .other }
        set { muscleGroupRaw = newValue.rawValue }
    }

    init(name: String, muscleGroup: MuscleGroup) {
        self.name = name
        self.muscleGroupRaw = muscleGroup.rawValue
        self.createdAt = .now
    }
}
