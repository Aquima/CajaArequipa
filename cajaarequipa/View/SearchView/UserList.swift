//
//  UserList.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 4/24/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit

protocol UserListDelegate {
    func checkFollowing(indexPath: IndexPath, user:User)
    func updateCheckFollowing(indexPath: IndexPath, user:User)
    func loadNewUsers(offset : Int,user:User)
    func openDetail(indexPath:IndexPath, user:User)
}
class UserList: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: UserListDelegate?
    let screenSize: CGRect = UIScreen.main.bounds
    let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
    
    var tableView: UITableView!
    var contentMessage: UIView!
    var currentData:[User] = []
    
    var pageNumber = 1
    
    var isLoading = false
    
    func drawBody(barHeight:CGFloat){
        
        self.frame =  CGRect(x:  (screenSize.width-320*valuePro)/2, y: 58*valuePro, width:320*valuePro, height: screenSize.height-barHeight-58*valuePro)
        self.tableView = UITableView(frame: CGRect(x:  0, y: 0, width:320*valuePro, height: self.frame.size.height-10*valuePro))
        self.tableView.backgroundColor = UIColor.init(hexString: "ffffff")
        self.tableView.separatorColor = UIColor.clear
        
        self.tableView.register(UINib(nibName: "UserItemTableViewCell", bundle: nil), forCellReuseIdentifier: "UserItemTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.addSubview(self.tableView)
   
    }
    func showNoDataMessage(show:Bool) {
        
        if contentMessage == nil {
            contentMessage = UIView()
            contentMessage.frame = CGRect(x: 0, y: 0, width:320*valuePro, height: self.frame.size.height-10*valuePro)
            let imgView:UIImageView = UIImageView(image: #imageLiteral(resourceName: "noSearchResult"))
            imgView.frame = CGRect(x:(contentMessage.frame.width-70*valuePro)/2, y: 92*valuePro + ((contentMessage.frame.height-92*valuePro)-(100)*valuePro)/2, width: 70*valuePro, height: 70*valuePro)
            contentMessage.addSubview(imgView)
            self.backgroundColor = UIColor.init(hexString: GlobalConstants.color.white)
            
            let lblMessage = UILabel()
            lblMessage.frame = CGRect(x:(contentMessage.frame.width-200*valuePro)/2, y: imgView.frame.origin.y+(70+5)*valuePro, width: 200*valuePro, height: 30*valuePro)
            lblMessage.text = "Aún no hay ninguna resultado \npara la busqueda."
            lblMessage.lineBreakMode = .byWordWrapping
            lblMessage.numberOfLines = 2
            lblMessage.font = UIFont(name: GlobalConstants.font.myriadProRegular, size: 13*valuePro)
            lblMessage.textColor = UIColor.init(hexString: GlobalConstants.color.blackComment)
            lblMessage.textAlignment = .center
            contentMessage.addSubview(lblMessage)
            
            let contentSuggestion:UIView = UIView()
            contentSuggestion.frame = CGRect(x: 0, y:0, width:  contentMessage.frame.size.width, height: 92*valuePro)
            contentSuggestion.backgroundColor = UIColor.init(hexString: GlobalConstants.color.grayMedium)
            contentMessage.addSubview(contentSuggestion)
            
            let lblSuggestion:UILabel = UILabel()
            lblSuggestion.frame = CGRect(x:(contentSuggestion.frame.width-200*valuePro)/2, y: 34*valuePro, width: 200*valuePro, height: 30*valuePro)
            lblSuggestion.textColor = UIColor.init(hexString: GlobalConstants.color.blackComment)
            lblSuggestion.text = "¡Ingresa el nombre de usuario a buscar!"
            lblSuggestion.textAlignment = .center
            lblSuggestion.font = UIFont(name: GlobalConstants.font.myriadProRegular, size: 11*valuePro)
            contentSuggestion.addSubview(lblSuggestion)
            
            let imgArrow:UIImageView = UIImageView(image: #imageLiteral(resourceName: "suggestionArrow"))
            imgArrow.frame = CGRect(x: (contentSuggestion.frame.width-13.82*valuePro)/2, y: 15*valuePro, width: 13.82*valuePro, height: 8.95*valuePro)
            contentSuggestion.addSubview(imgArrow)
            let angle =  CGFloat(Double.pi/180)*180
            let tr = CGAffineTransform.identity.rotated(by: angle)
            imgArrow.transform = tr
            addSubview(contentMessage)
            
            self.loper(arrow: imgArrow)
            
        }
        
        contentMessage.isHidden = show
        tableView.isHidden = !show
        
    }
    
    func loper(arrow:UIImageView){
        UIView.animate(withDuration: 0.6,
                       animations: {
                        arrow.frame =  CGRect(x: arrow.frame.origin.x, y: (0)*self.valuePro, width: 11.093*self.valuePro, height: 6.735*self.valuePro)
                        //arrow.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                        arrow.alpha = 0
        },
                       completion: { _ in
                        arrow.alpha = 0
                        arrow.frame =  CGRect(x: arrow.frame.origin.x, y: (30)*self.valuePro, width: 11.093*self.valuePro, height: 6.735*self.valuePro)
                        UIView.animate(withDuration: 0.6,animations: {
                            arrow.alpha = 1
                            arrow.frame =  CGRect(x: arrow.frame.origin.x, y: (15)*self.valuePro, width: 11.093*self.valuePro, height: 6.735*self.valuePro)
                        }, completion: { _ in
                            arrow.alpha = 1
                            self.loper(arrow: arrow)
                        })
        })
        
    }
    // MARK: - TableView Datasource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return currentData.count
    }
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UserItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UserItemTableViewCell") as! UserItemTableViewCell
        cell.loadWithUser(user: currentData[indexPath.row])
        delegate?.checkFollowing(indexPath: indexPath,user:currentData[indexPath.row])
        cell.showProfileAction = {
            self.delegate?.openDetail(indexPath: indexPath, user: self.currentData[indexPath.row])
        }
        return cell
    }
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
        return 92*valuePro;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      ///  delegate?.updateCheckFollowing(indexPath: indexPath, user: currentData[indexPath.row])
        delegate?.openDetail(indexPath: indexPath, user: currentData[indexPath.row])
    }
    // MARK: - Firebase
    func updateWithData(list:[User]){
        
        currentData = list
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.currentData.count-1 && self.isLoading == false {
            self.isLoading = true
            //load new data (new 10 movies)
            pageNumber = pageNumber + 1
            self.delegate?.loadNewUsers(offset: pageNumber, user: currentData.last!)
        }
    }
}
