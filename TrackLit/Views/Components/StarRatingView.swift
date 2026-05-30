//
//  StarRatingView.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 02.05.2026..
//

import SwiftUI

struct StarRatingView: View {
    
    let rating: Double
    private let maxStars = 5
    
    var body: some View {
        HStack {
            ForEach(1...maxStars, id: \.self) { star in
                PartialStarView(fill: fillAmount(for: star))
            }
        }
    }
    
    private func fillAmount(for star: Int) -> Double {
        let fill = rating - Double(star - 1)
        return min(max(fill, 0), 1)
    }
}

struct PartialStarView: View {
    let fill: Double
    
    var body: some View {
        ZStack {
            Image(systemName: "star")
                .foregroundStyle(.gray.opacity(0.3))
            
            Image(systemName: "star.fill")
                .foregroundStyle(.yellow)
                .mask(
                    GeometryReader { geo in
                        Rectangle()
                            .frame(width: geo.size.width * fill)
                    }
                )
        }
    }
}

#Preview {
    StarRatingView(rating: 3.5)
}
