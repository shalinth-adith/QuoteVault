//
//  CollectionsView.swift
//  QuoteVault
//
//  MVVM Architecture - View for Collections
//

import SwiftUI

struct CollectionsView: View {
    @StateObject private var viewModel = CollectionsViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showCreateCollection = false

    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.collections.isEmpty {
                    // Empty State
                    VStack(spacing: 20) {
                        Image(systemName: "folder.badge.plus")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)

                        Text("No Collections Yet")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("Organize your favorite quotes into custom collections")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)

                        Button(action: {
                            showCreateCollection = true
                        }) {
                            Label("Create Collection", systemImage: "plus.circle.fill")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(themeManager.primaryColor)
                                .cornerRadius(12)
                        }
                        .padding(.top)
                    }
                } else {
                    // Collections List
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.collections) { collection in
                                NavigationLink(destination: CollectionDetailView(collection: collection)) {
                                    CollectionCard(collection: collection)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
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
            .navigationTitle("Collections")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showCreateCollection = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showCreateCollection) {
                CreateCollectionView(viewModel: viewModel)
                    .environmentObject(authViewModel)
            }
            .task {
                if let userId = authViewModel.currentUser?.id {
                    await viewModel.loadCollections(userId: userId)
                }
            }
        }
    }
}

// MARK: - Collection Card
struct CollectionCard: View {
    let collection: QuoteCollection
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(themeManager.primaryColor.opacity(0.2))
                    .frame(width: 50, height: 50)

                Image(systemName: "folder.fill")
                    .font(.title3)
                    .foregroundColor(themeManager.primaryColor)
            }

            // Collection Info
            VStack(alignment: .leading, spacing: 4) {
                Text(collection.name)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text("\(collection.quoteCount) quotes")
                    .font(.subheadline)
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
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Create Collection View
struct CreateCollectionView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var viewModel: CollectionsViewModel

    @State private var collectionName = ""
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "folder.badge.plus")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                    .padding(.top, 40)

                Text("New Collection")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Give your collection a name")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                TextField("Collection name", text: $collectionName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 32)
                    .focused($isTextFieldFocused)

                Button(action: {
                    Task {
                        if let userId = authViewModel.currentUser?.id {
                            let success = await viewModel.createCollection(name: collectionName, userId: userId)
                            if success {
                                dismiss()
                            }
                        }
                    }
                }) {
                    Text("Create")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(collectionName.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(collectionName.isEmpty || viewModel.isLoading)
                .padding(.horizontal, 32)

                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                isTextFieldFocused = true
            }
        }
    }
}

#Preview {
    CollectionsView()
        .environmentObject(AuthViewModel())
        .environmentObject(ThemeManager())
}
