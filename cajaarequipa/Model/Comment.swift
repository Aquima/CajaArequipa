//
//  Comment.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 4/17/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit

class Comment: NSObject {
    
    var key:String!
    var message:String!
    var timestamp:Date!
    var userPropertier:User!
    func translateToModel(data:Dictionary<String, Any>){

        message = (data["message"] != nil) ? data["message"] as! String : ""
        userPropertier = User()
        userPropertier?.translateToModel(data: data["user"] as! Dictionary<String, Any>)
        let numberSeconds = data["timestamp"] as! NSNumber
        timestamp = Date(timeIntervalSince1970: (numberSeconds.doubleValue / 1000.0))
        
    }
}
