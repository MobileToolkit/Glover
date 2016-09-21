//
//  SomeEntry+CoreDataProperties.swift
//  iOS Example
//
//  Created by Sebastian Owodzin on 24/04/2016.
//  Copyright © 2016 mobiletoolkit.org. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SomeEntry {

    @NSManaged var name: String
    @NSManaged var createdAt: Date

}
