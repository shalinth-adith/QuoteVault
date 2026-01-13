//
//  MainTabView.swift
//  QuoteVault
//
//  MVVM Architecture - Main Tab Navigation
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            // Browse Tab
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "square.grid.2x2.fill")
                }
                .tag(1)

            // Favorites Tab
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
                .tag(2)

            // Collections Tab
            CollectionsView()
                .tabItem {
                    Label("Collections", systemImage: "folder.fill")
                }
                .tag(3)

            // Settings Tab
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(4)
        }
        .accentColor(themeManager.primaryColor)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthViewModel())
        .environmentObject(ThemeManager())
}
