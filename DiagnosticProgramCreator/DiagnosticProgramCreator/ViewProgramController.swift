//
//  ViewProgramControllerViewController.swift
//  DiagnosticProgramCreator
//
//  Created by Tiffany Sheng on 20/04/2016.
//  Copyright © 2016 Tiffany Sheng. All rights reserved.
//

import UIKit
import SpriteKit
import CoreData

class ViewProgramController: UIViewController {
    
    var naviTitle = ""
    var items: [NSManagedObject] = []
    let scene = CreateScene(size: CGSize(width: 2048, height: 1536))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
        
        let p = ProgramDao.sharedDao.getProgramByTitle(naviTitle)
        scene.reloadProgram(p)
        
        items = ProgramDao.sharedDao.findAll()
        
        self.navigationItem.title = naviTitle
        self.navigationController?.interactivePopGestureRecognizer?.enabled = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: #selector(ViewProgramController.save))
        
        
        
        
    }
    
    func save() {
        let program = ProgramDao.sharedDao.getProgramByTitle(naviTitle)
        
        let alertController = UIAlertController(title: "Save", message: "Type title and description", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
            textField.placeholder = "Title"
        }
        alertController.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
            textField.placeholder = "Description"
        }
        alertController.textFields![0].text = program.title
        alertController.textFields![1].text = program.desc
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let okAction = UIAlertAction(title: "Save", style: .Default,
                                     handler: {
                                        action in
                                        
                                        let title = alertController.textFields![0].text
                                        let desc = alertController.textFields![1].text
                                        
                                        var isExisted = false
                                        for i in self.items {
                                            if i.valueForKey("title") as? String == title && title != self.naviTitle {
                                                isExisted = true
                                            }
                                        }
                                        if title != "" {
                                            if title == program.title || isExisted == false {
                                                self.updateProgram(title!, desc: desc!, p: program)
                                                self.navigationController?.popViewControllerAnimated(true)
                                            }
                                            else {
                                                let alertController = UIAlertController(title: "Alert", message: "The title has already existed!", preferredStyle: .Alert)
                                                let cancelAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
                                                alertController.addAction(cancelAction)
                                                self.presentViewController(alertController, animated: true, completion: nil)
                                            }
                                            
                                        }
                                        else {
                                            let alertController = UIAlertController(title: "Alert", message: "Title cannot be empty", preferredStyle: .Alert)
                                            let cancelAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
                                            alertController.addAction(cancelAction)
                                            self.presentViewController(alertController, animated: true, completion: nil)
                                        }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func updateProgram(title: String, desc: String, p: Program) {
        let treeNodes = scene.getAllNodes()
        let paths = scene.getAllPaths()
        ProgramDao.sharedDao.updateProgram(title, desc: desc, p: p, treeNodes: treeNodes, paths: paths)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
