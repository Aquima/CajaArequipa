//
//  PhotosCollectionViewCell.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/31/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    var imageView:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
        let view = UIView()
        
        view.frame = CGRect(x: 0, y: 0, width: (267.4/3)*valuePro, height: (267.4/3)*valuePro)
        self.addSubview(view)

        imageView = UIImageView()
        imageView.frame = CGRect(x:0, y:0 ,width: view.frame.size.width, height: view.frame.size.height)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 2
        view.addSubview(imageView)
        
    }
    
    func loadWithData(data:Photos){
         imageView.sd_setImage(with: data.pictureUrl, placeholderImage: #imageLiteral(resourceName: "boxPlaceholder"))
    }

}
