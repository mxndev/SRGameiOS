//
//  TCPSender.swift
//  SRGameiOS
//
//  Created by Mikołaj-iMac on 27.01.2017.
//  Copyright © 2017 Mikołaj Płachta. All rights reserved.
//

import Foundation
import SwiftSocket

class TCPSender : AnyObject {
    var client : TCPClient!
    
    func connect(host: String, port : String) {
        client = TCPClient(address: host, port: Int32(port)!)
        if(client.connect(timeout: 1).isSuccess)
        {
            print("Connected to client: \(host as String)")
        } else {
            print("Cannot connect to client: \(host as String)")
        }
    }
    
    func disconnect() {
        client.close()
    }
    
    func sendData(params: Dictionary<String, AnyObject>)
    {
        if(client.send(string: JSONStringify(value: params as AnyObject) + "\n").isSuccess)
        {
            print("Message send: \(JSONStringify(value: params as AnyObject))")
        }
    }
    
    func JSONStringify(value: AnyObject) -> String {
        if JSONSerialization.isValidJSONObject(value) {
            let data = try! JSONSerialization.data(withJSONObject: value)
            if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                return string as String
            }
        }
        return ""
    }
}
