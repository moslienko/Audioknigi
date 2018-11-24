//
//  BookPageTableViewController.swift
//  Audioknigi
//
//  Created by Pavel Moslienko on 24/11/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import UIKit

class BookPageTableViewController: UITableViewController {
    private let reuseIdentifier = "cellCharter"
    
    var charters = [Audio]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)

        self.charters = getCharterBook(url: URL(string: "https://knigavuhe.ru/book/burja-stoletija/")!)
        //print ("List:",self.charters)
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: reuseIdentifier)
        let info = self.charters[indexPath.row]
        
        cell.textLabel?.text = info.name
        cell.detailTextLabel?.text = info.time

        return cell
    }

}
