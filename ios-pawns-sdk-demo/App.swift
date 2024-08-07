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
        
        Pawns.setup(apiKey: "api_key")
        
        return true
    }
    
}
