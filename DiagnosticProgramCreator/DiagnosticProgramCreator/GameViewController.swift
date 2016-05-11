//
//  GameViewController.swift
//  DiagnosticProgramCreator
//
//  Created by Tiffany Sheng on 19/03/2016.
//  Copyright (c) 2016 Tiffany Sheng. All rights reserved.
//

import UIKit
import SpriteKit
import CoreData

class GameViewController: UIViewController, UITextFieldDelegate {

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
        
        self.navigationController?.interactivePopGestureRecognizer?.enabled = false
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: #selector(GameViewController.save))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(GameViewController.cancel))
        
        items = ProgramDao.sharedDao.findAll()
        
    }
    
    func save() {
        let alertController = UIAlertController(title: "Save", message: "Type title and description", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
            textField.placeholder = "Title"
        }
        alertController.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
            textField.placeholder = "Description"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let okAction = UIAlertAction(title: "Save", style: .Default,
                                     handler: {
                                        action in
                                        let title = alertController.textFields![0].text
                                        let desc = alertController.textFields![1].text
                                        if title != "" {
                                            var isExisted = false
                                            for i in self.items {
                                                if i.valueForKey("title") as? String == title {
                                                    isExisted = true
                                                }
                                            }
                                            if isExisted == false {
                                                self.saveProgram(title!, desc: desc!)
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
    
    func cancel() {
        let alertController = UIAlertController(title: "Alert", message: "Do you want to discard the program? ", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "No", style: .Cancel, handler: nil)
        let okAction = UIAlertAction(title: "Yes", style: .Default, handler: {
            action in
            self.navigationController?.popViewControllerAnimated(true)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func saveProgram(title: String, desc: String) {
        let treeNodes = scene.getAllNodes()
        let paths = scene.getAllPaths()
        
        ProgramDao.sharedDao.saveProgram(title, desc: desc, treeNodes: treeNodes, paths: paths)
        
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
