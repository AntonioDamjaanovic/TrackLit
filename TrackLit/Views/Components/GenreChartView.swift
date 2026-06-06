//
//  GenreChartView.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 06.06.2026..
//

import SwiftUI
import Charts

struct GenreChartView: View {
    
    let genreCounts: [GenreCount]
    
    private var topGenres: [GenreCount] {
        Array(genreCounts.prefix(8))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Top genres")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            Chart(topGenres) { item in
                BarMark(
                    x: .value("Books", item.count),
                    y: .value("Genre", item.genre)
                )
                .foregroundStyle(.blue.gradient)
                .cornerRadius(6)
                .annotation(position: .trailing, alignment: .leading) {
                    Text("\(item.count)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis {
                AxisMarks { _ in
                    AxisValueLabel()
                }
            }
            .frame(height: CGFloat(topGenres.count) * 36)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.regularMaterial, in: .rect(cornerRadius: 16))
        .padding()
    }
}

#Preview {
    GenreChartView(genreCounts: [
        GenreCount(genre: "Fantasy", count: 5),
        GenreCount(genre: "Science Fiction", count: 4),
        GenreCount(genre: "Mystery", count: 3),
        GenreCount(genre: "Literary Fiction", count: 2),
        GenreCount(genre: "Horror", count: 1)
    ])
}
