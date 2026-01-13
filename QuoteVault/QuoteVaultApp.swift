//
//  QuoteVaultApp.swift
//  QuoteVault
//
//  MVVM Architecture - Main App Entry Point
//

import SwiftUI

@main
struct QuoteVaultApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            Group {
                if authViewModel.isLoading {
                    // Loading splash screen
                    SplashView()
                } else if authViewModel.isAuthenticated {
                    // Main app
                    ContentView()
                        .environmentObject(authViewModel)
                        .environmentObject(themeManager)
                } else {
                    // Authentication flow
                    LoginView()
                        .environmentObject(authViewModel)
                }
            }
            .preferredColorScheme(themeManager.colorScheme)
        }
    }
}

// MARK: - Splash View
struct SplashView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Image(systemName: "quote.bubble.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.white)

                Text("QuoteVault")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            }
        }
    }
}
