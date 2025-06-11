//
//  Questionnaire+CoreDataProperties.swift
//  HealthQuestions
//
//  Created by Tay Jiun Yuan on 5/6/25.
//
//

import Foundation
import CoreData


extension Questionnaire {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Questionnaire> {
        return NSFetchRequest<Questionnaire>(entityName: "Questionnaire")
    }

    @NSManaged public var anxietyLevel: Double
    @NSManaged public var anxietyOrdinal: String?
    @NSManaged public var anxietySectionComplete: Bool?
    @NSManaged public var anxietyTrigger: String?
    @NSManaged public var dateCreated: String?
    @NSManaged public var emotions: NSObject?
    @NSManaged public var energyLevel: Double
    @NSManaged public var isNeedHelp: Bool
    @NSManaged public var isSelfHarm: Bool
    @NSManaged public var isTalkToTherapist: Bool
    @NSManaged public var moodOrdinal: String?
    @NSManaged public var moodRating: Double
    @NSManaged public var moodSectionComplete: Bool
    @NSManaged public var safetySectionComplete: Bool
    @NSManaged public var sleepHours: Double
    @NSManaged public var sleepOrdinal: String?
    @NSManaged public var sleepSectionComplete: Bool

}

extension Questionnaire : Identifiable {

}
