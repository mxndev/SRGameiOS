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
    public var matrix : [[Int]] = Array(repeating: Array(repeating: 0, count: 20), count: 20) // 1..4 - pozycje graczy, 5 - teren zabudowany, 6 - mina
    public var matrixVisible : [[Int]] = Array(repeating: Array(repeating: 0, count: 20), count: 20) // 0 - nieodkryty, 1 - odkryty
    var matrixShape : [[SKShapeNode]] = []
    var posX : Int = 0
    var posY : Int = 0
    var skScene : SKScene
    
    init(x : Int, y : Int, scene : SKScene)
    {
        posX = x
        posY = y
        skScene = scene
        renderBoard(posX: posX, posY: posY)
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
    
    func renderBoard(posX : Int, posY : Int)
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
            }
            matrixShape.append(shapeLine)
        }
    }
}
