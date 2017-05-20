//
//  Publications.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/24/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
protocol PublicationsDelegate {
    func selectedPhoto(photo:Photos,index:IndexPath)
}
class Publications: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate  {
    var delegate:PublicationsDelegate?
    let screenSize: CGRect = UIScreen.main.bounds
    let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
    
    var lblTitle: UILabel!
    var collectionView: UICollectionView!
    var listPhotos:[Photos] = []
    var contentMessage:UIView!
    
    func drawBody(barHeight:CGFloat,title:String){
        
        self.backgroundColor = UIColor.init(hexString: GlobalConstants.color.white)
        self.frame = CGRect(x: 0, y: 180*valuePro, width: screenSize.width, height: screenSize.height-180*valuePro-barHeight-10*valuePro)
        
        let contentView:UIView = UIView()
        contentView.frame =  CGRect(x: 0, y: 0, width: screenSize.width, height: 25*valuePro)
        contentView.backgroundColor = UIColor.init(hexString: GlobalConstants.color.cobalto)

        lblTitle = UILabel()
        lblTitle.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 23*valuePro)
        lblTitle.titleColor(color: GlobalConstants.color.white,text:title)
        lblTitle.font = UIFont (name: GlobalConstants.font.helveticaRoundedBold, size: 14*valuePro)
        
        let flowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect(x: (self.frame.size.width-294.4*valuePro)/2, y: 35*valuePro , width: 294.4*valuePro, height: self.frame.size.height - 35*valuePro), collectionViewLayout: flowLayout)
        //   self.tableView.register(UINib(nibName: "CauseTableViewCell", bundle: nil), forCellReuseIdentifier: "CauseTableViewCell")
        collectionView.register(UINib(nibName: "PhotosCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotosCollectionViewCell")
        //collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        
        addSubview(collectionView)
        addSubview(contentView)
        contentView.addSubview(lblTitle)
        
    }
    func drawBodyNoData() {
        
        if contentMessage == nil {
            contentMessage = UIView()
            contentMessage.frame = self.bounds
            let imgView:UIImageView = UIImageView(image: #imageLiteral(resourceName: "noPublications"))
            imgView.frame = CGRect(x:(contentMessage.frame.width-70*valuePro)/2, y: (contentMessage.frame.height-(82+70)*valuePro)/2, width: 70*valuePro, height: 70*valuePro)
            contentMessage.addSubview(imgView)
            self.backgroundColor = UIColor.init(hexString: GlobalConstants.color.grayMedium)
            
            let lblMessage = UILabel()
            lblMessage.frame = CGRect(x:(contentMessage.frame.width-200*valuePro)/2, y: imgView.frame.origin.y+(70+5)*valuePro, width: 200*valuePro, height: 30*valuePro)
            lblMessage.text = "Aún no hay publicaciónes\npara mostrar."
            lblMessage.lineBreakMode = .byWordWrapping
            lblMessage.numberOfLines = 2
            lblMessage.font = UIFont(name: GlobalConstants.font.myriadProRegular, size: 13*valuePro)
            lblMessage.textColor = UIColor.init(hexString: GlobalConstants.color.blackComment)
            lblMessage.textAlignment = .center
            contentMessage.addSubview(lblMessage)
            
            let contentSuggestion:UIView = UIView()
            contentSuggestion.frame = CGRect(x: 0, y: (contentMessage.frame.size.height-82*valuePro), width:  contentMessage.frame.size.width, height: 92*valuePro)
            contentSuggestion.backgroundColor = UIColor.init(hexString: GlobalConstants.color.grayLight)
            contentMessage.addSubview(contentSuggestion)
            
            let lblSuggestion:UILabel = UILabel()
            lblSuggestion.frame = CGRect(x:(contentSuggestion.frame.width-200*valuePro)/2, y: 24*valuePro, width: 200*valuePro, height: 30*valuePro)
            lblSuggestion.textColor = UIColor.init(hexString: GlobalConstants.color.blackComment)
            lblSuggestion.text = "¡Comparte tu primera foto ya!"
            lblSuggestion.textAlignment = .center
            lblSuggestion.font = UIFont(name: GlobalConstants.font.myriadProRegular, size: 11*valuePro)
            contentSuggestion.addSubview(lblSuggestion)
            
            let imgArrow:UIImageView = UIImageView(image: #imageLiteral(resourceName: "suggestionArrow"))
            imgArrow.frame = CGRect(x: (contentSuggestion.frame.width-13.82*valuePro)/2, y: 61*valuePro, width: 13.82*valuePro, height: 8.95*valuePro)
            contentSuggestion.addSubview(imgArrow)
            
            addSubview(contentMessage)
            
            self.loper(arrow: imgArrow)
            
        }else{
            contentMessage.isHidden = false
        }
        
    }
    func loper(arrow:UIImageView){
        UIView.animate(withDuration: 0.6,
                       animations: {
                        arrow.frame =  CGRect(x: arrow.frame.origin.x, y: (61+15)*self.valuePro, width: 11.093*self.valuePro, height: 6.735*self.valuePro)
                        //arrow.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                        arrow.alpha = 0
        },
                       completion: { _ in
                        arrow.alpha = 0
                        arrow.frame =  CGRect(x: arrow.frame.origin.x, y: (61-15)*self.valuePro, width: 11.093*self.valuePro, height: 6.735*self.valuePro)
                        UIView.animate(withDuration: 0.6,animations: {
                            arrow.alpha = 1
                            arrow.frame =  CGRect(x: arrow.frame.origin.x, y: (61)*self.valuePro, width: 11.093*self.valuePro, height: 6.735*self.valuePro)
                        }, completion: { _ in
                            arrow.alpha = 1
                            self.loper(arrow: arrow)
                        })
        })
        
    }
    func drawBodyPublic(barHeight:CGFloat,title:String){
        
        self.backgroundColor = UIColor.init(hexString: GlobalConstants.color.white)
        self.frame = CGRect(x: 0, y: 208*valuePro, width: screenSize.width, height: screenSize.height-208*valuePro-barHeight-10*valuePro)
        
        let contentView:UIView = UIView()
        contentView.frame =  CGRect(x: 0, y: 0, width: screenSize.width, height: 25*valuePro)
        contentView.backgroundColor = UIColor.init(hexString: GlobalConstants.color.cobalto)
        
        lblTitle = UILabel()
        lblTitle.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 23*valuePro)
        lblTitle.titleColor(color: GlobalConstants.color.white,text:title)
        lblTitle.font = UIFont (name: GlobalConstants.font.helveticaRoundedBold, size: 14*valuePro)
        
        let flowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect(x: (self.frame.size.width-294.4*valuePro)/2, y: 35*valuePro , width: 294.4*valuePro, height: self.frame.size.height - 35*valuePro), collectionViewLayout: flowLayout)
        //   self.tableView.register(UINib(nibName: "CauseTableViewCell", bundle: nil), forCellReuseIdentifier: "CauseTableViewCell")
        collectionView.register(UINib(nibName: "PhotosCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotosCollectionViewCell")
        //collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        
        addSubview(collectionView)
        addSubview(contentView)
        contentView.addSubview(lblTitle)
        
    }

    func bodyNoData() {
        
    }
    func updateWithData(list:[Photos]){
        if list.count == 0 {
            drawBodyNoData()
        }else{
            if contentMessage != nil {
                contentMessage.isHidden = true
            }
            self.listPhotos = list
            collectionView.reloadData()
            self.backgroundColor = UIColor.clear
        }
       
    }
    // MARK: - CollectionViewCell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.listPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:PhotosCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCollectionViewCell", for: indexPath as IndexPath) as! PhotosCollectionViewCell
        
        cell.backgroundColor = UIColor.clear
        let photo:Photos = self.listPhotos[indexPath.row]
        cell.loadWithData(data: photo)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
        return CGSize(width: (267.4/3)*valuePro, height: (267.4/3)*valuePro)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected cell")
        self.delegate?.selectedPhoto(photo: self.listPhotos[indexPath.row],index: indexPath)
//        addToList.append(objectsArray[indexPath.row])
//        let cell = collectionView.cellForItem(at: indexPath)
//        cell?.layer.borderWidth = 2.0
//        cell?.layer.borderColor = UIColor.gray.cgColor
    }
}
