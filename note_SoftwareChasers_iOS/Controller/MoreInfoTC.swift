//
//  MoreInfoTC.swift
//  note_SoftwareChasers_iOS
//
//  Created by user190379 on 2/3/21.
//

import UIKit
import MapKit

class MoreInfoTC: UITableViewController {
    var note : Note!
    let helper = Helper()
    var subject : String!
    
    @IBOutlet weak var lblSubject: UILabel!
    @IBOutlet weak var lblDateModifed: UILabel!
    @IBOutlet weak var lblDateCreated: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    @IBAction func handleClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func setupUI() {
        if let lat = note.lat,let long = note.long{
            let location = CLLocationCoordinate2D(latitude: lat,longitude: long)
            let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
        
            

        }
        lblDateCreated.text = "\(helper.getDateString(from: note.date_created!, with: "EEEE, MMM d, yyyy, h:mm a"))"
        lblDateModifed.text = "\(helper.getDateString(from: note.date_created!, with: "EEEE, MMM d, yyyy, h:mm a"))"
        lblSubject.text = subject
       
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowsHeight :CGFloat = 0
        rowsHeight = rowsHeight + tableView.rowHeight
        if indexPath.row == 3{
            let height = (tableView.frame.height - rowsHeight) - 100
            return height
        }
        return UITableView.automaticDimension
    }
}

