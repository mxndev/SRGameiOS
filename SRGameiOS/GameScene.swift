//
//  GameScene.swift
//  SRGameiOS
//
//  Created by Mikołaj-iMac on 23.01.2017.
//  Copyright © 2017 Mikołaj Płachta. All rights reserved.
//

import SpriteKit
import GameplayKit

struct pos
{
    public var id : Int
    public var x, y : Int
}

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var boards : [BoardModel] = []

    var playerId : Int = 0
    var localPlayerId : Int = 0
    var playerPos : [pos] = []
    var playerRound : Int = 0
    var gameInitialized = false
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    func leftButton()
    {
        var newPos : pos = playerPos[localPlayerId]
        if(newPos.x - 1 < 0)
        {
            if(boards.count > 0)
            {
                if(newPos.id - 1 < 0)
                {
                    newPos.id = boards.count - 1;
                }
                else {
                    newPos.id -= 1;
                }
            }
            newPos.x = 19
        }
        else
        {
            newPos.x -= 1
        }
        makeMove(position: newPos, vertical: false)
    }
    
    func rightButton()
    {
        var newPos : pos = playerPos[localPlayerId]
        if(newPos.x + 1 > 19)
        {
            if(boards.count > 0)
            {
                if(newPos.id + 1 >= boards.count)
                {
                    newPos.id = 0;
                }
                else {
                    newPos.id += 1;
                }
            }
            newPos.x = 0
        }
        else
        {
            newPos.x += 1
        }
        makeMove(position: newPos, vertical: false)
    }
    
    func upButton()
    {
        var newPos : pos = playerPos[localPlayerId]
        if(newPos.y - 1 < 0)
        {
            if(boards.count > 2)
            {
                if(newPos.id / 2 == 0)
                {
                    if(((newPos.id == 1) && (boards.count > 3)) || ((newPos.id == 0) && (boards.count > 2)))
                    {
                        newPos.id += 2
                    }
                }
                else if(newPos.id / 2 == 1)
                {
                    newPos.id -= 2
                }
                newPos.y = 0
            }
        }
        else
        {
            newPos.y -= 1
        }
        makeMove(position: newPos, vertical: true)
    }
    
    func downButton()
    {
        var newPos : pos = playerPos[localPlayerId]
        if(newPos.y + 1 > 19)
        {
            if(boards.count > 2)
            {
                if(newPos.id / 2 == 0)
                {
                    if(((newPos.id == 1) && (boards.count > 3)) || ((newPos.id == 0) && (boards.count > 2)))
                    {
                        newPos.id += 2
                    }
                }
                else if(newPos.id / 2 == 1)
                {
                    newPos.id -= 2
                }
                newPos.y = 19
            }
        }
        else
        {
            newPos.y += 1
        }
        makeMove(position: newPos, vertical: true)
    }
    
    func leftDownButton()
    {
        var newPos : pos = playerPos[localPlayerId]
        if(newPos.x - 1 < 0)
        {
            if(boards.count > 0)
            {
                if(newPos.id - 1 < 0)
                {
                    newPos.id = boards.count - 1;
                }
                else {
                    newPos.id -= 1;
                }
            }
            newPos.x = 19
        }
        else
        {
            newPos.x -= 1
        }
        if(newPos.y + 1 > 19)
        {
            if(boards.count > 2)
            {
                if(newPos.id / 2 == 0)
                {
                    if(((newPos.id == 1) && (boards.count > 3)) || ((newPos.id == 0) && (boards.count > 2)))
                    {
                        newPos.id += 2
                    }
                }
                else if(newPos.id / 2 == 1)
                {
                    newPos.id -= 2
                }
                newPos.y = 19
            }
        }
        else
        {
            newPos.y += 1
        }

        makeMove(position: newPos, vertical: false)
    }
    
    func leftUpButton()
    {
        var newPos : pos = playerPos[localPlayerId]
        if(newPos.x - 1 < 0)
        {
            if(boards.count > 0)
            {
                if(newPos.id - 1 < 0)
                {
                    newPos.id = boards.count - 1;
                }
                else {
                    newPos.id -= 1;
                }
            }
            newPos.x = 19
        }
        else
        {
            newPos.x -= 1
        }
        if(newPos.y - 1 < 0)
        {
            if(boards.count > 2)
            {
                if(newPos.id / 2 == 0)
                {
                    if(((newPos.id == 1) && (boards.count > 3)) || ((newPos.id == 0) && (boards.count > 2)))
                    {
                        newPos.id += 2
                    }
                }
                else if(newPos.id / 2 == 1)
                {
                    newPos.id -= 2
                }
                newPos.y = 0
            }
        }
        else
        {
            newPos.y -= 1
        }
        makeMove(position: newPos, vertical: false)
    }
    
    func rightDownButton()
    {
        var newPos : pos = playerPos[localPlayerId]
        if(newPos.x + 1 > 19)
        {
            if(boards.count > 0)
            {
                if(newPos.id + 1 >= boards.count)
                {
                    newPos.id = 0;
                }
                else {
                    newPos.id += 1;
                }
            }
            newPos.x = 0
        }
        else
        {
            newPos.x += 1
        }
        if(newPos.y + 1 > 19)
        {
            if(boards.count > 2)
            {
                if(newPos.id / 2 == 0)
                {
                    if(((newPos.id == 1) && (boards.count > 3)) || ((newPos.id == 0) && (boards.count > 2)))
                    {
                        newPos.id += 2
                    }
                }
                else if(newPos.id / 2 == 1)
                {
                    newPos.id -= 2
                }
                newPos.y = 19
            }
        }
        else
        {
            newPos.y += 1
        }
        makeMove(position: newPos, vertical: false)
    }
    
    func rightUpButton()
    {
        var newPos : pos = playerPos[localPlayerId]
        if(newPos.x + 1 > 19)
        {
            if(boards.count > 0)
            {
                if(newPos.id + 1 >= boards.count)
                {
                    newPos.id = 0;
                }
                else {
                    newPos.id += 1;
                }
            }
            newPos.x = 0
        }
        else
        {
            newPos.x += 1
        }
        if(newPos.y - 1 < 0)
        {
            if(boards.count > 2)
            {
                if(newPos.id / 2 == 0)
                {
                    if(((newPos.id == 1) && (boards.count > 3)) || ((newPos.id == 0) && (boards.count > 2)))
                    {
                        newPos.id += 2
                    }
                }
                else if(newPos.id / 2 == 1)
                {
                    newPos.id -= 2
                }
                newPos.y = 0
            }
        }
        else
        {
            newPos.y -= 1
        }
        makeMove(position: newPos, vertical: false)
    }
    
    func checkMove(position : pos) -> Bool
    {
        if((boards[position.id].matrix[position.x][position.y] != 5) && (boards[position.id].matrix[position.x][position.y]  != 1) && (boards[position.id].matrix[position.x][position.y]  != 2) && (boards[position.id].matrix[position.x][position.y]  != 3) && (boards[position.id].matrix[position.x][position.y]  != 4))
        {
            return true
        }
        else{
            return false
        }
    }
    
    func makeMove(position : pos, vertical : Bool)
    {
        if(checkMove(position: position))
        {
            // zmiana pozycji w tablicy
            boards[playerPos[playerId].id].matrix[playerPos[playerId].x][playerPos[playerId].y] = 0
            playerPos[playerId] = position
            boards[position.id].matrix[position.x][position.y] = playerId + 1
            if(localPlayerId == playerId)
            {
                // odkrycie nowych pól
                for var i in (position.x-1..<position.x+2)
                {
                    var boardId = position.id
                    for var j in (position.y-1..<position.y+2)
                    {
                        if(i < 0)
                        {
                            if(boards.count > 0)
                            {
                                if(boardId - 1 < 0)
                                {
                                    boardId = boards.count - 1;
                                }
                                else {
                                    boardId -= 1;
                                }
                            }
                            i = 19
                        }
                        if(i > 19)
                        {
                            if(boards.count > 0)
                            {
                                if(boardId + 1 >= boards.count)
                                {
                                    boardId = 0;
                                }
                                else {
                                    boardId += 1;
                                }
                            }
                            i = 0
                        }
                        if(j < 0)
                        {
                            if(boards.count > 2)
                            {
                                if(boardId2 / 2 == 0)
                                {
                                    if(((boardId == 1) && (boards.count > 3)) || ((boardId == 0) && (boards.count > 2)))
                                    {
                                        boardId += 2
                                    }
                                }
                                else if(boardId / 2 == 1)
                                {
                                    boardId -= 2
                                }
                            }
                            j = 0
                        }
                        if(j > 19)
                        {
                            if(boards.count > 2)
                            {
                                if(boardId2 / 2 == 0)
                                {
                                    if(((boardId == 1) && (boards.count > 3)) || ((boardId == 0) && (boards.count > 2)))
                                    {
                                        boardId += 2
                                    }
                                }
                                else if(boardId / 2 == 1)
                                {
                                    boardId -= 2
                                }
                            }
                            j = 19
                        }
                        boards[boardId].matrixVisible[i][j] = 1
                        if(vertical)
                        {
                            boardId = position.id
                        }
                    }
                }
            }
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(!gameInitialized)
        {
            let buttonLeft = UIButton(frame: CGRect(x: 10, y: 80, width: 100, height: 50))
            buttonLeft.setTitle("Lewo", for: .normal)
            buttonLeft.addTarget(self, action: #selector(leftButton), for: .touchUpInside)
            self.view?.addSubview(buttonLeft)
            
            let buttonRight = UIButton(frame: CGRect(x: 250, y: 80, width: 100, height: 50))
            buttonRight.setTitle("Prawo", for: .normal)
            buttonRight.addTarget(self, action: #selector(rightButton), for: .touchUpInside)
            self.view?.addSubview(buttonRight)
            
            let buttonUp = UIButton(frame: CGRect(x: 120, y: 10, width: 100, height: 50))
            buttonUp.setTitle("Góra", for: .normal)
            buttonUp.addTarget(self, action: #selector(upButton), for: .touchUpInside)
            self.view?.addSubview(buttonUp)
            
            let buttonDown = UIButton(frame: CGRect(x: 120, y: 140, width: 100, height: 50))
            buttonDown.setTitle("Dół", for: .normal)
            buttonDown.addTarget(self, action: #selector(downButton), for: .touchUpInside)
            self.view?.addSubview(buttonDown)
            
            let buttonLeftDown = UIButton(frame: CGRect(x: 10, y: 140, width: 100, height: 50))
            buttonLeftDown.setTitle("Lewo-Dół", for: .normal)
            buttonLeftDown.addTarget(self, action: #selector(leftDownButton), for: .touchUpInside)
            self.view?.addSubview(buttonLeftDown)
            
            let buttonLeftUp = UIButton(frame: CGRect(x: 10, y: 10, width: 100, height: 50))
            buttonLeftUp.setTitle("Lewo-Góra", for: .normal)
            buttonLeftUp.addTarget(self, action: #selector(leftUpButton), for: .touchUpInside)
            self.view?.addSubview(buttonLeftUp)
            
            let buttonRightDown = UIButton(frame: CGRect(x: 250, y: 140, width: 100, height: 50))
            buttonRightDown.setTitle("Prawo-Dół", for: .normal)
            buttonRightDown.addTarget(self, action: #selector(rightDownButton), for: .touchUpInside)
            self.view?.addSubview(buttonRightDown)
            
            let buttonRightUp = UIButton(frame: CGRect(x: 250, y: 10, width: 100, height: 50))
            buttonRightUp.setTitle("Prawo-Góra", for: .normal)
            buttonRightUp.addTarget(self, action: #selector(rightUpButton), for: .touchUpInside)
            self.view?.addSubview(buttonRightUp)
            
            playerPos.append(pos(id: 0, x: 9, y: 9))
            boards.append(BoardModel(x: 0, y: -350, scene: self))
            boards.append(BoardModel(x: 370, y: -350, scene: self))
            boards.append(BoardModel(x: 0, y: -700, scene: self))
            boards.append(BoardModel(x: 370, y: -700, scene: self))
            makeMove(position: playerPos[0], vertical: true)
            //matrixShape2 = renderBoard(matrix: matrix2, posX: 0, posY: -700)
            //matrixShape3 = renderBoard(matrix: matrix3, posX: 370, posY: -350)
            //matrixShape4 = renderBoard(matrix: matrix4, posX: 370, posY: -700)
            gameInitialized = true;
        }
        for i in(0..<boards.count)
        {
            boards[i].refreshBoard()
        }
    }
}
