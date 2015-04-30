//
//  UserSearch.swift
//  iGit
//
//  Created by Isaías Lima on 30/04/15.
//  Copyright (c) 2015 Isaías Lima. All rights reserved.
//

import UIKit

class UserSearch: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
    var json: NSMutableData!
    var gitHubUser: NSDictionary!
    
    class var sharedInstance : UserSearch {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : UserSearch? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = UserSearch()
        }
        return Static.instance!
    }
    
    private override init() {
        super.init()
    }
    
    func gitHubUser(user: User) {
        
        let loginString = NSString(format: "%@:%@", user.nome, user.senha)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions(nil)
        
        // create the request
        let url = NSURL(string: "https://api.github.com/user")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        // fire off the request
        // make sure your class conforms to NSURLConnectionDelegate
        let urlConnection = NSURLConnection(request: request, delegate: self, startImmediately: true)
        urlConnection?.start()
        
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        json = NSMutableData()
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        json.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        gitHubUser = NSJSONSerialization.JSONObjectWithData(json, options: .MutableContainers, error: nil) as! NSDictionary
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.postNotificationName("gitHubUser", object: self)
    }
    
}

