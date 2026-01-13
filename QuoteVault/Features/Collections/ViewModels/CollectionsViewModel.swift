//
//  CollectionsViewModel.swift
//  QuoteVault
//
//  MVVM Architecture - ViewModel for Collections
//

import Foundation
import Combine

@MainActor
class CollectionsViewModel: ObservableObject {
    @Published var collections: [QuoteCollection] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let collectionService = CollectionService()
    private var userId: UUID?

    // MARK: - Load Collections
    func loadCollections(userId: UUID) async {
        self.userId = userId
        isLoading = true
        errorMessage = nil

        do {
            collections = try await collectionService.fetchCollections(userId: userId)
        } catch {
            errorMessage = "Failed to load collections. Please try again."
            print("Error loading collections: \(error)")
        }

        isLoading = false
    }

    // MARK: - Create Collection
    func createCollection(name: String, userId: UUID) async -> Bool {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Collection name cannot be empty."
            return false
        }

        isLoading = true
        errorMessage = nil

        do {
            let newCollection = try await collectionService.createCollection(userId: userId, name: name)
            collections.insert(newCollection, at: 0)
            isLoading = false
            return true
        } catch {
            errorMessage = "Failed to create collection. Please try again."
            print("Error creating collection: \(error)")
            isLoading = false
            return false
        }
    }

    // MARK: - Delete Collection
    func deleteCollection(_ collection: QuoteCollection) async {
        do {
            try await collectionService.deleteCollection(collectionId: collection.id)
            collections.removeAll { $0.id == collection.id }
        } catch {
            errorMessage = "Failed to delete collection. Please try again."
            print("Error deleting collection: \(error)")
        }
    }

    // MARK: - Refresh
    func refresh(userId: UUID) async {
        await loadCollections(userId: userId)
    }
}
