//
//  MonthlyReadCount.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 07.06.2026..
//

import Foundation

struct MonthlyReadCount: Identifiable, Equatable {
    let month: Date
    let count: Int
    var id: Date { month }
}
