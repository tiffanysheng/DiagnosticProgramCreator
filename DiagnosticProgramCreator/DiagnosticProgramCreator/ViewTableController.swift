//
//  ViewProgramController.swift
//  DiagnosticProgramCreator
//
//  Created by Tiffany Sheng on 12/04/2016.
//  Copyright © 2016 Tiffany Sheng. All rights reserved.
//

import UIKit
import CoreData

class ViewTableController: UITableViewController {

    var items: [Program] = []
    var navigationTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = ProgramDao.sharedDao.findAll()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()

    }
    
    func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.valueForKey("title") as? String
        cell.detailTextLabel?.text = item.valueForKey("desc") as? String
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "Delete"
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            ProgramDao.sharedDao.remove(items[indexPath.row])
            
            items.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            tableView.reloadData()
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vpController = segue.destinationViewController as! ViewProgramController
        let indexPath = self.tableView.indexPathForSelectedRow!
        let item = items[indexPath.row]
        navigationTitle = (item.valueForKey("title") as? String)!
        vpController.naviTitle = navigationTitle
    }
    

}
