import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack { HomeView() }
                .tabItem { Label("ホーム", systemImage: "house.fill") }

            NavigationStack { HistoryView() }
                .tabItem { Label("履歴", systemImage: "calendar") }

            NavigationStack { ExerciseListView() }
                .tabItem { Label("種目", systemImage: "list.bullet") }

            NavigationStack { StatsView() }
                .tabItem { Label("統計", systemImage: "chart.bar.fill") }
        }
        .tint(.orange)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Exercise.self, WorkoutSession.self, WorkoutSet.self], inMemory: true)
}
