//
//  MiniPlayer.swift
//  Audioknigi
//
//  Created by Pavel Moslienko on 27/11/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import Foundation
import AVFoundation
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
        self.playerButton?.setImage(Player.shared.getPlayButtonImage(), for: UIControl.State.normal) //Интерфейс
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
    let miniPlayerView = getView(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

    /**
     Получить панель мини плеера
     - Returns: Слой мини плеера
     */
    static func getView(width:CGFloat, height: CGFloat) -> MiniPlayerView {
        let view = MiniPlayerView.instanceFromNib()
        view.frame = CGRect(x: 0, y: height-100, width: width, height: 80)
        
        let player = Player.shared
        
        if player.book.count > 0 {
            view.bookName?.text = player.book[0].name
            view.charterName?.text = player.playlist[player.charterID].name
            view.coverImage?.image = UIImage(data: player.book[0].image)
            view.playerButton?.setImage(player.getPlayButtonImage(), for: UIControl.State.normal)
        }
        
        return view
    }
    
    /**
     Вставить мини плеер на экран приложения
     - Returns: Слой AVPlayer
     */
    func initMiniPlayer() -> AVPlayerLayer {
        let player = Player.shared
        player.initPlayer()
        
        let window = UIApplication.shared.keyWindow!
        window.addSubview(self.miniPlayerView);
        
        return player.getPlayerLayer()
    }
    
    /**
     Показать панель мини плеера
     */
    func showMiniPlayer() {
        self.miniPlayerView.isHidden = false
    }
    
    /**
     Скрыть панель мини плеера
     */
    func hideMiniPlayer() {
        self.miniPlayerView.isHidden = true
    }
}
