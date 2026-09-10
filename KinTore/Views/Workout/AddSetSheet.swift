import SwiftUI

struct AddSetSheet: View {
    let exercise: Exercise
    let onAdd: (Double, Int) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var weight: Double = 20
    @State private var reps: Int = 10

    var body: some View {
        NavigationStack {
            Form {
                Section(exercise.name) {
                    Stepper(value: $weight, in: 0...500, step: 2.5) {
                        HStack {
                            Text("重量")
                            Spacer()
                            Text("\(weight.formatted()) kg")
                                .foregroundStyle(.secondary)
                        }
                    }
                    Stepper(value: $reps, in: 1...50) {
                        HStack {
                            Text("回数")
                            Spacer()
                            Text("\(reps) 回")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("セットを追加")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("追加") {
                        onAdd(weight, reps)
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
}
