//
//  Extensions.swift
//  Shelfie
//
//  Created by Antonio Damjanović on 05.05.2026..
//

import Foundation

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
    func with(userRating: Int, shelf: ShelfState) -> Book {
        return Book(
            id: id,
            title: title,
            description: description,
            contributions: contributions,
            genres: genres,
            featuredSeries: featuredSeries,
            releaseYear: releaseYear,
            image: image,
            pages: pages,
            isbns: isbns,
            contentWarnings: contentWarnings,
            moods: moods,
            rating: rating,
            ratingsCount: ratingsCount,
            reviewsCount: reviewsCount,
            usersRead: usersRead,
            featuredSeriesPosition: featuredSeriesPosition,
            userRating: userRating,
            shelf: shelf
        )
    }
}
