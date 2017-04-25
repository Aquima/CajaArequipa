//
//  CommentTableViewCell.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 4/17/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    let screenSize: CGRect = UIScreen.main.bounds
    let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
    
    var imgProfileView:UIImageView!
    var lblNameComments:UILabel!
    var lblTimestamp:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        let view = UIView()
        view.frame = CGRect(x: (screenSize.width-320*valuePro)/2, y: 0*valuePro, width: 320*valuePro, height: 70*valuePro)
        view.backgroundColor = UIColor.init(hexString: GlobalConstants.color.white)
        self.addSubview(view)
        
        imgProfileView = UIImageView()
        imgProfileView.frame = CGRect(x:14*valuePro, y:14*valuePro ,width: 36*valuePro, height: 36*valuePro)
        imgProfileView.layer.cornerRadius = imgProfileView.frame.size.width/2
        imgProfileView.layer.masksToBounds = true
        imgProfileView.contentMode = .scaleAspectFill
        imgProfileView.backgroundColor = UIColor.init(hexString: GlobalConstants.color.linColor)
        imgProfileView.layer.borderColor = UIColor.init(hexString: GlobalConstants.color.white).cgColor
        imgProfileView.layer.borderWidth = 1*valuePro
        
        lblNameComments = UILabel()
        lblNameComments.frame = CGRect(x:65*valuePro, y:14*valuePro ,width: 210*valuePro, height: 34*valuePro)
        lblNameComments.lineBreakMode = .byWordWrapping
        lblNameComments.numberOfLines = 2
        
        lblTimestamp = UILabel()
        lblTimestamp.frame = CGRect(x:65*valuePro, y:view.frame.size.height - 20*valuePro ,width: 170*valuePro, height: 15*valuePro)
        lblTimestamp.textColor = UIColor.init(hexString: GlobalConstants.color.timestampColor)
        lblTimestamp.font = UIFont(name: GlobalConstants.font.myriadProRegular, size: 12*valuePro)!
        
        view.addSubview(lblTimestamp)
        view.addSubview(lblNameComments)
        view.addSubview(imgProfileView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func loadWithComment(comment:Comment){
        imgProfileView.sd_setImage(with: comment.userPropertier?.pictureUrl, placeholderImage: #imageLiteral(resourceName: "userPlaceHolder"))
        
        lblNameComments.attributedText = updateAtributesComments(name: comment.userPropertier.name.getUserName(), comment: comment.message)
        lblTimestamp.text =  comment.timestamp.retrivePostTime()
    }
    func updateAtributesComments(name:String,comment:String) -> NSAttributedString{
        let attributedInformation = NSAttributedString(string: " \(comment)", attributes: [NSFontAttributeName: UIFont(name: GlobalConstants.font.myriadProRegular, size: 12*valuePro)!,NSForegroundColorAttributeName: UIColor.init(hexString: GlobalConstants.color.blackComment)])
        
        let followerRegular = NSMutableAttributedString(attributedString: attributedInformation)
        
        let attributedInformationCompose = NSAttributedString(string: name, attributes: [NSFontAttributeName: UIFont(name: GlobalConstants.font.myriadProBold, size: 12*valuePro)!,NSForegroundColorAttributeName: UIColor.init(hexString: GlobalConstants.color.redName)])
        
        let attributedString = NSMutableAttributedString(attributedString: attributedInformationCompose)
        attributedString.append(followerRegular)
        
        return attributedString
        
    }
   
}
