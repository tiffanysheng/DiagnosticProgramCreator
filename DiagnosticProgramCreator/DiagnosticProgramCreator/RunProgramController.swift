//
//  RunProgramController.swift
//  DiagnosticProgramCreator
//
//  Created by Tiffany Sheng on 20/04/2016.
//  Copyright © 2016 Tiffany Sheng. All rights reserved.
//

import UIKit
import SpriteKit
import CoreData

class RunProgramController: UIViewController {
    
    var naviTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = naviTitle
        self.doseRun()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func doseRun() {
        let program = ProgramDao.sharedDao.getProgramByTitle(naviTitle)
        
        var hasText = true
        for n in program.nodes! {
            let node = n as! Node
            if node.label == nil {
                hasText = false
            }
        }
        
        var nlCount = true
        if program.links?.count != (program.nodes?.count)! - 1 {
            nlCount = false
        }
        
        var diamondHasYN = true
        for pn in program.nodes! {
            let node = pn as! Node
            if node.type == "Diamond" {
                if node.yesNode == nil || node.noNode == nil {
                    diamondHasYN = false
                }
            }
        }
        
        if hasText == true && nlCount == true && diamondHasYN == true {
            let scene = RunScene(size: CGSize(width: 2048, height: 1536))
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .AspectFill
            //scene.getProgram(program)
            skView.presentScene(scene)
            scene.getProgram(program)
            
        }
        else {
            let alertController = UIAlertController(title: "Fail", message: "The program is not completed", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default,
                                         handler: {
                                            action in
                                            self.navigationController?.popViewControllerAnimated(true)
            })
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }

}
