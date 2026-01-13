//
//  SettingsView.swift
//  QuoteVault
//
//  MVVM Architecture - View for Settings
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        NavigationStack {
            List {
                // User Profile Section
                Section {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.blue)

                        VStack(alignment: .leading) {
                            Text(authViewModel.currentUser?.name ?? "User")
                                .font(.headline)
                            Text(authViewModel.currentUser?.email ?? "")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.leading, 8)
                    }
                    .padding(.vertical, 8)
                }

                // Appearance Section
                Section("Appearance") {
                    HStack {
                        Text("Theme")
                        Spacer()
                        Text(themeManager.currentTheme.rawValue)
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Font Size")
                        Spacer()
                        Text(themeManager.fontSize.rawValue)
                            .foregroundColor(.secondary)
                    }
                }

                // Account Section
                Section("Account") {
                    Button(action: {
                        Task {
                            await authViewModel.signOut()
                        }
                    }) {
                        HStack {
                            Text("Sign Out")
                                .foregroundColor(.red)
                            Spacer()
                            if authViewModel.isLoading {
                                ProgressView()
                            }
                        }
                    }
                    .disabled(authViewModel.isLoading)
                }

                // App Info Section
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthViewModel())
        .environmentObject(ThemeManager())
}
