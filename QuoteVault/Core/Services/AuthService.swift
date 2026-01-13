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

        guard let userId = authResponse.user?.id else {
            throw AuthError.signUpFailed
        }

        // Create user profile
        if let name = name {
            try await createUserProfile(userId: userId, email: email, name: name)
        }

        return User(id: userId, email: email, name: name)
    }

    // MARK: - Sign In
    func signIn(email: String, password: String) async throws -> User {
        let session = try await client.auth.signIn(
            email: email,
            password: password
        )

        guard let userId = session.user.id else {
            throw AuthError.signInFailed
        }

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
        guard let session = try? await client.auth.session,
              let userId = session.user.id else {
            return nil
        }

        return try await fetchUserProfile(userId: userId)
    }

    // MARK: - Session Management
    func restoreSession() async throws -> User? {
        return try await getCurrentUser()
    }

    // MARK: - Profile Management
    private func createUserProfile(userId: UUID, email: String, name: String) async throws {
        let profile: [String: Any] = [
            "id": userId.uuidString,
            "email": email,
            "name": name,
            "settings": try JSONEncoder().encode(UserSettings())
        ]

        try await client
            .from("user_profiles")
            .insert(profile)
            .execute()
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
        var updates: [String: Any] = [:]
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
