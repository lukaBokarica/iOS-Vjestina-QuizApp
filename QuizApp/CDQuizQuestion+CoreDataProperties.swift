//
//  CDQuizQuestion+CoreDataProperties.swift
//  QuizApp
//
//  Created by Pero Bokarica on 29.05.2021..
//
//

import Foundation
import CoreData


extension CDQuizQuestion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDQuizQuestion> {
        return NSFetchRequest<CDQuizQuestion>(entityName: "CDQuizQuestion")
    }

    @NSManaged public var question: String
    @NSManaged public var id: Int16
    @NSManaged public var correctAnswer: Int16
    @NSManaged public var answers: NSObject
    @NSManaged public var quiz: CDQuiz?

}

extension CDQuizQuestion : Identifiable {

}
