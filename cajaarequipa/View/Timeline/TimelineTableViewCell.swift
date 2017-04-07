//
//  TimelineTableViewCell.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 4/6/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit

class TimelineTableViewCell: UITableViewCell {

    let screenSize: CGRect = UIScreen.main.bounds
    let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
    
    var imgView:UIImageView!
    var imgProfileView:UIImageView!
    var lblNameComments:UILabel!
    var btnFavorite:UIButton!
    var btnComments:UIButton!
    var btnShare:UIButton!
    var lblLikes:UILabel!
    var lblShowComments:UILabel!
    var lblTimestamp:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        let view = UIView()
        view.frame = CGRect(x: (screenSize.width-320*valuePro)/2, y: 0, width: 320*valuePro, height: 280*valuePro)
        view.backgroundColor = UIColor.init(hexString: GlobalConstants.color.grayMedium)
        self.addSubview(view)

        imgView = UIImageView()
        imgView.frame = CGRect(x:0*valuePro, y:0 ,width: view.frame.width, height: 160*valuePro)
        imgView.layer.masksToBounds = true
        imgView.contentMode = .scaleAspectFill
        
        imgProfileView = UIImageView()
        imgProfileView.frame = CGRect(x:14*valuePro, y:128*valuePro ,width: 65*valuePro, height: 65*valuePro)
        imgProfileView.layer.cornerRadius = imgProfileView.frame.size.width/2
        imgProfileView.layer.masksToBounds = true
        imgProfileView.contentMode = .scaleAspectFill
        imgProfileView.backgroundColor = UIColor.init(hexString: GlobalConstants.color.linColor)
        imgProfileView.layer.borderColor = UIColor.init(hexString: GlobalConstants.color.white).cgColor
        imgProfileView.layer.borderWidth = 3*valuePro
        
        btnFavorite = UIButton()
        btnFavorite.frame = CGRect(x:194*valuePro, y:166*valuePro ,width: 20*valuePro, height: 20*valuePro)
        btnFavorite.setImage(#imageLiteral(resourceName: "favoritedIconOff"), for: .normal)
        btnFavorite.addTarget(self, action: #selector(pressFavoriteOn(sender:)), for: .touchUpInside)
        
        btnComments = UIButton()
        btnComments.frame = CGRect(x:240*valuePro, y:166*valuePro ,width: 20*valuePro, height: 20*valuePro)
        btnComments.setImage(#imageLiteral(resourceName: "commentIcon"), for: .normal)
        
        
        btnShare = UIButton()
        btnShare.frame = CGRect(x:283*valuePro, y:166*valuePro ,width: 20*valuePro, height: 20*valuePro)
        btnShare.setImage(#imageLiteral(resourceName: "shareIcon"), for: .normal)
        
        lblLikes = UILabel()
        lblLikes.frame = CGRect(x:12*valuePro, y:198*valuePro ,width: 150*valuePro, height: 15*valuePro)
        
        lblNameComments = UILabel()
        lblNameComments.frame = CGRect(x:12*valuePro, y:210*valuePro ,width: 290*valuePro, height: 34*valuePro)
        lblNameComments.lineBreakMode = .byWordWrapping
        lblNameComments.numberOfLines = 2
        
        lblShowComments = UILabel()
        lblShowComments.frame = CGRect(x:12*valuePro, y:246*valuePro ,width: 170*valuePro, height: 15*valuePro)
        lblShowComments.textColor = UIColor.init(hexString: GlobalConstants.color.showCommentColor)
        lblShowComments.font = UIFont(name: GlobalConstants.font.myriadProRegular, size: 12*valuePro)!
        
        lblTimestamp = UILabel()
        lblTimestamp.frame = CGRect(x:12*valuePro, y:262*valuePro ,width: 170*valuePro, height: 15*valuePro)
        lblTimestamp.textColor = UIColor.init(hexString: GlobalConstants.color.timestampColor)
        lblTimestamp.font = UIFont(name: GlobalConstants.font.myriadProRegular, size: 12*valuePro)!

        view.addSubview(lblTimestamp)
        view.addSubview(lblShowComments)
        view.addSubview(lblNameComments)
        view.addSubview(lblLikes)
        view.addSubview(btnShare)
        view.addSubview(btnComments)
        view.addSubview(btnFavorite)
        
        view.addSubview(imgView)
        view.addSubview(imgProfileView)
        
    }
    func loadWithTimeline(timeline:TimeLine){
        
        imgView.sd_setImage(with: timeline.pictureUrl)
        imgProfileView.sd_setImage(with: timeline.userPropertier?.pictureUrl, placeholderImage: #imageLiteral(resourceName: "userPlaceHolder"))
        lblLikes.attributedText = updateAtributes(likes: String(timeline.likes))
        lblNameComments.attributedText = updateAtributesComments(name: (timeline.userPropertier?.name.getUserName().capitalized)!, comment: timeline.describe)
        lblShowComments.text = "Ver los \(timeline.comments) comentarios"
        lblTimestamp.text = "Hace 5 horas"
        btnFavorite.setImage(#imageLiteral(resourceName: "favoritedIconOff"), for: .normal)
    }
    func updateAtributes(likes:String) -> NSAttributedString{
        let attributedInformation = NSAttributedString(string: " Me Gusta", attributes: [NSFontAttributeName: UIFont(name: GlobalConstants.font.myriadProBold, size: 12*valuePro)!,NSForegroundColorAttributeName: UIColor.black])
        
        let followerRegular = NSMutableAttributedString(attributedString: attributedInformation)
        
        let attributedInformationCompose = NSAttributedString(string: likes, attributes: [NSFontAttributeName: UIFont(name: GlobalConstants.font.myriadProRegular, size: 12*valuePro)!,NSForegroundColorAttributeName: UIColor.black])
        
        let attributedString = NSMutableAttributedString(attributedString: attributedInformationCompose)
        attributedString.append(followerRegular)
  
        return attributedString
        
    }
    func updateAtributesComments(name:String,comment:String) -> NSAttributedString{
        let attributedInformation = NSAttributedString(string: " \(comment)", attributes: [NSFontAttributeName: UIFont(name: GlobalConstants.font.myriadProRegular, size: 12*valuePro)!,NSForegroundColorAttributeName: UIColor.init(hexString: GlobalConstants.color.blackComment)])
        
        let followerRegular = NSMutableAttributedString(attributedString: attributedInformation)
        
        let attributedInformationCompose = NSAttributedString(string: name, attributes: [NSFontAttributeName: UIFont(name: GlobalConstants.font.myriadProBold, size: 12*valuePro)!,NSForegroundColorAttributeName: UIColor.init(hexString: GlobalConstants.color.redName)])
        
        let attributedString = NSMutableAttributedString(attributedString: attributedInformationCompose)
        attributedString.append(followerRegular)
        
        return attributedString
        
    }


    func pressFavoriteOn(sender:UIButton){
        UIView.animate(withDuration: 0.3,
                       animations: {
                        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.3) {
                           sender.transform = CGAffineTransform.identity
                           sender.setImage(#imageLiteral(resourceName: "favoritedIconOn"), for: .normal)

                        }
        })
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
