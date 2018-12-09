//
//  EditAudioBookViewController.swift
//  Audioknigi
//
//  Created by Pavel Moslienko on 04/12/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import UIKit
import ShadowImageView

class EditAudioBookViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var coverImage: ShadowImageView!
    @IBOutlet weak var nameAudioBook: UITextField!
    
    let imagePicker = UIImagePickerController()
    var bookInfo = [AudioBooks]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        setStandartCover()
        
        print ("bookInfo:",bookInfo)
        if bookInfo.count > 0 {
            coverImage?.image = UIImage(data: bookInfo[0].image)
            nameAudioBook?.text = bookInfo[0].name
        }
    }

    @IBAction func chooseUserPhoto(_ sender: UIButton) {
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .photoLibrary
        
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func standartImageClick(_ sender: UIButton) {
        setStandartCover()
    }
    
    /**
     Установка стандартного изображения для обложки
     */
    func setStandartCover()  {
        self.coverImage?.image = UIImage(named: "AppIcon")
    }
    
    /**
     Выбор обложки из пользовательской библиотеки
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            self.coverImage?.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    /**
     Сохранение аудиокниги
     */
    @IBAction func saveBook(_ sender: UIBarButtonItem) {
        if self.bookInfo.count > 0 {
            //Обновить
            let currentBookInfo = self.bookInfo[0]
            if updateBook(bookInfo: AudioBooks.init(
                id: currentBookInfo.id,
                image: coverImage.image?.pngData() ?? currentBookInfo.image,
                name: nameAudioBook?.text ?? currentBookInfo.name,
                url: currentBookInfo.url,
                charter: currentBookInfo.charter,
                time: currentBookInfo.time
            )) {
                navigationController?.popViewController(animated: true)
            }
            else {
                showNote(vc: self.navigationController!, title: "Error", text: "Error update book", style: .error)
            }
        }
        else {
            //Создать
            if createBook(bookInfo: AudioBooks.init(
                id: randomString(length: 6),
                image: (coverImage.image?.pngData())!,
                name: nameAudioBook?.text ?? "New audiobook",
                url:URL(string: "google.com")!,
                charter: 0,
                time: 0
            )) {
                navigationController?.popViewController(animated: true)
            }
            else {
                showNote(vc: self.navigationController!, title: "Error", text: "Error create book", style: .error)
            }
        }
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
    
}
