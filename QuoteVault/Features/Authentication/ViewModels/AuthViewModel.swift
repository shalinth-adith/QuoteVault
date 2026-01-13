//
//  AuthViewModel.swift
//  QuoteVault
//
//  MVVM Architecture - ViewModel for Authentication
//

import Foundation
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let authService = AuthService()

    init() {
        Task {
            await checkAuthStatus()
        }
    }

    // MARK: - Check Auth Status
    func checkAuthStatus() async {
        isLoading = true
        do {
            if let user = try await authService.restoreSession() {
                currentUser = user
                isAuthenticated = true
            }
        } catch {
            print("Session restore failed: \(error)")
        }
        isLoading = false
    }

    // MARK: - Sign Up
    func signUp(email: String, password: String, name: String) async {
        guard validateSignUp(email: email, password: password, name: name) else { return }

        isLoading = true
        errorMessage = nil

        do {
            let user = try await authService.signUp(email: email, password: password, name: name)
            currentUser = user
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Sign In
    func signIn(email: String, password: String) async {
        guard validateSignIn(email: email, password: password) else { return }

        isLoading = true
        errorMessage = nil

        do {
            let user = try await authService.signIn(email: email, password: password)
            currentUser = user
            isAuthenticated = true
        } catch {
            errorMessage = "Invalid email or password. Please try again."
        }

        isLoading = false
    }

    // MARK: - Sign Out
    func signOut() async {
        isLoading = true

        do {
            try await authService.signOut()
            currentUser = nil
            isAuthenticated = false
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Password Reset
    func resetPassword(email: String) async -> Bool {
        guard validateEmail(email) else {
            errorMessage = "Please enter a valid email address."
            return false
        }

        isLoading = true
        errorMessage = nil

        do {
            try await authService.resetPassword(email: email)
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }

    // MARK: - Validation
    private func validateSignUp(email: String, password: String, name: String) -> Bool {
        if name.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage = "Please enter your name."
            return false
        }

        if !validateEmail(email) {
            errorMessage = "Please enter a valid email address."
            return false
        }

        if password.count < 6 {
            errorMessage = "Password must be at least 6 characters."
            return false
        }

        return true
    }

    private func validateSignIn(email: String, password: String) -> Bool {
        if !validateEmail(email) {
            errorMessage = "Please enter a valid email address."
            return false
        }

        if password.isEmpty {
            errorMessage = "Please enter your password."
            return false
        }

        return true
    }

    private func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    // MARK: - Clear Error
    func clearError() {
        errorMessage = nil
    }
}
