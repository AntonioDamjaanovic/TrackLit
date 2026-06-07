//
//  MonthlyReadChartView.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 07.06.2026..
//

import SwiftUI
import Charts

struct MonthlyReadChartView: View {

    let monthlyReadCounts: [MonthlyReadCount]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Books read by month")
                .font(.headline)
                .foregroundStyle(.secondary)

            Chart(monthlyReadCounts) { item in
                BarMark(
                    x: .value("Month", item.month, unit: .month),
                    y: .value("Books", item.count)
                )
                .foregroundStyle(.blue.gradient)
                .cornerRadius(6)
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .month)) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel(format: .dateTime.month(.abbreviated))
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { _ in
                    AxisGridLine()
                    AxisValueLabel()
                }
            }
            .frame(height: 220)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.regularMaterial, in: .rect(cornerRadius: 16))
        .padding()
    }
}

#Preview {
    let calendar = Calendar.current
    let start = calendar.dateInterval(of: .month, for: Date())?.start ?? Date()
    let sample: [MonthlyReadCount] = (0..<6).reversed().compactMap { offset in
        guard let month = calendar.date(byAdding: .month, value: -offset, to: start) else { return nil }
        let counts = [2, 1, 3, 4, 2, 5]
        return MonthlyReadCount(month: month, count: counts[5 - offset])
    }
    return MonthlyReadChartView(monthlyReadCounts: sample)
}
