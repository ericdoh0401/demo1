import SwiftUI

@main
struct AppEntry: App {
    @AppStorage("yourName") var yourName = ""
    @StateObject var game = GameService()

    var body: some Scene {
        WindowGroup {
            if yourName.isEmpty {
                SetUpUserID()
            } else {
                ContentView(yourName: yourName)
                    .environmentObject(game)
            }
        }
    }
}
