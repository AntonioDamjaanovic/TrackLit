//
//  SettingsViewModel.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 26.05.2026..
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

@MainActor
@Observable
class SettingsViewModel {

    var state: LoadingState<User> = .idle
    private(set) var profileImage: UIImage?

    func loadProfileImage() {
        guard let url = getProfileImageURL(),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else { return }
        
        self.profileImage = image
    }

    func saveProfileImage(_ image: UIImage) {
        guard let url = getProfileImageURL(),
              let data = image.jpegData(compressionQuality: 0.85) else { return }
        
        do {
            try data.write(to: url, options: .atomic)
            self.profileImage = image
        } catch {
            print("Save profile image failed: \(error.localizedDescription)")
        }
    }

    private func getProfileImageURL() -> URL? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return docs?.appendingPathComponent("profile_\(uid).jpg")
    }

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
