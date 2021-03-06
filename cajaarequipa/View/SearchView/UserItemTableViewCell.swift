//
//  UserItemTableViewCell.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 4/24/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit

class UserItemTableViewCell: UITableViewCell {
    
    let screenSize: CGRect = UIScreen.main.bounds
    let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
    
    var imgView:UIImageView!
    var lblName:UILabel!
    var lblUsername:UILabel!
    var btnProfile:UIButton!
    
    var showProfileAction : (() -> Void)? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        let view = UIView()
        view.frame = CGRect(x: (320*valuePro-304*valuePro)/2, y: 10*valuePro, width: 304*valuePro, height: 84*valuePro)

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
        
        btnProfile = UIButton()
        btnProfile.frame = imgView.frame
        btnProfile.addTarget(self, action: #selector(pressProfileOn(sender:)), for: .touchUpInside)
        
        lblName = UILabel()
        lblName.frame = CGRect(x: 84*valuePro, y: 25*valuePro, width: 200*valuePro, height: 24*valuePro)
        lblName.font = UIFont (name: GlobalConstants.font.helveticaRoundedBold, size: 13*valuePro)
        lblName.textColor = UIColor(hexString: GlobalConstants.color.blue)
        view.addSubview(lblName)
        
        lblUsername = UILabel()
        lblUsername.frame = CGRect(x: 84*valuePro, y: 45*valuePro, width: 200*valuePro, height: 15*valuePro)
        lblUsername.font = UIFont (name: GlobalConstants.font.myriadProRegular, size: 12*valuePro)
        lblUsername.textColor = UIColor(hexString: GlobalConstants.color.iron)
        view.addSubview(lblUsername)
        

        view.addSubview(btnProfile)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func loadWithUser(user:User){
        
        imgView.sd_setImage(with: user.pictureUrl, placeholderImage: #imageLiteral(resourceName: "userPlaceHolder"))
        lblName.text = user.name.getFirstName()
        lblUsername.text = user.name.getLastName()
        
    }
    func checkFollow(user:User){
        
    }
    func pressProfileOn(sender:UIButton){
        if let btnProfileAction = self.showProfileAction
        {
            btnProfileAction()
        }
    }
 
}
