//
//  RunTableViewController.swift
//  DiagnosticProgramCreator
//
//  Created by Tiffany Sheng on 20/04/2016.
//  Copyright © 2016 Tiffany Sheng. All rights reserved.
//

import UIKit
import SpriteKit
import CoreData

class RunTableViewController: UITableViewController {
    
    var items: [Program] = []
    var navigationTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = ProgramDao.sharedDao.findAll()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("RunCell", forIndexPath: indexPath)
        
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.valueForKey("title") as? String
        cell.detailTextLabel?.text = item.valueForKey("desc") as? String
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let rpController = segue.destinationViewController as! RunProgramController
        let indexPath = self.tableView.indexPathForSelectedRow!
        let item = items[indexPath.row]
        navigationTitle = (item.valueForKey("title") as? String)!
        rpController.naviTitle = navigationTitle
    }
    

}
