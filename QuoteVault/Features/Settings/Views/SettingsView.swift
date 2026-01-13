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
    @StateObject private var notificationManager = NotificationManager.shared
    @State private var showThemePicker = false
    @State private var showFontSizePicker = false

    var body: some View {
        NavigationStack {
            List {
                // User Profile Section
                Section {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(themeManager.primaryColor)

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
                    Button(action: {
                        showThemePicker = true
                    }) {
                        HStack {
                            Label("Theme", systemImage: "paintbrush.fill")
                                .foregroundColor(.primary)
                            Spacer()
                            Text(themeManager.currentTheme.rawValue)
                                .foregroundColor(.secondary)
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }

                    Button(action: {
                        showFontSizePicker = true
                    }) {
                        HStack {
                            Label("Font Size", systemImage: "textformat.size")
                                .foregroundColor(.primary)
                            Spacer()
                            Text(themeManager.fontSize.rawValue)
                                .foregroundColor(.secondary)
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }

                // Notifications Section
                Section("Notifications") {
                    Toggle(isOn: Binding(
                        get: { notificationManager.notificationsEnabled },
                        set: { newValue in
                            Task {
                                await notificationManager.setNotificationsEnabled(newValue)
                            }
                        }
                    )) {
                        Label("Daily Quote Reminder", systemImage: "bell.fill")
                    }
                    .tint(themeManager.primaryColor)

                    if notificationManager.notificationsEnabled {
                        DatePicker(
                            "Notification Time",
                            selection: Binding(
                                get: { notificationManager.notificationTime },
                                set: { newValue in
                                    Task {
                                        await notificationManager.updateNotificationTime(newValue)
                                    }
                                }
                            ),
                            displayedComponents: .hourAndMinute
                        )
                        .labelled(with: "clock.fill")

                        Text("You'll receive a daily reminder at this time")
                            .font(.caption)
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
                            Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
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
                        Label("Version", systemImage: "info.circle")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Label("Developer", systemImage: "hammer")
                        Spacer()
                        Text("QuoteVault Team")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showThemePicker) {
                ThemePickerView()
            }
            .sheet(isPresented: $showFontSizePicker) {
                FontSizePickerView()
            }
        }
    }
}

// MARK: - Theme Picker View
struct ThemePickerView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        NavigationStack {
            List {
                ForEach(UserSettings.AppTheme.allCases, id: \.self) { theme in
                    Button(action: {
                        themeManager.currentTheme = theme
                        dismiss()
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(theme.rawValue)
                                    .font(.headline)
                                    .foregroundColor(.primary)

                                if let description = themeDescription(for: theme) {
                                    Text(description)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }

                            Spacer()

                            if themeManager.currentTheme == theme {
                                Image(systemName: "checkmark")
                                    .foregroundColor(themeManager.primaryColor)
                                    .fontWeight(.semibold)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Choose Theme")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func themeDescription(for theme: UserSettings.AppTheme) -> String? {
        switch theme {
        case .light:
            return "Always use light mode"
        case .dark:
            return "Always use dark mode"
        case .system:
            return "Match system appearance"
        case .ocean:
            return "Calm blue ocean vibes"
        case .sunset:
            return "Warm sunset colors"
        }
    }
}

// MARK: - Font Size Picker View
struct FontSizePickerView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        NavigationStack {
            List {
                ForEach(UserSettings.FontSize.allCases, id: \.self) { size in
                    Button(action: {
                        themeManager.fontSize = size
                        dismiss()
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(size.rawValue)
                                    .font(.system(size: 17 * size.scale))
                                    .foregroundColor(.primary)

                                Text("Sample quote text")
                                    .font(.system(size: 15 * size.scale))
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            if themeManager.fontSize == size {
                                Image(systemName: "checkmark")
                                    .foregroundColor(themeManager.primaryColor)
                                    .fontWeight(.semibold)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Choose Font Size")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Helper Extension for DatePicker with Label
extension DatePicker {
    func labelled(with iconName: String) -> some View {
        HStack {
            Image(systemName: iconName)
            self
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthViewModel())
        .environmentObject(ThemeManager())
}
