//
//  PlacesTableViewController.swift
//  PlaceSearch
//
//  Created by Sepandat Pourtaymour on 15/04/2018.
//  Copyright © 2018 Sepandat Pourtaymour. All rights reserved.
//

import UIKit

class PlacesTableViewController: UITableViewController {

	let cellId = "cellId"
	var places = [Place]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "Near Me"
		let backItem = UIBarButtonItem()
		backItem.title = "Back"
		navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
		tableView.register(PlacesTableCell.self, forCellReuseIdentifier: cellId)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let place = places[indexPath.row]
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		if let controller = storyboard.instantiateViewController(withIdentifier: "placeDetailViewController") as? PlaceDetailViewController {
			controller.configure(place: place)
			navigationController?.pushViewController(controller, animated: true)
		}
	}
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PlacesTableCell
		let place = places[indexPath.row]
		cell.configure(place: place)
        return cell
    }
}
