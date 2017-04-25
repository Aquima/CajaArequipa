//
//  ListTimeline.swift
//  cajaarequipa
//
//  Created by Raul  on 4/6/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
protocol ListTimelineDelegate {
    func updateFavorited(indexPath: IndexPath, timeline:TimeLine)
    func loadNewTimeLine(offset : Int,timeline:TimeLine)
    func goProfileViewController(indexPath: IndexPath,timeline:TimeLine)
    func goCommentsViewController(indexPath: IndexPath,timeline:TimeLine)
    func goShare(indexPath: IndexPath,timeline:TimeLine)
    func showComments(indexPath: IndexPath,timeline:TimeLine)
}
class ListTimeline: UIView , UITableViewDelegate, UITableViewDataSource {
    
    var delegate: ListTimelineDelegate?
    let screenSize: CGRect = UIScreen.main.bounds
    let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
    
    var tableView: UITableView!
    var currentData:[TimeLine] = []
    
    var pageNumber = 0
    
    var isLoading = false
    
    var contentMessage:UIView!
    var isFavoritedView = false
    func drawBody(barHeight:CGFloat){
        
        self.frame =  CGRect(x:  (screenSize.width-320*valuePro)/2, y: 58*valuePro, width:320*valuePro, height: screenSize.height-barHeight-58*valuePro)
        self.tableView = UITableView(frame: CGRect(x:  (screenSize.width-320*valuePro)/2, y: 0, width:320*valuePro, height: self.frame.size.height))
        self.tableView.backgroundColor = UIColor.init(hexString: "ffffff")
        self.tableView.separatorColor = UIColor.clear
        
        self.tableView.register(UINib(nibName: "TimelineTableViewCell", bundle: nil), forCellReuseIdentifier: "TimelineTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.addSubview(self.tableView)
        
        drawBodyNoData()
    }
    func drawBodyNoData() {
        
        if contentMessage == nil {
            contentMessage = UIView()
            contentMessage.frame = self.bounds
            let imgView:UIImageView = UIImageView(image: #imageLiteral(resourceName: "placeholderHomeNoData"))
           
            imgView.frame = CGRect(x:(contentMessage.frame.width-70*valuePro)/2, y: (contentMessage.frame.height-(82+70)*valuePro)/2, width: 70*valuePro, height: 70*valuePro)
            contentMessage.addSubview(imgView)
            self.backgroundColor = UIColor.init(hexString: GlobalConstants.color.grayMedium)
            
            let lblMessage = UILabel()
            lblMessage.frame = CGRect(x:(contentMessage.frame.width-200*valuePro)/2, y: imgView.frame.origin.y+(70+5)*valuePro, width: 200*valuePro, height: 30*valuePro)
            lblMessage.text = "Aún no hay ninguna historia \npara mostrar."
            lblMessage.lineBreakMode = .byWordWrapping
            lblMessage.numberOfLines = 2
            lblMessage.font = UIFont(name: GlobalConstants.font.myriadProRegular, size: 13*valuePro)
            lblMessage.textColor = UIColor.init(hexString: GlobalConstants.color.blackComment)
            lblMessage.textAlignment = .center
            if isFavoritedView == true {
                imgView.image = #imageLiteral(resourceName: "noFavorited")
                lblMessage.text = "Aún no tienes favoritos\npara mostrar."
            }
            contentMessage.addSubview(lblMessage)
            
 
            if isFavoritedView == false{
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
                
                self.loper(arrow: imgArrow)
            }
            addSubview(contentMessage)
            contentMessage.isHidden = true
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
    // MARK: - TableView Datasource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //  let sectionInfo = self.fetchedResultsController.sections![section]
        return currentData.count//sectionInfo.numberOfObjects
    }
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    public func tableView(_ tableView:         UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TimelineTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell") as! TimelineTableViewCell
        cell.loadWithTimeline(timeline: currentData[indexPath.row])
      //  delegate?.checkFollowing(indexPath: indexPath,user:currentData[indexPath.row])
        cell.shareAction = {
            //Do whatever you want to do when the button is tapped here
              self.delegate?.goShare(indexPath: indexPath, timeline: self.currentData[indexPath.row])
        }
        cell.commentsAction = {
            //Do whatever you want to do when the button is tapped here
            self.delegate?.goCommentsViewController(indexPath: indexPath, timeline: self.currentData[indexPath.row])
        }
        cell.favoriteAction = {
            //Do whatever you want to do when the button is tapped here
            self.delegate?.updateFavorited(indexPath: indexPath, timeline: self.currentData[indexPath.row])
        }
        cell.showProfileAction = {
            self.delegate?.goProfileViewController(indexPath: indexPath, timeline: self.currentData[indexPath.row])
        }
        cell.showCommentsAction = {
            self.delegate?.showComments(indexPath: indexPath, timeline: self.currentData[indexPath.row])
        }
        return cell
    }
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
        return 440*valuePro;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

       // self.delegate?.goProfileViewController(indexPath: indexPath, timeline: self.currentData[indexPath.row])
    }//quima@kb7i // 1859olo@kb7i88
    // MARK: - Firebase
    func updateWithData(list:[TimeLine]){
        
        if list.count == 0 {
            drawBodyNoData()
            tableView.isHidden = true
        }else{
            if contentMessage != nil {
                contentMessage.isHidden = true
            }
            tableView.isHidden = false
            currentData = list
            tableView.reloadData()
            self.backgroundColor = UIColor.clear
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.currentData.count-1 && self.isLoading == false {
            self.isLoading = true
            //load new data (new 10 movies)
            pageNumber = pageNumber + 1
            self.delegate?.loadNewTimeLine(offset: pageNumber, timeline: currentData.last!)
        }
    }
}
   
