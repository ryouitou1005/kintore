import Foundation
import SwiftData

@Model
final class WorkoutSet {
    var weight: Double
    var reps: Int
    var order: Int
    var exercise: Exercise?
    var session: WorkoutSession?

    init(weight: Double, reps: Int, order: Int, exercise: Exercise?) {
        self.weight = weight
        self.reps = reps
        self.order = order
        self.exercise = exercise
    }

    var volume: Double { weight * Double(reps) }
}
