import SwiftUI

extension [Screen]: @retroactive RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
            let result = try? JSONDecoder().decode([Screen].self, from: data)
        else { return nil }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
            let result = String(data: data, encoding: .utf8)
        else { return "[]" }
        return result
    }
}

enum Screen: String, Codable, Hashable, CaseIterable, Identifiable {
    case home
    case detail // (id: Int)

    var id: String { rawValue }
}

@main
struct PathRestore: App {
    @AppStorage("path") private var path = [Screen]()
    @AppStorage("selection") private var selection: Screen?

    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                List(Screen.allCases) { screen in
                    Button(screen.rawValue.capitalized) {
                        selection = screen
                        path = []
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(screen == selection ? .primary : .secondary)
                }
            } detail: {
                NavigationStack(path: $path) {
                    NavigationLink(selection?.rawValue ?? "", value: selection)
                    .navigationDestination(for: Screen.self) {
                        Text($0.rawValue.uppercased())
                    }
                }
            }
            .font(.largeTitle)
        }
    }
}
