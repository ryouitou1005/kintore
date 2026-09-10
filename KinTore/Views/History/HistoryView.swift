import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \WorkoutSession.date, order: .reverse) private var sessions: [WorkoutSession]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        List {
            ForEach(sessions) { session in
                NavigationLink(value: session) {
                    SessionRow(session: session)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .onDelete(perform: deleteSessions)
        }
        .listStyle(.plain)
        .navigationTitle("履歴")
        .navigationDestination(for: WorkoutSession.self) { session in
            SessionDetailView(session: session)
        }
        .overlay {
            if sessions.isEmpty {
                ContentUnavailableView("履歴がありません", systemImage: "calendar", description: Text("ワークアウトを記録すると、ここに表示されます"))
            }
        }
    }

    private func deleteSessions(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(sessions[index])
        }
    }
}
