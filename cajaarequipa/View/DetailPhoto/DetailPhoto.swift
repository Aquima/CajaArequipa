//
//  DetailPhoto.swift
//  cajaarequipa
//
//  Created by Raul on 5/11/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit

class DetailPhoto: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    let screenSize: CGRect = UIScreen.main.bounds
    let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
    
    var imgView:UIImageView!
    var imgProfileView:UIImageView!
    var lblNameComments:UILabel!
    var btnProfile:UIButton!
    var btnFavorite:UIButton!
    var btnComments:UIButton!
    var btnShare:UIButton!
    var btnShowComment:UIButton!
    var lblLikes:UILabel!
    var lblShowComments:UILabel!
    var lblTimestamp:UILabel!
    
    var currentPhoto:Photos!
    //Action
    var favoriteAction : (() -> Void)? = nil
    var commentsAction : (() -> Void)? = nil
    var shareAction : (() -> Void)? = nil
    var showProfileAction : (() -> Void)? = nil
    var showCommentsAction : (() -> Void)? = nil
    func drawBody(barHeight:CGFloat) {
        super.awakeFromNib()
        // Initialization code
        let view = UIView()
        view.frame = CGRect(x: 0, y: 58*valuePro, width: 320*valuePro, height: 440*valuePro)
        view.backgroundColor = UIColor.init(hexString: GlobalConstants.color.white)
        self.addSubview(view)
        
        imgView = UIImageView()
        imgView.frame = CGRect(x:0*valuePro, y:0 ,width: view.frame.width, height: 320*valuePro)
        imgView.layer.masksToBounds = true
        imgView.contentMode = .scaleAspectFill
        imgView.layer.borderColor = UIColor.init(hexString: GlobalConstants.color.blue).cgColor
        //  imgView.layer.borderWidth = 0.5
        imgView.backgroundColor = UIColor.init(hexString: GlobalConstants.color.grayMedium)
        
        imgProfileView = UIImageView()
        imgProfileView.frame = CGRect(x:14*valuePro, y:288*valuePro ,width: 65*valuePro, height: 65*valuePro)
        imgProfileView.layer.cornerRadius = imgProfileView.frame.size.width/2
        imgProfileView.layer.masksToBounds = true
        imgProfileView.contentMode = .scaleAspectFill
        imgProfileView.backgroundColor = UIColor.init(hexString: GlobalConstants.color.linColor)
        imgProfileView.layer.borderColor = UIColor.init(hexString: GlobalConstants.color.white).cgColor
        imgProfileView.layer.borderWidth = 3*valuePro
        
        btnFavorite = UIButton()
        btnFavorite.frame = CGRect(x:180*valuePro, y:320*valuePro ,width: 40*valuePro, height: 40*valuePro)
        btnFavorite.setImage(#imageLiteral(resourceName: "favoritedIconOff"), for: .normal)
        btnFavorite.addTarget(self, action: #selector(pressFavoriteOn(sender:)), for: .touchUpInside)
        
        btnComments = UIButton()
        btnComments.frame = CGRect(x:226*valuePro, y:320*valuePro ,width: 40*valuePro, height: 40*valuePro)
        btnComments.setImage(#imageLiteral(resourceName: "commentIcon"), for: .normal)
        btnComments.addTarget(self, action: #selector(pressCommentsOn(sender:)), for: .touchUpInside)
        
        btnShare = UIButton()
        btnShare.frame = CGRect(x:269*valuePro, y:320*valuePro ,width: 40*valuePro, height: 40*valuePro)
        btnShare.setImage(#imageLiteral(resourceName: "shareIcon"), for: .normal)
        btnShare.addTarget(self, action: #selector(pressShareOn(sender:)), for: .touchUpInside)
        
        btnProfile = UIButton()
        btnProfile.frame = imgProfileView.frame
        btnProfile.addTarget(self, action: #selector(pressProfileOn(sender:)), for: .touchUpInside)
        
        
        lblLikes = UILabel()
        lblLikes.frame = CGRect(x:12*valuePro, y:325*valuePro ,width: 150*valuePro, height: 15*valuePro)
        
        lblNameComments = UILabel()
     //   lblNameComments.frame = CGRect(x:12*valuePro, y:370*valuePro ,width: 290*valuePro, height: 34*valuePro)
        lblNameComments.frame = CGRect(x:12*valuePro, y:335*valuePro ,width: 290*valuePro, height: 34*valuePro)
        lblNameComments.lineBreakMode = .byWordWrapping
        lblNameComments.numberOfLines = 2
        
        lblShowComments = UILabel()
     //   lblShowComments.frame = CGRect(x:12*valuePro, y:406*valuePro ,width: 170*valuePro, height: 15*valuePro)
        lblShowComments.frame = CGRect(x:12*valuePro, y:371*valuePro ,width: 170*valuePro, height: 15*valuePro)
        lblShowComments.textColor = UIColor.init(hexString: GlobalConstants.color.showCommentColor)
        lblShowComments.font = UIFont(name: GlobalConstants.font.myriadProRegular, size: 12*valuePro)!
        
        btnShowComment = UIButton()
        btnShowComment.frame = lblShowComments.frame
        btnShowComment.addTarget(self, action: #selector(pressShowComments(sender:)), for: .touchUpInside)
        
        lblTimestamp = UILabel()
        lblTimestamp.frame = CGRect(x:12*valuePro, y:386*valuePro ,width: 170*valuePro, height: 15*valuePro)
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
     //   view.addSubview(imgProfileView)
        
        view.addSubview(btnProfile)
        view.addSubview(btnShowComment)
        
    }
    func loadWithPhoto(photo:Photos){
        self.currentPhoto = photo
        imgView.sd_setImage(with: photo.pictureUrl , placeholderImage: #imageLiteral(resourceName: "placeholderTimelinePhoto"))
      //  imgProfileView.sd_setImage(with: timeline.userPropertier?.pictureUrl, placeholderImage: #imageLiteral(resourceName: "userPlaceHolder"))
        lblLikes.attributedText = updateAtributes(likes: String(photo.likes))
// 
        lblNameComments.attributedText = updateAtributesComments(name: "Raul", comment: photo.describe)
        lblShowComments.text = "Ver los \(photo.comments) comentarios"
        lblTimestamp.text = photo.timestamp.retrivePostTime()
        if photo.isfavorited == false{
           self.btnFavorite.isHidden = true
            self.btnComments.isHidden = true
        }
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
    
    // MARK: - Actions
    func pressShowComments(sender:UIButton){
        if let btnShomCommentAction = self.showCommentsAction
        {
            btnShomCommentAction()
        }
    }
    func pressFavoriteOn(sender:UIButton){
        sender.isEnabled = false
        UIView.animate(withDuration: 0.3,
                       animations: {
                        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.3, animations: {
                            sender.transform = CGAffineTransform.identity
                            if sender.tag == 1 {
                                sender.tag = 0
                                self.btnFavorite.setImage(#imageLiteral(resourceName: "favoritedIconOff"), for: .normal)
                            }else{
                                sender.tag = 1
                                self.btnFavorite.setImage(#imageLiteral(resourceName: "favoritedIconOn"), for: .normal)
                            }
                            
                        },completion: { _ in
                            sender.isEnabled = true
                        })
        })
        if let btnFavoriteAction = self.favoriteAction
        {
            btnFavoriteAction()
        }
    }
    func pressCommentsOn(sender:UIButton){
        if let btnCommentsAction = self.commentsAction
        {
            btnCommentsAction()
        }
    }
    func pressShareOn(sender:UIButton){
        if let btnShareAction = self.shareAction
        {
            btnShareAction()
        }
    }
    func pressProfileOn(sender:UIButton){
        if let btnProfileAction = self.showProfileAction
        {
            btnProfileAction()
        }
    }

    func checkFavorited(timeline: TimeLine){
        lblLikes.attributedText = updateAtributes(likes: String(timeline.likes))
        //        self.currentTimeline = timeline
        //        if self.currentTimeline.isfavorited == false{
        //            btnFavorite.setImage(#imageLiteral(resourceName: "favoritedIconOff"), for: .normal)
        //        }else{
        //            btnFavorite.setImage(#imageLiteral(resourceName: "favoritedIconOn"), for: .normal)
        //        }
    }
}
