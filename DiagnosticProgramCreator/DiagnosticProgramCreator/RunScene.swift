//
//  RunScene.swift
//  DiagnosticProgramCreator
//
//  Created by Tiffany Sheng on 20/04/2016.
//  Copyright © 2016 Tiffany Sheng. All rights reserved.
//

import UIKit
import SpriteKit
import CoreData
import AVFoundation

class RunScene: SKScene {
    
    let playableRect: CGRect
    let background = SKSpriteNode(imageNamed: "runbackground")
    let doctor = SKSpriteNode(imageNamed: "doctor")
    let text = SKLabelNode(fontNamed: "Thonburi-Bold")
    let yes = SKSpriteNode(imageNamed: "yes")
    let no = SKSpriteNode(imageNamed: "no")
    let bubble = SKSpriteNode(imageNamed: "messageBubble")
    var program: Program!
    var currentNode: Node!
    let π = CGFloat(M_PI)
    var av: AVSpeechSynthesizer = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance(string: "Hello")
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.whiteColor()
        
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        addChild(background)
        
        doctor.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        doctor.position = CGPoint(x: CGRectGetMinX(playableRect) + CGRectGetWidth(playableRect)/5, y: CGRectGetMaxY(playableRect)/3)
        doctor.setScale(0.8)
        doctor.zPosition = 2
        doctor.runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.rotateToAngle(π/8, duration: 0.5),
                SKAction.rotateToAngle(-π/8, duration: 0.5),
                ])
            ))
        addChild(doctor)
        
        bubble.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        bubble.position = CGPoint(x: CGRectGetMidX(playableRect) + 100, y: CGRectGetMidY(playableRect) + 100)
        bubble.setScale(0.5)
        bubble.zPosition = 1
        addChild(bubble)
        
        text.position = CGPointMake(bubble.position.x, bubble.position.y)
        text.fontColor = SKColor.blackColor()
        text.zPosition = 2
        addChild(text)
        
        no.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        no.setScale(0.12)
        no.position = CGPoint(x: CGRectGetMinX(playableRect) + CGRectGetWidth(playableRect)/4, y: 150)
        no.zPosition = 3
        no.runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.scaleTo(0.15, duration: 0.5),
                SKAction.scaleTo(0.12, duration: 0.5),
                SKAction.scaleTo(0.15, duration: 0.5),
                ])
            ))
        addChild(no)
        
        yes.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        yes.setScale(0.12)
        yes.position = CGPoint(x: CGRectGetMinX(playableRect) + CGRectGetWidth(playableRect)*3/4, y: 150)
        yes.zPosition = 3
        yes.runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.scaleTo(0.15, duration: 0.5),
                SKAction.scaleTo(0.12, duration: 0.5),
                SKAction.scaleTo(0.15, duration: 0.5),
                ])
            ))
        addChild(yes)
        
        
    }
    
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 9.0/16.0
        let playableWidth = size.height * maxAspectRatio
        let playableMargin = (size.width - playableWidth)/2.0
        playableRect = CGRect(x: playableMargin, y: 0, width: playableWidth, height: size.height)
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
        }
        catch let error as NSError{
            print(error.code)
        }
        utterance.preUtteranceDelay = 0.0
        utterance.postUtteranceDelay = 0.0
        utterance.rate = 0.4
        av.speakUtterance(utterance)
        
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let touchLocation = touch.locationInNode(self)
            
            if self.nodeAtPoint(touchLocation) == self.yes {
                //self.getNextNode("yes")
                for n in self.program.nodes! {
                    let nextNode = n as! Node
                    if nextNode.name == currentNode.yesNode {
                        text.text = nextNode.label
                        currentNode = nextNode
                        utterance = AVSpeechUtterance(string: currentNode.label!)
                        utterance.preUtteranceDelay = 0.0
                        utterance.postUtteranceDelay = 0.0
                        utterance.rate = 0.4
                        av.speakUtterance(utterance)
                        
                        if currentNode.type == "Square" {
                            yes.removeFromParent()
                            no.removeFromParent()
                        }
                        break
                        
                    }
                }
                
            }
            if self.nodeAtPoint(touchLocation) == self.no {
                //self.getNextNode("no")
                for n in self.program.nodes! {
                    let nextNode = n as! Node
                    if nextNode.name == currentNode.noNode {
                        text.text = nextNode.label
                        currentNode = nextNode
                        utterance = AVSpeechUtterance(string: currentNode.label!)
                        utterance.preUtteranceDelay = 0.0
                        utterance.postUtteranceDelay = 0.0
                        utterance.rate = 0.4
                        av.speakUtterance(utterance)
                        
                        if currentNode.type == "Square" {
                            yes.removeFromParent()
                            no.removeFromParent()
                        }
                        break
                    }
                }
            }
            
        }
    }
    
    func getProgram(program: Program) {
        self.program = program
        
        var ysNodeName: [String] = []
        for n in program.nodes! {
            let node = n as! Node
            if node.yesNode != nil {
                ysNodeName.append(node.yesNode!)
                
            }
            if node.noNode != nil {
                ysNodeName.append(node.noNode!)
                
            }
        }
        
        for n1 in program.nodes! {
            var isExist = false
            let node1 = n1 as! Node
            for ysn in ysNodeName {
                if node1.name == ysn {
                    isExist = true
                }
            }
            if isExist == false {
                text.text = node1.label
                currentNode = node1
                utterance = AVSpeechUtterance(string: currentNode.label!)
                utterance.preUtteranceDelay = 0.0
                utterance.postUtteranceDelay = 0.0
                utterance.rate = 0.4
                av.speakUtterance(utterance)
                
            }
        }
        
        
        
        
    }
    
}
