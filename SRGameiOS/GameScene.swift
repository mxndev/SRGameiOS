//
//  GameScene.swift
//  SRGameiOS
//
//  Created by Mikołaj-iMac on 23.01.2017.
//  Copyright © 2017 Mikołaj Płachta. All rights reserved.
//

import SpriteKit
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
    
    init(playerPos: [player]) {
        self.playerPos = playerPos
    }}

class BoardsWrapper {
    var boards : [BoardModel] = []
    var treasurePos : pos = pos(id: 0, x: 0, y: 0)
    var tresurePacketAnalysed : Bool = false
    
    init(boards: [BoardModel]) {
        self.boards = boards
    }
}

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var boardsWrapper : BoardsWrapper = BoardsWrapper(boards: [])

    var localPlayerId : Int = 0 // lokalny gracz
    var gameState : Int = 0 // 0 - ekran wpisywania ip, 1 - ekran łączenia, 2 - inicjalizowanie gry, 3 - tryb gry
    var initializingGameState : Int = 0 // 0 - ustawianie kolejki rundy, 1 - przesłanie map, 3 - generacja skarbu
    var appLoaded : Bool = false
    var roundQueueLoaded : Bool = false
    var playerWrapper : PlayerWrapper = PlayerWrapper(playerPos: [])
    var playerRound : Int = 0
    var buttonLeft : UIButton = UIButton()
    var buttonRight : UIButton = UIButton()
    var buttonUp : UIButton = UIButton()
    var buttonDown : UIButton = UIButton()
    var buttonLeftDown : UIButton = UIButton()
    var buttonLeftUp : UIButton = UIButton()
    var buttonRightDown : UIButton = UIButton()
    var buttonRightUp : UIButton = UIButton()
    var sender : TCPListener!
    var labelIp : SKLabelNode?
    var ip1 : UITextField = UITextField()
    var port1 : UITextField = UITextField()
    var ip2 : UITextField = UITextField()
    var port2 : UITextField = UITextField()
    var ip3 : UITextField = UITextField()
    var port3 : UITextField = UITextField()
    var connect : UIButton = UIButton()
    var labelConnecting : SKLabelNode?
    var countOfPlayers : Int = 0
    
    override func didMove(to view: SKView) {
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    func leftButton()
    {
        if(localPlayerId == playerWrapper.playerId)
        {
            var newPlayer : player = playerWrapper.playerPos[localPlayerId]
            if(newPlayer.x - 1 < 0)
            {
                if(boardsWrapper.boards.count > 0)
                {
                    if(newPlayer.id - 1 < 0)
                    {
                        newPlayer.id = boardsWrapper.boards.count - 1;
                    }
                    else {
                        newPlayer.id -= 1;
                    }
                }
                newPlayer.x = 19
            }
            else
            {
                newPlayer.x -= 1
            }
            makeMove(player: newPlayer, dontSendPos: false, goFuther: true)
        }
    }
    
    func rightButton()
    {
        if(localPlayerId == playerWrapper.playerId)
        {
            var newPlayer : player = playerWrapper.playerPos[localPlayerId]
            if(newPlayer.x + 1 > 19)
            {
                if(boardsWrapper.boards.count > 0)
                {
                    if(newPlayer.id + 1 >= boardsWrapper.boards.count)
                    {
                        newPlayer.id = 0;
                    }
                    else {
                        newPlayer.id += 1;
                    }
                }
                newPlayer.x = 0
            }
            else
            {
                newPlayer.x += 1
            }
            makeMove(player: newPlayer, dontSendPos: false, goFuther: true)
        }
    }
    
    func upButton()
    {
        if(localPlayerId == playerWrapper.playerId)
        {
            var newPlayer : player = playerWrapper.playerPos[localPlayerId]
            if(newPlayer.y - 1 < 0)
            {
                if(boardsWrapper.boards.count > 2)
                {
                    if(newPlayer.id / 2 == 0)
                    {
                        if(((newPlayer.id == 1) && (boardsWrapper.boards.count > 3)) || ((newPlayer.id == 0) && (boardsWrapper.boards.count > 2)))
                        {
                            newPlayer.id += 2
                        }
                    }
                    else if(newPlayer.id / 2 == 1)
                    {
                        newPlayer.id -= 2
                    }
                    newPlayer.y = 0
                }
            }
            else
            {
                newPlayer.y -= 1
            }
            makeMove(player: newPlayer, dontSendPos: false, goFuther: true)
        }
    }
    
    func downButton()
    {
        if(localPlayerId == playerWrapper.playerId)
        {
            var newPlayer : player = playerWrapper.playerPos[localPlayerId]
            if(newPlayer.y + 1 > 19)
            {
                if(boardsWrapper.boards.count > 2)
                {
                    if(newPlayer.id / 2 == 0)
                    {
                        if(((newPlayer.id == 1) && (boardsWrapper.boards.count > 3)) || ((newPlayer.id == 0) && (boardsWrapper.boards.count > 2)))
                        {
                            newPlayer.id += 2
                        }
                    }
                    else if(newPlayer.id / 2 == 1)
                    {
                        newPlayer.id -= 2
                    }
                    newPlayer.y = 19
                }
            }
            else
            {
                newPlayer.y += 1
            }
            makeMove(player: newPlayer, dontSendPos: false, goFuther: true)
        }
    }
    
    func leftDownButton()
    {
        if(localPlayerId == playerWrapper.playerId)
        {
            var newPlayer : player = playerWrapper.playerPos[localPlayerId]
            if(newPlayer.x - 1 < 0)
            {
                if(boardsWrapper.boards.count > 0)
                {
                    if(newPlayer.id - 1 < 0)
                    {
                        newPlayer.id = boardsWrapper.boards.count - 1;
                    }
                    else {
                        newPlayer.id -= 1;
                    }
                }
                newPlayer.x = 19
            }
            else
            {
                newPlayer.x -= 1
            }
            if(newPlayer.y + 1 > 19)
            {
                if(boardsWrapper.boards.count > 2)
                {
                    if(newPlayer.id / 2 == 0)
                    {
                        if(((newPlayer.id == 1) && (boardsWrapper.boards.count > 3)) || ((newPlayer.id == 0) && (boardsWrapper.boards.count > 2)))
                        {
                            newPlayer.id += 2
                        }
                    }
                    else if(newPlayer.id / 2 == 1)
                    {
                        newPlayer.id -= 2
                    }
                    newPlayer.y = 19
                }
            }
            else
            {
                newPlayer.y += 1
            }
            
            makeMove(player: newPlayer, dontSendPos: false, goFuther: true)
        }
    }
    
    func leftUpButton()
    {
        if(localPlayerId == playerWrapper.playerId)
        {
            var newPlayer : player = playerWrapper.playerPos[localPlayerId]
            if(newPlayer.x - 1 < 0)
            {
                if(boardsWrapper.boards.count > 0)
                {
                    if(newPlayer.id - 1 < 0)
                    {
                        newPlayer.id = boardsWrapper.boards.count - 1;
                    }
                    else {
                        newPlayer.id -= 1;
                    }
                }
                newPlayer.x = 19
            }
            else
            {
                newPlayer.x -= 1
            }
            if(newPlayer.y - 1 < 0)
            {
                if(boardsWrapper.boards.count > 2)
                {
                    if(newPlayer.id / 2 == 0)
                    {
                        if(((newPlayer.id == 1) && (boardsWrapper.boards.count > 3)) || ((newPlayer.id == 0) && (boardsWrapper.boards.count > 2)))
                        {
                            newPlayer.id += 2
                        }
                    }
                    else if(newPlayer.id / 2 == 1)
                    {
                        newPlayer.id -= 2
                    }
                    newPlayer.y = 0
                }
            }
            else
            {
                newPlayer.y -= 1
            }
            makeMove(player: newPlayer, dontSendPos: false, goFuther: true)
        }
    }
    
    func rightDownButton()
    {
        if(localPlayerId == playerWrapper.playerId)
        {
            var newPlayer : player = playerWrapper.playerPos[localPlayerId]
            if(newPlayer.x + 1 > 19)
            {
                if(boardsWrapper.boards.count > 0)
                {
                    if(newPlayer.id + 1 >= boardsWrapper.boards.count)
                    {
                        newPlayer.id = 0;
                    }
                    else {
                        newPlayer.id += 1;
                    }
                }
                newPlayer.x = 0
            }
            else
            {
                newPlayer.x += 1
            }
            if(newPlayer.y + 1 > 19)
            {
                if(boardsWrapper.boards.count > 2)
                {
                    if(newPlayer.id / 2 == 0)
                    {
                        if(((newPlayer.id == 1) && (boardsWrapper.boards.count > 3)) || ((newPlayer.id == 0) && (boardsWrapper.boards.count > 2)))
                        {
                            newPlayer.id += 2
                        }
                    }
                    else if(newPlayer.id / 2 == 1)
                    {
                        newPlayer.id -= 2
                    }
                    newPlayer.y = 19
                }
            }
            else
            {
                newPlayer.y += 1
            }
            makeMove(player: newPlayer, dontSendPos: false, goFuther: true)
        }
    }
    
    func rightUpButton()
    {
        if(localPlayerId == playerWrapper.playerId)
        {
            var newPlayer : player = playerWrapper.playerPos[localPlayerId]
            if(newPlayer.x + 1 > 19)
            {
                if(boardsWrapper.boards.count > 0)
                {
                    if(newPlayer.id + 1 >= boardsWrapper.boards.count)
                    {
                        newPlayer.id = 0;
                    }
                    else {
                        newPlayer.id += 1;
                    }
                }
                newPlayer.x = 0
            }
            else
            {
                newPlayer.x += 1
            }
            if(newPlayer.y - 1 < 0)
            {
                if(boardsWrapper.boards.count > 2)
                {
                    if(newPlayer.id / 2 == 0)
                    {
                        if(((newPlayer.id == 1) && (boardsWrapper.boards.count > 3)) || ((newPlayer.id == 0) && (boardsWrapper.boards.count > 2)))
                        {
                            newPlayer.id += 2
                        }
                    }
                    else if(newPlayer.id / 2 == 1)
                    {
                        newPlayer.id -= 2
                    }
                    newPlayer.y = 0
                }
            }
            else
            {
                newPlayer.y -= 1
            }
            makeMove(player: newPlayer, dontSendPos: false, goFuther: true)
        }
    }
    
    func checkMove(position : player) -> Bool
    {
        if((boardsWrapper.boards[position.id].matrix[position.x][position.y] != 5) && (boardsWrapper.boards[position.id].matrix[position.x][position.y]  != 1) && (boardsWrapper.boards[position.id].matrix[position.x][position.y]  != 2) && (boardsWrapper.boards[position.id].matrix[position.x][position.y]  != 3) && (boardsWrapper.boards[position.id].matrix[position.x][position.y]  != 4))
        {
            return true
        }
        else{
            return false
        }
    }
    
    func makeMove(player : player, dontSendPos : Bool, goFuther : Bool)
    {
        if(checkMove(position: player))
        {
            if(boardsWrapper.boards[player.id].matrix[player.x][player.y] == 6)
            {
                if(localPlayerId == playerWrapper.playerId)
                {
                    let refreshAlert2 = UIAlertController(title: "Uwaga", message: "Wszedłeś na minę. Koniec gry!", preferredStyle: UIAlertControllerStyle.alert)
                    
                    refreshAlert2.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                        self.buttonLeft.removeFromSuperview()
                        self.buttonRight.removeFromSuperview()
                        self.buttonDown.removeFromSuperview()
                        self.buttonUp.removeFromSuperview()
                        self.buttonLeftDown.removeFromSuperview()
                        self.buttonLeftUp.removeFromSuperview()
                        self.buttonRightDown.removeFromSuperview()
                        self.buttonRightUp.removeFromSuperview()
                    }))
                    
                    self.view?.window?.rootViewController?.present(refreshAlert2, animated: true, completion: nil)
                } else {
                    boardsWrapper.boards[playerWrapper.playerPos[playerWrapper.playerId].id].matrix[playerWrapper.playerPos[playerWrapper.playerId].x][playerWrapper.playerPos[playerWrapper.playerId].y] = 0
                    playerWrapper.playerPos.remove(at: playerWrapper.playerId)
                }
            }
            else if(boardsWrapper.boards[player.id].matrix[player.x][player.y] == 7)
            {
                if(localPlayerId == playerWrapper.playerId)
                {
                    let refreshAlert = UIAlertController(title: "Uwaga", message: "Znalazłeś skarb. Wygrałeś!", preferredStyle: UIAlertControllerStyle.alert)
                    
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                        self.buttonLeft.removeFromSuperview()
                        self.buttonRight.removeFromSuperview()
                        self.buttonDown.removeFromSuperview()
                        self.buttonUp.removeFromSuperview()
                        self.buttonLeftDown.removeFromSuperview()
                        self.buttonLeftUp.removeFromSuperview()
                        self.buttonRightDown.removeFromSuperview()
                        self.buttonRightUp.removeFromSuperview()
                    }))
                    
                    self.view?.window?.rootViewController?.present(refreshAlert, animated: true, completion: nil)
                } else {
                    let refreshAlert = UIAlertController(title: "Uwaga", message: "Gracz nr \(playerWrapper.playerId+1) znalazł skarb! Przegrałeś!", preferredStyle: UIAlertControllerStyle.alert)
                    
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                        self.buttonLeft.removeFromSuperview()
                        self.buttonRight.removeFromSuperview()
                        self.buttonDown.removeFromSuperview()
                        self.buttonUp.removeFromSuperview()
                        self.buttonLeftDown.removeFromSuperview()
                        self.buttonLeftUp.removeFromSuperview()
                        self.buttonRightDown.removeFromSuperview()
                        self.buttonRightUp.removeFromSuperview()
                    }))
                    
                    self.view?.window?.rootViewController?.present(refreshAlert, animated: true, completion: nil)
                }
            }
            else
            {
                // zmiana pozycji w tablicy
                boardsWrapper.boards[playerWrapper.playerPos[playerWrapper.playerId].id].matrix[playerWrapper.playerPos[playerWrapper.playerId].x][playerWrapper.playerPos[playerWrapper.playerId].y] = 0
                playerWrapper.playerPos[playerWrapper.playerId] = player
                boardsWrapper.boards[player.id].matrix[player.x][player.y] = playerWrapper.playerId + 1
                if(localPlayerId == playerWrapper.playerId)
                {
                    // odkrycie nowych pól
                    var matrixEnable : [[pos]] = []
                    for i in (player.x-1..<player.x+2)
                    {
                        var matrixLine : [pos] = []
                        for j in (player.y-1..<player.y+2)
                        {
                            matrixLine.append(pos(id: player.id, x: i, y: j))
                        }
                        matrixEnable.append(matrixLine)
                    }
                    var boardId : Int = 0
                    if(player.x == 0)
                    {
                        if(boardsWrapper.boards.count > 0)
                        {
                            if(player.id - 1 < 0)
                            {
                                boardId = boardsWrapper.boards.count - 1;
                            }
                            else {
                                boardId = player.id - 1;
                            }
                        }
                        for i in (0..<3)
                        {
                            for j in (0..<3)
                            {
                                if(i == 0)
                                {
                                    matrixEnable[i][j].id = boardId
                                    matrixEnable[i][j].x = 19
                                }
                            }
                        }
                    }
                    if(player.y == 0)
                    {
                        if(boardsWrapper.boards.count > 2)
                        {
                            if(player.id  / 2 == 0)
                            {
                                if(((player.id  == 1) && (boardsWrapper.boards.count > 3)) || ((player.id  == 0) && (boardsWrapper.boards.count > 2)))
                                {
                                    boardId = player.id + 2
                                }
                            }
                            else if(player.id  / 2 == 1)
                            {
                                boardId = player.id - 2
                            }
                        }
                        for i in (0..<3)
                        {
                            for j in (0..<3)
                            {
                                if(j == 0)
                                {
                                    matrixEnable[i][j].id = boardId
                                    matrixEnable[i][j].y = 0
                                }
                            }
                        }
                    }
                    if(player.x == 19)
                    {
                        if(boardsWrapper.boards.count > 0)
                        {
                            if(player.id + 1 >= boardsWrapper.boards.count)
                            {
                                boardId = 0;
                            }
                            else {
                                boardId = player.id + 1;
                            }
                        }
                        for i in (0..<3)
                        {
                            for j in (0..<3)
                            {
                                if(i == 2)
                                {
                                    matrixEnable[i][j].id = boardId
                                    matrixEnable[i][j].x = 0
                                }
                            }
                        }
                    }
                    if(player.y == 19)
                    {
                        if(player.id / 2 == 0)
                        {
                            if(((player.id == 1) && (boardsWrapper.boards.count > 3)) || ((player.id == 0) && (boardsWrapper.boards.count > 2)))
                            {
                                boardId = player.id + 2
                            }
                        }
                        else if(player.id / 2 == 1)
                        {
                            boardId = player.id - 2
                        }
                        for i in (0..<3)
                        {
                            for j in (0..<3)
                            {
                                if(j == 2)
                                {
                                    matrixEnable[i][j].id = boardId
                                    matrixEnable[i][j].y = 19
                                }
                            }
                        }
                    }

                    if((player.x == 0) && (player.y == 0))
                    {
                        var findBoards : Set<Int> = []
                        findBoards.insert(matrixEnable[0][1].id)
                        findBoards.insert(matrixEnable[1][0].id)
                        findBoards.insert(matrixEnable[1][1].id)
                        for i in (0..<4)
                        {
                            if(findBoards.contains(i))
                            {
                                matrixEnable[0][0].id = i
                                break;
                            }
                        }
                    }
                    
                    if((player.x == 0) && (player.y == 19))
                    {
                        var findBoards : Set<Int> = []
                        findBoards.insert(matrixEnable[0][1].id)
                        findBoards.insert(matrixEnable[1][2].id)
                        findBoards.insert(matrixEnable[0][2].id)
                        for i in (0..<4)
                        {
                            if(findBoards.contains(i))
                            {
                                matrixEnable[0][2].id = i
                                break;
                            }
                        }
                    }

                    if((player.x == 19) && (player.y == 0))
                    {
                        var findBoards : Set<Int> = []
                        findBoards.insert(matrixEnable[1][0].id)
                        findBoards.insert(matrixEnable[2][1].id)
                        findBoards.insert(matrixEnable[2][0].id)
                        for i in (0..<4)
                        {
                            if(findBoards.contains(i))
                            {
                                matrixEnable[2][0].id = i
                                break;
                            }
                        }
                    }

                    if((player.x == 19) && (player.y == 19))
                    {
                        var findBoards : Set<Int> = []
                        findBoards.insert(matrixEnable[1][2].id)
                        findBoards.insert(matrixEnable[2][1].id)
                        findBoards.insert(matrixEnable[2][2].id)
                        for i in (0..<4)
                        {
                            if(findBoards.contains(i))
                            {
                                matrixEnable[2][2].id = i
                                break;
                            }
                        }
                    }

                    enablePositions(matrixEnable: matrixEnable)

                }
                self.removeAllChildren()
                
                for i in(0..<boardsWrapper.boards.count)
                {
                    boardsWrapper.boards[i].renderBoard()
                }
                drawCompass(angle: calculateCompass() )
            }
        }
        if((localPlayerId == playerWrapper.playerId) && !dontSendPos)
        {
            for i in (0..<playerWrapper.playerPos.count)
            {
                if(i != localPlayerId)
                {
                    playerWrapper.playerPos[i].sender.sendData(params: preparePlayerToSendJSON())
                }
            }
        }
        if(goFuther)
        {
            if(playerWrapper.playerId + 1 >= playerWrapper.playerPos.count)
            {
                playerWrapper.playerId = 0
            } else {
                playerWrapper.playerId += 1
            }
        }
    }
    
    func connectButton()
    {
        self.ip1.removeFromSuperview()
        self.port1.removeFromSuperview()
        self.ip2.removeFromSuperview()
        self.port2.removeFromSuperview()
        self.ip3.removeFromSuperview()
        self.port3.removeFromSuperview()
        self.connect.removeFromSuperview()
        self.removeAllChildren()
        labelConnecting = SKLabelNode(fontNamed: "Arial")
        labelConnecting!.text = String("Łączenie...")
        labelConnecting!.fontSize = 20
        labelConnecting!.fontColor = UIColor.white
        labelConnecting!.position = CGPoint(x: -Int(self.size.width*0.48) + 100, y:  -250 + Int(self.size.height*0.5))
        self.addChild(labelConnecting!)

        sender.initialsMap += 1
        self.countOfPlayers += 1
        
        if(ip1.text != "")
        {
            self.countOfPlayers += 1
            let client = TCPSender()
            client.connect(host: ip1.text!, port: port1.text!)
            playerWrapper.playerPos.append(player(ip: ip1.text!, lossNumber: boardsWrapper.boards[boardsWrapper.boards.count - 1].lossNumber, sender: client, id: 0, x: 9, y: 9))
            var queue : Dictionary<String, AnyObject> = [:]
            var message : Dictionary<String, AnyObject> = [:]
            queue["ip"] = playerWrapper.playerPos[localPlayerId].ip as AnyObject?
            queue["number"] = playerWrapper.playerPos[localPlayerId].lossNumber as AnyObject?
            message["randomQueue"] = queue as AnyObject?
            client.sendData(params: message)
        }
        if(ip2.text != "")
        {
            self.countOfPlayers += 1
            let client = TCPSender()
            client.connect(host: ip2.text!, port: port2.text!)
            playerWrapper.playerPos.append(player(ip: ip2.text!, lossNumber: boardsWrapper.boards[boardsWrapper.boards.count - 1].lossNumber, sender: client, id: 0, x: 9, y: 9))
            var queue : Dictionary<String, AnyObject> = [:]
            var message : Dictionary<String, AnyObject> = [:]
            queue["ip"] = playerWrapper.playerPos[localPlayerId].ip as AnyObject?
            queue["number"] = playerWrapper.playerPos[localPlayerId].lossNumber as AnyObject?
            message["randomQueue"] = queue as AnyObject?
            client.sendData(params: message)
        }
        if(ip3.text != "")
        {
            self.countOfPlayers += 1
            let client = TCPSender()
            client.connect(host: ip3.text!, port: port3.text!)
            playerWrapper.playerPos.append(player(ip: ip3.text!, lossNumber: boardsWrapper.boards[boardsWrapper.boards.count - 1].lossNumber, sender: client, id: 0, x: 9, y: 9))
            var queue : Dictionary<String, AnyObject> = [:]
            var message : Dictionary<String, AnyObject> = [:]
            queue["ip"] = playerWrapper.playerPos[localPlayerId].ip as AnyObject?
            queue["number"] = playerWrapper.playerPos[localPlayerId].lossNumber as AnyObject?
            message["randomQueue"] = queue as AnyObject?
            client.sendData(params: message)
        }
        gameState = 1
    }
    
    override func update(_ currentTime: TimeInterval) {
        switch gameState {
        case 0:
            if(!appLoaded)
            {
                self.sender = TCPListener(port: 51210, players: self.playerWrapper, boards: self.boardsWrapper, scene: self)
                self.appLoaded = true
                
                self.labelIp = SKLabelNode(fontNamed: "Arial")
                self.labelIp?.text = String(self.getWiFiAddress()! + ":51210")
                self.labelIp?.fontSize = 20
                self.labelIp?.fontColor = UIColor.white
                self.labelIp?.position = CGPoint(x: -Int(self.size.width*0.48) + 100, y:  -250 + Int(self.size.height*0.5))
                self.addChild(self.labelIp!)
                
                self.ip1 = UITextField(frame: CGRect(x: 30, y: 100, width: 200, height: 30))
                self.ip1.placeholder = "IP1"
                self.ip1.text = "192.168.0.11"
                self.ip1.font = UIFont.systemFont(ofSize: 15)
                self.ip1.borderStyle = UITextBorderStyle.roundedRect
                self.ip1.autocorrectionType = UITextAutocorrectionType.no
                self.ip1.keyboardType = UIKeyboardType.default
                self.ip1.returnKeyType = UIReturnKeyType.done
                self.ip1.clearButtonMode = UITextFieldViewMode.whileEditing;
                self.ip1.contentVerticalAlignment = UIControlContentVerticalAlignment.center
                self.view?.addSubview(self.ip1)
                
                self.port1 = UITextField(frame: CGRect(x: 250, y: 100, width: 100, height: 30))
                self.port1.placeholder = "PORT1"
                self.port1.text = "51210"
                self.port1.font = UIFont.systemFont(ofSize: 15)
                self.port1.borderStyle = UITextBorderStyle.roundedRect
                self.port1.autocorrectionType = UITextAutocorrectionType.no
                self.port1.keyboardType = UIKeyboardType.default
                self.port1.returnKeyType = UIReturnKeyType.done
                self.port1.clearButtonMode = UITextFieldViewMode.whileEditing;
                self.port1.contentVerticalAlignment = UIControlContentVerticalAlignment.center
                self.view?.addSubview(self.port1)
                
                self.ip2 = UITextField(frame: CGRect(x: 30, y: 150, width: 200, height: 30))
                self.ip2.placeholder = "IP2"
                self.ip2.font = UIFont.systemFont(ofSize: 15)
                self.ip2.borderStyle = UITextBorderStyle.roundedRect
                self.ip2.autocorrectionType = UITextAutocorrectionType.no
                self.ip2.keyboardType = UIKeyboardType.default
                self.ip2.returnKeyType = UIReturnKeyType.done
                self.ip2.clearButtonMode = UITextFieldViewMode.whileEditing;
                self.ip2.contentVerticalAlignment = UIControlContentVerticalAlignment.center
                self.view?.addSubview(self.ip2)
                
                self.port2 = UITextField(frame: CGRect(x: 250, y: 150, width: 100, height: 30))
                self.port2.placeholder = "PORT2"
                self.port2.font = UIFont.systemFont(ofSize: 15)
                self.port2.borderStyle = UITextBorderStyle.roundedRect
                self.port2.autocorrectionType = UITextAutocorrectionType.no
                self.port2.keyboardType = UIKeyboardType.default
                self.port2.returnKeyType = UIReturnKeyType.done
                self.port2.clearButtonMode = UITextFieldViewMode.whileEditing;
                self.port2.contentVerticalAlignment = UIControlContentVerticalAlignment.center
                self.view?.addSubview(self.port2)
                
                self.ip3 = UITextField(frame: CGRect(x: 30, y: 200, width: 200, height: 30))
                self.ip3.placeholder = "IP3"
                self.ip3.font = UIFont.systemFont(ofSize: 15)
                self.ip3.borderStyle = UITextBorderStyle.roundedRect
                self.ip3.autocorrectionType = UITextAutocorrectionType.no
                self.ip3.keyboardType = UIKeyboardType.default
                self.ip3.returnKeyType = UIReturnKeyType.done
                self.ip3.clearButtonMode = UITextFieldViewMode.whileEditing;
                self.ip3.contentVerticalAlignment = UIControlContentVerticalAlignment.center
                self.view?.addSubview(self.ip3)
                
                self.port3 = UITextField(frame: CGRect(x: 250, y: 200, width: 100, height: 30))
                self.port3.placeholder = "PORT3"
                self.port3.font = UIFont.systemFont(ofSize: 15)
                self.port3.borderStyle = UITextBorderStyle.roundedRect
                self.port3.autocorrectionType = UITextAutocorrectionType.no
                self.port3.keyboardType = UIKeyboardType.default
                self.port3.returnKeyType = UIReturnKeyType.done
                self.port3.clearButtonMode = UITextFieldViewMode.whileEditing;
                self.port3.contentVerticalAlignment = UIControlContentVerticalAlignment.center
                self.view?.addSubview(self.port3)
                
                self.boardsWrapper.boards.append(BoardModel(scene: self, initializeFields: true))
                self.playerWrapper.playerPos.append(player(ip: self.getWiFiAddress()!, lossNumber: self.boardsWrapper.boards[self.boardsWrapper.boards.count - 1].lossNumber, sender: TCPSender(), id: 0, x: 9, y: 9))
                
                self.connect = UIButton(frame: CGRect(x: 30, y: 250, width: 100, height: 50))
                self.connect.setTitle("Połącz", for: .normal)
                self.connect.addTarget(self, action: #selector(self.connectButton), for: .touchUpInside)
                self.view?.addSubview(self.connect)
            }
            break
        case 1:
            switch initializingGameState {
            case 0:
                if(self.countOfPlayers == boardsWrapper.boards.count)
                {
                    if(playerWrapper.playerPos.count > 1)
                    {
                        // gdy wszystkie roundQueue dotarły
                        if(playerWrapper.playerPos.count == boardsWrapper.boards.count)
                        {
                            // gdy jest wiecej niz jeden gracz
                            for i in (0..<playerWrapper.playerPos.count)
                            {
                                for j in (0..<boardsWrapper.boards.count)
                                {
                                    if(boardsWrapper.boards[j].ip == playerWrapper.playerPos[i].ip)
                                    {
                                        playerWrapper.playerPos[i].lossNumber = boardsWrapper.boards[j].lossNumber
                                    }
                                }
                            }
                            
                            // sortowanie klas
                            boardsWrapper.boards.sort(by: { $0.lossNumber > $1.lossNumber })
                            playerWrapper.playerPos.sort(by: { $0.lossNumber > $1.lossNumber })
                            
                            //ustawienie wartosci id
                            for i in (0..<playerWrapper.playerPos.count)
                            {
                                playerWrapper.playerPos[i].id = i
                            }
                            localPlayerId = self.getLocalIdPlayer()
                            
                            for i in (0..<playerWrapper.playerPos.count)
                            {
                                if(i != localPlayerId)
                                {
                                    playerWrapper.playerPos[i].sender.sendData(params: boardsWrapper.boards[localPlayerId].genereteMinesBuildingDictionary(id: localPlayerId))
                                }
                            }
                            initializingGameState = 1
                        }
                    }
                }
                break
            case 1:
                // roundQueue i map przesłane, decyzja  odnośnie treasure
                if(sender.initialsMap == boardsWrapper.boards.count)
                {
                    // jeśli tak, wylosuj i roześlij do innych graczy treausre
                    if(localPlayerId == 0)
                    {
                        for i in (0..<playerWrapper.playerPos.count)
                        {
                            if(i != localPlayerId)
                            {
                                boardsWrapper.treasurePos = generateTreasurePos()
                                playerWrapper.playerPos[i].sender.sendData(params: prepareTreasureToSendJSON())
                            }
                        }
                        initializingGameState = 2
                    }
                    
                    // jeśli nie, to oczekuj na pakiet i idz dalej
                    if(localPlayerId != 0 )
                    {
                        if(boardsWrapper.tresurePacketAnalysed)
                        {
                            boardsWrapper.tresurePacketAnalysed = false
                            initializingGameState = 2
                        }
                    }
                }
                break
            case 2:
                // zakonczono ładowanie elementów, uruchom grę
                self.removeAllChildren()
                for i in(0..<boardsWrapper.boards.count)
                {
                    if(i == 0)
                    {
                        boardsWrapper.boards[i].setXY(x: 0, y: -350)
                    }
                    else if(i == 1)
                    {
                        boardsWrapper.boards[i].setXY(x: 370, y: -350)
                    }
                    else if(i == 2)
                    {
                        boardsWrapper.boards[i].setXY(x: 0, y: -700)
                    }
                    else if(i == 3)
                    {
                        boardsWrapper.boards[i].setXY(x: 370, y: -700)
                    }
                    boardsWrapper.boards[i].renderBoard()
                }
                drawCompass(angle: calculateCompass() )
                gameState = 2
                break
            default: break
            }
            
            break
        case 2:
            buttonLeft = UIButton(frame: CGRect(x: 10, y: 80, width: 100, height: 50))
            buttonLeft.setTitle("Lewo", for: .normal)
            buttonLeft.addTarget(self, action: #selector(leftButton), for: .touchUpInside)
            self.view?.addSubview(buttonLeft)
            
            buttonRight = UIButton(frame: CGRect(x: 250, y: 80, width: 100, height: 50))
            buttonRight.setTitle("Prawo", for: .normal)
            buttonRight.addTarget(self, action: #selector(rightButton), for: .touchUpInside)
            self.view?.addSubview(buttonRight)
            
            buttonUp = UIButton(frame: CGRect(x: 120, y: 10, width: 100, height: 50))
            buttonUp.setTitle("Góra", for: .normal)
            buttonUp.addTarget(self, action: #selector(upButton), for: .touchUpInside)
            self.view?.addSubview(buttonUp)
            
            buttonDown = UIButton(frame: CGRect(x: 120, y: 140, width: 100, height: 50))
            buttonDown.setTitle("Dół", for: .normal)
            buttonDown.addTarget(self, action: #selector(downButton), for: .touchUpInside)
            self.view?.addSubview(buttonDown)
            
            buttonLeftDown = UIButton(frame: CGRect(x: 10, y: 140, width: 100, height: 50))
            buttonLeftDown.setTitle("Lewo-Dół", for: .normal)
            buttonLeftDown.addTarget(self, action: #selector(leftDownButton), for: .touchUpInside)
            self.view?.addSubview(buttonLeftDown)
            
            buttonLeftUp = UIButton(frame: CGRect(x: 10, y: 10, width: 100, height: 50))
            buttonLeftUp.setTitle("Lewo-Góra", for: .normal)
            buttonLeftUp.addTarget(self, action: #selector(leftUpButton), for: .touchUpInside)
            self.view?.addSubview(buttonLeftUp)
            
            buttonRightDown = UIButton(frame: CGRect(x: 250, y: 140, width: 100, height: 50))
            buttonRightDown.setTitle("Prawo-Dół", for: .normal)
            buttonRightDown.addTarget(self, action: #selector(rightDownButton), for: .touchUpInside)
            self.view?.addSubview(buttonRightDown)
            
            buttonRightUp = UIButton(frame: CGRect(x: 250, y: 10, width: 100, height: 50))
            buttonRightUp.setTitle("Prawo-Góra", for: .normal)
            buttonRightUp.addTarget(self, action: #selector(rightUpButton), for: .touchUpInside)
            self.view?.addSubview(buttonRightUp)
            
            for i in (0..<playerWrapper.playerPos.count)
            {
                makeMove(player: playerWrapper.playerPos[i], dontSendPos: true, goFuther: true)
            }
            //drawCompass(angle: 0)
            
            boardsWrapper.boards[boardsWrapper.treasurePos.id].matrix[boardsWrapper.treasurePos.x][boardsWrapper.treasurePos.y] = 7
            gameState = 3
            break
        case 3:
            for i in(0..<boardsWrapper.boards.count)
            {
                boardsWrapper.boards[i].refreshBoard()
            }
            break
        default: break
        }
    }
    
    func getLocalIdPlayer() -> Int
    {
        for i in (0..<playerWrapper.playerPos.count)
        {
            if(playerWrapper.playerPos[i].ip == getWiFiAddress())
            {
                return i
            }
        }
        return 0
    }
    
    func drawCompass(angle : Float)
    {
        let circle = SKShapeNode(circleOfRadius: 50 )
        circle.position = CGPoint(x: -210, y: 402)
        self.addChild(circle)
        
        let newX : Int = Int(-((cos((angle * .pi) / 180)*2025) + 9450)/45)
        let newY : Int = Int(angle > 180 ? -sqrt(Double(2025 - pow((Double(newX + 210)), 2))) + 402 : sqrt(Double(2025 - pow((Double(newX + 210)), 2))) + 402 )
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: -210, y: 402))
        path.addLine(to: CGPoint(x: newX, y: newY))
        let shape = SKShapeNode()
        shape.path = path
        shape.strokeColor = UIColor.white
        shape.lineWidth = 2
        self.addChild(shape)
    }
    
    func calculateCompass() -> Float
    {
        var angle : Float = 0
        if(playerWrapper.playerPos[localPlayerId].id == boardsWrapper.treasurePos.id)
        {
            angle = Float(acos((Float(playerWrapper.playerPos[localPlayerId].x - boardsWrapper.treasurePos.x))/(Float(sqrt(Float(pow((Float(boardsWrapper.treasurePos.x - playerWrapper.playerPos[localPlayerId].x)), 2) + pow((Float(boardsWrapper.treasurePos.y - playerWrapper.playerPos[localPlayerId].y)), 2)))))))
            if(playerWrapper.playerPos[localPlayerId].y < boardsWrapper.treasurePos.y)
            {
                angle = (2 * .pi) - angle
            }
            angle = (angle * 180) / .pi
        } else
        {
            if(boardsWrapper.treasurePos.id == 0)
            {
                if(playerWrapper.playerPos[localPlayerId].id == 1)
                {
                    angle = 0
                }
                else if(playerWrapper.playerPos[localPlayerId].id == 2)
                {
                    angle = 90
                }
                else if(playerWrapper.playerPos[localPlayerId].id == 3)
                {
                    angle = 180
                }
            }
            else if(boardsWrapper.treasurePos.id == 1)
            {
                if(playerWrapper.playerPos[localPlayerId].id == 0)
                {
                    angle = 180
                }
                else if(playerWrapper.playerPos[localPlayerId].id == 2)
                {
                    angle = 0
                }
                else if(playerWrapper.playerPos[localPlayerId].id == 3)
                {
                    angle = 90
                }
            }
            else if(boardsWrapper.treasurePos.id == 2)
            {
                if(playerWrapper.playerPos[localPlayerId].id == 0)
                {
                    angle = 90
                }
                else if(playerWrapper.playerPos[localPlayerId].id == 1)
                {
                    angle = 90
                }
                else if(playerWrapper.playerPos[localPlayerId].id == 3)
                {
                    angle = 0
                }
            }
            else if(boardsWrapper.treasurePos.id == 3)
            {
                if(playerWrapper.playerPos[localPlayerId].id == 0)
                {
                    angle = 0
                }
                else if(playerWrapper.playerPos[localPlayerId].id == 1)
                {
                    angle = 90
                }
                else if(playerWrapper.playerPos[localPlayerId].id == 2)
                {
                    angle = 180
                }
            }
        }
        return angle
    }
    
    func enablePositions(matrixEnable : [[pos]])
    {
        for i in (0..<matrixEnable.count)
        {
            for j in (0..<matrixEnable[i].count)
            {
                boardsWrapper.boards[matrixEnable[i][j].id].matrixVisible[matrixEnable[i][j].x][matrixEnable[i][j].y] = 1
            }
        }
    }
    
    func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var addr = interface.ifa_addr.pointee
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
    
    func generateTreasurePos() -> pos
    {
        let id: Int = boardsWrapper.boards[0].randomInt(min: 0, max: boardsWrapper.boards.count - 1)
        let x: Int = boardsWrapper.boards[0].randomInt(min: 0, max: 19)
        let y: Int = boardsWrapper.boards[0].randomInt(min: 0, max: 19)
        return pos(id: id, x: x, y: y)
    }
    
    func prepareTreasureToSendJSON() -> Dictionary<String, AnyObject>
    {
        var point : Dictionary<String, AnyObject> = [:]
        var treasure : Dictionary<String, AnyObject> = [:]
        point["p"] = boardsWrapper.treasurePos.id as AnyObject?
        point["x"] = boardsWrapper.treasurePos.x as AnyObject?
        point["y"] = boardsWrapper.treasurePos.y as AnyObject?
        treasure["treasure"] = point as AnyObject?
        return treasure
    }
    
    func preparePlayerToSendJSON() -> Dictionary<String, AnyObject>
    {
        var point : Dictionary<String, AnyObject> = [:]
        var player : Dictionary<String, AnyObject> = [:]
        point["p"] = playerWrapper.playerPos[playerWrapper.playerId].id as AnyObject?
        point["x"] = playerWrapper.playerPos[playerWrapper.playerId].x as AnyObject?
        point["y"] = playerWrapper.playerPos[playerWrapper.playerId].y as AnyObject?
        player["player"] = point as AnyObject?
        return player
    }
}
