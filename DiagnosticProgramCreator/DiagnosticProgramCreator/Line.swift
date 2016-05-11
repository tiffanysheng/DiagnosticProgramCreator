//
//  Line.swift
//  DiagnosticProgramCreator
//
//  Created by Tiffany Sheng on 13/04/2016.
//  Copyright © 2016 Tiffany Sheng. All rights reserved.
//

import SpriteKit

class Line {
    var start: SKSpriteNode
    var end: SKSpriteNode
    var name: String
    var label: SKLabelNode
    
    init(name: String, start: SKSpriteNode, end: SKSpriteNode, label: SKLabelNode) {
        self.name = name
        self.start = start
        self.end = end
        self.label = label
    }
    
    func getStart() -> SKSpriteNode {
        return self.start
    }
    
    func getEnd() -> SKSpriteNode {
        return self.end
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getLabel() -> SKLabelNode {
        return self.label
    }
    
}
