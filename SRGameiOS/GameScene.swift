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
    
    init(playerPos: [player]) {
        self.playerPos = playerPos
    }}

class BoardsWrapper {
    var boards : [BoardModel] = []
    
    init(boards: [BoardModel]) {
        self.boards = boards
    }
}

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var boardsWrapper : BoardsWrapper = BoardsWrapper(boards: [])

    var playerId : Int = 0 // runda gracza
    var localPlayerId : Int = 0 // lokalny gracz
    var playerWrapper : PlayerWrapper = PlayerWrapper(playerPos: [])
    var playerRound : Int = 0
    var gameInitialized = true
    var treasurePos : pos = pos(id: 0, x: 5, y: 9)
    var buttonLeft : UIButton = UIButton()
    var buttonRight : UIButton = UIButton()
    var buttonUp : UIButton = UIButton()
    var buttonDown : UIButton = UIButton()
    var buttonLeftDown : UIButton = UIButton()
    var buttonLeftUp : UIButton = UIButton()
    var buttonRightDown : UIButton = UIButton()
    var buttonRightUp : UIButton = UIButton()
    var sender : TCPListener!
    var appStarted : Bool = false
    var labelIp : SKLabelNode?
    var ip1 : UITextField = UITextField()
    var port1 : UITextField = UITextField()
    var ip2 : UITextField = UITextField()
    var port2 : UITextField = UITextField()
    var ip3 : UITextField = UITextField()
    var port3 : UITextField = UITextField()
    var connect : UIButton = UIButton()
    var labelConnecting : SKLabelNode?
    var connecting : Bool = false
    var gameRun : Bool = false
    var gameSetup : Bool = false
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
        var newPos : player = playerWrapper.playerPos[localPlayerId]
        if(newPos.x - 1 < 0)
        {
            if(boardsWrapper.boards.count > 0)
            {
                if(newPos.id - 1 < 0)
                {
                    newPos.id = boardsWrapper.boards.count - 1;
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
        var newPos : player = playerWrapper.playerPos[localPlayerId]
        if(newPos.x + 1 > 19)
        {
            if(boardsWrapper.boards.count > 0)
            {
                if(newPos.id + 1 >= boardsWrapper.boards.count)
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
        var newPos : player = playerWrapper.playerPos[localPlayerId]
        if(newPos.y - 1 < 0)
        {
            if(boardsWrapper.boards.count > 2)
            {
                if(newPos.id / 2 == 0)
                {
                    if(((newPos.id == 1) && (boardsWrapper.boards.count > 3)) || ((newPos.id == 0) && (boardsWrapper.boards.count > 2)))
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
        var newPos : player = playerWrapper.playerPos[localPlayerId]
        if(newPos.y + 1 > 19)
        {
            if(boardsWrapper.boards.count > 2)
            {
                if(newPos.id / 2 == 0)
                {
                    if(((newPos.id == 1) && (boardsWrapper.boards.count > 3)) || ((newPos.id == 0) && (boardsWrapper.boards.count > 2)))
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
        var newPos : player = playerWrapper.playerPos[localPlayerId]
        if(newPos.x - 1 < 0)
        {
            if(boardsWrapper.boards.count > 0)
            {
                if(newPos.id - 1 < 0)
                {
                    newPos.id = boardsWrapper.boards.count - 1;
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
            if(boardsWrapper.boards.count > 2)
            {
                if(newPos.id / 2 == 0)
                {
                    if(((newPos.id == 1) && (boardsWrapper.boards.count > 3)) || ((newPos.id == 0) && (boardsWrapper.boards.count > 2)))
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
        var newPos : player = playerWrapper.playerPos[localPlayerId]
        if(newPos.x - 1 < 0)
        {
            if(boardsWrapper.boards.count > 0)
            {
                if(newPos.id - 1 < 0)
                {
                    newPos.id = boardsWrapper.boards.count - 1;
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
            if(boardsWrapper.boards.count > 2)
            {
                if(newPos.id / 2 == 0)
                {
                    if(((newPos.id == 1) && (boardsWrapper.boards.count > 3)) || ((newPos.id == 0) && (boardsWrapper.boards.count > 2)))
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
        var newPos : player = playerWrapper.playerPos[localPlayerId]
        if(newPos.x + 1 > 19)
        {
            if(boardsWrapper.boards.count > 0)
            {
                if(newPos.id + 1 >= boardsWrapper.boards.count)
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
            if(boardsWrapper.boards.count > 2)
            {
                if(newPos.id / 2 == 0)
                {
                    if(((newPos.id == 1) && (boardsWrapper.boards.count > 3)) || ((newPos.id == 0) && (boardsWrapper.boards.count > 2)))
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
        var newPos : player = playerWrapper.playerPos[localPlayerId]
        if(newPos.x + 1 > 19)
        {
            if(boardsWrapper.boards.count > 0)
            {
                if(newPos.id + 1 >= boardsWrapper.boards.count)
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
            if(boardsWrapper.boards.count > 2)
            {
                if(newPos.id / 2 == 0)
                {
                    if(((newPos.id == 1) && (boardsWrapper.boards.count > 3)) || ((newPos.id == 0) && (boardsWrapper.boards.count > 2)))
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
    
    func makeMove(position : player, vertical : Bool)
    {
        if(checkMove(position: position))
        {
            if(boardsWrapper.boards[position.id].matrix[position.x][position.y] == 6)
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
            }
            else if(boardsWrapper.boards[position.id].matrix[position.x][position.y] == 7)
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
            }
            else
            {
                // zmiana pozycji w tablicy
                boardsWrapper.boards[playerWrapper.playerPos[playerId].id].matrix[playerWrapper.playerPos[playerId].x][playerWrapper.playerPos[playerId].y] = 0
                playerWrapper.playerPos[playerId] = position
                boardsWrapper.boards[position.id].matrix[position.x][position.y] = playerId + 1
                if(localPlayerId == playerId)
                {
                    // odkrycie nowych pól
                    var matrixEnable : [[pos]] = []
                    for i in (position.x-1..<position.x+2)
                    {
                        var matrixLine : [pos] = []
                        for j in (position.y-1..<position.y+2)
                        {
                            matrixLine.append(pos(id: position.id, x: i, y: j))
                        }
                        matrixEnable.append(matrixLine)
                    }
                    var boardId : Int = 0
                    if(position.x == 0)
                    {
                        if(boardsWrapper.boards.count > 0)
                        {
                            if(position.id - 1 < 0)
                            {
                                boardId = boardsWrapper.boards.count - 1;
                            }
                            else {
                                boardId = position.id - 1;
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
                    if(position.y == 0)
                    {
                        if(boardsWrapper.boards.count > 2)
                        {
                            if(position.id  / 2 == 0)
                            {
                                if(((position.id  == 1) && (boardsWrapper.boards.count > 3)) || ((position.id  == 0) && (boardsWrapper.boards.count > 2)))
                                {
                                    boardId = position.id + 2
                                }
                            }
                            else if(position.id  / 2 == 1)
                            {
                                boardId = position.id - 2
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
                    if(position.x == 19)
                    {
                        if(boardsWrapper.boards.count > 0)
                        {
                            if(position.id + 1 >= boardsWrapper.boards.count)
                            {
                                boardId = 0;
                            }
                            else {
                                boardId = position.id + 1;
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
                    if(position.y == 19)
                    {
                        if(position.id / 2 == 0)
                        {
                            if(((position.id == 1) && (boardsWrapper.boards.count > 3)) || ((position.id == 0) && (boardsWrapper.boards.count > 2)))
                            {
                                boardId = position.id + 2
                            }
                        }
                        else if(position.id / 2 == 1)
                        {
                            boardId = position.id - 2
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

                    if((position.x == 0) && (position.y == 0))
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
                    
                    if((position.x == 0) && (position.y == 19))
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

                    if((position.x == 19) && (position.y == 0))
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

                    if((position.x == 19) && (position.y == 19))
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
        connecting = true
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(!appStarted)
        {
            sender = TCPListener(port: 51210, players: playerWrapper, boards: boardsWrapper, scene: self)
            appStarted = true
            
            labelIp = SKLabelNode(fontNamed: "Arial")
            labelIp?.text = String(getWiFiAddress()! + ":51210")
            labelIp?.fontSize = 20
            labelIp?.fontColor = UIColor.white
            labelIp?.position = CGPoint(x: -Int(self.size.width*0.48) + 100, y:  -250 + Int(self.size.height*0.5))
            self.addChild(labelIp!)
            
            ip1 = UITextField(frame: CGRect(x: 30, y: 100, width: 200, height: 30))
            ip1.placeholder = "IP1"
            ip1.text = "192.168.0.11"
            ip1.font = UIFont.systemFont(ofSize: 15)
            ip1.borderStyle = UITextBorderStyle.roundedRect
            ip1.autocorrectionType = UITextAutocorrectionType.no
            ip1.keyboardType = UIKeyboardType.default
            ip1.returnKeyType = UIReturnKeyType.done
            ip1.clearButtonMode = UITextFieldViewMode.whileEditing;
            ip1.contentVerticalAlignment = UIControlContentVerticalAlignment.center
            self.view?.addSubview(ip1)
            
            port1 = UITextField(frame: CGRect(x: 250, y: 100, width: 100, height: 30))
            port1.placeholder = "PORT1"
            port1.text = "51210"
            port1.font = UIFont.systemFont(ofSize: 15)
            port1.borderStyle = UITextBorderStyle.roundedRect
            port1.autocorrectionType = UITextAutocorrectionType.no
            port1.keyboardType = UIKeyboardType.default
            port1.returnKeyType = UIReturnKeyType.done
            port1.clearButtonMode = UITextFieldViewMode.whileEditing;
            port1.contentVerticalAlignment = UIControlContentVerticalAlignment.center
            self.view?.addSubview(port1)
            
            ip2 = UITextField(frame: CGRect(x: 30, y: 150, width: 200, height: 30))
            ip2.placeholder = "IP2"
            ip2.font = UIFont.systemFont(ofSize: 15)
            ip2.borderStyle = UITextBorderStyle.roundedRect
            ip2.autocorrectionType = UITextAutocorrectionType.no
            ip2.keyboardType = UIKeyboardType.default
            ip2.returnKeyType = UIReturnKeyType.done
            ip2.clearButtonMode = UITextFieldViewMode.whileEditing;
            ip2.contentVerticalAlignment = UIControlContentVerticalAlignment.center
            self.view?.addSubview(ip2)
            
            port2 = UITextField(frame: CGRect(x: 250, y: 150, width: 100, height: 30))
            port2.placeholder = "PORT2"
            port2.font = UIFont.systemFont(ofSize: 15)
            port2.borderStyle = UITextBorderStyle.roundedRect
            port2.autocorrectionType = UITextAutocorrectionType.no
            port2.keyboardType = UIKeyboardType.default
            port2.returnKeyType = UIReturnKeyType.done
            port2.clearButtonMode = UITextFieldViewMode.whileEditing;
            port2.contentVerticalAlignment = UIControlContentVerticalAlignment.center
            self.view?.addSubview(port2)
            
            ip3 = UITextField(frame: CGRect(x: 30, y: 200, width: 200, height: 30))
            ip3.placeholder = "IP3"
            ip3.font = UIFont.systemFont(ofSize: 15)
            ip3.borderStyle = UITextBorderStyle.roundedRect
            ip3.autocorrectionType = UITextAutocorrectionType.no
            ip3.keyboardType = UIKeyboardType.default
            ip3.returnKeyType = UIReturnKeyType.done
            ip3.clearButtonMode = UITextFieldViewMode.whileEditing;
            ip3.contentVerticalAlignment = UIControlContentVerticalAlignment.center
            self.view?.addSubview(ip3)
            
            port3 = UITextField(frame: CGRect(x: 250, y: 200, width: 100, height: 30))
            port3.placeholder = "PORT3"
            port3.font = UIFont.systemFont(ofSize: 15)
            port3.borderStyle = UITextBorderStyle.roundedRect
            port3.autocorrectionType = UITextAutocorrectionType.no
            port3.keyboardType = UIKeyboardType.default
            port3.returnKeyType = UIReturnKeyType.done
            port3.clearButtonMode = UITextFieldViewMode.whileEditing;
            port3.contentVerticalAlignment = UIControlContentVerticalAlignment.center
            self.view?.addSubview(port3)
            
            boardsWrapper.boards.append(BoardModel(scene: self, initializeFields: true))
            playerWrapper.playerPos.append(player(ip: getWiFiAddress()!, lossNumber: boardsWrapper.boards[boardsWrapper.boards.count - 1].lossNumber, sender: TCPSender(), id: 0, x: 9, y: 9))
            
            connect = UIButton(frame: CGRect(x: 30, y: 250, width: 100, height: 50))
            connect.setTitle("Połącz", for: .normal)
            connect.addTarget(self, action: #selector(connectButton), for: .touchUpInside)
            self.view?.addSubview(connect)
        }
        if(connecting)
        {
            if(self.countOfPlayers == boardsWrapper.boards.count)
            {
                if(playerWrapper.playerPos.count > 1)
                {
                    // gdy wszystkie roundQueue dotarły
                    if((playerWrapper.playerPos.count == boardsWrapper.boards.count) && !gameSetup)
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
                        boardsWrapper.boards.sorted(by: { $0.lossNumber > $1.lossNumber })
                        playerWrapper.playerPos.sorted(by: { $0.lossNumber > $1.lossNumber })
                        
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
                                let dd = boardsWrapper.boards[localPlayerId].genereteMinesBuildingDictionary(id: localPlayerId)
                                playerWrapper.playerPos[i].sender.sendData(params: dd)
                            }
                        }
                        
                        gameSetup = true
                    }
                }
                if(sender.initialsMap == boardsWrapper.boards.count)
                {
                    self.removeAllChildren()
                    // wyślij wszystkim mapy
                    if(playerWrapper.playerPos.count > 1)
                    {
                        // gdy jest wiecej niz jeden gracz
                        
                    }
                    connecting = false
                    gameInitialized = false
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
                }
            }
        }
        
        if(!gameInitialized)
        {
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
            
            
            //boardsWrapper.boards.append(BoardModel(x: 0, y: -350, scene: self))
            //boardsWrapper.boards.append(BoardModel(x: 370, y: -350, scene: self))
            //boardsWrapper.boards.append(BoardModel(x: 0, y: -700, scene: self))
            //boardsWrapper.boards.append(BoardModel(x: 370, y: -700, scene: self))
            makeMove(position: playerWrapper.playerPos[0], vertical: true)
            
            drawCompass(angle: 0)
            
            boardsWrapper.boards[treasurePos.id].matrix[treasurePos.x][treasurePos.y] = 7
            gameInitialized = true
            gameRun = true
        }
        if(gameRun)
        {
            for i in(0..<boardsWrapper.boards.count)
            {
                boardsWrapper.boards[i].refreshBoard()
            }
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
        if(playerWrapper.playerPos[localPlayerId].id == treasurePos.id)
        {
            angle = Float(acos((Float(playerWrapper.playerPos[localPlayerId].x - treasurePos.x))/(Float(sqrt(Float(pow((Float(treasurePos.x - playerWrapper.playerPos[localPlayerId].x)), 2) + pow((Float(treasurePos.y - playerWrapper.playerPos[localPlayerId].y)), 2)))))))
            if(playerWrapper.playerPos[localPlayerId].y < treasurePos.y)
            {
                angle = (2 * .pi) - angle
            }
            angle = (angle * 180) / .pi
        } else
        {
            if(treasurePos.id == 0)
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
            else if(treasurePos.id == 1)
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
            else if(treasurePos.id == 2)
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
            else if(treasurePos.id == 3)
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
}
