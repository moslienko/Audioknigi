//
//  EditAudioBook+UIImagePickerDelegate.swift
//  Audioknigi
//
//  Created by Pavel Moslienko on 29/01/2019.
//  Copyright © 2019 Pavel Moslienko. All rights reserved.
//

import UIKit

extension EditAudioBookViewController: UIImagePickerControllerDelegate {
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
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
}
