//
//  Timeline+CoreDataProperties.swift
//  
//
//  Created by Yejun Park on 12/3/20.
//
//

import Foundation
import CoreData


extension Timeline {

    /// Request FETCH for Timeline data
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Timeline> {
        return NSFetchRequest<Timeline>(entityName: "Timeline")
    }
    
    /// Unique id
    @NSManaged public var id: Int32
    
    /// Date for this timeline
    @NSManaged public var logDate: String?
    
    /// Title for this timeline
    @NSManaged public var routineTitle: String?

}
