//
//  LoginView.swift
//  QuoteVault
//
//  MVVM Architecture - View for Login
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var showForgotPassword = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 30) {
                        // Logo/Title
                        VStack(spacing: 10) {
                            Image(systemName: "quote.bubble.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.white)

                            Text("QuoteVault")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Text("Your daily inspiration awaits")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(.top, 60)

                        // Login Form
                        VStack(spacing: 20) {
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
                                        TextField("Enter your password", text: $password)
                                            .foregroundColor(.white)
                                    } else {
                                        SecureField("Enter your password", text: $password)
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
                            }

                            // Forgot Password
                            HStack {
                                Spacer()
                                Button("Forgot Password?") {
                                    showForgotPassword = true
                                }
                                .font(.subheadline)
                                .foregroundColor(.white)
                            }

                            // Error Message
                            if let errorMessage = authViewModel.errorMessage {
                                Text(errorMessage)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background(Color.white.opacity(0.9))
                                    .cornerRadius(8)
                            }

                            // Login Button
                            Button(action: {
                                authViewModel.clearError()
                                Task {
                                    await authViewModel.signIn(email: email, password: password)
                                }
                            }) {
                                HStack {
                                    if authViewModel.isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                    } else {
                                        Text("Sign In")
                                            .fontWeight(.semibold)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.blue)
                                .cornerRadius(12)
                            }
                            .disabled(authViewModel.isLoading)

                            // Sign Up Link
                            HStack {
                                Text("Don't have an account?")
                                    .foregroundColor(.white.opacity(0.9))
                                NavigationLink("Sign Up") {
                                    SignUpView()
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
            .sheet(isPresented: $showForgotPassword) {
                ForgotPasswordView()
                    .environmentObject(authViewModel)
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
