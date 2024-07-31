import SwiftUI
import Pawns

struct ContentView: View {
    
    private let pawns: Pawns = .init(
        apiKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZGsiOnRydWUsImV4cCI6MjAzNzM0NTYzMSwianRpIjoiMDFKM1E1RjBUNk42QjAwRFY5UUdQVkdZSFEiLCJpYXQiOjE3MjE5ODU2MzEsInN1YiI6IjAxR05WRTFTUk1KVlJCQUdORkYzRkM5VEhCIn0.L9W9TqoIROBo7plSLXE34SdekFR8YyHFm0XHU9mSmsQ"
    )
    
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
        
                        ZStack {
                            
                            Toggle(
                                isOn: .init(
                                    get: { self.pawns.isRunning },
                                    set: { _ in Task { await self.toggle() } }
                                ),
                                label: {
                                    EmptyView()
                                }
                            )
                            .labelsHidden()
                            .toggleStyle(.switch)
                            .opacity(self.status.isLoading ? .zero : 1)
                            
                            if self.status.isLoading {
                                ProgressView()
                            }
                        }
                    }
                }
                
                Button(
                    "Force Stop",
                    action: { self.pawns.stop() }
                )
                .font(.callout)
                .foregroundStyle(Color.red)
                
                Section {
                    events()
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
    
    private func toggle() async {
        if self.pawns.isRunning {
            self.pawns.stop()
        } else {
            self.statuses = []
            Task {
                for await status in await self.pawns.start() {
                    self.statuses.append(String(describing: status))
                    self.status = status
                    self.isPresented = status.isError
                }
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
        default:
            return "Not Running"
        }
    }
    
    var isOn: Bool {
        self == .running || self == .starting || self == .notRunning(.waitingForWifi)
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
