//
//  Link+CoreDataProperties.swift
//  DiagnosticProgramCreator
//
//  Created by Tiffany Sheng on 22/04/2016.
//  Copyright © 2016 Tiffany Sheng. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Link {

    @NSManaged var name: String?
    @NSManaged var startNodeX: NSNumber?
    @NSManaged var startNodeY: NSNumber?
    @NSManaged var endNodeX: NSNumber?
    @NSManaged var endNodeY: NSNumber?
    @NSManaged var startNodeName: String?
    @NSManaged var endNodeName: String?
    @NSManaged var label: String?
    @NSManaged var program: Program?

}
