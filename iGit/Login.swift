//
//  Login.swift
//  iGit
//
//  Created by Isaías Lima on 30/04/15.
//  Copyright (c) 2015 Isaías Lima. All rights reserved.
//

import UIKit
import CoreData

class Login: UIViewController {
    
    var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet var logo: UIImageView!
    @IBOutlet var nick: UITextField!
    @IBOutlet var pass: UITextField!
    
    var userSearch: UserSearch!
    var user: User!
    var result: NSArray!
    
    @IBAction func login(sender: AnyObject) {
        user = result.objectAtIndex(0) as! User
        user.nome = nick.text
        user.senha = pass.text
        context!.save(nil)
        
        userSearch.gitHubUser(user)
    }

    func memoriaCheia() -> Bool {
        
        var request = NSFetchRequest(entityName: "User")
        request.returnsObjectsAsFaults = false
        
        result = context!.executeFetchRequest(request, error: nil)!
        
        if result.count == 0 {
            return false
        } else {
            return true
        }
        
    }
    
    func enter() {
        self.performSegueWithIdentifier("login", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "enter", name: "gitHubUser", object: nil)
        
        userSearch = UserSearch.sharedInstance
        
        if self.memoriaCheia() == false {
            user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: context!) as! User
            context!.save(nil)
        } else {
            user = result.objectAtIndex(0) as! User
            userSearch.gitHubUser(user)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
