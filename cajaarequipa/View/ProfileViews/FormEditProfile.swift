//
//  FormEditProfile.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/27/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

protocol FormEditProfileDelegate {
    
    func goCamPro(sender:UIButton)
    func saveInfo(describe:String,website:String,email:String)
    func logOut()
    
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
    var btnLogOut:UIButton!
    
    var txtDescribe: UITextField!
    var txtWebSite: UITextField!
    var txtEmail: UITextField!
    
    var lineDescribe: UIView!
    var lineWebSite: UIView!
    var lineEmail: UIView!
    
    var contentView:UIView!
    
    var inputList:[UITextField] = []
 
    var activityIndicatorView: NVActivityIndicatorView!
    var activityIndicatorPhotoView: NVActivityIndicatorView!
    
    func drawBody(barHeight:CGFloat){
        
        self.backgroundColor = UIColor.init(hexString: GlobalConstants.color.grayMedium)
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
        txtDescribe.textColor = UIColor.init(hexString: GlobalConstants.color.iron)
        
        txtWebSite = UITextField()
        txtWebSite.styleForm()
        txtWebSite.placeholder = "Pagina Web"
        txtWebSite.textAlignment = .center
        txtWebSite.keyboardType = .webSearch
        txtWebSite.clearButtonMode = .always
        txtWebSite.textColor = UIColor.init(hexString: GlobalConstants.color.blue)
        txtWebSite.autocorrectionType = .no
        
        txtEmail = UITextField()
        txtEmail.styleForm()
        txtEmail.placeholder = "Correo Electronico"
        txtEmail.textAlignment = .center
        txtEmail.keyboardType = .emailAddress
        txtEmail.clearButtonMode = .always
        txtEmail.autocorrectionType = .no
        
        lineDescribe = UIView()
        lineDescribe.backgroundColor = UIColor.init(hexString: GlobalConstants.color.linColor)
        
        lineWebSite = UIView()
        lineWebSite.backgroundColor = UIColor.init(hexString: GlobalConstants.color.linColor)
        
        lineEmail = UIView()
        lineEmail.backgroundColor = UIColor.init(hexString: GlobalConstants.color.linColor)
  
        btnSaveChanges = UIButton()
        btnSaveChanges.fillTextColor(color: GlobalConstants.color.blue, text: "Guardar Cambios")
        btnSaveChanges.addTarget(self, action: #selector(saveInfo(sender:)), for: .touchUpInside)
        
        btnLogOut = UIButton()
        btnLogOut.borderTextColor(color: GlobalConstants.color.cancelRed, text: "Cerrar Sesión")
        btnLogOut.addTarget(self, action: #selector(pressLogOut(sender:)), for: .touchUpInside)
        
        let frame =  CGRect(x: btnSaveChanges.frame.origin.x + (btnSaveChanges.frame.size.width-35*valuePro)/2, y:  btnSaveChanges.frame.origin.y + (btnSaveChanges.frame.size.height-35*valuePro)/2, width:35*valuePro, height: 35*valuePro)
        
        activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                        type: NVActivityIndicatorType(rawValue:1)!)
        activityIndicatorView.color = UIColor.init(hexString: GlobalConstants.color.blue)
        activityIndicatorView.stopAnimating()
        
        let framePhoto =  CGRect(x: imgProfile.frame.origin.x + (imgProfile.frame.size.width-35*valuePro)/2, y:  imgProfile.frame.origin.y + (imgProfile.frame.size.height-35*valuePro)/2, width:35*valuePro, height: 35*valuePro)
        activityIndicatorPhotoView = NVActivityIndicatorView(frame: framePhoto,
                                                        type: NVActivityIndicatorType(rawValue:29)!)
        activityIndicatorPhotoView.color = UIColor.init(hexString: GlobalConstants.color.cobalto)
        activityIndicatorPhotoView.stopAnimating()
        
        addSubview(contentView)
        
        contentView.addSubview(activityIndicatorPhotoView)
        contentView.addSubview(activityIndicatorView)
        
        contentView.addSubview(imgProfile)
        contentView.addSubview(lblName)
        contentView.addSubview(btnChangePhoto)
        contentView.addSubview(txtDescribe)
        contentView.addSubview(txtWebSite)
        contentView.addSubview(txtEmail)
        
        contentView.addSubview(lineDescribe)
        contentView.addSubview(lineWebSite)
        contentView.addSubview(lineEmail)
        
        contentView.addSubview(btnSaveChanges)
        contentView.addSubview(btnLogOut)

        //- Add Elements to Texfield Array
        inputList.append(txtDescribe)
        inputList.append(txtWebSite)
        inputList.append(txtEmail)
        
    }
    func updateViewWithData(user:User){
        
        imgProfile.sd_setImage(with: user.pictureUrl, placeholderImage: #imageLiteral(resourceName: "userPlaceHolder"))
        lblName.text = user.name.getFirstName()
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

        btnSaveChanges.frame = CGRect(x: (contentView.frame.size.width-258*valuePro)/2, y: self.frame.size.height-(26+37)*valuePro, width: 258*valuePro, height: 37*valuePro)
        btnSaveChanges.layer.cornerRadius = 37*valuePro/2
        btnSaveChanges.titleLabel?.font = UIFont (name: GlobalConstants.font.myriadProRegular, size: 12*valuePro)
        
        btnLogOut.frame = CGRect(x: (contentView.frame.size.width-258*valuePro)/2, y: self.frame.size.height-(26+37+47)*valuePro, width: 258*valuePro, height: 37*valuePro)
        btnLogOut.layer.cornerRadius = 37*valuePro/2
        btnLogOut.titleLabel?.font = UIFont (name: GlobalConstants.font.myriadProRegular, size: 12*valuePro)

        
    }
    func resignFirstResponderList(){
        
        for inputUX in self.inputList {
            let inputTxt = inputUX
            inputTxt.resignFirstResponder()
        }
        
    }
    // MARK - Actions
    func saveInfo(sender:UIButton) {
        sender.isHidden = true
        let frame =  CGRect(x: sender.frame.origin.x + (sender.frame.size.width-35*valuePro)/2, y:  sender.frame.origin.y + (sender.frame.size.height-35*valuePro)/2, width:35*valuePro, height: 35*valuePro)
        activityIndicatorView.frame = frame
        //validate all fields
        
        activityIndicatorView.startAnimating()
        self.delegate?.saveInfo(describe: txtDescribe.text!, website: txtWebSite.text!, email: txtEmail.text!)
    }
    func pressCam(sender:UIButton) {
        sender.isHidden = true
        imgProfile.isHidden = true
        let frame =  CGRect(x: imgProfile.frame.origin.x + (imgProfile.frame.size.width-35*valuePro)/2, y:  imgProfile.frame.origin.y + (imgProfile.frame.size.height-35*valuePro)/2, width:35*valuePro, height: 35*valuePro)
        activityIndicatorPhotoView.frame = frame
        //validate all fields
        
        activityIndicatorPhotoView.startAnimating()
        self.delegate?.goCamPro(sender: sender)
    }
    func pressLogOut(sender:UIButton) {
        self.delegate?.logOut()
    }
    func stopPhotoAnimation(){
        activityIndicatorPhotoView.stopAnimating()
        btnChangePhoto.isHidden = false
        imgProfile.isHidden = false
    }
    func stopAnimation(){
        activityIndicatorView.stopAnimating()
        btnSaveChanges.isHidden = false
    }
   
}
