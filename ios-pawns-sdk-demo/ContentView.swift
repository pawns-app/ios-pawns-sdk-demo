import SwiftUI
import Pawns

struct ContentView: View {
    
    @State private var status: Pawns.Status = .notRunning(.stopped)
    @State private var isPresented: Bool = false
    @State private var statuses: [String] = []
    
    init() {
        
        Pawns.Preferences.isLoggingEnabled = true
//        Pawns.Preferences.useWifiOnly = true
//        Pawns.Preferences.useLowPowerMode = true
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            List {
                
                Section {
                    HStack {
                        
                        Text("Status")
                            .font(.callout)
                        
                        Spacer()
                        
                        Text(self.status.localised)
                            .font(.subheadline)
                            .foregroundStyle(Color.secondary)
        
                        if self.status.isLoading {
                            ProgressView()
                        }
                    }
                    
                    if !Pawns.isRunning() {
                        Button(
                            "Connect",
                            action: { Task { await self.connect() } }
                        )
                        .font(.callout)
                    }
                }
                
                Button(
                    "Force Stop",
                    action: { Pawns.stop() }
                )
                .font(.callout)
                .foregroundStyle(Color.red)
                
                if !self.statuses.isEmpty {
                    Section(
                        header: Text("Events"),
                        content: events
                    )
                }
                
            }
            .navigationTitle("Pawns")
        }
        .alert(
            "Error",
            isPresented: self.$isPresented,
            actions: { Button("Close") { self.isPresented = false } },
            message: { Text(String(describing: self.status)) })
    }
    
    private func events() -> some View {
        ForEach(statuses, id: \.self) { Text($0) }
    }
    
    // MARK: - API
    
    private func connect() async {
        self.statuses = []
        Task {
            for await status in await Pawns.start() {
                self.statuses.append(String(describing: status))
                self.status = status
                self.isPresented = status.isError
            }
        }
    }
    
}


// MARK: - Status

private extension Pawns.Status {
    
    var localised: String {
        switch self {
        case .starting:
            return "Starting"
        case .running:
            return "Running"
        case .notRunning(.waitingForWifi):
            return "Waiting For Wi-Fi"
        case .notRunning(.detectedVPN):
            return "VPN detected"
        default:
            return "Not Running"
        }
    }
    
    var isOn: Bool {
        self == .running || self == .starting || self == .notRunning(.waitingForWifi) || self == .notRunning(.detectedVPN)
    }
    
    var isLoading: Bool {
        self == .starting || self == .notRunning(.waitingForWifi)
    }
    
    var isError: Bool {
        
        let statuses: [Pawns.Status] = [
            .notRunning(.ipUsed),
            .notRunning(.unauthorized),
            .notRunning(.nonResidentialIp),
            .notRunning(.cantGetFreePort),
            .notRunning(.cantOpenPort),
        ]
            
        return statuses.contains(self)
    }
    
}
