//
//  RegisterViewModel.swift
//  Shelfie
//
//  Created by Antonio Damjanović on 25.05.2026..
//

import Foundation
import Observation
import FirebaseAuth
import FirebaseFirestore

@MainActor
@Observable
class RegisterViewModel {
    
    // Inputs
    var name = ""
    var email = ""
    var password = ""
    var confirmPassword = ""
    
    // Outputs
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    
    var canSubmit: Bool {
        !name.isEmpty && !email.isEmpty
        && !password.isEmpty && !confirmPassword.isEmpty
    }
    
    func register() async {
        guard validate() else { return }
        
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            try await insertUserRecord(id: result.user.uid)
        } catch {
            errorMessage = mapError(error)
        }
    }
    
    private func insertUserRecord(id: String) async throws {
        let newUser = User(id: id, name: name, email: email, joined: Date().timeIntervalSince1970)
        
        try await Firestore.firestore()
            .collection("users")
            .document(id)
            .setData(newUser.asDictionary())
    }
    
    private func validate() -> Bool {
        guard !isLoading else { return false }
        
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              !confirmPassword.trimmingCharacters(in: .whitespaces).isEmpty else {
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
        
        guard password == confirmPassword else {
            errorMessage = "Passwords don't match."
            return false
        }
        
        return true
    }
    
    private func mapError(_ error: Error) -> String {
        guard let code = AuthErrorCode(rawValue: (error as NSError).code) else {
            return error.localizedDescription
        }
        
        switch code {
            case .emailAlreadyInUse: return "That email is already registered."
            case .invalidEmail: return "That email address looks invalid."
            case .weakPassword: return "Your password doesn't meet the requirements."
            case .networkError: return "Network error. Please try again."
            default: return error.localizedDescription
        }
    }
}
