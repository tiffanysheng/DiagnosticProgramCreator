//
//  ProgramDao.swift
//  DiagnosticProgramCreator
//
//  Created by Tiffany Sheng on 10/05/2016.
//  Copyright © 2016 Tiffany Sheng. All rights reserved.
//

import UIKit
import CoreData

private let sharedInstance = ProgramDao()

class ProgramDao {
    
    class var sharedDao: ProgramDao {
        return sharedInstance
    }
    
    func findAll() -> [Program] {
        var items: [Program] = []
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Program")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            items = results as! [Program]
        }
        catch {
            print("error")
        }
        return items
    }
    
    func getProgramByTitle(programTitle: String) -> Program {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let pTitle = programTitle
        let programFetch = NSFetchRequest(entityName: "Program")
        programFetch.predicate = NSPredicate(format: "title == %@", pTitle)
        var items: [Program] = []
        do {
            let results = try managedContext.executeFetchRequest(programFetch)
            items = results as! [Program]
            
        }
        catch {
            print("error")
        }
        return items[0]
    }
    
    func remove(program: Program) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        managedContext.deleteObject(program)
        
        do {
            try managedContext.save()
        }
        catch {
            print("error")
        }
    }
    
    func saveProgram(title: String, desc: String, treeNodes: [TreeNode], paths: [Line]) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let pEntity = NSEntityDescription.entityForName("Program", inManagedObjectContext: managedContext)
        let program = Program(entity: pEntity!, insertIntoManagedObjectContext: managedContext)
        program.title = title
        program.desc = desc
        
        let nodes = program.nodes?.mutableCopy() as! NSMutableSet
        let appDelegate2 = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext2 = appDelegate2.managedObjectContext
        let nEntity = NSEntityDescription.entityForName("Node", inManagedObjectContext: managedContext2)
        var ns:[Node] = []
        for treeNode in treeNodes {
            let n = Node(entity: nEntity!, insertIntoManagedObjectContext: managedContext2)
            n.name = treeNode.getName()
            n.type = treeNode.getType()
            n.label = treeNode.getLabel().text
            n.scale = treeNode.getNode().xScale
            n.positionX = treeNode.getNode().position.x
            n.positionY = treeNode.getNode().position.y
            for p in paths {
                if p.start == treeNode.getNode() && p.label.text == "Y" {
                    n.yesNode = p.end.name
                }
                if p.start == treeNode.getNode() && p.label.text == "N" {
                    n.noNode = p.end.name
                }
            }
            ns.append(n)
        }
        print(ns)
        nodes.addObjectsFromArray(ns)
        program.nodes = nodes.copy() as! NSSet
        
        let lines = program.links?.mutableCopy() as! NSMutableSet
        let appDelegate3 = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext3 = appDelegate3.managedObjectContext
        let lEntity = NSEntityDescription.entityForName("Link", inManagedObjectContext: managedContext3)
        var ls:[Link] = []
        for line in paths {
            let l = Link(entity: lEntity!, insertIntoManagedObjectContext: managedContext3)
            l.name = line.getName()
            l.startNodeX = line.getStart().position.x
            l.startNodeY = line.getStart().position.y
            l.endNodeX = line.getEnd().position.x
            l.endNodeY = line.getEnd().position.y
            l.startNodeName = line.getStart().name
            l.endNodeName = line.getEnd().name
            l.label = line.getLabel().text
            
            ls.append(l)
        }
        print(ls)
        lines.addObjectsFromArray(ls)
        program.links = lines.copy() as! NSSet
        
        do {
            try managedContext.save()
        }
        catch {
            print("error")
        }

    }
    
    func updateProgram(title: String, desc: String, p: Program, treeNodes: [TreeNode], paths: [Line]) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        for n in p.nodes! {
            managedContext.deleteObject(n as! Node)
        }
        
        for l in p.links! {
            managedContext.deleteObject(l as! Link)
        }
        
        p.title = title
        p.desc = desc
        
        let nodes = p.nodes?.mutableCopy() as! NSMutableSet
        let appDelegate2 = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext2 = appDelegate2.managedObjectContext
        let nEntity = NSEntityDescription.entityForName("Node", inManagedObjectContext: managedContext2)
        var ns:[Node] = []
        for treeNode in treeNodes {
            let n = Node(entity: nEntity!, insertIntoManagedObjectContext: managedContext2)
            n.name = treeNode.getName()
            n.type = treeNode.getType()
            n.label = treeNode.getLabel().text
            n.scale = treeNode.getNode().xScale
            n.positionX = treeNode.getNode().position.x
            n.positionY = treeNode.getNode().position.y
            for p1 in paths {
                if p1.start == treeNode.getNode() && p1.label.text == "Y" {
                    n.yesNode = p1.end.name
                }
                if p1.start == treeNode.getNode() && p1.label.text == "N" {
                    n.noNode = p1.end.name
                }
            }
            ns.append(n)
        }
        print(ns)
        nodes.addObjectsFromArray(ns)
        p.nodes = nodes.copy() as! NSSet
        
        let lines = p.links?.mutableCopy() as! NSMutableSet
        let appDelegate3 = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext3 = appDelegate3.managedObjectContext
        let lEntity = NSEntityDescription.entityForName("Link", inManagedObjectContext: managedContext3)
        var ls:[Link] = []
        for line in paths {
            let l = Link(entity: lEntity!, insertIntoManagedObjectContext: managedContext3)
            l.name = line.getName()
            l.startNodeX = line.getStart().position.x
            l.startNodeY = line.getStart().position.y
            l.endNodeX = line.getEnd().position.x
            l.endNodeY = line.getEnd().position.y
            l.startNodeName = line.getStart().name
            l.endNodeName = line.getEnd().name
            l.label = line.getLabel().text
            
            ls.append(l)
        }
        print(ls)
        lines.addObjectsFromArray(ls)
        p.links = lines.copy() as! NSSet
        
        do {
            try managedContext.save()
        }
        catch {
            print("error")
        }
    }
    
}
