import SwiftUI

enum Screen: String, RawRepresentable {
    case home
    case detail
}

@main
struct PathRestore: App {
    @AppStorage("path") private var appNavigationPath: String?

    var appNavigation: [Screen] {
        get {
            if appNavigationPath == nil || appNavigationPath!.isEmpty {
                return []
            }
            return (appNavigationPath ?? String(Screen.home.rawValue)).split(separator: ".")
                .compactMap { Screen(rawValue: String($0)) }
        }
    }

    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                Text("Menu")
            } detail: {
                NavigationStack(
                    path: Binding(
                        get: { appNavigation },
                        set: { newValue in
                            appNavigationPath = newValue.map(\.rawValue).joined(separator: ".")
                        })
                ) {
                    NavigationLink(value: Screen.detail) {
                        Text("Next")
                    }
                    .navigationDestination(for: Screen.self) { _ in
                        Text("Detail")
                    }
                }
            }
            .font(.largeTitle)
        }
    }
}
