//
//  QuestionnaireViewModel.swift
//  HealthQuestions
//
//  Created by Tay Jiun Yuan on 4/6/25.
//

import Foundation
import CoreData
import SwiftUI

@MainActor
class QuestionnaireViewModel: ObservableObject {
    
    @Published var freezedDateString: String?
    @Published var todayQuestionnaire: Questionnaire?
    @Published var showCompletion: Bool = false
    
    
    private let context: NSManagedObjectContext
    
    var isAtRisk: Bool {
        todayQuestionnaire?.isSelfHarm == true || todayQuestionnaire?.isNeedHelp == true || todayQuestionnaire?.isTalkToTherapist == true
    }
    
    var questionnaireProgress: QuestionnaireProgress {
        guard let questionnaire = todayQuestionnaire else {
            return .notStarted
        }
        
        let sections = [
            questionnaire.moodSectionComplete,
            questionnaire.anxietySectionComplete,
            questionnaire.sleepSectionComplete,
            questionnaire.safetySectionComplete
        ]
        
        if sections.allSatisfy({ $0 == false }) {
            return .notStarted
        } else if sections.allSatisfy({ $0 == true }) {
            return .completed
        } else {
            return .inProgress
        }
    } // [LEARNING] Cleaner than using if-elseif-else
    
    init(context: NSManagedObjectContext = CoreDataProvider.shared.context) {
        self.context = context
        fetchTodayQuestionnaire()
    }
    
    func checkTodayQuestionnaireStatus() -> QuestionnaireProgress {
        let dateString = Date().yyyyMMddString
        
        guard Questionnaire.exists(context: context, date: dateString) else {
            return .notStarted
        }
        
        let request: NSFetchRequest<Questionnaire> = Questionnaire.fetchRequest()
        request.predicate = NSPredicate(format: "dateCreated == %@", dateString)
        request.fetchLimit = 1
        
        do {
            if let questionnaire = try context.fetch(request).first {
                return questionnaire.moodSectionComplete ? .completed : .notStarted
            } else {
                print("[QuestionnaireViewModel] No questionnaire found for today.")
            }
        } catch {
            print("[QuestionnaireViewModel] Failed to fetch today's questionnaire: \(error)")
        }
        
        return .notStarted
    }
    
    func fetchTodayQuestionnaire() {
        let today = Date().yyyyMMddString
        freezedDateString = today
        
        if let existing = findQuestionnaire(for: freezedDateString!) {
            todayQuestionnaire = existing
            return
        }
        todayQuestionnaire = createQuestionnaire(for: freezedDateString!)
    }
    
    func saveMoodSection(selectedMoodOrdinal: MoodOrdinal?, selectedEmotions: Set<String>, selectedMoodRating: Double) {
        saveSection(sectionName: "Mood", saveAttributes: { questionnaire in
            questionnaire.moodOrdinal = selectedMoodOrdinal?.rawValue ?? nil
            questionnaire.emotions = Array(selectedEmotions) as NSArray
            questionnaire.moodRating = selectedMoodRating
            questionnaire.moodSectionComplete = true
        })
    }
    
    func saveAnxietySection(selectedAnxietyOrdinal: AnxietyOrdinal?, selectedAnxietyLevel: Double, selectedAnxietyTrigger: String) {
        saveSection(sectionName: "Anxiety", saveAttributes: { questionnaire in
            questionnaire.anxietyOrdinal = selectedAnxietyOrdinal?.rawValue ?? nil
            questionnaire.anxietyLevel = selectedAnxietyLevel
            questionnaire.anxietyTrigger = selectedAnxietyTrigger
            questionnaire.anxietySectionComplete = true
        })
    }
    
    func saveSleepSection(selectedSleepHours: String, selectedSleepOrdinal: SleepOrdinal?, selectedEnergyLevel: Double ) {
        saveSection(sectionName: "Sleep", saveAttributes: { questionnaire in
            questionnaire.sleepHours = Double(selectedSleepHours) ?? 0
            questionnaire.sleepOrdinal = selectedSleepOrdinal?.rawValue
            questionnaire.energyLevel = selectedEnergyLevel
            questionnaire.sleepSectionComplete = true
        })
    }
    
    func saveSafetySection(selectedIsSelfHarm: Bool?, selectedIsNeedHelp: Bool?, selectedIsTalkToTherapist: Bool? ) {
        saveSection(sectionName: "Safety", saveAttributes: { questionnaire in // [LEARNING] Uses questionnaire as a param, supplied by saveSection.
            questionnaire.isSelfHarm = selectedIsSelfHarm ?? false
            questionnaire.isNeedHelp = selectedIsNeedHelp ?? false
            questionnaire.isTalkToTherapist = selectedIsTalkToTherapist ?? false
            questionnaire.safetySectionComplete = true
        })
    }
    
    // Helpers
    private func saveSection(sectionName: String, saveAttributes: (Questionnaire) -> Void) {    // [LEARNING] Accepts saveAttributed closure as a param. Good way to adhere to DRY.
        guard let questionnaire = todayQuestionnaire else { return }
        saveAttributes(questionnaire)
        do {
            try context.save()
            print("[QuestionnaireViewModel] \(sectionName) sectioned saved successfully")
        } catch {
            print("[QuestionnaireViewModel] Failed to save \(sectionName) section \(error.localizedDescription)")
        }
    }
    
    private func findQuestionnaire(for date: String) -> Questionnaire? {
        let request: NSFetchRequest<Questionnaire> = Questionnaire.fetchRequest()
        request.predicate = NSPredicate(format: "dateCreated == %@", date)
        request.fetchLimit = 1
        
        return try? context.fetch(request).first
    }
    
    private func createQuestionnaire(for date: String) -> Questionnaire? {
        let entry = Questionnaire(context: context)
        entry.dateCreated = date
        
        do {
            try context.save()
            return entry
        } catch {
            print("[QuestionnaireViewModel] Failed to save new Questionnaire: \(error.localizedDescription)")
            return nil
        }
    }
    
}
