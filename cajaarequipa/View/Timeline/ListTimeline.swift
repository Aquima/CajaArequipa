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
    
}
class ListTimeline: UIView , UITableViewDelegate, UITableViewDataSource {
    
    var delegate: ListTimelineDelegate?
    let screenSize: CGRect = UIScreen.main.bounds
    let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
    
    var tableView: UITableView!
    var currentData:[TimeLine] = []
    
    var pageNumber = 1
    
    var isLoading = false
    
    func drawBody(barHeight:CGFloat){
        
        self.frame =  CGRect(x:  (screenSize.width-320*valuePro)/2, y: 58*valuePro, width:320*valuePro, height: screenSize.height-barHeight-58*valuePro)
        self.tableView = UITableView(frame: CGRect(x:  (screenSize.width-320*valuePro)/2, y: 0, width:320*valuePro, height: self.frame.size.height))
        self.tableView.backgroundColor = UIColor.init(hexString: "ffffff")
        self.tableView.separatorColor = UIColor.clear
        
        self.tableView.register(UINib(nibName: "TimelineTableViewCell", bundle: nil), forCellReuseIdentifier: "TimelineTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.addSubview(self.tableView)
        
    }
    func drawBodyNoData() {
        let imgView:UIImageView = UIImageView()
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
        return cell
    }
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
        return 440*valuePro;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

       // self.delegate?.goProfileViewController(indexPath: indexPath, timeline: self.currentData[indexPath.row])
    }
    // MARK: - Firebase
    func updateWithData(list:[TimeLine]){
        
        currentData = list
        tableView.reloadData()
        
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
   
