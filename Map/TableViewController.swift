//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Maram Moh on 28/06/2020.
//  Copyright © 2020 Maram Moh. All rights reserved.
//

import UIKit

class TableViewController: ViewController {
    
   @IBAction func logOut(_ sender: Any) {
       UdacityAPI.logOut(completion: { err in })
           dismiss(animated: true, completion: nil)
       }
   
   override func viewDidLoad() {
          super.viewDidLoad()
          
   
          loadStudentLocations()
          
      }
   
   @IBAction func refreshButton(_ sender: Any) {
       loadStudentLocations()
   }
   @IBAction func plusButton(_ sender: Any) {
       self.performSegue(withIdentifier: "AddLocationNavigationController", sender: nil)
   }
   
  
    
    @IBOutlet weak var tableView: UITableView!
    
  override var locationInfo: LocataionInfo? {

          didSet {
              guard let locationsinfo = locationInfo else { return }
              locations = locationsinfo.results
          }
      }
      var locations: [StudentLocation] = [] {
          didSet {
              tableView.reloadData()
          }
      }
}
    // MARK: - Table view data source

extension TableViewController: UITableViewDataSource,UITableViewDelegate{


  func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
    return locations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableViewCell
        cell.name?.text = locations[indexPath.row].firstName
        cell.media?.text = locations[indexPath.row].mediaURL
        return cell
      }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt Path: IndexPath) {
        tableView.deselectRow(at: Path, animated: true)
        let loc = locations[Path.row]
        let mediaL = loc.mediaURL!
        let mediaURL = URL(string: mediaL)!
        UIApplication.shared.open(mediaURL, options: [:], completionHandler: nil)
    }


}
