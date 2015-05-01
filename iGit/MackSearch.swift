//
//  MackSearch.swift
//  iGit
//
//  Created by Isaías Lima on 30/04/15.
//  Copyright (c) 2015 Isaías Lima. All rights reserved.
//

import UIKit

class MackSearch: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
    var json: NSMutableData!
    var repositorio: NSDictionary!
    var mackRepos: NSMutableArray!
    var repoSearch: RepoSearch!
    var usuario: User!
    var i = 0
    
    class var sharedInstance : MackSearch {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : MackSearch? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = MackSearch()
        }
        return Static.instance!
    }
    
    private override init() {
        
        mackRepos = NSMutableArray()
        repoSearch = RepoSearch.sharedInstance
        
        super.init()
    }
    
    func repoGitHub(user: User) {
        
        usuario = user
        
        let loginString = NSString(format: "%@:%@", user.nome, user.senha)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions(nil)
        
        let url = NSURL(string: repoSearch.repos.objectAtIndex(i) as! String)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        // fire off the request
        // make sure your class conforms to NSURLConnectionDelegate
        let urlConnection = NSURLConnection(request: request, delegate: self, startImmediately: true)
        urlConnection?.start()
        i++
        
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        json?.appendData(data)
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        json = NSMutableData()
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        repositorio = NSJSONSerialization.JSONObjectWithData(json, options: .MutableContainers, error: nil) as! NSDictionary
        
        if repositorio.valueForKey("parent") != nil {
            
            var parent = repositorio.valueForKey("parent") as! NSMutableDictionary
            var owner = parent.valueForKey("owner") as! NSMutableDictionary
            var login = owner.valueForKey("login") as! String
            
            if login == "mackmobile" {
                mackRepos.addObject(repositorio.valueForKey("name") as! String)
            }
            
        }
        
        if i < repoSearch.repos.count {
            self.repoGitHub(usuario)
        } else {
            let notificationCenter = NSNotificationCenter.defaultCenter()
            notificationCenter.postNotificationName("gitHubUser", object: self)
        }
    }
    
}
