//
//  RepoSearch.swift
//  iGit
//
//  Created by Isaías Lima on 30/04/15.
//  Copyright (c) 2015 Isaías Lima. All rights reserved.
//

import UIKit

class RepoSearch: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate  {
    
    var json: NSMutableData!
    var repositorios: NSMutableArray!
    var repos: NSMutableArray!
    
    class var sharedInstance : RepoSearch {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : RepoSearch? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = RepoSearch()
        }
        return Static.instance!
    }
    
    private override init() {
        super.init()
    }
    
    func reposGitHub(user: User) {
        
        let loginString = NSString(format: "%@:%@", user.nome, user.senha)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions(nil)
        
        // create the request
        let url = NSURL(string: "https://api.github.com/users/\(user.nome)/repos")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        // fire off the request
        // make sure your class conforms to NSURLConnectionDelegate
        let connection = NSURLConnection(request: request, delegate: self, startImmediately: true)
        connection?.start()
        
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        json = NSMutableData()
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        json.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        repositorios = NSJSONSerialization.JSONObjectWithData(json, options: .MutableContainers, error: nil) as! NSMutableArray
        
        for i in 0..<(repositorios.count) {
            
            var repo = repositorios[i] as! NSMutableDictionary
            var url = repo.valueForKey("url") as! String
            repos.addObject(url)
            
        }
        
    }
    
}
