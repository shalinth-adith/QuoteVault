//
//  BrowseView.swift
//  QuoteVault
//
//  MVVM Architecture - View for Browse
//

import SwiftUI

struct BrowseView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Browse by Category")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("Coming soon...")
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .navigationTitle("Browse")
        }
    }
}

#Preview {
    BrowseView()
}
