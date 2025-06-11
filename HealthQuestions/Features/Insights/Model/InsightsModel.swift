//
//  InsightsViewModel.swift
//  HealthQuestions
//
//  Created by Tay Jiun Yuan on 8/6/25.
//

import Foundation

protocol InsightEntry {
    var date: Date { get }
    var rating: Double { get }
}

struct MoodEntry: Identifiable, InsightEntry {
    let id = UUID()
    let date: Date
    let moodRating: Double

    var rating: Double { moodRating }
}

struct SleepEntry: Identifiable, InsightEntry {
    let id = UUID()
    let date: Date
    let energyLevel: Double

    var rating: Double { energyLevel }
}

struct AnxietyEntry: Identifiable, InsightEntry {
    let id = UUID()
    let date: Date
    let anxietyLevel: Double

    var rating: Double { anxietyLevel }
}

enum Option: String {
    case moodRating
    case anxietyLevel
    case sleepLevel
    case all
}
