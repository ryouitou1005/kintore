import SwiftUI
import SwiftData

struct SessionDetailView: View {
    @Bindable var session: WorkoutSession

    var body: some View {
        List {
            Section {
                HStack {
                    Text("合計ボリューム")
                    Spacer()
                    Text("\(Int(session.totalVolume)) kg")
                        .bold()
                        .foregroundStyle(.orange)
                }
            }
            ForEach(session.setsGroupedByExercise) { group in
                Section(group.exercise.name) {
                    ForEach(Array(group.sets.enumerated()), id: \.element.persistentModelID) { index, set in
                        HStack {
                            Text("\(index + 1)セット目")
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("\(set.weight.formatted()) kg × \(set.reps) 回")
                        }
                    }
                }
            }
            Section("メモ") {
                TextField("メモを入力", text: $session.memo, axis: .vertical)
            }
        }
        .navigationTitle(session.date.formatted(.dateTime.month().day().weekday(.wide)))
        .navigationBarTitleDisplayMode(.inline)
    }
}
