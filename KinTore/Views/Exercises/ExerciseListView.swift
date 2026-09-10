import SwiftUI
import SwiftData

struct ExerciseListView: View {
    @Query(sort: \Exercise.name) private var exercises: [Exercise]
    @Environment(\.modelContext) private var modelContext
    @State private var showingAddExercise = false

    private var grouped: [MuscleGroupSection] {
        exercises.groupedByMuscle()
    }

    var body: some View {
        List {
            ForEach(grouped) { section in
                Section(section.group.rawValue) {
                    ForEach(section.exercises) { exercise in
                        Label(exercise.name, systemImage: section.group.symbolName)
                    }
                    .onDelete { offsets in
                        delete(items: section.exercises, at: offsets)
                    }
                }
            }
        }
        .navigationTitle("種目一覧")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddExercise = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddExercise) {
            AddExerciseSheet()
        }
        .overlay {
            if exercises.isEmpty {
                ContentUnavailableView("種目がありません", systemImage: "list.bullet", description: Text("右上の＋から追加できます"))
            }
        }
    }

    private func delete(items: [Exercise], at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(items[index])
        }
    }
}
