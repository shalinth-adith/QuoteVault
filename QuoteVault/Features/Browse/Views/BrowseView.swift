//
//  BrowseView.swift
//  QuoteVault
//
//  MVVM Architecture - View for Browse
//

import SwiftUI

struct BrowseView: View {
    @StateObject private var viewModel = BrowseViewModel()
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)

                    TextField("Search quotes or authors...", text: $viewModel.searchText)
                        .textFieldStyle(PlainTextFieldStyle())

                    if !viewModel.searchText.isEmpty {
                        Button(action: {
                            viewModel.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top)

                ScrollView {
                    VStack(spacing: 20) {
                        // Categories Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Browse by Category")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Spacer()
                                if viewModel.selectedCategory != nil {
                                    Button("Clear") {
                                        Task {
                                            await viewModel.selectCategory(nil)
                                        }
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(themeManager.primaryColor)
                                }
                            }
                            .padding(.horizontal)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(QuoteCategory.allCases) { category in
                                        CategoryChip(
                                            category: category,
                                            isSelected: viewModel.selectedCategory == category
                                        ) {
                                            Task {
                                                await viewModel.selectCategory(
                                                    viewModel.selectedCategory == category ? nil : category
                                                )
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.top)

                        // Results Section
                        if viewModel.isLoading {
                            ProgressView()
                                .padding()
                        } else if let errorMessage = viewModel.errorMessage {
                            VStack(spacing: 12) {
                                Image(systemName: "exclamationmark.triangle")
                                    .font(.system(size: 40))
                                    .foregroundColor(.orange)
                                Text(errorMessage)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                        } else if viewModel.quotes.isEmpty {
                            if !viewModel.searchText.isEmpty || viewModel.selectedCategory != nil {
                                VStack(spacing: 12) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 40))
                                        .foregroundColor(.gray)
                                    Text("No quotes found")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                            } else {
                                VStack(spacing: 12) {
                                    Image(systemName: "square.grid.2x2")
                                        .font(.system(size: 40))
                                        .foregroundColor(.gray)
                                    Text("Select a category or search to explore quotes")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                }
                                .padding()
                            }
                        } else {
                            // Results Header
                            HStack {
                                Text("\(viewModel.quotes.count) quotes found")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            .padding(.horizontal)

                            // Quotes List
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.quotes) { quote in
                                    QuoteCardView(quote: quote)
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Browse")
        }
    }
}

// MARK: - Category Chip
struct CategoryChip: View {
    let category: QuoteCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.caption)
                Text(category.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .foregroundColor(isSelected ? .white : category.color)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? category.color : category.color.opacity(0.15))
            .cornerRadius(20)
        }
    }
}

#Preview {
    BrowseView()
        .environmentObject(ThemeManager())
}
