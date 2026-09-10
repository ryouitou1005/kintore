import SwiftUI
import SwiftData

struct ActiveWorkoutView: View {
    @Bindable var session: WorkoutSession
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showingExercisePicker = false
    @State private var selectedExercise: Exercise?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if session.setsGroupedByExercise.isEmpty {
                    ContentUnavailableView(
                        "種目を追加しましょう",
                        systemImage: "dumbbell",
                        description: Text("下のボタンから種目を選んでセットを記録します")
                    )
                    Spacer()
                } else {
                    List {
                        ForEach(session.setsGroupedByExercise) { group in
                            Section(group.exercise.name) {
                                ForEach(Array(group.sets.enumerated()), id: \.element.persistentModelID) { index, set in
                                    HStack {
                                        Text("\(index + 1)セット目")
                                            .foregroundStyle(.secondary)
                                        Spacer()
                                        Text("\(set.weight.formatted()) kg × \(set.reps) 回")
                                            .font(.body.monospacedDigit())
                                    }
                                }
                                .onDelete { offsets in
                                    deleteSets(group.sets, at: offsets)
                                }
                                Button {
                                    selectedExercise = group.exercise
                                } label: {
                                    Label("セットを追加", systemImage: "plus")
                                }
                            }
                        }
                    }
                }

                Button {
                    showingExercisePicker = true
                } label: {
                    Label("種目を追加", systemImage: "plus.circle.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                .padding()
            }
            .navigationTitle("ワークアウト中")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("破棄", role: .destructive) {
                        modelContext.delete(session)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("完了") {
                        dismiss()
                    }
                    .disabled(session.setsGroupedByExercise.isEmpty)
                }
            }
            .sheet(isPresented: $showingExercisePicker) {
                ExercisePickerView { exercise in
                    selectedExercise = exercise
                }
            }
            .sheet(item: $selectedExercise) { exercise in
                AddSetSheet(exercise: exercise) { weight, reps in
                    addSet(exercise: exercise, weight: weight, reps: reps)
                }
            }
        }
        .interactiveDismissDisabled()
    }

    private func addSet(exercise: Exercise, weight: Double, reps: Int) {
        let order = (session.sets ?? []).count
        let set = WorkoutSet(weight: weight, reps: reps, order: order, exercise: exercise)
        set.session = session
        modelContext.insert(set)
    }

    private func deleteSets(_ sets: [WorkoutSet], at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(sets[index])
        }
    }
}
