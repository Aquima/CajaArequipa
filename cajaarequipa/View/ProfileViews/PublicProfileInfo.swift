//
//  PublicProfileInfo.swift
//  cajaarequipa
//
//  Created by Nara on 4/10/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
protocol PublicProfileInfoDelegate {
    func contactWithUser(user:User)
    func followWithUser(user:User)
}
class PublicProfileInfo: UIView {

    var delegate:PublicProfileInfoDelegate?
    let screenSize: CGRect = UIScreen.main.bounds
    let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
    
    var followers:String = ""
    var follows:String = ""
    var lblFollowers:UILabel!
    var lblFollowing:UILabel!
    var lblDescription:UILabel!
    var lblWebSite:UILabel!
    var lblName:UILabel!
    var imgProfile:UIImageView!
    var btnContact:UIButton!
    var btnFollow:UIButton!
    var currentUser:User!
    /**
     Esta funcion sirve para mostrar información del usuario
     */
    func drawBody(){
        
        self.backgroundColor = UIColor.init(hexString: GlobalConstants.color.grayMedium)
        self.frame = CGRect(x: 0, y: 58*valuePro, width: screenSize.width, height: 150*valuePro)
        self.layer.masksToBounds = true
        
        let contentView:UIView = UIView()
        contentView.frame =  CGRect(x: (screenSize.width-320*valuePro)/2, y: 0, width:320*valuePro , height: 150*valuePro)
        contentView.backgroundColor = UIColor.init(hexString: GlobalConstants.color.grayMedium)
        contentView.layer.masksToBounds = true
        
        imgProfile = UIImageView(image: #imageLiteral(resourceName: "userPlaceHolder"))
        imgProfile.frame = CGRect(x: 13*valuePro, y: 20*valuePro, width: 64*valuePro, height: 64*valuePro)
        imgProfile.layer.cornerRadius = imgProfile.frame.size.height/2
        imgProfile.layer.masksToBounds = true
        //   imgProfile.contentMode = .scaleAspectFit
        imgProfile.backgroundColor = UIColor.init(hexString: GlobalConstants.color.linColor)
        
        lblFollowers = UILabel()
        lblFollowers.frame = CGRect(x: 103*valuePro, y: 20*valuePro, width: 98*valuePro, height: 35*valuePro)
        lblFollowers.textAlignment = .center
        lblFollowers.lineBreakMode = .byWordWrapping
        lblFollowers.numberOfLines = 2
        lblFollowers.textColor = UIColor.init(hexString: GlobalConstants.color.blue)
        lblFollowers.font = UIFont (name: GlobalConstants.font.myriadProRegular, size: 13*valuePro)
        
        lblFollowing = UILabel()
        lblFollowing.frame = CGRect(x: 208*valuePro, y: 20*valuePro, width: 98*valuePro, height: 35*valuePro)
        lblFollowing.textAlignment = .center
        lblFollowing.lineBreakMode = .byWordWrapping
        lblFollowing.numberOfLines = 2
        lblFollowing.textColor = UIColor.init(hexString: GlobalConstants.color.blue)
        lblFollowing.font = UIFont (name: GlobalConstants.font.myriadProRegular, size: 13*valuePro)
        
        btnContact = UIButton()
        btnContact.frame = CGRect(x: 103*valuePro, y: 58*valuePro, width: 98*valuePro, height: 22*valuePro)
        btnContact.backgroundColor = UIColor.init(hexString: GlobalConstants.color.cobaltoDark)
        btnContact.layer.cornerRadius = 5
        btnContact.layer.masksToBounds = true
        btnContact.titleLabel?.font = UIFont(name: GlobalConstants.font.myriadProRegular, size: 12*valuePro)
        btnContact.addTarget(self, action: #selector(contactPressOn(sender:)), for: .touchUpInside)
        
        btnFollow = UIButton()
        btnFollow.frame = CGRect(x: 208*valuePro, y: 58*valuePro, width: 98*valuePro, height: 22*valuePro)
        btnFollow.backgroundColor = UIColor.init(hexString: GlobalConstants.color.cobalto)
        btnFollow.layer.cornerRadius = 5
        btnFollow.layer.masksToBounds = true
        btnFollow.titleLabel?.font = UIFont(name: GlobalConstants.font.myriadProRegular, size: 12*valuePro)
        btnFollow.addTarget(self, action: #selector(followPressOn(sender:)), for: .touchUpInside)
        
        lblName = UILabel()
        lblName.frame = CGRect(x: 13*valuePro, y: 95*valuePro, width: 180*valuePro, height: 17*valuePro)
        lblName.titleColor(color: GlobalConstants.color.blue,text:"")
        lblName.textAlignment = .left
        lblName.font = UIFont (name: GlobalConstants.font.helveticaRoundedBold, size: 14.5*valuePro)
        
        lblDescription = UILabel()
        lblDescription.frame = CGRect(x: 13*valuePro, y: 114*valuePro, width: 180*valuePro, height: 15*valuePro)
        lblDescription.textAlignment = .left
        lblDescription.textColor = UIColor.init(hexString: GlobalConstants.color.iron)
        lblDescription.font = UIFont (name: GlobalConstants.font.myriadProRegular, size: 13*valuePro)
        
        
        lblWebSite = UILabel()
        lblWebSite.frame = CGRect(x: 13*valuePro, y: 130*valuePro, width: 180*valuePro, height: 15*valuePro)
        lblWebSite.textAlignment = .left
        lblWebSite.textColor = UIColor.init(hexString: GlobalConstants.color.blue)
        lblWebSite.font = UIFont (name: GlobalConstants.font.myriadProRegular, size: 13*valuePro)
        
        btnContact.setTitle("Contactar", for: .normal)
        btnFollow.setTitle("Seguir", for: .normal)
        
        lblWebSite.text = "Pagina Web"
        lblDescription.text = "Descripción"
        lblFollowers.attributedText = followersInfo
        lblFollowing.attributedText = followingInfo
        addSubview(contentView)
        
        contentView.addSubview(btnFollow)
        contentView.addSubview(btnContact)
        contentView.addSubview(imgProfile)
        contentView.addSubview(lblName)
        contentView.addSubview(lblDescription)
        contentView.addSubview(lblWebSite)
        contentView.addSubview(lblFollowers)
        contentView.addSubview(lblFollowing)
        
        btnFollow.isHidden = true
        btnContact.isHidden = true
        
    }
    
    func updateView(user:User){
        self.currentUser = user

        imgProfile.sd_setImage(with: user.pictureUrl, placeholderImage: #imageLiteral(resourceName: "userPlaceHolder"))

        followers = String(user.followers)
        follows = String(user.follows)
        lblFollowers.attributedText = followersInfo
        lblFollowing.attributedText = followingInfo
        lblDescription.text = user.describe != "" ? user.describe:"Descripción"
        lblWebSite.text = user.website != "" ? user.website:"Pagina Web"
        lblName.text = user.name.getFirstName().capitalized
        
        if user.email != nil {
            btnFollow.isHidden = false
            btnContact.isHidden = false
            if user.isFollowing == false {
                btnFollow.fillTextColor(color: GlobalConstants.color.cobalto, text: "Seguir")
            }else{
                btnFollow.borderTextColor(color: GlobalConstants.color.linColor, text: "Siguiendo")
            }
        }
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
    // MARK: - Actions
    func contactPressOn(sender:UIButton){
        self.delegate?.contactWithUser(user: self.currentUser)
    }
    func followPressOn(sender:UIButton){
        self.delegate?.followWithUser(user: self.currentUser)
    }
}
