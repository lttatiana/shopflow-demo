import SwiftUI

@main
struct ShopFlowApp: App {
    @State private var selectedTab = 3

    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                Text("Home").tabItem { Label("Home", systemImage: "house") }.tag(0)
                Text("Browse").tabItem { Label("Browse", systemImage: "magnifyingglass") }.tag(1)
                Text("Cart").tabItem { Label("Cart", systemImage: "cart") }.tag(2)
                OrderHistoryView().tabItem { Label("Orders", systemImage: "doc.plaintext") }.tag(3)
                Text("Account").tabItem { Label("Account", systemImage: "person") }.tag(4)
            }
            .accentColor(.blue)
        }
    }
}
