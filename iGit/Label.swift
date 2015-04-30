//
//  Label.swift
//  iGit
//
//  Created by Isaías Lima on 30/04/15.
//  Copyright (c) 2015 Isaías Lima. All rights reserved.
//

import Foundation
import CoreData

class Label: NSManagedObject {

    @NSManaged var color: AnyObject
    @NSManaged var index: Int16
    @NSManaged var descricao: String
    @NSManaged var repo: Repo

}
