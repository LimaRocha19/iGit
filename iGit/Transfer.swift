//
//  Transfer.swift
//  iGit
//
//  Created by Isaías Lima on 01/05/15.
//  Copyright (c) 2015 Isaías Lima. All rights reserved.
//

import UIKit

class Transfer: NSObject {
    
    var user: User!
    var repo: String!
    
    class var sharedInstance : Transfer {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : Transfer? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = Transfer()
        }
        return Static.instance!
    }
    
    private override init() {
        super.init()
    }
    
}
