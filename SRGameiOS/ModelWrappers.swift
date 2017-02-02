//
//  ModelWrappers.swift
//  SRGameiOS
//
//  Created by Mikołaj-iMac on 02.02.2017.
//  Copyright © 2017 Mikołaj Płachta. All rights reserved.
//

import Foundation
import GameplayKit

struct player
{
    public var ip : String
    var lossNumber : Int = 0
    public var sender : TCPSender
    public var id : Int
    public var x, y : Int
}

struct pos
{
    public var id : Int
    public var x, y : Int
}

class PlayerWrapper {
    var playerPos : [player] = []
    var playerId : Int = 0 // runda gracza
    var localPlayerId : Int = 0 // lokalny gracz
    
    init(playerPos: [player]) {
        self.playerPos = playerPos
    }}

class BoardsWrapper {
    var boards : [BoardModel] = []
    var treasurePos : pos = pos(id: 0, x: 0, y: 0)
    var tresurePacketAnalysed : Bool = false
    var roundLabel = SKLabelNode(fontNamed: "Arial")
    var counterLabel = SKLabelNode(fontNamed: "Arial")
    var numberOfCount : Int
    var lastValueOfCounter: TimeInterval
    
    init(boards: [BoardModel]) {
        self.boards = boards
        self.numberOfCount = 0
        self.lastValueOfCounter = 0
    }
    
    func setWidthHeightRoundLabel(width : Double, height :Double)
    {
        self.roundLabel.fontSize = 20
        self.roundLabel.fontColor = UIColor.white
        self.roundLabel.position = CGPoint(x: -Int(width * 0.48) + 410, y: 85 + Int(height * 0.5))
    }
    
    func setWidthHeightCounterLabel(width : Double, height :Double)
    {
        self.counterLabel.fontSize = 20
        self.counterLabel.fontColor = UIColor.white
        self.counterLabel.position = CGPoint(x: -Int(width * 0.48) + 450, y: 50 + Int(height * 0.5))
    }
}
