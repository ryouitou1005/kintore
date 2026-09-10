import SwiftUI
import SwiftData

struct ExercisePickerView: View {
    @Query(sort: \Exercise.name) private var exercises: [Exercise]
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var showingAddExercise = false
    let onSelect: (Exercise) -> Void

    private var filtered: [Exercise] {
        guard !searchText.isEmpty else { return exercises }
        return exercises.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    private var grouped: [MuscleGroupSection] {
        filtered.groupedByMuscle()
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(grouped) { section in
                    Section(section.group.rawValue) {
                        ForEach(section.exercises) { exercise in
                            Button {
                                onSelect(exercise)
                                dismiss()
                            } label: {
                                HStack {
                                    Image(systemName: section.group.symbolName)
                                        .foregroundStyle(.orange)
                                        .frame(width: 24)
                                    Text(exercise.name)
                                        .foregroundStyle(.primary)
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "種目を検索")
            .navigationTitle("種目を選択")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddExercise = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddExercise) {
                AddExerciseSheet { exercise in
                    onSelect(exercise)
                    dismiss()
                }
            }
        }
    }
}
