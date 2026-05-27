//
//  RegisterView.swift
//  Shelfie
//
//  Created by Antonio Damjanović on 25.05.2026..
//

import SwiftUI

struct RegisterScreen: View {
    
    @State private var viewModel = RegisterViewModel()
    
    var body: some View {
        VStack(spacing: 60) {
            header
            form
            submitButton
        }
        .padding()
        .setAppearanceTheme()
    }
    
    private var header: some View {
        VStack(spacing: 8) {
            Text("Welcome to Shelfie!")
                .font(.largeTitle.bold())
            
            Text("Create an account to star your reading journey")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    private var form: some View {
        VStack(spacing: 12) {
            TextField("Full name", text: $viewModel.name)
                .textContentType(.name)
                .textInputAutocapitalization(.words)
                .filledField()

            TextField("Email", text: $viewModel.email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .filledField()

            SecureField("Password", text: $viewModel.password)
                .textContentType(.password)
                .filledField()

            SecureField("Confirm password", text: $viewModel.confirmPassword)
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
            Task { await viewModel.register() }
        } label: {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else {
                Text("Create account")
                    .frame(maxWidth: .infinity)
            }
        }
        .buttonStyle(.glassProminent)
        .disabled(!viewModel.canSubmit)
        .controlSize(.large)
    }
}

#Preview {
    RegisterScreen()
}
