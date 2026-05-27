//
//  LoginScreen.swift
//  Shelfie
//
//  Created by Antonio Damjanović on 25.05.2026..
//

import SwiftUI

struct LoginScreen: View {
    
    @State private var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 60) {
                header
                form
                submitButton
                
                VStack {
                    Text("Don't have an account?")
                    NavigationLink("Create an account", destination: RegisterScreen())
                }
            }
            .padding()
        }
        .setAppearanceTheme()
    }
    
    private var header: some View {
        VStack(spacing: 8) {
            Text("Welcome to Shelfie!")
                .font(.largeTitle.bold())
            
            Text("Sign in to continue your reading journey")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    private var form: some View {
        VStack(spacing: 12) {
            TextField("Email", text: $viewModel.email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .filledField()

            SecureField("Password", text: $viewModel.password)
                .textContentType(.password)
                .filledField()

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.pink)
                    .font(.footnote)
            }
        }
    }
    
    private var submitButton: some View {
        Button {
            Task { await viewModel.login() }
        } label: {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else {
                Text("Sign in")
                    .frame(maxWidth: .infinity)
            }
        }
        .buttonStyle(.glassProminent)
        .disabled(!viewModel.canSubmit)
        .controlSize(.large)
    }
}

#Preview {
    LoginScreen()
}
