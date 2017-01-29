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
    var skScene : SKScene
    var initialsMap : Int
    
    init(port : Int32, players : PlayerWrapper, boards : BoardsWrapper, scene : SKScene)
    {
        self.skScene = scene
        self.port = port
        self.players = players
        self.boards = boards
        self.initialsMap = 0
        startServer()
    }
    
    func stopServer() {
        server.close()
    }
    
    func startServer()
    {
        self.server = TCPServer(address: getWiFiAddress()!, port: self.port)
        DispatchQueue.global(qos: .background).async
        {
            while true
            {
                self.server.listen()
                if let client = self.server.accept()
                {
                    print("Client connected IP:\(client.address) Port:[\(client.port)]")
                    while true
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
            boards.boards.append(BoardModel(scene: skScene, initializeFields: false))
            boards.boards[boards.boards.count - 1].setInitialNumber(number: convertToDictionary(text: convertToJSON(value: JSONDictionary?["randomQueue"] as AnyObject))?["number"] as! Int, ip:(convertToDictionary(text: convertToJSON(value: JSONDictionary?["randomQueue"] as AnyObject))?["ip"] as! String).characters.split{$0 == ":"}.map(String.init)[0])
        }
        else if(JSONDictionary?["map"] != nil)
        {
            var buildings = convertToDictionary(text: convertToJSON(value: JSONDictionary?["map"] as AnyObject))?["buildings"] as! [Dictionary<String, AnyObject>]
            boards.boards[buildings[0]["p"] as! Int].setFields(mines: convertToDictionary(text: convertToJSON(value: JSONDictionary?["map"] as AnyObject))?["mines"] as! [Dictionary<String, AnyObject>], fields: convertToDictionary(text: convertToJSON(value: JSONDictionary?["map"] as AnyObject))?["buildings"] as! [Dictionary<String, AnyObject>])
            self.initialsMap += 1
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
