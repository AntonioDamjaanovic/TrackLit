//
//  SettingsViewModel.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 26.05.2026..
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
@Observable
class SettingsViewModel {
    
    var state: LoadingState<User> = .idle
    
    func fetchUserData() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        self.state = .loading
        
        do {
            let userDocument = try await Firestore.firestore()
                .collection("users")
                .document(uid)
                .getDocument()
            
            let user = try userDocument.data(as: User.self)
            
            self.state = .loaded(user)
            print("Fetch succesfull")
        } catch {
            self.state = .error(error.localizedDescription)
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Logout failed: \(error.localizedDescription)")
        }
    }
}
