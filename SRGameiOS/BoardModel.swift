//
//  BoardModel.swift
//  SRGameiOS
//
//  Created by Mikołaj-iMac on 24.01.2017.
//  Copyright © 2017 Mikołaj Płachta. All rights reserved.
//

import Foundation
import GameplayKit

class BoardModel {
    
    var lossNumber : Int = 0
    public var matrix : [[Int]] = Array(repeating: Array(repeating: 0, count: 20), count: 20) // 1..4 - pozycje graczy, 5 - teren zabudowany, 6 - mina, 7 - skarb
    public var matrixVisible : [[Int]] = Array(repeating: Array(repeating: 0, count: 20), count: 20) // 0 - nieodkryty, 1 - odkryty
    var matrixShape : [[SKShapeNode]] = []
    var label : [SKLabelNode] = []
    var posX : Int = 0
    var posY : Int = 0
    var skScene : SKScene
    var ip : String
    
    init(scene : SKScene, initializeFields : Bool)
    {
        skScene = scene
        
        ip = ""
        
        if(initializeFields)
        {
            ip = "127.0.0.1"
            
            //losowanie liczby
            lossNumber = randomInt(min: 0, max: 2000000)
            
            // ustawianie zabudowan
            for _ in(0..<30)
            {
                var x: Int = randomInt(min: 0, max: 19)
                var y: Int = randomInt(min: 0, max: 19)
                while ((x == 9) && (y == 9))
                {
                    x = randomInt(min: 0, max: 19)
                    y = randomInt(min: 0, max: 19)
                }
                matrix[x][y] = 5
            }
            
            // ustawianie min
            for _ in(0..<30)
            {
                var x: Int = randomInt(min: 0, max: 19)
                var y: Int = randomInt(min: 0, max: 19)
                while ((x == 9) && (y == 9))
                {
                    x = randomInt(min: 0, max: 19)
                    y = randomInt(min: 0, max: 19)
                }
                matrix[x][y] = 6
            }
            
        }
    }
    
    init(scene : SKScene, number : Int, ip : String)
    {
        skScene = scene
        
        self.ip = ip
        self.lossNumber = number
    }
    
    func setXY(x : Int, y : Int)
    {
        posX = x
        posY = y
    }
    
    func setFields(mines : [Dictionary<String, AnyObject>], fields : [Dictionary<String, AnyObject>])
    {
        // ustawianie zabudowan
        for element in fields
        {
            matrix[element["x"] as! Int][element["y"] as! Int] = 5
        }
        
        // ustawianie min
        for element in mines
        {
            matrix[element["x"] as! Int][element["y"] as! Int] = 6
        }
        
    }
    
    func genereteMinesBuildingDictionary(id : Int) -> Dictionary<String, AnyObject>
    {
        var mines : Array<Any> = []
        var buildings : Array<Any> = []
        for i in(0..<20)
        {
            for j in(0..<20)
            {
                if(matrix[i][j] == 5)
                {
                    var element : Dictionary<String, AnyObject> = [:]
                    element["p"] = id as AnyObject?
                    element["x"] = i as AnyObject?
                    element["y"] = j as AnyObject?
                    buildings.append(element)
                }
            }
        }
        for i in(0..<20)
        {
            for j in(0..<20)
            {
                if(matrix[i][j] == 6)
                {
                    var element : Dictionary<String, AnyObject> = [:]
                    element["p"] = id as AnyObject?
                    element["x"] = i as AnyObject?
                    element["y"] = j as AnyObject?
                    mines.append(element)
                }
            }
        }
        var mapp : Dictionary<String, AnyObject> = [:]
        var message : Dictionary<String, AnyObject> = [:]
        mapp["mines"] = mines as AnyObject?
        mapp["buildings"] = buildings as AnyObject?
        message["map"] = mapp as AnyObject?
        return message
    }
    
    func refreshBoard()
    {
        // refresh matrix
        for i in (0..<matrix.count)
        {
            for j in (0..<matrix[i].count)
            {
                if(matrix[i][j] == 1)
                {
                    matrixShape[i][j].fillColor = SKColor.blue
                }
                else if(matrix[i][j] == 2)
                {
                    matrixShape[i][j].fillColor = SKColor.brown
                }
                else if(matrix[i][j] == 3)
                {
                    matrixShape[i][j].fillColor = SKColor.orange
                }
                else if(matrix[i][j] == 4)
                {
                    matrixShape[i][j].fillColor = SKColor.purple
                }
                else if(matrix[i][j] == 5)
                {
                    matrixShape[i][j].fillColor = SKColor.yellow
                }
                else if(matrix[i][j] == 6)
                {
                    matrixShape[i][j].fillColor = SKColor.red
                }
                else if(matrix[i][j] == 7)
                {
                    matrixShape[i][j].fillColor = SKColor.cyan
                }
                else if(matrixVisible[i][j] == 0)
                {
                    matrixShape[i][j].fillColor = SKColor.white
                }
                else if(matrixVisible[i][j] == 1)
                {
                    matrixShape[i][j].fillColor = SKColor.green
                }
            }
        }
    }
    
    func renderBoard()
    {
        if((matrixShape.count == 0) && (label.count == 0))
        {
            for i in (0..<matrix.count)
            {
                var shapeLine : [SKShapeNode] = []
                for j in (0..<matrix[i].count)
                {
                    shapeLine.append(SKShapeNode(rectOf: CGSize(width: 15, height: 15)))
                    shapeLine[j].name = "bar"
                    shapeLine[j].fillColor = SKColor.white
                    shapeLine[j].position = CGPoint(x: i*17 - Int(skScene.size.width*0.48) + posX, y: Int(skScene.size.height*0.5) - 15 - j*17 + posY)
                    skScene.addChild(shapeLine[j])
                
                    if(calculateMines(posX: i, posY: j) > 0)
                    {
                        label.append(SKLabelNode(fontNamed: "Arial"))
                        label[label.count - 1].text = String(calculateMines(posX: i, posY: j))
                        label[label.count - 1].fontSize = 15
                        label[label.count - 1].fontColor = UIColor.black
                        label[label.count - 1].position = CGPoint(x: i*17 - Int(skScene.size.width*0.48) + posX, y: Int(skScene.size.height*0.5) - 21 - j*17 + posY)
                        skScene.addChild(label[label.count - 1])
                    }
                }
                matrixShape.append(shapeLine)
            }
        }
        else
        {
            for i in (0..<matrix.count)
            {
                for j in (0..<matrix[i].count)
                {
                    skScene.addChild(matrixShape[i][j])
                }
            }
            for i in (0..<label.count)
            {
                skScene.addChild(label[i])
            }
        }
    }
    
    func randomInt(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    func calculateMines(posX : Int, posY : Int) -> Int
    {
        var counter : Int = 0
        for i in (posX-1..<posX+1)
        {
            for j in (posY-1..<posY+1)
            {
                if((i >= 0) && (i <= 19) && (j >= 0) && (j <= 19))
                {
                    if(matrix[i][j] == 6)
                    {
                        counter += 1
                    }
                }
            }
        }
        return counter
    }
}
