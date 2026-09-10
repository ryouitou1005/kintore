import SwiftUI
import SwiftData

struct HomeView: View {
    @Query(sort: \WorkoutSession.date, order: .reverse) private var sessions: [WorkoutSession]
    @Environment(\.modelContext) private var modelContext
    @State private var activeSession: WorkoutSession?

    private var thisWeekVolume: Double {
        let calendar = Calendar.current
        guard let weekStart = calendar.dateInterval(of: .weekOfYear, for: .now)?.start else { return 0 }
        return sessions
            .filter { $0.date >= weekStart }
            .reduce(0) { $0 + $1.totalVolume }
    }

    private var currentStreak: Int {
        let calendar = Calendar.current
        var streak = 0
        var day = calendar.startOfDay(for: .now)
        let workoutDays = Set(sessions.map { calendar.startOfDay(for: $0.date) })
        while workoutDays.contains(day) {
            streak += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: day) else { break }
            day = previous
        }
        return streak
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(Date.now.formatted(.dateTime.month(.wide).day().weekday(.wide)))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 12) {
                    StatCard(title: "今週のボリューム", value: "\(Int(thisWeekVolume)) kg", icon: "flame.fill", color: .orange)
                    StatCard(title: "連続日数", value: "\(currentStreak) 日", icon: "bolt.fill", color: .pink)
                }

                Button(action: startWorkout) {
                    Label("ワークアウトを開始", systemImage: "plus.circle.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)

                if sessions.isEmpty {
                    ContentUnavailableView(
                        "記録がありません",
                        systemImage: "figure.strengthtraining.traditional",
                        description: Text("「ワークアウトを開始」から最初の記録をつけましょう")
                    )
                    .padding(.top, 40)
                } else {
                    Text("最近のワークアウト")
                        .font(.headline)
                    ForEach(sessions.prefix(5)) { session in
                        NavigationLink(value: session) {
                            SessionRow(session: session)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("筋トレノート")
        .navigationDestination(for: WorkoutSession.self) { session in
            SessionDetailView(session: session)
        }
        .fullScreenCover(item: $activeSession) { session in
            ActiveWorkoutView(session: session)
        }
    }

    private func startWorkout() {
        let session = WorkoutSession()
        modelContext.insert(session)
        activeSession = session
    }
}
