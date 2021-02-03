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

        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

   
}
