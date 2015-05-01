//
//  PullSearch.swift
//  iGit
//
//  Created by Isaías Lima on 01/05/15.
//  Copyright (c) 2015 Isaías Lima. All rights reserved.
//

import UIKit

class PullSearch:  NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
    var json: NSMutableData!
    var pullRequests: NSMutableArray!
    var myPull: NSMutableDictionary!
    var mackSearch: MackSearch!
    var usuario: User!
    var repositorio: String!
    var i = 1
    
    class var sharedInstance : PullSearch {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : PullSearch? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = PullSearch()
        }
        return Static.instance!
    }
    
    private override init() {
        mackSearch = MackSearch.sharedInstance
        super.init()
    }
    
    func pullGitHub(user: User, repo: String) {
        
        usuario = user
        repositorio = repo
        
        let loginString = NSString(format: "%@:%@", user.nome, user.senha)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions(nil)
        
        
        let url = NSURL(string: "https://api.github.com/repos/mackmobile/\(repo)/pulls?state=all&page=\(i)")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        // fire off the request
        // make sure your class conforms to NSURLConnectionDelegate
        let urlConnection = NSURLConnection(request: request, delegate: self, startImmediately: true)
        urlConnection?.start()
        
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        json?.appendData(data)
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        json = NSMutableData()
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        pullRequests = NSJSONSerialization.JSONObjectWithData(json, options: .MutableContainers, error: nil) as! NSMutableArray
        
        if pullRequests != nil {
            
            for j in 0..<(pullRequests.count) {
                
                var pullRequest = pullRequests[j].objectForKey("user") as! NSMutableDictionary!
                if pullRequest.objectForKey("login") as! String == usuario.nome {
                    myPull = pullRequest
                }
                
            }
            
        } else {
            self.pullGitHub(usuario, repo: repositorio)
        }
        
    }
    
    
    
}
