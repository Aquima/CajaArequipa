//
//  OptionsCamera.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/30/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
protocol OptionsCameraDelegate {
    func pressLibraryOn()
    func pressCameraOn()
    func pressFlipOn()
    func pressFlashOn(sender:UIButton)
    func pressShotOn(sender:UIButton)
}
class OptionsCamera: UIView {

    var delegate:OptionsCameraDelegate?
    
    let screenSize: CGRect = UIScreen.main.bounds
    let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
    
    var flashButton: UIButton!
    var flipButton: UIButton!
    
    var shotButton: UIButton!
    
    var photoButton: UIButton!
    var libraryButton: UIButton!
    var hasFlash:Bool = true
    // MARK: - View
    func createComponents(){
        self.frame = CGRect(x: (screenSize.width-320*valuePro)/2, y: 58*valuePro, width: 320*valuePro, height: screenSize.height-58*valuePro)
    //    self.backgroundColor = UIColor.black
        flipButton = UIButton()
        flipButton.frame = CGRect(x: 0, y: self.frame.size.width-44*valuePro, width: 44*valuePro, height: 44*valuePro)
        flipButton.setImage(#imageLiteral(resourceName: "loop"), for: .normal)
        addSubview(flipButton)
        if hasFlash == true {
            flashButton = UIButton()
            flashButton.frame = CGRect(x:  self.frame.size.width-44*valuePro, y: self.frame.size.width-44*valuePro, width: 44*valuePro, height: 44*valuePro)
            flashButton.setImage(#imageLiteral(resourceName: "flash"), for: .normal)
            flashButton.addTarget(self, action: #selector(flashButtonPressed(sender:)), for: .touchUpInside)
            addSubview(flashButton)
        }
     
        shotButton = UIButton()
        shotButton.frame = CGRect(x:  (self.frame.size.width-74*valuePro)/2, y: self.frame.size.width+42*valuePro, width: 74*valuePro, height: 74*valuePro)
        shotButton.setImage(#imageLiteral(resourceName: "shutter"), for: .normal)
        addSubview(shotButton)
        
        libraryButton = UIButton()
        libraryButton.frame = CGRect(x: 0 , y: self.frame.size.height - 44*valuePro, width:  (self.frame.size.width)/2 , height: 44*valuePro)
        libraryButton.titleTextColor(color: GlobalConstants.color.deactivateBlue, text: "Biblioteca")
        libraryButton.titleLabel?.font = UIFont(name: GlobalConstants.font.helveticaRoundedBold, size: 15*valuePro)
        addSubview(libraryButton)
        
        photoButton = UIButton()
        photoButton.frame = CGRect(x: (self.frame.size.width)/2 , y: self.frame.size.height - 44*valuePro, width:  (self.frame.size.width)/2 , height: 44*valuePro)
        photoButton.titleTextColor(color: GlobalConstants.color.blue, text: "Camara")
        photoButton.titleLabel?.font = UIFont(name: GlobalConstants.font.helveticaRoundedBold, size: 15*valuePro)
        addSubview(photoButton)
        
        flipButton.addTarget(self, action: #selector(flipButtonPressed(sender:)), for: .touchUpInside)
      
        shotButton.addTarget(self, action: #selector(shotButtonPressed(sender:)), for: .touchUpInside)
        libraryButton.addTarget(self, action: #selector(libraryButtonPressed(sender:)), for: .touchUpInside)
        photoButton.addTarget(self, action: #selector(cameraButtonPressed(sender:)), for: .touchUpInside)
        
    }
    // MARK: - Actions
    func flipButtonPressed(sender:UIButton) {
        self.delegate?.pressFlipOn()
    }
    func flashButtonPressed(sender:UIButton) {
        self.delegate?.pressFlashOn(sender: sender)
    }
    func shotButtonPressed(sender:UIButton) {
        self.delegate?.pressShotOn(sender: sender)
    }
    func libraryButtonPressed(sender:UIButton) {
        self.delegate?.pressLibraryOn()
    }
    func cameraButtonPressed(sender:UIButton) {
        self.delegate?.pressCameraOn()
    }
}
