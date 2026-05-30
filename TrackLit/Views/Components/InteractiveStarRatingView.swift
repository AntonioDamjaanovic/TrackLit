//
//  InteractiveStarRatingView.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 09.05.2026..
//

import SwiftUI

struct InteractiveStarRatingView: View {
    
    @Binding var rating: Int
    private let maxStars = 5
    
    var body: some View {
        HStack {
            ForEach(1...maxStars, id: \.self) { star in
                Image(systemName: star <= rating ? "star.fill" : "star")
                    .foregroundStyle(star <= rating ? .yellow : .gray.opacity(0.3))
                    .onTapGesture {
                        if rating == star {
                            rating = 0
                        } else {
                            rating = star
                        }
                    }
            }
        }
    }
}

#Preview {
    @Previewable @State var rating: Int = 3
    InteractiveStarRatingView(rating: $rating)
}
