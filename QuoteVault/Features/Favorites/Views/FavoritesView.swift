//
//  FavoritesView.swift
//  QuoteVault
//
//  MVVM Architecture - View for Favorites
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.favorites.isEmpty {
                    // Empty State
                    VStack(spacing: 20) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)

                        Text("No Favorites Yet")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("Start adding quotes to your favorites by tapping the heart icon")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                } else {
                    // Favorites List
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.favorites) { quote in
                                FavoriteQuoteCard(quote: quote) {
                                    if let userId = authViewModel.currentUser?.id {
                                        Task {
                                            await viewModel.toggleFavorite(quote, userId: userId)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                    .refreshable {
                        if let userId = authViewModel.currentUser?.id {
                            await viewModel.refresh(userId: userId)
                        }
                    }
                }

                // Error Message
                if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Spacer()
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                            .padding()
                    }
                }
            }
            .navigationTitle("Favorites")
            .task {
                if let userId = authViewModel.currentUser?.id {
                    await viewModel.loadFavorites(userId: userId)
                }
            }
        }
    }
}

// MARK: - Favorite Quote Card
struct FavoriteQuoteCard: View {
    let quote: Quote
    let onUnfavorite: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showAddToCollection = false
    @State private var showShareSheet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                CategoryBadge(category: quote.category)
                Spacer()

                // Share Button
                Button(action: {
                    showShareSheet = true
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(themeManager.primaryColor)
                }
                .padding(.trailing, 8)

                // Add to Collection Button
                Button(action: {
                    showAddToCollection = true
                }) {
                    Image(systemName: "folder.badge.plus")
                        .foregroundColor(themeManager.primaryColor)
                }
                .padding(.trailing, 8)

                // Unfavorite Button
                Button(action: onUnfavorite) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                }
            }

            Text("\"\(quote.text)\"")
                .font(.body)
                .foregroundColor(.primary)

            HStack {
                Text("— \(quote.author)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
        .padding(16)
        .background(themeManager.secondaryBackgroundColor)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .sheet(isPresented: $showAddToCollection) {
            AddToCollectionSheet(quote: quote)
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(quote: quote)
        }
    }
}

#Preview {
    FavoritesView()
        .environmentObject(AuthViewModel())
        .environmentObject(ThemeManager())
}
