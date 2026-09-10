import SwiftUI
import SwiftData
import Charts

private struct DailyVolume: Identifiable {
    let date: Date
    let volume: Double
    var id: Date { date }
}

private struct PersonalRecord: Identifiable {
    let exercise: Exercise
    let maxWeight: Double
    var id: PersistentIdentifier { exercise.persistentModelID }
}

struct StatsView: View {
    @Query(sort: \WorkoutSession.date) private var sessions: [WorkoutSession]

    private var dailyVolumes: [DailyVolume] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: sessions) { calendar.startOfDay(for: $0.date) }
        let items = grouped
            .map { DailyVolume(date: $0.key, volume: $0.value.reduce(0) { $0 + $1.totalVolume }) }
            .sorted { $0.date < $1.date }
        return Array(items.suffix(30))
    }

    private var personalRecords: [PersonalRecord] {
        var best: [PersistentIdentifier: PersonalRecord] = [:]
        for session in sessions {
            for set in session.sets ?? [] {
                guard let exercise = set.exercise else { continue }
                if let current = best[exercise.persistentModelID], current.maxWeight >= set.weight {
                    continue
                }
                best[exercise.persistentModelID] = PersonalRecord(exercise: exercise, maxWeight: set.weight)
            }
        }
        return best.values.sorted { $0.maxWeight > $1.maxWeight }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                if sessions.isEmpty {
                    ContentUnavailableView(
                        "データがありません",
                        systemImage: "chart.bar",
                        description: Text("ワークアウトを記録すると統計が表示されます")
                    )
                    .padding(.top, 60)
                } else {
                    volumeChartCard
                    personalRecordsCard
                }
            }
            .padding()
        }
        .navigationTitle("統計")
    }

    private var volumeChartCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ボリューム推移（直近30日）")
                .font(.headline)
            Chart(dailyVolumes) { item in
                LineMark(x: .value("日付", item.date), y: .value("ボリューム", item.volume))
                    .foregroundStyle(.orange)
                    .interpolationMethod(.catmullRom)
                PointMark(x: .value("日付", item.date), y: .value("ボリューム", item.volume))
                    .foregroundStyle(.orange)
            }
            .frame(height: 200)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var personalRecordsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("自己ベスト（最大重量）")
                .font(.headline)
            VStack(spacing: 10) {
                ForEach(personalRecords) { record in
                    HStack {
                        Text(record.exercise.name)
                        Spacer()
                        Text("\(record.maxWeight.formatted()) kg")
                            .bold()
                            .foregroundStyle(.orange)
                    }
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
