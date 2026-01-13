//
//  ContentView.swift
//  QuoteVault
//
//  MVVM Architecture - Main Content View
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
        .environmentObject(ThemeManager())
}
