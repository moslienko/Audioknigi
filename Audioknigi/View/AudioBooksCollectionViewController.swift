//
//  AudioBooksCollectionViewController.swift
//  Audioknigi
//
//  Created by Pavel Moslienko on 24/11/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import UIKit

class AudioBooksCollectionViewController: UICollectionViewController,UIGestureRecognizerDelegate {
    private let reuseIdentifier = "cellAudioBook"
    
    var books = [AudioBooks]() // Список сохраненых книг
    let audioPlayer = Player.shared //Аудиоплеер

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.shortcutItems = getHomeIconShortcuts()
        
        self.collectionView?.register(UINib(nibName: "AudioBookViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        self.books = getMyAudioBooks()
        self.collectionView.reloadData()
        
        //Загрузить мини плеер
        let player = Player.shared
        //Найдена последняя открытая книга
        if  player.initPlayerWithLastBook() {
            let miniPlayer = MiniPlayer.shared
            self.view.layer.addSublayer(miniPlayer.initMiniPlayer())
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.books = getMyAudioBooks()
        self.collectionView.reloadData()
    }
    
    /**
     Получить элементы shortcuts для иконки приложения (3D Touch)
     */
    func getHomeIconShortcuts() -> [UIApplicationShortcutItem] {
        var link = [UIApplicationShortcutItem]()
        
        let lastBook = getLastBook()
        if lastBook.count > 0 {
              link.append(UIApplicationShortcutItem(type: "com.moslienko.Audioknigi.lastBookPlay", localizedTitle: "Play \"Last\"", localizedSubtitle: lastBook[0].name, icon: UIApplicationShortcutIcon(templateImageName: "play"), userInfo: nil))
        }
      
        return link
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:AudioBookViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AudioBookViewCell
        let book = self.books[indexPath.row]
        
        cell.bookCover?.image = UIImage(data: book.image)
        cell.bookCover?.shadowAlpha = CGFloat(0.95)
        
        return cell
    }
    
    /**
     Модальное окно с выбором способа добавления аудиокниги
     */
    @IBAction func addAudioBook(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Audiobook", message: "Choose way", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Add manual from URL", style: .default , handler:{ (UIAlertAction)in
            self.addFromCustomUrl()
        }))
        
        alert.addAction(UIAlertAction(title: "Auto parce from knigavuhe URL", style: .default , handler:{ (UIAlertAction)in
            self.addFromKnigaVuhe()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /**
     Добавить пустую аудокнигу
     */
    func addFromCustomUrl() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playerVC = storyboard.instantiateViewController(withIdentifier: "editBook_VC_ID") as! EditAudioBookViewController
        
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            navigationController.pushViewController(playerVC, animated: true)
        }
    }
    
    /**
     Добавить аудиокнигу используя ее url с сайта knigavuhe
     */
    func addFromKnigaVuhe() {
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
                let bookInfo = getBookInfoFromURL(NSURL(string: url!)! as URL)
                print ("Book:", bookInfo)
                if bookInfo != nil {
                    let charters = getCharterBook(url: NSURL(string: url!)! as URL, bookID: (bookInfo?.id)!)
                    print ("Charters:",charters)
                    if createBook(bookInfo: bookInfo!) {
                        for charter in charters {
                            saveCharters(charterData: charter)
                        }
                        self.books = getMyAudioBooks()
                        self.collectionView.reloadData()
                    }
                    else {
                        showNote(vc: self.navigationController!, title: "Error", text: "Error create book", style: .error)
                    }
                }
                else {
                    showNote(vc: self.navigationController!, title: "Error", text: "Not correct URL", style: .error)
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
