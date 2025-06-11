//
//  QuestionnaireModel.swift
//  HealthQuestions
//
//  Created by Tay Jiun Yuan on 5/6/25.
//

import Foundation

enum MoodOrdinal: String, CaseIterable, Identifiable {
    case veryGood = "Very good"
    case good = "Good"
    case neutral = "Neutral"
    case bad = "Bad"
    case veryBad = "Very bad"
    
    var id: String { rawValue }
}

let allEmotions: [String] = ["Happy", "Calm", "Sad", "Anxious", "Angry", "Lonely", "Grateful", "Frustrated", "Hopeless", "Proud"]

enum QuestionnaireProgress: String {
    case notStarted
    case inProgress
    case completed
    
    var text: String {
        switch self {   // [LEARNING] computed property
        case .notStarted:
            return "Not completed! Tap to do"
        case .inProgress:
            return "Partially completed! Tap to continue"
        case .completed:
            return "Completed! Tap to review"
        }
    }
}

enum AnxietyOrdinal: String, CaseIterable, Identifiable {
    case notAtAll = "Not at all"
    case aLittle = "A little"
    case moderately = "Moderately"
    case aLot = "A lot"
    case extremely = "Extremely"
    
    var id: String { rawValue }
}

enum SleepOrdinal: String, CaseIterable, Identifiable {
    case excellent = "Excellent"
    case good = "Good"
    case fair = "Fair"
    case poor = "Poor"
    case veryPoor = "Very poor"
    
    var id: String { rawValue }
}
