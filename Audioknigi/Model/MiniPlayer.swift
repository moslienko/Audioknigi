//
//  MiniPlayer.swift
//  Audioknigi
//
//  Created by Pavel Moslienko on 27/11/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import Foundation
import UIKit

extension MiniPlayerView {
    /**
     Инициализация панели мини плеера
     */
    func initMiniPlayer() {
        self.playerButton.addTarget(self, action: #selector(self.playActionMiniPlayer(_:)), for: UIControl.Event.touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.openCurrentBook(_:)))
        self.addGestureRecognizer(tap)
    }
    
    /**
     Управление воспроизведением
     */
    @objc func playActionMiniPlayer(_ sender: UIButton?){
        Player.shared.playPauseAction() //Работа с файлом
        //Интерфейс
        var playImg = "pause"
        if Player.shared.player?.rate == 0 {
            playImg = "play"
        }
        
        self.playerButton?.setImage(UIImage(named: playImg), for: UIControl.State.normal)
    }
    /**
     Открыть полноценный экран плеера
     */
    @objc func openCurrentBook(_ sender: UITapGestureRecognizer? = nil){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playerVC = storyboard.instantiateViewController(withIdentifier: "PlayerVC_ID") as! PlayerViewController
       
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            navigationController.pushViewController(playerVC, animated: true)
        }
        
    }
    
}

class MiniPlayer {
    static let shared = MiniPlayer()
    
    /**
     Получить панель мини плеера
     - Returns: Слой мини плеера
     */
    func getView(width:CGFloat, height: CGFloat) -> MiniPlayerView {
        let view = MiniPlayerView.instanceFromNib()
        view.frame = CGRect(x: 0, y: height-100, width: width, height: 80)
        
        let player = Player.shared
        
        if player.book.count > 0 {
            view.bookName?.text = player.book[0].name
            view.charterName?.text = player.playlist[player.charterID].name
            view.coverImage?.image = UIImage(data: player.book[0].image)
        }
        
        return view
    }
}
