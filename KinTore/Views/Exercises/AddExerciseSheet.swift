import SwiftUI
import SwiftData

struct AddExerciseSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var muscleGroup: MuscleGroup = .other
    var onCreate: ((Exercise) -> Void)? = nil

    var body: some View {
        NavigationStack {
            Form {
                TextField("種目名", text: $name)
                Picker("部位", selection: $muscleGroup) {
                    ForEach(MuscleGroup.allCases) { group in
                        Text(group.rawValue).tag(group)
                    }
                }
            }
            .navigationTitle("新しい種目")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        let exercise = Exercise(name: name.trimmingCharacters(in: .whitespaces), muscleGroup: muscleGroup)
                        modelContext.insert(exercise)
                        onCreate?(exercise)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
        .presentationDetents([.medium])
    }
}
