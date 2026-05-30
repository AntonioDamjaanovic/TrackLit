//
//  LoginViewModel.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 25.05.2026..
//

import Foundation
import Observation
import FirebaseAuth

@MainActor
@Observable
class LoginViewModel {
    
    // Inputs
    var email = ""
    var password = ""
    
    // Outputs
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    
    var canSubmit: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    func login() async {
        guard validate() else { return }
        
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            errorMessage = mapError(error)
        }
    }
    
    private func validate() -> Bool {
        guard !isLoading else { return false }
        
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please fill in all fields."
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Please enter a valid email address."
            return false
        }
        
        guard password.count >= 6 else {
            errorMessage = "Password is too short."
            return false
        }
        
        return true
    }
    
    private func mapError(_ error: Error) -> String {
        guard let code = AuthErrorCode(rawValue: (error as NSError).code) else {
            return error.localizedDescription
        }
        
        switch code {
            case .invalidEmail: return "That email address looks invalid."
            case .wrongPassword: return "Password is incorrect."
            case .networkError: return "Network error. Please try again."
            default: return error.localizedDescription
        }
    }
}
