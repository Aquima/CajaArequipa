//
//  FormEditProfile.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/27/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
protocol FormEditProfileDelegate {
    func goCamPro(sender:UIButton)
}
class FormEditProfile: UIView {

    var delegate:FormEditProfileDelegate?
    
    let screenSize: CGRect = UIScreen.main.bounds
    let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
    
    var imgProfile:UIImageView!
    var lblName:UILabel!
    
    var btnChangePhoto:UIButton!
    var btnChangePassword:UIButton!
    var btnSaveChanges:UIButton!
    
    var txtDescribe: UITextField!
    var txtWebSite: UITextField!
    var txtEmail: UITextField!
    
    var lineDescribe: UIView!
    var lineWebSite: UIView!
    var lineEmail: UIView!
    
    var contentView:UIView!
    
    func drawBody(barHeight:CGFloat){
        
        self.backgroundColor = UIColor.init(hexString: GlobalConstants.color.white)
        self.frame = CGRect(x: 0, y: 58*valuePro, width: screenSize.width, height: screenSize.height-58*valuePro-barHeight)
        
        contentView = UIView()
        contentView.backgroundColor = UIColor.init(hexString: GlobalConstants.color.grayMedium)
        
        imgProfile = UIImageView(image: #imageLiteral(resourceName: "userPlaceHolder"))
        imgProfile.layer.masksToBounds = true
        imgProfile.backgroundColor = UIColor.init(hexString: GlobalConstants.color.linColor)

        lblName = UILabel()
        lblName.textAlignment = .center
        lblName.textColor = UIColor.init(hexString: GlobalConstants.color.blue)
        lblName.font = UIFont (name: GlobalConstants.font.helveticaRoundedBold, size: 14.5*valuePro)
        
        btnChangePhoto = UIButton()
        btnChangePhoto.fillTextColor(color: GlobalConstants.color.cobalto, text: "Cambiar Foto")
        btnChangePhoto.addTarget(self, action: #selector(pressCam(sender:)), for: .touchUpInside)
        
        txtDescribe = UITextField()
        txtDescribe.styleForm()
        txtDescribe.placeholder = "Descripción"
        txtDescribe.textAlignment = .center
        txtDescribe.keyboardType = .default
        txtDescribe.clearButtonMode = .always
        
        txtWebSite = UITextField()
        txtWebSite.styleForm()
        txtWebSite.placeholder = "Pagina Web"
        txtWebSite.textAlignment = .center
        txtWebSite.keyboardType = .default
        txtWebSite.clearButtonMode = .always
        
        txtEmail = UITextField()
        txtEmail.styleForm()
        txtEmail.placeholder = "Correo Electronico"
        txtEmail.textAlignment = .center
        txtEmail.keyboardType = .default
        txtEmail.clearButtonMode = .always
        
        lineDescribe = UIView()
        lineDescribe.backgroundColor = UIColor.init(hexString: GlobalConstants.color.linColor)
        
        lineWebSite = UIView()
        lineWebSite.backgroundColor = UIColor.init(hexString: GlobalConstants.color.linColor)
        
        lineEmail = UIView()
        lineEmail.backgroundColor = UIColor.init(hexString: GlobalConstants.color.linColor)
  
        addSubview(contentView)
        
        contentView.addSubview(imgProfile)
        contentView.addSubview(lblName)
        contentView.addSubview(btnChangePhoto)
        contentView.addSubview(txtDescribe)
        contentView.addSubview(txtWebSite)
        contentView.addSubview(txtEmail)
        
        contentView.addSubview(lineDescribe)
        contentView.addSubview(lineWebSite)
        contentView.addSubview(lineEmail)
        
    }
    func updateViewWithData(user:User){
        
        lblName.text = user.name
        txtEmail.text = user.email
        txtWebSite.text = user.website
        txtDescribe.text = user.describe
        
    }
    func updateView(){
        
        contentView.frame =  CGRect(x: (screenSize.width-320*valuePro)/2, y: 0, width: 320*valuePro , height: self.frame.size.height)
       
        btnChangePhoto.frame = CGRect(x: (contentView.frame.size.width-100*valuePro)/2, y: 110*valuePro, width: 100*valuePro, height: 25*valuePro)
        btnChangePhoto.layer.cornerRadius = 12.5*valuePro
        btnChangePhoto.titleLabel?.font = UIFont (name: GlobalConstants.font.myriadProRegular, size: 12*valuePro)

        lblName.frame = CGRect(x: (contentView.frame.size.width-250*valuePro)/2, y: 88*valuePro, width: 250*valuePro, height: 17*valuePro)
        imgProfile.frame = CGRect(x: (contentView.frame.size.width-74*valuePro)/2, y: 10*valuePro, width: 74*valuePro, height: 74*valuePro)
        imgProfile.layer.cornerRadius = imgProfile.frame.size.height/2
        
        let spaceHeight = 44*valuePro
        let startSpaceHeight = 148*valuePro

        //--
        txtDescribe.frame = CGRect(x: (contentView.frame.size.width-220*valuePro)/2, y: startSpaceHeight+0*(spaceHeight), width: 220*valuePro, height: 44*valuePro)
        txtDescribe.font = UIFont (name: GlobalConstants.font.myriadProRegular, size: 13*valuePro)
        
        lineDescribe.frame = CGRect(x: (contentView.frame.size.width-258*valuePro)/2, y: startSpaceHeight+1*(spaceHeight), width: 258*valuePro, height: 0.8*valuePro)
        //--
        txtWebSite.frame = CGRect(x: (contentView.frame.size.width-220*valuePro)/2, y: startSpaceHeight+1*(spaceHeight), width: 220*valuePro, height: 44*valuePro)
        txtWebSite.font = UIFont (name: GlobalConstants.font.myriadProRegular, size: 13*valuePro)
        
        lineWebSite.frame = CGRect(x: (contentView.frame.size.width-258*valuePro)/2, y: startSpaceHeight+2*(spaceHeight), width: 258*valuePro, height: 0.8*valuePro)
        //--
        txtEmail.frame = CGRect(x: (contentView.frame.size.width-220*valuePro)/2, y: startSpaceHeight+2*(spaceHeight), width: 220*valuePro, height: 44*valuePro)
        txtEmail.font = UIFont (name: GlobalConstants.font.myriadProRegular, size: 13*valuePro)
        
        lineEmail.frame = CGRect(x: (contentView.frame.size.width-258*valuePro)/2, y: startSpaceHeight+3*(spaceHeight), width: 258*valuePro, height: 0.8*valuePro)

    }
    func pressCam(sender:UIButton) {
        self.delegate?.goCamPro(sender: sender)
    }

}
