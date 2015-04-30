//
//  Repo.swift
//  iGit
//
//  Created by Isaías Lima on 30/04/15.
//  Copyright (c) 2015 Isaías Lima. All rights reserved.
//

import Foundation
import CoreData

class Repo: NSManagedObject {

    @NSManaged var nome: String
    @NSManaged var commit: NSDate
    @NSManaged var labels: NSSet
    @NSManaged var user: User

}
