//
//  HistoryTableViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 25/01/2021.
//  Copyright © 2021 BeeBants. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFunctions
import AuthenticationServices
import FirebaseFirestoreSwift

class HistoryTableViewController: UITableViewController {

    
    var history : [HistoryField] = []
    var offset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        loadTripsFromHistory(offset: offset)
    }
    
    
    func loadTripsFromHistory(offset: Int) {
        Functions.functions().httpsCallable("loadHistory").call(["offset":offset]) {
            (result, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let results = (result?.data as? [String: Any])?["historyElements"] as! [String]
            var x =  0
            
            for trip in results {
                x = x + 1
                
                // Retrieve History Trip Data Firestore
                Firestore.firestore().collection("History").document(trip).getDocument {
                    (document, error) in
                    
                    if let document = document, document.exists {
                        let imgPath = (document.get("cityName") as! String) + "/Locations/" + (document.get("locImg") as! String)
                        let storageRef = Storage.storage().reference(withPath: imgPath)
                        storageRef.getData(maxSize: (1 * 4194304 * 4194304)) {
                            (data, error) in
                            if let _data  = data {
                                let img = UIImage(data: _data)!

                                let row = HistoryField(name: document.get("spotName") as! String, img: img, timestamp: document.get("timestamp") as! Timestamp, review: document.get("review") as! Int, fileName: trip)
                                self.history.append(row)
                                
                                
                                if (x == results.count) {
                                    self.history.sort(by: {$0.stamp > $1.stamp})
                                    self.tableView.reloadData()
                                }
                            } else {
                                // this loc img not found
                            }
                        }
                    } else {
                        // this trip not found
                    }
                }
            }
        }
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? HistoryTableViewCell else {
            fatalError("")
        }
        
        let row = history[indexPath.row]
        
        cell.nameLabel.text = row.spotName
        cell.dateLabel.text = row.date
        cell.locationImg.image = row.location
        cell.ranking = row.ranking
        print(row.historyFile)
        print(row.ranking)
        cell.historyFile = row.historyFile
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.addLoading(indexPath) {
            self.offset += 1
            self.loadTripsFromHistory(offset: self.offset)
        }
    }

}



extension UITableView{

    func addLoading(_ indexPath:IndexPath, closure: @escaping (() -> Void)){
        if let lastVisibleIndexPath = self.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath && indexPath.row == self.numberOfRows(inSection: 0) - 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    closure()
                }
            }
        }
    }
}
