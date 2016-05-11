//
//  CreateScene.swift
//  DiagnosticProgramCreator
//
//  Created by Tiffany Sheng on 19/03/2016.
//  Copyright © 2016 Tiffany Sheng. All rights reserved.
//

import SpriteKit
import UIKit
import CoreData

class CreateScene: SKScene, UITextFieldDelegate {
    
    let playableRect: CGRect
    let background = SKSpriteNode(imageNamed: "background")
    var diamond = SKSpriteNode(imageNamed: "frameDiamond")
    var newDiamonds: [SKSpriteNode] = []
    var square = SKSpriteNode(imageNamed: "frameSquare")
    var newSquares: [SKSpriteNode] = []
    let line = SKSpriteNode(imageNamed: "line")
    let text = SKSpriteNode(imageNamed: "text")
    var dash = SKSpriteNode(imageNamed: "dash")
    let trash = SKSpriteNode(imageNamed: "trash")
    let selectedLine = SKSpriteNode(imageNamed: "selectedline")
    
    var previousScale = CGFloat(0.5)
    var selectedNode = SKSpriteNode()
    
    let textField = UITextField(frame: CGRectMake(10, 70, 360, 30))
    var textFieldContent = ""
    var treeNodes: [TreeNode] = []
    var textLabels: [SKLabelNode] = []
    
    var count = 0
    
    var startNode = SKSpriteNode()
    var endNode = SKSpriteNode()
    var flag = 0
    
    var isSelectedLine = false
    var links: [SKShapeNode] = []
    var linkText = ""
    var linkLabels: [SKLabelNode] = []
    var paths: [Line] = []
    
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.whiteColor()
        
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        addChild(background)
        
        diamond.setScale(0.3)
        diamond.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        diamond.position = CGPoint(x: CGRectGetMinX(playableRect) + CGRectGetWidth(playableRect)/10, y: size.height/10 * 8)
        addChild(diamond)
        
        square.setScale(0.3)
        square.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        square.position = CGPoint(x: CGRectGetMinX(playableRect) + CGRectGetWidth(playableRect)/10, y: diamond.position.y - diamond.size.height/2 - square.size.height/2)
        addChild(square)
        
        line.setScale(0.3)
        line.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        line.position = CGPoint(x: CGRectGetMinX(playableRect) + CGRectGetWidth(playableRect)/10, y: square.position.y - square.size.height/2 - line.size.height/2)
        addChild(line)
        
        text.setScale(0.3)
        text.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        text.position = CGPoint(x: CGRectGetMinX(playableRect) + CGRectGetWidth(playableRect)/10, y: line.position.y - line.size.height/2 - text.size.height/2)
        addChild(text)
        
        trash.setScale(0.15)
        trash.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        trash.position = CGPoint(x: CGRectGetMinX(playableRect) + CGRectGetWidth(playableRect)/10, y: text.position.y - text.size.height/2 - trash.size.height/2)
        addChild(trash)
        
        dash.setScale(0.5)
        dash.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        dash.position = CGPoint(x: CGRectGetMinX(playableRect) + CGRectGetWidth(playableRect)/10, y: size.height/10 * 9)
        dash.hidden = true
        addChild(dash)
        
        let pinch:UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(CreateScene.pinched(_:)))
        view.addGestureRecognizer(pinch)
        
        let longPress:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(CreateScene.longPressed(_:)))
        view.addGestureRecognizer(longPress)
        
        let doubleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateScene.doubleTaped(_:)))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
        
        
    }
    
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 9.0/16.0
        let playableWidth = size.height * maxAspectRatio
        let playableMargin = (size.width - playableWidth)/2.0
        playableRect = CGRect(x: playableMargin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let touchLocation = touch.locationInNode(self)
            if self.nodeAtPoint(touchLocation) == self.diamond {
                spawnDiamond()
                showSelected(diamond.position)

            }
            if self.nodeAtPoint(touchLocation) == self.square {
                spawnSquare()
                showSelected(diamond.position)
            }
            if self.nodeAtPoint(touchLocation) == self.line {
                selectedLine.setScale(0.3)
                selectedLine.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                selectedLine.position = CGPoint(x: CGRectGetMinX(playableRect) + CGRectGetWidth(playableRect)/10, y: square.position.y - square.size.height/2 - line.size.height/2)
                
                isSelectedLine = true
                
                let alertView = UIAlertView()
                alertView.title = "Add a link"
                alertView.tag = 1
                alertView.message = "Double tap the start node, then tap the end node."
                alertView.addButtonWithTitle("OK")
                alertView.cancelButtonIndex = 0
                alertView.delegate = self
                alertView.show()
                
            }
            if self.nodeAtPoint(touchLocation) == self.selectedLine {
                addChild(line)
                selectedLine.removeFromParent()
                isSelectedLine = false
                
            }
            if self.nodeAtPoint(touchLocation) == self.text {
                let alertView = UIAlertView()
                alertView.title = "Add texts"
                alertView.tag = 2
                alertView.message = "Long press the node"
                alertView.addButtonWithTitle("OK")
                alertView.cancelButtonIndex = 0
                alertView.delegate = self
                alertView.show()
            }
            
            
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let touchLocation = touch.locationInNode(self)
            selectNodeForTouch(touchLocation)
            
            if self.nodeAtPoint(touchLocation) == selectedNode {
                selectedNode.position = touchLocation
                for node in treeNodes {
                    if node.name == selectedNode.name {
                        node.setNode(selectedNode)
                        for label in textLabels {
                            if label.name == selectedNode.name {
                                label.position = selectedNode.position
                                node.setLabel(label)
                            }
                        }
                    }
                }
                showSelected(selectedNode.position)
                
                var temp: [String] = []
                for link in links {
                    temp = (link.name!.componentsSeparatedByString(","))
                    if temp[0] == selectedNode.name {
                        for p in paths {
                            if p.name == link.name {
                                let path: Line = p
                                link.path = self.drawLine(selectedNode, end: path.end)
                            }
                        }
                        
                    }
                    if temp[1] == selectedNode.name {
                        for p in paths {
                            if p.name == link.name {
                                let path: Line = p
                                link.path = self.drawLine(path.start, end: selectedNode)
                            }
                        }
                        
                    }
                    
                }
                
                for p in paths {
                    for l in linkLabels {
                        if p.name == l.name {
                            l.position = CGPoint(x: p.end.position.x, y: p.start.position.y)
                        }
                    }
                }
            }
            
            if flag == 1 && selectedNode.name != nil && selectedNode != startNode {
                endNode = selectedNode
                
                var i = 0
                var j = 0
                var isExist = false
                for link in links {
                    if link.name == startNode.name! + "," + endNode.name! || link.name == endNode.name! + "," + startNode.name! {
                        link.removeFromParent()
                        links.removeAtIndex(i)
                        paths.removeAtIndex(i)
                        for label in linkLabels {
                            if label.name == startNode.name! + "," + endNode.name! || label.name == endNode.name! + "," + startNode.name! {
                                label.removeFromParent()
                                linkLabels.removeAtIndex(j)
                            }
                            j = j + 1
                        }
                        isExist = true
                    }
                    i = i + 1
                }
                
                if isExist == false {
                    let alertView = UIAlertView()
                    alertView.title = "Alert"
                    alertView.tag = 3
                    alertView.message = "Type Y or N"
                    alertView.alertViewStyle = UIAlertViewStyle.PlainTextInput
                    alertView.addButtonWithTitle("No")
                    alertView.addButtonWithTitle("Yes")
                    alertView.cancelButtonIndex = 0
                    alertView.delegate = self
                    alertView.show()
                    
                }
                flag = 0
            }

        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        checkCollisions()
        
    }
    
    func spawnDiamond() {
        let newDiamond = SKSpriteNode(imageNamed: "diamond")
        newDiamond.name = "\(count)"
        newDiamond.setScale(0.5)
        newDiamond.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        newDiamond.position = CGPoint(x: CGRectGetMinX(playableRect) + CGRectGetWidth(playableRect)/10, y: size.height/10 * 8)
        addChild(newDiamond)
        newDiamonds.append(newDiamond)
        
        let textLabel = SKLabelNode(fontNamed: "Thonburi-Bold")
        textLabel.text = ""
        textLabel.name = newDiamond.name
        textLabel.fontSize = 20
        textLabel.position = CGPointMake(selectedNode.position.x, selectedNode.position.y)
        textLabel.fontColor = SKColor.blackColor()
        textLabel.zPosition = 1
        //textLabel.hidden = true
        textLabels.append(textLabel)
        addChild(textLabel)
        
        let treeNode = TreeNode(node: newDiamond, label: textLabel)
        treeNode.name = newDiamond.name!
        treeNode.type = "Diamond"
        treeNodes.append(treeNode)
        
        count = count + 1
    }
    
    func spawnSquare() {
        let newSquare = SKSpriteNode(imageNamed: "square")
        newSquare.name = "\(count)"
        newSquare.setScale(0.5)
        newSquare.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        newSquare.position = CGPoint(x: CGRectGetMinX(playableRect) + CGRectGetWidth(playableRect)/10, y: diamond.position.y - diamond.size.height/2 - square.size.height/2)
        addChild(newSquare)
        newSquares.append(newSquare)
        
        let textLabel = SKLabelNode(fontNamed: "Thonburi-Bold")
        textLabel.text = ""
        textLabel.name = newSquare.name
        textLabel.fontSize = 20
        textLabel.position = CGPointMake(selectedNode.position.x, selectedNode.position.y)
        textLabel.fontColor = SKColor.blackColor()
        textLabel.zPosition = 1
        //textLabel.hidden = true
        textLabels.append(textLabel)
        addChild(textLabel)
        
        let node = TreeNode(node: newSquare, label: textLabel)
        node.name = newSquare.name!
        node.type = "Square"
        treeNodes.append(node)
        
        count = count + 1
    }
    
    func selectNodeForTouch(location: CGPoint) {
        let touchedNode = self.nodeAtPoint(location)
        
        if touchedNode is SKSpriteNode && touchedNode != background && touchedNode != diamond && touchedNode != square && touchedNode != line && touchedNode != text && touchedNode != trash && touchedNode != dash {
            selectedNode = touchedNode as! SKSpriteNode
        }
        
        if touchedNode is SKSpriteNode && touchedNode == background {
            dash.hidden = true
            selectedNode = SKSpriteNode()
        }
        
    }
    
    func pinched(sender: UIPinchGestureRecognizer) {
        if sender.scale > previousScale {
            previousScale = sender.scale
            selectedNode.runAction(SKAction.scaleBy(1.05, duration: 0))
            dash.runAction(SKAction.scaleBy(1.05, duration: 0))
        }
        if sender.scale < previousScale {
            previousScale = sender.scale
            selectedNode.runAction(SKAction.scaleBy(0.95, duration: 0))
            dash.runAction(SKAction.scaleBy(0.95, duration: 0))
        }
    }
    
    func showSelected(location: CGPoint) {
        dash.setScale(selectedNode.xScale)
        dash.hidden = false
        dash.position = location
    }
    
    func deleteNode(node: SKSpriteNode) {
        node.removeFromParent()
        dash.hidden = true
        for label in textLabels {
            if label.name == node.name {
                label.removeFromParent()
            }
        }
        
        var i = 0
        for treeNode in treeNodes {
            if node.name == treeNode.name {
                treeNodes.removeAtIndex(i)
            }
            i = i + 1
        }
        
        var j = 0
        var tempLabel: [String] = []
        for label in linkLabels {
            tempLabel = (label.name?.componentsSeparatedByString(","))!
            for tl in tempLabel {
                if tl == node.name {
                    label.removeFromParent()
                    linkLabels.removeAtIndex(j)
                    j = j - 1
                }
            }
            
            j = j + 1
        }
        
        var m = 0
        var tempLink: [String] = []
        for link in links {
            tempLink = (link.name?.componentsSeparatedByString(","))!
            for tl in tempLink {
                if tl == node.name {
                    link.removeFromParent()
                    links.removeAtIndex(m)
                    m = m - 1
                }
            }
            m = m + 1
        }
    }
    
    func checkCollisions() {
        if CGRectIntersectsRect(CGRectInset(trash.frame, -20, -20), self.selectedNode.frame) {
            deleteNode(selectedNode)
        }
    }
    
    func longPressed(sender: UILongPressGestureRecognizer) {
        textField.borderStyle = UITextBorderStyle.RoundedRect
        textField.becomeFirstResponder()
        textField.placeholder = "Text"
        textField.adjustsFontSizeToFitWidth = true
        textField.becomeFirstResponder()
        textField.delegate = self
        self.view!.addSubview(textField)

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textFieldContent = textField.text!
        
        for label in textLabels {
            if label.name == selectedNode.name {
                if textFieldContent != "" {
                    //label.hidden = false
                    label.text = textFieldContent
                }
            }
            
        }
        
        textField.resignFirstResponder()
        textField.removeFromSuperview()
        return true
        
    }
    
    func alertView(alertView:UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        
        if alertView.tag == 1 {
            if buttonIndex == alertView.cancelButtonIndex {
                line.removeFromParent()
                addChild(selectedLine)
            }
        }
        if alertView.tag == 3 {
            if buttonIndex != alertView.cancelButtonIndex {
                linkText = (alertView.textFieldAtIndex(0)?.text)!
                
                var num = 0
                var isAdd = true
                for p in paths {
                    if p.start.name == startNode.name {
                        num = num + 1
                        if p.label.text == linkText {
                            isAdd = false
                        }
                    }
                }
                if num > 1 || isAdd == false {
                    let alertView = UIAlertView()
                    alertView.title = "Alert"
                    alertView.tag = 4
                    alertView.message = "Cannot be added:\nthe start node cannot have two same or more than 2 conditions."
                    alertView.addButtonWithTitle("OK")
                    alertView.cancelButtonIndex = 0
                    alertView.delegate = self
                    alertView.show()
                }
                else if linkText != "" {
                    let linkLabel = SKLabelNode(fontNamed: "Thonburi-Bold")
                    linkLabel.name = startNode.name! + "," + endNode.name!
                    linkLabel.text = linkText
                    linkLabel.position = CGPointMake(endNode.position.x, startNode.position.y)
                    linkLabel.fontColor = SKColor.blackColor()
                    linkLabel.zPosition = 2
                    addChild(linkLabel)
                    linkLabels.append(linkLabel)
                    
                    let shapeNode = SKShapeNode()
                    shapeNode.path = self.drawLine(startNode, end: endNode)
                    shapeNode.name = startNode.name! + "," + endNode.name!
                    shapeNode.strokeColor = UIColor.blackColor()
                    shapeNode.lineWidth = 2
                    shapeNode.zPosition = 0
                    self.addChild(shapeNode)
                    links.append(shapeNode)
                    let path = Line(name: startNode.name! + "," + endNode.name!, start: startNode, end: endNode, label: linkLabel)
                    paths.append(path)
                    isSelectedLine = false
                    selectedLine.removeFromParent()
                    addChild(line)
                }
            }
            else {
                isSelectedLine = false
                selectedLine.removeFromParent()
                addChild(line)
            }
            
        }
        
    }
    
    func doubleTaped(sender: UITapGestureRecognizer) {
        var isSquare = false
        for s in newSquares {
            if s.name == selectedNode.name {
                isSquare = true
            }
        }
        if isSquare == true {
            let alertView = UIAlertView()
            alertView.title = "Alert"
            alertView.tag = 5
            alertView.message = "Cannot be added:\nthe advice box cannot be a start node."
            alertView.addButtonWithTitle("OK")
            alertView.cancelButtonIndex = 0
            alertView.delegate = self
            alertView.show()
        }
        else if isSelectedLine == true {
            startNode = selectedNode
            flag = 1
        }
        
    }
    
    func drawLine(start: SKSpriteNode, end: SKSpriteNode) -> CGPathRef? {
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, start.position.x, start.position.y)
        CGPathAddLineToPoint(path, nil, end.position.x, start.position.y)
        CGPathAddLineToPoint(path, nil, end.position.x, end.position.y)
        return path
    }
    
    func getAllNodes() -> [TreeNode] {
        return treeNodes
    }
    
    func getAllPaths() -> [Line] {
        return paths
    }
    
    func reloadProgram(program: Program) {
        for n in program.nodes! {
            let node = n as! Node
            if node.type == "Diamond" {
                let newDiamond = SKSpriteNode(imageNamed: "diamond")
                newDiamond.name = node.name
                newDiamond.setScale(CGFloat((node.scale?.floatValue)!))
                newDiamond.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                newDiamond.position = CGPoint(x: CGFloat(node.positionX!.floatValue), y: CGFloat(node.positionY!.floatValue))
                addChild(newDiamond)
                newDiamonds.append(newDiamond)
                
                let textLabel = SKLabelNode(fontNamed: "Thonburi-Bold")
                textLabel.text = node.label
                textLabel.name = newDiamond.name
                textLabel.fontSize = 20
                textLabel.position = CGPointMake(CGFloat(node.positionX!.floatValue), CGFloat(node.positionY!.floatValue))
                textLabel.fontColor = SKColor.blackColor()
                textLabel.zPosition = 1
                //textLabel.hidden = true
                textLabels.append(textLabel)
                addChild(textLabel)
                
                let treeNode = TreeNode(node: newDiamond, label: textLabel)
                treeNode.name = newDiamond.name!
                treeNode.type = "Diamond"
                treeNodes.append(treeNode)
                
                count = count + 1
            }
            
            if node.type == "Square" {
                let newSquare = SKSpriteNode(imageNamed: "square")
                newSquare.name = node.name
                newSquare.setScale(CGFloat((node.scale?.floatValue)!))
                newSquare.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                newSquare.position = CGPoint(x: CGFloat(node.positionX!.floatValue), y: CGFloat(node.positionY!.floatValue))
                addChild(newSquare)
                newSquares.append(newSquare)
                
                let textLabel = SKLabelNode(fontNamed: "Thonburi-Bold")
                textLabel.text = node.label
                textLabel.name = newSquare.name
                textLabel.fontSize = 20
                textLabel.position = CGPointMake(CGFloat(node.positionX!.floatValue), CGFloat(node.positionY!.floatValue))
                textLabel.fontColor = SKColor.blackColor()
                textLabel.zPosition = 1
                //textLabel.hidden = true
                textLabels.append(textLabel)
                addChild(textLabel)
                
                let node = TreeNode(node: newSquare, label: textLabel)
                node.name = newSquare.name!
                node.type = "Square"
                treeNodes.append(node)
                
                count = count + 1
            }
            
        }
        
        for l in program.links! {
            let pl = l as! Link
            
            let linkLabel = SKLabelNode(fontNamed: "Thonburi-Bold")
            linkLabel.name = pl.startNodeName! + "," + pl.endNodeName!
            linkLabel.text = pl.label
            linkLabel.position = CGPointMake(CGFloat(pl.endNodeX!.floatValue), CGFloat(pl.startNodeY!.floatValue))
            linkLabel.fontColor = SKColor.blackColor()
            linkLabel.zPosition = 2
            addChild(linkLabel)
            linkLabels.append(linkLabel)
            
            let shapeNode = SKShapeNode()
            for t in treeNodes {
                if t.getNode().name == pl.startNodeName {
                    startNode = t.getNode()
                }
                if t.getNode().name == pl.endNodeName {
                    endNode = t.getNode()
                }
            }
            shapeNode.path = self.drawLine(startNode, end: endNode)
            shapeNode.name = pl.startNodeName! + "," + pl.endNodeName!
            shapeNode.strokeColor = UIColor.blackColor()
            shapeNode.lineWidth = 2
            shapeNode.zPosition = 0
            self.addChild(shapeNode)
            links.append(shapeNode)
            let path = Line(name: pl.startNodeName! + "," + pl.endNodeName!, start: startNode, end: endNode, label: linkLabel)
            paths.append(path)
        }
    }
    
    
}
