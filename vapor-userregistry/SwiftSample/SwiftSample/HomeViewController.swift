//
//  HomeViewController.swift
//  SwiftSample
//
//  Created by qbuser on 15/02/17.
//  Copyright © 2017 qbuser. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

class HomeViewController: UITableViewController,NVActivityIndicatorViewable {

    var dataSource = Array<Car>()
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllCar()
    }

    func fetchAllCar() {
        
        self.startAnimating()
        BaseService.requestGetURL(root+allCar, params: nil, headers:["Content-Type" :"application/json","accessToken": UserDefaults.standard.value(forKey: accessToken) as! String] , success: { (response) in
            self.dataSource.removeAll()
            for (_, element) in (response.array?.enumerated())! {
                let car = Car.init(detail: element)
                self.dataSource.append(car)
            }
            self.dataSource.sort(by: { (a, b) -> Bool in
                
                let date1 = Date.init(timeIntervalSinceReferenceDate: b.updatedDate!)
                let date2 = Date.init(timeIntervalSinceReferenceDate: a.updatedDate!)
                return date1 <= date2

            })
            self.tableView.reloadData()
            self.stopAnimating()
            
        }) { (error) in
            self.stopAnimating()
            UIAlertController.init(title: "Error", message: error.localizedDescription, preferredStyle: .alert) .show(self, sender: self)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 1 {
            return dataSource.count
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell?
        // Configure the cell...
        if indexPath.section == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
            let tempCell :CarTableViewCell = cell as! CarTableViewCell
            tempCell.setCarDetails(detal: dataSource[indexPath.row])
        }
        else
        {
        cell = tableView.dequeueReusableCell(withIdentifier: "AddCarCell", for: indexPath) as! AddCarCell
            let tempCell :AddCarCell = cell as! AddCarCell
            tempCell.parentVc = self
            tempCell.didAddCar = downloadFileFromURL
        }
        
        cell?.selectionStyle = .none
        return cell!
    }
    
   
    func  downloadFileFromURL(error: String?) -> Void {
    
        if let error = error {
            self.stopAnimating()
            let alert = UIAlertController(title: "Error", message:  error, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
         }
       else {
            fetchAllCar()
        }
    }
 
}
