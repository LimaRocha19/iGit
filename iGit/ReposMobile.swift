//
//  ReposMobile.swift
//  iGit
//
//  Created by Isaías Lima on 01/05/15.
//  Copyright (c) 2015 Isaías Lima. All rights reserved.
//

import UIKit
import CoreData

class ReposMobile: UITableViewController {
    
    var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    var user: User!
    var mackSearch: MackSearch!
    
    var pullSearch: PullSearch!
    var pullDetail: PullDetail!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var request = NSFetchRequest(entityName: "User")
        request.returnsObjectsAsFaults = false
        
        var result: NSArray = context!.executeFetchRequest(request, error: nil)!
        
        user = result.objectAtIndex(0) as! User
        
        mackSearch = MackSearch.sharedInstance
        pullDetail = PullDetail.sharedInstance
        pullSearch = PullSearch.sharedInstance
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "segue", name: "pullRequest", object: nil)
        notificationCenter.addObserver(self, selector: "perform", name: "label", object: nil)
        
    }
    
    func segue() {
        let indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow()!
        pullDetail.labelPull(user, repo: mackSearch.mackRepos.objectAtIndex(indexPath.row) as! String, pullNumber: pullSearch.pullNumber)
    }
    
    func perform() {
        self.performSegueWithIdentifier("label", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Mack Mobile repos"
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return mackSearch.mackRepos.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("repo", forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel?.text = mackSearch.mackRepos.objectAtIndex(indexPath.row) as? String

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        pullSearch.pullGitHub(user, repo: mackSearch.mackRepos.objectAtIndex(indexPath.row) as! String)
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    

}
