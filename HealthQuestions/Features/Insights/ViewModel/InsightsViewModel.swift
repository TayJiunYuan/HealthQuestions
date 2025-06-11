//
//  InsightsViewModel.swift
//  HealthQuestions
//
//  Created by Tay Jiun Yuan on 8/6/25.
//

import Foundation
import CoreData

@MainActor
class InsightsViewModel: ObservableObject {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataProvider.shared.context) {
        self.context = context
    }
    @Published var allInsightsData: [(Option, Date, Double)] = []
    @Published var individualInsightsData: [(Date, Double)] = []
    
    func fetchInsights(for option: Option, startDate: String, endDate: String) -> [(option: Option, date: Date, rating: Double)] {
        let request: NSFetchRequest<Questionnaire> = Questionnaire.fetchRequest()
        request.predicate = NSPredicate(format: "dateCreated >= %@ AND dateCreated <= %@", startDate, endDate)
        
        var result: [(option: Option, date: Date, rating: Double)] = []
        
        do {
            let questionnaires = try context.fetch(request)
            
            for q in questionnaires {
                guard let dateStr = q.dateCreated,
                      let date = dateStr.asDate_yyyyMMdd
                else { continue }
                
                switch option {
                case .moodRating:
                    if q.moodSectionComplete {
                        let rating = q.moodRating
                        result.append((.moodRating, date, rating))
                    }
                    
                case .anxietyLevel:
                    if q.anxietySectionComplete {
                        let rating = q.anxietyLevel
                        result.append((.anxietyLevel, date, rating))
                    }
                    
                case .sleepLevel:
                    if q.sleepSectionComplete {
                        let rating = q.energyLevel
                        result.append((.sleepLevel, date, rating))
                    }
                    
                case .all:
                    if q.moodSectionComplete {
                        let rating = q.moodRating
                        result.append((.moodRating, date, rating))
                    }
                    if q.anxietySectionComplete {
                        let rating = q.anxietyLevel
                        result.append((.anxietyLevel, date, rating))
                    }
                    if q.sleepSectionComplete {
                        let rating = q.energyLevel
                        result.append((.sleepLevel, date, rating))
                    }
                }
            }
            // Sort by date ascending
            result.sort{ $0.date < $1.date }
            
        } catch {
            print("Failed to fetch questionnaires: \(error)")
        }
        return result
    }
    
    func fetchInsightsForAllForPastWeek() {
        let calendar = Calendar.current
        let today = Date()
        guard let startDate = calendar.date(byAdding: .day, value: -6, to: today) else {
            return
        }
        let startDateStr = startDate.yyyyMMddString
        let endDateStr = today.yyyyMMddString
        allInsightsData = fetchInsights(for: .all, startDate: startDateStr, endDate: endDateStr)
    }
    
    func reloadIndividualInsights(selectedOption: Option, startDate: Date, endDate: Date) {
        individualInsightsData = fetchInsights(
            for: selectedOption,
            startDate: startDate.yyyyMMddString,
            endDate:   endDate.yyyyMMddString
        )
        .map { ($0.date, $0.rating) }           // keep only date & value
        .sorted { $0.0 < $1.0 }                 // chronological
    }
}
