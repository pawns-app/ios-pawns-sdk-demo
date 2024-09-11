import SwiftUI
import Pawns

@main
struct App: SwiftUI.App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear { UIScrollView.appearance().delaysContentTouches = false }
        }
    }
    
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Use this key only for testing purposes.
        Pawns.setup(apiKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZGsiOnRydWUsImV4cCI6MjAzNzM0NTYzMSwianRpIjoiMDFKM1E1RjBUNk42QjAwRFY5UUdQVkdZSFEiLCJpYXQiOjE3MjE5ODU2MzEsInN1YiI6IjAxR05WRTFTUk1KVlJCQUdORkYzRkM5VEhCIn0.L9W9TqoIROBo7plSLXE34SdekFR8YyHFm0XHU9mSmsQ")
        
        return true
    }
    
}
