//
//  Program+CoreDataProperties.swift
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

extension Program {

    @NSManaged var desc: String?
    @NSManaged var title: String?
    @NSManaged var nodes: NSSet?
    @NSManaged var links: NSSet?

}
