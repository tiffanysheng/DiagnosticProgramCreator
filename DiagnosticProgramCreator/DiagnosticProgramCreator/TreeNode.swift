//
//  TreeNode.swift
//  DiagnosticProgramCreator
//
//  Created by Tiffany Sheng on 10/04/2016.
//  Copyright © 2016 Tiffany Sheng. All rights reserved.
//

import UIKit
import SpriteKit

class TreeNode {
    
    var name = "0"
    var skNode = SKSpriteNode()
    var textLabel = SKLabelNode(fontNamed: "Thonburi-Bold")
    var type = ""
    
    var position: CGPoint{
        get{ return skNode.position }
        set( newPosition ) {
            skNode.position = newPosition
            textLabel.position = newPosition
        }
    }
    
    init() {
        self.textLabel.position = self.skNode.position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(node: SKSpriteNode) {
        self.skNode = node
        self.skNode.position = node.position
    }
    
    init(node: SKSpriteNode, label: SKLabelNode) {
        self.skNode = node
        self.textLabel = label
        self.textLabel.position = self.skNode.position
    }
    
    func getName() -> String {
        return name
    }
    
    func getNode() -> SKSpriteNode {
        return skNode
    }
    
    func getLabel() -> SKLabelNode {
        return textLabel
    }
    
    func getType() -> String {
        return type
    }
    
    func setName(name: String) {
        self.name = name
    }
    
    func setNode(node: SKSpriteNode) {
        self.skNode = node
    }
    
    func setLabel(label: SKLabelNode) {
        self.textLabel = label
    }
    
    func setType(type: String) {
        self.type = type
    }
    
}
