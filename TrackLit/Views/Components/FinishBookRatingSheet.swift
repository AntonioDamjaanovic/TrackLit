//
//  FinishBookRatingSheet.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 31.05.2026..
//

import SwiftUI

struct FinishBookRatingSheet: View {

    let book: Book
    let onRated: (Int) -> Void

    @State private var rating: Int = 0
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 14) {
            Text("How would you rate?")
                .font(.title3)
            Text(book.title ?? "this book")
                .font(.title2.bold())
                .multilineTextAlignment(.center)

            InteractiveStarRatingView(rating: $rating)
                .padding(.vertical)

            Button {
                dismiss()
                onRated(rating)
            } label: {
                Text(rating == 0 ? "Skip rating" : "Save rating")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .foregroundStyle(.blue)
            .controlSize(.large)
        }
        .padding(24)
    }
}

#Preview {
    FinishBookRatingSheet(
        book: .example,
        onRated: { rating in
            print("User rated: \(rating)")
        }
    )
}
