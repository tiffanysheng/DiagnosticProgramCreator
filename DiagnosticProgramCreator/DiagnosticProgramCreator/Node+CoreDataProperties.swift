//
//  Node+CoreDataProperties.swift
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

extension Node {

    @NSManaged var name: String?
    @NSManaged var type: String?
    @NSManaged var label: String?
    @NSManaged var yesNode: String?
    @NSManaged var noNode: String?
    @NSManaged var scale: NSNumber?
    @NSManaged var positionX: NSNumber?
    @NSManaged var positionY: NSNumber?
    @NSManaged var program: Program?

}
