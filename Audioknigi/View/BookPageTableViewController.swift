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
    
    var myBook = [AudioBooks]()
    var charters = [Charter]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)

        if self.myBook.count > 0 {
            print ("get:",self.myBook)
            self.navigationItem.title = self.myBook[0].name
            self.charters = getChartersForBookID(self.myBook[0].id)
            print ("List:",self.charters)
            self.tableView.reloadData()
        }
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
        cell.detailTextLabel?.text = info.duration

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) != nil {
            self.performSegue(withIdentifier: "playBook", sender: self)
        }
    }
    
   
    @IBAction func deleteBookAction(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Delete", message: "Delete audio book?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default , handler:{ (UIAlertAction)in
            if deleteBook(id: self.myBook[0].id),deleteChartersForBookID(self.myBook[0].id) {
                self.navigationController?.popViewController(animated: true)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playBook" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if indexPath.first != nil {
                    let bookData = self.myBook[0]

                    if segue.destination is PlayerViewController {
                        let player =  Player.shared
                        
                        player.url = charters[indexPath.row].url
                        player.charterID = indexPath.row //Порядковый номер главы
                        player.book = [bookData] //Данные о книги
                        player.playlist = charters //Главы
                    }
                }
            }
        }
     }
    
}
