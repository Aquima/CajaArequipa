//
//  TimeLine.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 4/6/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit

class TimeLine: NSObject {
    
    var key:String!
    var pictureUrl:URL?
    var likes:Int!
    var comments:Int = 0
    var describe:String!
    var userPropertier:User?
    var isfavorited:Bool?
    
    func translateToModel(data:Dictionary<String, Any>){
        describe = (data["description"] != nil) ? data["description"] as! String : "Descripción"
        likes = (data["likes"] != nil) ? data["likes"] as! Int : 0
        comments = (data["comments"] != nil) ? data["comments"] as! Int : 0
        pictureUrl = (data["pictureurl"] != nil) ? URL(string: data["pictureurl"] as! String) :  nil
        userPropertier = User()
        userPropertier?.translateToModel(data: data["user"] as! Dictionary<String, Any>)
    }
}
