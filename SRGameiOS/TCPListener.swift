//
//  TCPListener.swift
//  SRGameiOS
//
//  Created by Mikołaj-iMac on 27.01.2017.
//  Copyright © 2017 Mikołaj Płachta. All rights reserved.
//

import Foundation
import SwiftSocket
import GameplayKit

class TCPListener : AnyObject
{
    
    var server: TCPServer!
    var port : Int32
    var players : PlayerWrapper = PlayerWrapper(playerPos: [])
    var boards : BoardsWrapper = BoardsWrapper(boards: [])
    var gameScene : GameScene
    var initialsMap : Int
    var runningServer : Bool
    
    init(port : Int32, players : PlayerWrapper, boards : BoardsWrapper, scene : GameScene)
    {
        self.gameScene = scene
        self.port = port
        self.players = players
        self.boards = boards
        self.initialsMap = 0
        runningServer = false
        startServer()
    }
    
    func stopServer() {
        runningServer = false
        server.close()
    }
    
    func startServer()
    {
        runningServer = true
        self.server = TCPServer(address: getWiFiAddress()!, port: self.port)
        DispatchQueue.global(qos: .background).async
        {
            while self.runningServer
            {
                self.server.listen()
                if let client = self.server.accept()
                {
                    print("Client connected IP:\(client.address) Port:[\(client.port)]")
                    while self.runningServer
                    {
                        let test = client.read(1024*10)
                        if(test == nil)
                        {
                            print("Client \(client.address) disconnected.")
                            client.close()
                            break
                        }
                        if(test! != [])
                        {
                            let count = (test?.count)! / MemoryLayout<UInt8>.size
                            let datastring = NSString(bytes: test!, length: count, encoding: String.Encoding.ascii.rawValue)
                            print("New message: \(datastring as! String)")
                            self.analyseIncomingJSONMessage(jsonString: datastring as! String)
                        }
                    }
                }
            }
        }
    }
    
    func analyseIncomingJSONMessage(jsonString : String)
    {
        let JSONDictionary = convertToDictionary(text: jsonString)
        if(JSONDictionary?["randomQueue"] != nil)
        {
            boards.boards.append(BoardModel(scene: gameScene, number: convertToDictionary(text: convertToJSON(value: JSONDictionary?["randomQueue"] as AnyObject))?["number"] as! Int, ip:(convertToDictionary(text: convertToJSON(value: JSONDictionary?["randomQueue"] as AnyObject))?["ip"] as! String).characters.split{$0 == ":"}.map(String.init)[0]))
        }
        else if(JSONDictionary?["map"] != nil)
        {
            var buildings = convertToDictionary(text: convertToJSON(value: JSONDictionary?["map"] as AnyObject))?["buildings"] as! [Dictionary<String, AnyObject>]
            boards.boards[buildings[0]["p"] as! Int].setFields(mines: convertToDictionary(text: convertToJSON(value: JSONDictionary?["map"] as AnyObject))?["mines"] as! [Dictionary<String, AnyObject>], fields: convertToDictionary(text: convertToJSON(value: JSONDictionary?["map"] as AnyObject))?["buildings"] as! [Dictionary<String, AnyObject>])
            self.initialsMap += 1
        }
        else if(JSONDictionary?["treasure"] != nil)
        {
            boards.treasurePos.id = convertToDictionary(text: convertToJSON(value: JSONDictionary?["treasure"] as AnyObject))?["p"] as! Int
            boards.treasurePos.x = convertToDictionary(text: convertToJSON(value: JSONDictionary?["treasure"] as AnyObject))?["x"] as! Int
            boards.treasurePos.y = convertToDictionary(text: convertToJSON(value: JSONDictionary?["treasure"] as AnyObject))?["y"] as! Int
            if(!boards.tresurePacketAnalysed)
            {
                boards.tresurePacketAnalysed = true
            }
        }
        else if(JSONDictionary?["player"] != nil)
        {
            var newPlayer : player = players.playerPos[players.playerId]
            newPlayer.id = convertToDictionary(text: convertToJSON(value: JSONDictionary?["player"] as AnyObject))?["p"] as! Int
            newPlayer.x = convertToDictionary(text: convertToJSON(value: JSONDictionary?["player"] as AnyObject))?["x"] as! Int
            newPlayer.y = convertToDictionary(text: convertToJSON(value: JSONDictionary?["player"] as AnyObject))?["y"] as! Int
            if(boards.boards[newPlayer.id].matrix[newPlayer.x][newPlayer.y] == 6)
            {
                boards.boards[players.playerPos[players.playerId].id].matrix[players.playerPos[players.playerId].x][players.playerPos[players.playerId].y] = 0
                players.playerPos.remove(at: players.playerId)
                if(players.playerPos.count <= players.playerId)
                {
                    players.playerId -= 1
                }
                if(players.playerId < players.localPlayerId)
                {
                    players.localPlayerId -= 1
                }
            }
            else if(boards.boards[newPlayer.id].matrix[newPlayer.x][newPlayer.y] == 7)
            {
                let refreshAlert = UIAlertController(title: "Uwaga", message: "Gracz nr \(players.playerId+1) znalazł skarb! Przegrałeś!", preferredStyle: UIAlertControllerStyle.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    self.gameScene.buttonLeft.removeFromSuperview()
                    self.gameScene.buttonRight.removeFromSuperview()
                    self.gameScene.buttonDown.removeFromSuperview()
                    self.gameScene.buttonUp.removeFromSuperview()
                    self.gameScene.buttonLeftDown.removeFromSuperview()
                    self.gameScene.buttonLeftUp.removeFromSuperview()
                    self.gameScene.buttonRightDown.removeFromSuperview()
                    self.gameScene.buttonRightUp.removeFromSuperview()
                }))
                
                self.gameScene.view?.window?.rootViewController?.present(refreshAlert, animated: true, completion: nil)
            }
            else
            {
                boards.boards[players.playerPos[players.playerId].id].matrix[players.playerPos[players.playerId].x][players.playerPos[players.playerId].y] = 0
                players.playerPos[players.playerId] = newPlayer
                boards.boards[newPlayer.id].matrix[newPlayer.x][newPlayer.y] = players.playerId + 1
                if(players.playerId + 1 >= players.playerPos.count)
                {
                    players.playerId = 0
                } else {
                    players.playerId += 1
                }
            }
            if(players.localPlayerId == players.playerId)
            {
                boards.roundLabel.text = String("Twoja kolej: Tak")
                boards.numberOfCount = 30
            } else {
                boards.roundLabel.text = String("Twoja kolej: Nie")
            }
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [String:Any] {
                    print(json)
                    return json
                }
            } catch let err{
                print(err.localizedDescription)
            }
        }
        return nil
    }
    
    func convertToJSON(value: AnyObject) -> String {
        if JSONSerialization.isValidJSONObject(value) {
            let data = try! JSONSerialization.data(withJSONObject: value)
            if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                return string as String
            }
        }
        return ""
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
    }}
