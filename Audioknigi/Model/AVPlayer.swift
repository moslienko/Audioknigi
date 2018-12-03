//
//  AVPlayer.swift
//  Audioknigi
//
//  Created by Pavel Moslienko on 26/11/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class Player {
    static let shared = Player()
    
    var book = [AudioBooks]() //Данные о книги
    var playlist = [Charter]() //Плейлист (главы)
    var charterID = 0 //Номер главы
    var url:URL? //URL текущей главы
    
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    
    /**
     Инициализация плеера с последней воспроизведенной книгой
     */
    func initPlayerWithLastBook() -> Bool {
        let currentBook = getLastBook() // Последняя прослушанная книга
        
        if currentBook.count > 0 {
            
            print ("TIME:",currentBook[0].time)
            
            let playlist = getChartersForBookID(currentBook[0].id)
            
            let player = Player.shared
            
            player.charterID = currentBook[0].charter //Порядковый номер главы
            player.url = playlist[player.charterID].url
            player.book = [currentBook[0]] //Данные о книги
            player.playlist = playlist //Главы
            
            return true
        }
        return false
    }
    
    /**
     Инициализация плеера
     */
    func initPlayer() {
        if url != nil {
            print ("init with:",url)
            self.playerItem = AVPlayerItem(url: url!)
            self.player = AVPlayer(playerItem: playerItem)
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
            
        }
    }
    
    /**
     Получить слой плеера
     - Returns: Плеер для VC
     */
    func getPlayerLayer() -> AVPlayerLayer {
        let playerLayer=AVPlayerLayer(player: self.player)
        playerLayer.frame=CGRect(x:0, y:0, width:10, height:50)
        
        return playerLayer
    }

    /**
     Получить длительность текущей главы
     - Returns: Длительность
     */
    func getDuration() -> CMTime {
        if url != nil, self.player != nil {
            return self.playerItem?.asset.duration ?? CMTime()
        }
        return CMTime()
    }
    
    /**
     Если конец воспроизведения главы - открыть следующую
     */
    @objc func finishedPlaying( _ myNotification:NSNotification) {
        print ("END")
        if self.playlist.indices.contains(self.charterID+1) {
            let nextAudio = self.playlist[self.charterID+1]
            print ("Play next:",nextAudio)
            self.url = nextAudio.url
            initPlayer()
            startPlayInTime(0)
        }
    }
    
    /**
     Воспроизвести с заданного времени
     - Parameter time: Время вопроизведения
     */
    func startPlayInTime(_ time:Float) {
        let seconds : Int64 = Int64(time)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        player!.seek(to: targetTime)
        
        if player!.rate == 0
        {
            player?.play()
        }
    }
    /**
     Поставить книгу на паузу или воспроизвести
     */
    func playPauseAction() {
        if player?.rate == 0
        {
            player?.play()
        } else {
            player?.pause()
            //Сохранить время остановки
            if !savePlayer(id: book[0].id, charter: charterID, time: Float(CMTimeGetSeconds(player?.currentTime() ?? CMTime()))) {
                print ("Error save stop")
            }
        }
    }
    
    /**
     Получить изображение для кнопки воспроизведения
     - Returns: Изображение паузы или воспроизведения
     */
    func getPlayButtonImage() -> UIImage {
        var playImg = "pause"
        if Player.shared.player?.rate == 0 {
            playImg = "play"
        }
        
        return UIImage(named: playImg)!
    }
    
}
