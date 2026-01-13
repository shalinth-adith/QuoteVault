//
//  SignUpView.swift
//  QuoteVault
//
//  MVVM Architecture - View for Sign Up
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var localError: String?

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 30) {
                    // Logo/Title
                    VStack(spacing: 10) {
                        Image(systemName: "person.badge.plus.fill")
                            .font(.system(size: 70))
                            .foregroundColor(.white)

                        Text("Create Account")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text("Join QuoteVault today")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.top, 40)

                    // Sign Up Form
                    VStack(spacing: 20) {
                        // Name Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)

                            HStack {
                                Image(systemName: "person")
                                    .foregroundColor(.white.opacity(0.7))
                                TextField("Enter your name", text: $name)
                                    .autocorrectionDisabled()
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                        }

                        // Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)

                            HStack {
                                Image(systemName: "envelope")
                                    .foregroundColor(.white.opacity(0.7))
                                TextField("Enter your email", text: $email)
                                    .textInputAutocapitalization(.never)
                                    .keyboardType(.emailAddress)
                                    .autocorrectionDisabled()
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                        }

                        // Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)

                            HStack {
                                Image(systemName: "lock")
                                    .foregroundColor(.white.opacity(0.7))

                                if showPassword {
                                    TextField("Create a password", text: $password)
                                        .foregroundColor(.white)
                                } else {
                                    SecureField("Create a password", text: $password)
                                        .foregroundColor(.white)
                                }

                                Button(action: { showPassword.toggle() }) {
                                    Image(systemName: showPassword ? "eye.slash" : "eye")
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)

                            Text("At least 6 characters")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }

                        // Confirm Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Confirm Password")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)

                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.white.opacity(0.7))

                                if showConfirmPassword {
                                    TextField("Confirm your password", text: $confirmPassword)
                                        .foregroundColor(.white)
                                } else {
                                    SecureField("Confirm your password", text: $confirmPassword)
                                        .foregroundColor(.white)
                                }

                                Button(action: { showConfirmPassword.toggle() }) {
                                    Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                        }

                        // Error Message
                        if let errorMessage = localError ?? authViewModel.errorMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(8)
                        }

                        // Sign Up Button
                        Button(action: {
                            handleSignUp()
                        }) {
                            HStack {
                                if authViewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                                } else {
                                    Text("Create Account")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.purple)
                            .cornerRadius(12)
                        }
                        .disabled(authViewModel.isLoading)

                        // Sign In Link
                        HStack {
                            Text("Already have an account?")
                                .foregroundColor(.white.opacity(0.9))
                            Button("Sign In") {
                                dismiss()
                            }
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        }
                        .font(.subheadline)
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 40)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(20)
                    .padding(.horizontal, 24)

                    Spacer()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func handleSignUp() {
        localError = nil
        authViewModel.clearError()

        // Validate passwords match
        if password != confirmPassword {
            localError = "Passwords don't match."
            return
        }

        Task {
            await authViewModel.signUp(email: email, password: password, name: name)
            if authViewModel.isAuthenticated {
                dismiss()
            }
        }
    }
}

#Preview {
    NavigationStack {
        SignUpView()
            .environmentObject(AuthViewModel())
    }
}
