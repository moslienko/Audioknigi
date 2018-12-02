//
//  MiniPlayer.swift
//  Audioknigi
//
//  Created by Pavel Moslienko on 27/11/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import Foundation
import UIKit

class MiniPlayer {
    static let shared = MiniPlayer()
    
    /**
     Получить панель мини плеера
     - Returns: Слой мини плеера
     */
    func getView(width:CGFloat, height: CGFloat) -> MiniPlayerView {
        let view = MiniPlayerView.instanceFromNib()
        view.frame = CGRect(x: 0, y: height-100, width: width, height: 100)
        
        return view
    }
}
