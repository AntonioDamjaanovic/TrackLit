//
//  Extensions.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 05.05.2026..
//

import Foundation
import SwiftUI

// MARK: - helper to save theme
struct AppearanceThemeViewModifier: ViewModifier {
    
    @AppStorage(UserDefaultsKeys.appearanceTheme)
    private var appearanceTheme: AppearanceTheme = .system
    
    func body(content: Content) -> some View {
        content
            .preferredColorScheme(scheme())
    }
    
    func scheme() -> ColorScheme? {
        switch appearanceTheme {
            case .system:
                return nil
            case .dark:
                return .dark
            case .light:
                return .light
        }
    }
}

extension View {
    func setAppearanceTheme() -> some View {
        modifier(AppearanceThemeViewModifier())
    }
}

// MARK: - text field style
struct FilledFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension View {
    func filledField() -> some View {
        modifier(FilledFieldStyle())
    }
}

extension Encodable {
    func asDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else {
            return [:]
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            return json ?? [:]
        } catch {
            return [:]
        }
    }
}

extension Book {
    func with(userRating: Int, shelf: ShelfState, onPage: Int) -> Book {
        return Book(
            id: id,
            title: title,
            description: description,
            contributions: contributions,
            genres: genres,
            releaseYear: releaseYear,
            image: image,
            pages: pages,
            contentWarnings: contentWarnings,
            moods: moods,
            rating: rating,
            ratingsCount: ratingsCount,
            reviewsCount: reviewsCount,
            usersRead: usersRead,
            userRating: userRating,
            shelf: shelf,
            onPage: onPage
        )
    }
}
