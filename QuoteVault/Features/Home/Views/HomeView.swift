//
//  HomeView.swift
//  QuoteVault
//
//  MVVM Architecture - View for Home
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        // Daily Quote Card
                        if let dailyQuote = viewModel.dailyQuote {
                            DailyQuoteCardView(quote: dailyQuote)
                                .padding(.horizontal)
                                .padding(.top)
                        }

                        // Quote Feed Header
                        HStack {
                            Text("Discover Quotes")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding(.horizontal)

                        // Quotes List
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.quotes) { quote in
                                QuoteCardView(quote: quote)
                                    .padding(.horizontal)
                                    .onAppear {
                                        Task {
                                            await viewModel.loadMoreIfNeeded(currentQuote: quote)
                                        }
                                    }
                            }

                            // Loading indicator
                            if viewModel.isLoading {
                                ProgressView()
                                    .padding()
                            }

                            // No more quotes message
                            if !viewModel.hasMoreQuotes && !viewModel.quotes.isEmpty {
                                Text("You've reached the end!")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .padding()
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
                .refreshable {
                    await viewModel.refresh()
                }

                // Error message
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
                        Spacer()
                    }
                }
            }
            .navigationTitle("QuoteVault")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Daily Quote Card
struct DailyQuoteCardView: View {
    let quote: Quote
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "sun.max.fill")
                    .foregroundColor(.yellow)
                Text("Quote of the Day")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
            }

            Text("\"\(quote.text)\"")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.white)

            HStack {
                Text("— \(quote.author)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                Spacer()
                CategoryBadge(category: quote.category)
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [themeManager.primaryColor, themeManager.primaryColor.opacity(0.7)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .shadow(color: themeManager.primaryColor.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

// MARK: - Quote Card
struct QuoteCardView: View {
    let quote: Quote
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                CategoryBadge(category: quote.category)
                Spacer()
                Button(action: {
                    // TODO: Toggle favorite
                }) {
                    Image(systemName: quote.isFavorited ? "heart.fill" : "heart")
                        .foregroundColor(quote.isFavorited ? .red : .gray)
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
    }
}

// MARK: - Category Badge
struct CategoryBadge: View {
    let category: QuoteCategory

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: category.icon)
                .font(.caption2)
            Text(category.rawValue)
                .font(.caption)
                .fontWeight(.semibold)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(category.color)
        .cornerRadius(8)
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .environmentObject(ThemeManager())
            .environmentObject(AuthViewModel())
    }
}
