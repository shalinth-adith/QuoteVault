//
//  FavoritesView.swift
//  QuoteVault
//
//  MVVM Architecture - View for Favorites
//

import SwiftUI

struct FavoritesView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.red)

                    Text("Your Favorites")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("Coming soon...")
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    FavoritesView()
}
