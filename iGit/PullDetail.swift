//
//  PullDetail.swift
//  iGit
//
//  Created by Isaías Lima on 01/05/15.
//  Copyright (c) 2015 Isaías Lima. All rights reserved.
//

import UIKit

class PullDetail: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
    var json: NSMutableData!
    var pull: NSDictionary!
    var labels: NSMutableArray!
    var pullSearch: PullSearch!
    
    
    
    class var sharedInstance : PullDetail {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : PullDetail? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = PullDetail()
        }
        return Static.instance!
    }
    
    private override init() {
        pullSearch = PullSearch.sharedInstance
        super.init()
    }
    
    func labelPull(user: User, repo: String, pullNumber: Int) {
        
        let loginString = NSString(format: "%@:%@", user.nome, user.senha)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions(nil)
        
        
        let url = NSURL(string: "https://api.github.com/repos/mackmobile/\(repo)/issues/\(pullNumber)")
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
        pull = NSJSONSerialization.JSONObjectWithData(json, options: .MutableContainers, error: nil) as! NSDictionary
        labels = pull.objectForKey("labels") as! NSMutableArray
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.postNotificationName("label", object: self)
    }
    
}
