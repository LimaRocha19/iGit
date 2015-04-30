//
//  User.swift
//  iGit
//
//  Created by Isaías Lima on 30/04/15.
//  Copyright (c) 2015 Isaías Lima. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {

    @NSManaged var nome: String
    @NSManaged var senha: String

}
