//
//  Photos.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/30/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit

class Photos: NSObject {
    var pictureUrl:URL?
    func translateToModel(data:Dictionary<String, Any>){
        pictureUrl = URL(string: data["pictureUrl"] as! String)
        
    }
}
