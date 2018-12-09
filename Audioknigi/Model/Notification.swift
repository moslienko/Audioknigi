//
//  Notification.swift
//  Audioknigi
//
//  Created by Pavel Moslienko on 09/12/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift

enum noteIcon:String {
   case success = "success"
   case error = "error"
}

/**
 Показать уведомление
 - Parameter vc: Вид
 - Parameter title: Заголовок
 - Parameter text: Сообщение
 - Parameter style: Стиль
 */
func showNote(vc:UINavigationController, title:String, text:String,style:noteIcon) {
    var noteStyle = ToastStyle()
    noteStyle.titleColor = .black
    noteStyle.messageColor = .black
    noteStyle.backgroundColor = UIColor.white
    noteStyle.imageSize = CGSize(width: 35, height: 35)

    vc.view.makeToast(text, duration: 4.0, position: .top, title: title,image: UIImage(named:style.rawValue), style: noteStyle)
}
