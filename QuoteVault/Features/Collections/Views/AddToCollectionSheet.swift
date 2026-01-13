//
//  AddToCollectionSheet.swift
//  QuoteVault
//
//  Reusable component for adding quotes to collections
//

import SwiftUI

struct AddToCollectionSheet: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var themeManager: ThemeManager

    let quote: Quote
    @State private var collections: [QuoteCollection] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var successMessage: String?

    private let collectionService = CollectionService()

    var body: some View {
        NavigationStack {
            ZStack {
                if isLoading {
                    ProgressView()
                } else if collections.isEmpty {
                    // Empty State
                    VStack(spacing: 20) {
                        Image(systemName: "folder.badge.plus")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)

                        Text("No Collections Yet")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("Create a collection first to add quotes to it")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                } else {
                    // Collections List
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(collections) { collection in
                                Button(action: {
                                    Task {
                                        await addToCollection(collection)
                                    }
                                }) {
                                    HStack(spacing: 16) {
                                        // Icon
                                        ZStack {
                                            Circle()
                                                .fill(themeManager.primaryColor.opacity(0.2))
                                                .frame(width: 40, height: 40)

                                            Image(systemName: "folder.fill")
                                                .font(.body)
                                                .foregroundColor(themeManager.primaryColor)
                                        }

                                        // Collection Info
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(collection.name)
                                                .font(.headline)
                                                .foregroundColor(.primary)

                                            Text("\(collection.quoteCount) quotes")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }

                                        Spacer()

                                        // Arrow
                                        Image(systemName: "chevron.right")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .background(themeManager.secondaryBackgroundColor)
                                    .cornerRadius(12)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }

                // Success/Error Messages
                VStack {
                    Spacer()

                    if let successMessage = successMessage {
                        Text(successMessage)
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                            .padding()
                    }

                    if let errorMessage = errorMessage {
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
            .navigationTitle("Add to Collection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .task {
                await loadCollections()
            }
        }
    }

    // MARK: - Load Collections
    private func loadCollections() async {
        guard let userId = authViewModel.currentUser?.id else { return }

        isLoading = true
        errorMessage = nil

        do {
            collections = try await collectionService.fetchCollections(userId: userId)
        } catch {
            errorMessage = "Failed to load collections."
            print("Error loading collections: \(error)")
        }

        isLoading = false
    }

    // MARK: - Add to Collection
    private func addToCollection(_ collection: QuoteCollection) async {
        errorMessage = nil
        successMessage = nil

        do {
            try await collectionService.addQuoteToCollection(
                collectionId: collection.id,
                quoteId: quote.id
            )

            successMessage = "Added to \(collection.name)"

            // Dismiss after a short delay
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            dismiss()
        } catch {
            errorMessage = "Failed to add quote to collection."
            print("Error adding to collection: \(error)")
        }
    }
}

#Preview {
    AddToCollectionSheet(
        quote: Quote(
            text: "The only way to do great work is to love what you do.",
            author: "Steve Jobs",
            category: .motivation
        )
    )
    .environmentObject(AuthViewModel())
    .environmentObject(ThemeManager())
}
