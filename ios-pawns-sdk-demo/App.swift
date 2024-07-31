import SwiftUI

@main
struct App: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear { UIScrollView.appearance().delaysContentTouches = false }
        }
    }
}
