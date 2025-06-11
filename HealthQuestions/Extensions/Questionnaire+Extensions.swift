//
//  Questionnaire+Extensions.swift
//  HealthQuestions
//
//  Created by Tay Jiun Yuan on 4/6/25.
//

import Foundation
import CoreData

extension Questionnaire {
    // [LEARNING] extension on the Questionnaire class (automatically created which the budgetappmodel core data entity)
    // [LEARNING] extending is good as it allows for unit tests instead of putting in view
    // [LEARNING] Rule of thumb: for business logic, keep it in extension to unit test. For simple functions like CRUD, can put in view
    
    static func exists(context: NSManagedObjectContext, date: String) -> Bool {
        let request = Questionnaire.fetchRequest()
        request.predicate = NSPredicate(format: "dateCreated == %@", date)
        
        do {
            let results = try context.fetch(request)
            return !results.isEmpty
        } catch {
            print("[Questionnaire Extension] Error fetching todayExists")
            return false
        }
    }
    
    
}
