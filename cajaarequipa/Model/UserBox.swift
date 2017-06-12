//
//  UserBox.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/27/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
import Firebase

class UserBox: NSObject {
    var key:String!
    var uid:String!
    var describe:String!
    var name:String!
    var pictureUrl:URL!
    var email:String!
    var document:String!
    var locality:String!
    var website:String!
    var follows:Int!
    var followers:Int!
    var isFollowing:Bool = false
    func translateToModel(data:Dictionary<String, Any>){
        uid = (data["uid"] != nil) ? data["uid"] as! String : ""
        describe = (data["description"] != nil) ? data["description"] as! String : "Descripción"
        website = (data["website"] != nil) ? data["website"] as! String : "Pagina Web"
        document = (data["document"] != nil) ? data["document"] as! String : ""
        locality = (data["locality"] != nil) ? data["locality"] as! String : ""
        email = (data["email"] != nil) ? data["email"] as! String : ""
        name = (data["name"] != nil) ? data["name"] as! String : ""
        follows = (data["following"] != nil) ? data["following"] as! Int : 0
        followers = (data["followers"] != nil) ? data["followers"] as! Int : 0
        pictureUrl = (data["pictureurl"] != nil) ? URL(string: data["pictureurl"] as! String) :  nil
    }
   
}
