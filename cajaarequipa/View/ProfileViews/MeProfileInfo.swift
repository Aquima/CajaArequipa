//
//  MeProfileInfo.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/23/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit

class MeProfileInfo: UIView {
    
    let screenSize: CGRect = UIScreen.main.bounds
    let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
    
    var followers:String = ""
    var follows:String = ""
    var lblFollowers:UILabel!
    var lblFollowing:UILabel!
    var lblDescription:UILabel!
    var lblWebSite:UILabel!
    var imgProfile:UIImageView!
    /**
     Esta funcion sirve para mostrar información del usuario
     */
    func drawBody(){
 
        self.backgroundColor = UIColor.init(hexString: GlobalConstants.color.grayMedium)
        self.frame = CGRect(x: 0, y: 58*valuePro, width: screenSize.width, height: 122*valuePro)
        
        let contentView:UIView = UIView()
        contentView.frame =  CGRect(x: (screenSize.width-320*valuePro)/2, y:0 , width:320*valuePro , height: 122*valuePro)
        contentView.backgroundColor = UIColor.init(hexString: GlobalConstants.color.grayMedium)
        
        imgProfile = UIImageView(image: #imageLiteral(resourceName: "userPlaceHolder"))
        imgProfile.frame = CGRect(x: 24*valuePro, y: 20*valuePro, width: 82*valuePro, height: 82*valuePro)
        imgProfile.layer.cornerRadius = imgProfile.frame.size.height/2
        imgProfile.layer.masksToBounds = true
     //   imgProfile.contentMode = .scaleAspectFit
        imgProfile.backgroundColor = UIColor.init(hexString: GlobalConstants.color.linColor)
       
        lblFollowers = UILabel()
        lblFollowers.frame = CGRect(x: 128*valuePro, y: 20*valuePro, width: 60*valuePro, height: 35*valuePro)
        lblFollowers.textAlignment = .center
        lblFollowers.lineBreakMode = .byWordWrapping
        lblFollowers.numberOfLines = 2
        lblFollowers.textColor = UIColor.init(hexString: GlobalConstants.color.blue)
        lblFollowers.font = UIFont (name: GlobalConstants.font.myriadProRegular, size: 13*valuePro)
        
        lblFollowing = UILabel()
        lblFollowing.frame = CGRect(x: 220*valuePro, y: 20*valuePro, width: 60*valuePro, height: 35*valuePro)
        lblFollowing.textAlignment = .center
        lblFollowing.lineBreakMode = .byWordWrapping
        lblFollowing.numberOfLines = 2
        lblFollowing.textColor = UIColor.init(hexString: GlobalConstants.color.blue)
        lblFollowing.font = UIFont (name: GlobalConstants.font.myriadProRegular, size: 13*valuePro)

        
        lblDescription = UILabel()
        lblDescription.frame = CGRect(x: 128*valuePro, y: 58*valuePro, width: 180*valuePro, height: 15*valuePro)
        lblDescription.textAlignment = .left
        lblDescription.textColor = UIColor.init(hexString: GlobalConstants.color.iron)
        lblDescription.font = UIFont (name: GlobalConstants.font.myriadProRegular, size: 13*valuePro)

        
        lblWebSite = UILabel()
        lblWebSite.frame = CGRect(x: 128*valuePro, y: 74*valuePro, width: 180*valuePro, height: 15*valuePro)
        lblWebSite.textAlignment = .left
        lblWebSite.textColor = UIColor.init(hexString: GlobalConstants.color.blue)
        lblWebSite.font = UIFont (name: GlobalConstants.font.myriadProRegular, size: 13*valuePro)

        lblWebSite.text = "Pagina Web"
        lblDescription.text = "Descripción"
        lblFollowers.attributedText = followersInfo
        lblFollowing.attributedText = followingInfo
        addSubview(contentView)
        
        contentView.addSubview(imgProfile)
        contentView.addSubview(lblDescription)
        contentView.addSubview(lblWebSite)
        contentView.addSubview(lblFollowers)
        contentView.addSubview(lblFollowing)
        
    }
    
    func updateView(user:User){
      //  let urlimage = "https://firebasestorage.googleapis.com/v0/b/caja-arequipa.appspot.com/o/wL5pK9CT0tOLf7rA4dRelRQKzhh2?alt=media"
        imgProfile.sd_setImage(with: user.pictureUrl, placeholderImage: #imageLiteral(resourceName: "userPlaceHolder"))
      //   imgProfile.sd_setImage(with: URL.init(string:urlimage), placeholderImage: #imageLiteral(resourceName: "userPlaceHolder"))
        
        followers = String(user.followers)
        follows = String(user.follows)
        lblFollowers.attributedText = followersInfo
        lblFollowing.attributedText = followingInfo

        lblDescription.text = user.describe != "" ? user.describe:"Descripción"
        lblWebSite.text = user.website != "" ? user.website:"Pagina Web"
    }
    var followersInfo: NSAttributedString {
        let attributedInformation = NSAttributedString(string: followers, attributes: [NSFontAttributeName: UIFont(name: GlobalConstants.font.helveticaRoundedBold, size: 14*valuePro)!,NSForegroundColorAttributeName: UIColor.black])
        
        let attributedString = NSMutableAttributedString(attributedString: attributedInformation)
        attributedString.append(followerRegular)
        
        return attributedString
    }
    var followerRegular: NSAttributedString {
        let attributedInformation = NSAttributedString(string: "\nseguidores", attributes: [NSFontAttributeName: UIFont(name: GlobalConstants.font.myriadProRegular, size: 13*valuePro)!,NSForegroundColorAttributeName: UIColor.black])
        
        let attributedString = NSMutableAttributedString(attributedString: attributedInformation)
        
        return attributedString
    }
    var followingInfo: NSAttributedString {
        let attributedInformation = NSAttributedString(string: follows, attributes: [NSFontAttributeName: UIFont(name: GlobalConstants.font.helveticaRoundedBold, size: 14*valuePro)!,NSForegroundColorAttributeName: UIColor.darkGray])
        
        let attributedString = NSMutableAttributedString(attributedString: attributedInformation)
        attributedString.append(followingRegular)
        
        return attributedString
    }
    var followingRegular: NSAttributedString {
        let attributedInformation = NSAttributedString(string: "\nseguidos", attributes: [NSFontAttributeName: UIFont(name: GlobalConstants.font.myriadProRegular, size: 13*valuePro)!,NSForegroundColorAttributeName: UIColor.darkGray])
        
        let attributedString = NSMutableAttributedString(attributedString: attributedInformation)
        
        return attributedString
    }
}
