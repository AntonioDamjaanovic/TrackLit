//
//  StatsScreen.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 06.06.2026..
//

import SwiftUI

struct StatsScreen: View {
    
    @State private var viewModel = StatsViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                switch viewModel.state {
                case .idle:
                    Text("Your reading stats will be shown here.")
                        .foregroundStyle(.secondary)
                    
                case .loading:
                    ProgressView()
                    
                case .loaded(let readingStats):
                    ReadingStatsView(readingStats: readingStats)
                    
                case .error(let error):
                    Text(error)
                        .foregroundStyle(.pink)
                }
            }
            .navigationTitle("Stats")
            .task {
                await viewModel.fetchUserStats()
            }
        }
    }
}

private struct ReadingStatsView: View {
    
    let readingStats: ReadingStats
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                StatCard(
                    icon: "books.vertical.fill",
                    tint: .blue,
                    value: "\(readingStats.booksRead)",
                    label: "Books read"
                )
                
                StatCard(
                    icon: "doc.text.fill",
                    tint: .green,
                    value: readingStats.pagesRead.formatted(),
                    label: "Pages read"
                )
                
                StatCard(
                    icon: "star.fill",
                    tint: .yellow,
                    value: readingStats.averageRating.formatted(.number.precision(.fractionLength(1))),
                    label: "Average rating"
                )
                
                StatCard(
                    icon: "book.fill",
                    tint: .purple,
                    value: ReadingLevel(pagesRead: readingStats.pagesRead).rawValue,
                    label: "Reading level"
                )
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            if !readingStats.genreCounts.isEmpty {
                GenreChartView(genreCounts: readingStats.genreCounts)
            }

            if !readingStats.monthlyReadCounts.isEmpty {
                MonthlyReadChartView(monthlyReadCounts: readingStats.monthlyReadCounts)
            }
        }
    }
}

private struct StatCard: View {
    
    let icon: String
    let tint: Color
    let value: String
    let label: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(tint)
            
            Text(value)
                .font(.system(.title2, design: .rounded, weight: .bold))
                .contentTransition(.numericText())
            
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.regularMaterial, in: .rect(cornerRadius: 16))
    }
}

#Preview {
    StatsScreen()
}
