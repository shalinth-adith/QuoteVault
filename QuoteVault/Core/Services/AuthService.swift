//
//  AuthService.swift
//  QuoteVault
//
//  Created by Claude Code
//

import Foundation
import Supabase

class AuthService {
    private let client = SupabaseService.shared.client

    // MARK: - Sign Up
    func signUp(email: String, password: String, name: String?) async throws -> User {
        let authResponse = try await client.auth.signUp(
            email: email,
            password: password
        )

        let userId = authResponse.user.id

        // Wait a moment for the trigger to create the profile
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds

        // Update profile with name if provided
        if let name = name, !name.isEmpty {
            try await createUserProfile(userId: userId, email: email, name: name)
        }

        // Fetch the created profile
        return try await fetchUserProfile(userId: userId)
    }

    // MARK: - Sign In
    func signIn(email: String, password: String) async throws -> User {
        let session = try await client.auth.signIn(
            email: email,
            password: password
        )

        let userId = session.user.id

        // Fetch user profile
        let profile = try await fetchUserProfile(userId: userId)
        return profile
    }

    // MARK: - Sign Out
    func signOut() async throws {
        try await client.auth.signOut()
    }

    // MARK: - Password Reset
    func resetPassword(email: String) async throws {
        try await client.auth.resetPasswordForEmail(email)
    }

    // MARK: - Get Current User
    func getCurrentUser() async throws -> User? {
        guard let session = try? await client.auth.session else {
            return nil
        }

        let userId = session.user.id
        return try await fetchUserProfile(userId: userId)
    }

    // MARK: - Session Management
    func restoreSession() async throws -> User? {
        return try await getCurrentUser()
    }

    // MARK: - Profile Management
    private func createUserProfile(userId: UUID, email: String, name: String) async throws {
        // The database trigger automatically creates the profile
        // We just need to update the name if provided
        if !name.isEmpty {
            try await client
                .from("user_profiles")
                .update(["name": name])
                .eq("id", value: userId.uuidString)
                .execute()
        }
    }

    func fetchUserProfile(userId: UUID) async throws -> User {
        let response = try await client
            .from("user_profiles")
            .select()
            .eq("id", value: userId.uuidString)
            .single()
            .execute()

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let profile = try decoder.decode(User.self, from: response.data)
        return profile
    }

    func updateUserProfile(userId: UUID, name: String?, avatarURL: String?) async throws {
        var updates: [String: String] = [:]
        if let name = name {
            updates["name"] = name
        }
        if let avatarURL = avatarURL {
            updates["avatar_url"] = avatarURL
        }

        try await client
            .from("user_profiles")
            .update(updates)
            .eq("id", value: userId.uuidString)
            .execute()
    }
}

// MARK: - Auth Errors
enum AuthError: LocalizedError {
    case signUpFailed
    case signInFailed
    case invalidCredentials
    case userNotFound
    case networkError

    var errorDescription: String? {
        switch self {
        case .signUpFailed:
            return "Failed to create account. Please try again."
        case .signInFailed:
            return "Failed to sign in. Please check your credentials."
        case .invalidCredentials:
            return "Invalid email or password."
        case .userNotFound:
            return "User not found."
        case .networkError:
            return "Network error. Please check your connection."
        }
    }
}
