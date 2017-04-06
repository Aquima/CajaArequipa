//
//  UserTableViewCell.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 4/1/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    let screenSize: CGRect = UIScreen.main.bounds
    let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
    
    var imgView:UIImageView!
    var lblName:UILabel!
    var lblUsername:UILabel!
    var lblFollowers:UILabel!
  //  var followers:String = ""
    var btnFollow:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        let view = UIView()
        view.frame = CGRect(x: (screenSize.width-304*valuePro)/2, y: 10*valuePro, width: 304*valuePro, height: 84*valuePro)
        view.backgroundColor = UIColor.init(hexString: GlobalConstants.color.grayMedium)
        self.addSubview(view)
        
        imgView = UIImageView()
        imgView.frame = CGRect(x:9*valuePro, y:(view.frame.size.height - 66*valuePro)/2 ,width: 66*valuePro, height: 66*valuePro)
        imgView.layer.masksToBounds = true
        imgView.layer.cornerRadius = 33*valuePro
        imgView.backgroundColor = UIColor.init(hexString: GlobalConstants.color.linColor)
        imgView.layer.borderColor = UIColor.init(hexString: GlobalConstants.color.white).cgColor
        imgView.layer.borderWidth = 3*valuePro
        view.addSubview(imgView)
        
        lblName = UILabel()
        lblName.frame = CGRect(x: 81*valuePro, y: 25*valuePro, width: 110*valuePro, height: 24*valuePro)
        lblName.font = UIFont (name: GlobalConstants.font.helveticaRoundedBold, size: 13*valuePro)
        lblName.textColor = UIColor(hexString: GlobalConstants.color.blue)
        view.addSubview(lblName)
        
        lblUsername = UILabel()
        lblUsername.frame = CGRect(x: 81*valuePro, y: 45*valuePro, width: 110*valuePro, height: 15*valuePro)
        lblUsername.font = UIFont (name: GlobalConstants.font.myriadProRegular, size: 12*valuePro)
        lblUsername.textColor = UIColor(hexString: GlobalConstants.color.iron)
        view.addSubview(lblUsername)
        
        lblFollowers = UILabel()
        lblFollowers.frame = CGRect(x: 218*valuePro, y: 8*valuePro, width: 60*valuePro, height: 35*valuePro)
        lblFollowers.font = UIFont (name: GlobalConstants.font.myriadProRegular, size: 12*valuePro)
        lblFollowers.lineBreakMode = .byWordWrapping
        lblFollowers.numberOfLines = 2
        lblFollowers.textAlignment = .center
        view.addSubview(lblFollowers)
        
        btnFollow = UIButton()
        btnFollow.frame = CGRect(x: 193*valuePro, y: 48*valuePro, width: 102*valuePro, height: 22*valuePro)
  
        btnFollow.titleLabel?.font = UIFont(name: GlobalConstants.font.myriadProRegular, size: 12*valuePro)
        btnFollow.layer.cornerRadius = 5*valuePro
        btnFollow.layer.masksToBounds = true
          view.addSubview(btnFollow)
        btnFollow.fillTextColor(color: GlobalConstants.color.cobalto, text: "Seguir")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func loadWithUser(user:User){
    
        imgView.sd_setImage(with: user.pictureUrl, placeholderImage: #imageLiteral(resourceName: "userPlaceHolder"))
        lblName.text = user.name.getFirstName()
        lblFollowers.attributedText = updateAtributes(followers: String(user.followers))
        self.checkFollow(user: user)
        
    }
    func checkFollow(user:User){
        
        if user.isFollowing == false {
            btnFollow.fillTextColor(color: GlobalConstants.color.cobalto, text: "Seguir")
        }else{
            btnFollow.borderTextColor(color: GlobalConstants.color.linColor, text: "Siguiendo")
        }

        lblFollowers.attributedText = updateAtributes(followers: String(user.followers))
        
    }

    func updateAtributes(followers:String) -> NSAttributedString{
        let attributedInformation = NSAttributedString(string: "\nseguidores", attributes: [NSFontAttributeName: UIFont(name: GlobalConstants.font.myriadProRegular, size: 12*valuePro)!,NSForegroundColorAttributeName: UIColor.black])
        
        let followerRegular = NSMutableAttributedString(attributedString: attributedInformation)
        
        let attributedInformationCompose = NSAttributedString(string: followers, attributes: [NSFontAttributeName: UIFont(name: GlobalConstants.font.helveticaRoundedBold, size: 13*valuePro)!,NSForegroundColorAttributeName: UIColor.black])
        
        let attributedString = NSMutableAttributedString(attributedString: attributedInformationCompose)
        attributedString.append(followerRegular)
        
        
        return attributedString
    }
}
