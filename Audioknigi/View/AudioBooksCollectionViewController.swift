//
//  AudioBooksCollectionViewController.swift
//  Audioknigi
//
//  Created by Pavel Moslienko on 24/11/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import UIKit


class AudioBooksCollectionViewController: UICollectionViewController {
    private let reuseIdentifier = "cellAudioBook"
    
    var books = [AudioBooks]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.register(UINib(nibName: "AudioBookViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        self.books = getMyAudioBooks()
        self.collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.books = getMyAudioBooks()
        self.collectionView.reloadData()
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return books.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:AudioBookViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AudioBookViewCell
        let book = self.books[indexPath.row]
        
        cell.bookCover?.image = UIImage(data: book.image)
        
        return cell
    }
    
    @IBAction func addAudioBook(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Enter URL", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            
            if textField.text != "" {
                var url = textField.text
                if (url?.contains("m.kniga") == false) {
                    //Используется мобильная версия сайта
                     url = url?.replacingOccurrences(of: "knigav", with: "m.knigav")
                }
                //Получить информацию о книге и сохранить
                let bookInfo = getBookInfoFromURL(NSURL(string: url!)! as URL)!
                print ("Book:", bookInfo)
                if bookInfo.id != "" {
                    if createBook(bookInfo: bookInfo) {
                        self.books = getMyAudioBooks()
                        self.collectionView.reloadData()
                    }
                }
                
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter url audiobooks on knigavuhe.ru"
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        self.present(alert, animated:true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.cellForItem(at: indexPath) != nil {
            self.performSegue(withIdentifier: "openAudioBook", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print ("click")
        if segue.identifier == "openAudioBook" {
            
            if let indexPath = collectionView.indexPathsForSelectedItems{
                if indexPath.first != nil {
                    let bookData = self.books[indexPath.first!.row]
                    
                    if let openBookVC = segue.destination as? BookPageTableViewController {
                        openBookVC.myBook = [bookData]
                    }
                }
            }
        }
    }
    
}
