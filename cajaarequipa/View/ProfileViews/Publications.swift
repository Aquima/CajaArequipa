//
//  Publications.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/24/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit

class Publications: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate  {
    
    let screenSize: CGRect = UIScreen.main.bounds
    let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
    
    var lblTitle: UILabel!
    var collectionView: UICollectionView!
    var listPhotos:[Photos] = []
    
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
        self.listPhotos = list
        collectionView.reloadData()
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
}
