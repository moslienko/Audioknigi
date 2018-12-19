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
    }

    func loadBookCharter() {
        if self.myBook.count > 0 {
            print ("get:",self.myBook)
            self.navigationItem.title = self.myBook[0].name
            self.charters = getChartersForBookID(self.myBook[0].id)
            print ("List:",self.charters)
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MiniPlayer.shared.showMiniPlayer()
        loadBookCharter()
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
           //todo обновление плеера
            
            let bookData = self.myBook[0]
            let player =  Player.shared
                
            player.url = charters[indexPath.row].url
            player.charterID = indexPath.row //Порядковый номер главы
            player.book = [bookData] //Данные о книги
            player.playlist = charters //Главы
                
            //todo Обновить панель мини плеера
            player.player?.pause()
            
            player.update = true
            
            self.tabBarController?.tabBar.isHidden = false
            self.tabBarController?.selectedIndex = 1
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit".localized) { action, index in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let editCharterVC = storyboard.instantiateViewController(withIdentifier: "editCharter_VC_ID") as! EditCharterViewController
            
            editCharterVC.bookID = self.myBook[0].id
            editCharterVC.charterInfo = [self.charters[index.row]]
            
            self.navigationController?.pushViewController(editCharterVC, animated: true)
        }
        edit.backgroundColor = .blue
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete".localized) { action, index in
            let alert = UIAlertController(title: "Delete".localized, message: "Delete this charter?".localized, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes".localized, style: .default , handler:{ (UIAlertAction)in
                if deleteCharter(idBook: self.myBook[0].id, numCharter: self.charters[index.row].number) {
                    self.charters.remove(at: index.row)
                    self.tableView.reloadData()
                }
                else {
                    showNote(vc: self.navigationController!, title: "Error".localized, text: "Error delete charter".localized, style: .error)
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler:{ (UIAlertAction)in }))
            self.present(alert, animated: true, completion: nil)
        }
        delete.backgroundColor = .red
        
        return [edit, delete]
    }
    
    @IBAction func deleteBookAction(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Delete".localized, message: "Delete audio book?".localized, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes".localized, style: .default , handler:{ (UIAlertAction)in
            if deleteBook(id: self.myBook[0].id),deleteChartersForBookID(self.myBook[0].id) {
                self.navigationController?.popViewController(animated: true)
            }
            else {
                showNote(vc: self.navigationController!, title: "Error".localized, text: "Error delete book".localized, style: .error)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler:{ (UIAlertAction)in }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editBook" {
            if let editBookVC = segue.destination as? EditAudioBookViewController {
                editBookVC.bookInfo = self.myBook
            }
        }
        
        if segue.identifier == "editCharter" {
            if let editCharterVC = segue.destination as? EditCharterViewController {
                editCharterVC.bookID = self.myBook[0].id
            }
        }

     }
    
}
