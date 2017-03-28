//
//  User.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/27/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit

class User: NSObject {
    var describe:String!
    var name:String!
    var pictureUrl:String!
    var email:String!
    var document:String!
    var locality:String!
    var website:String!
    var follows:NSNumber!
    var followers:NSNumber!
    func translateToModel(data:NSDictionary){
        describe = data["description"] as! String
        website = data["website"] as! String
        document = data["document"] as! String
        locality = data["locality"] as! String
        email = data["email"] as! String
        pictureUrl = data["pictureUrl"] as! String
        name = data["name"] as! String
        follows = data["follows"] as! NSNumber
        followers = data["followers"] as! NSNumber
        print(follows)
    }
}
