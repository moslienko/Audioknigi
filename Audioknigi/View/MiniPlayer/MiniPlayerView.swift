//
//  MiniPlayerView.swift
//  Audioknigi
//
//  Created by Pavel Moslienko on 25/11/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import UIKit

class MiniPlayerView: UIView {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var charterName: UILabel!
    @IBOutlet weak var playerButton: UIButton!
    
    class func instanceFromNib() -> MiniPlayerView {
        let nib = UINib(nibName: "MiniPlayerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MiniPlayerView
        //Добавляет действия при нажатие на кнопки
        nib.initMiniPlayer()
        
        return nib
    }

}
