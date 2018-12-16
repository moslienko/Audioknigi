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
import MediaPlayer

extension Double {
    /**
     Перевод секунд в время (для отображения) в VC
     - Parameter style: Формат
     - Returns: Время
     */
    func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
        formatter.unitsStyle = style
        guard let formattedString = formatter.string(from: self) else { return "" }
        return formattedString
    }
}

extension AVPlayer {
    /**
     Наблюдатель за плеером, при проигрывании отслеживать изменение времени
     - Returns: пройденное время, сколько осталось
     */
    func addProgressObserver(action:@escaping ((Float64,Float64) -> Void)) -> Any {
        return self.addPeriodicTimeObserver(forInterval: CMTime.init(value: 1, timescale: 1), queue: .main, using: { time in
            if let duration = self.currentItem?.duration {
                let duration = CMTimeGetSeconds(duration), time = CMTimeGetSeconds(time)
                //let progress = (time/duration)
                //let progress = (test:duration,te:time)
                action(time, duration-time)
            }
        })
    }
}

class Player {
    static let shared = Player()
    
    var book = [AudioBooks]() //Данные о книги
    var playlist = [Charter]() //Плейлист (главы)
    var charterID = 0 //Номер главы
    var url:URL? //URL текущей главы
    
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    
    var update = false //Обновить плеер
    var timer = 0.0   //Таймер
    
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
            
            player.update = true
            
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
        //Если есть след. глава и не установлен таймер на остановки после окончания главы
        if self.playlist.indices.contains(self.charterID+1), self.timer != 0 {
            let nextAudio = self.playlist[self.charterID+1]
            print ("Play next:",nextAudio)
            self.url = nextAudio.url
            initPlayer()
            startPlayInTime(0)
        }
        
        self.timer = 0 //Отключить таймер
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
            MPNowPlayingInfoCenter.default().playbackState = .playing
        } else {
            player?.pause()
            MPNowPlayingInfoCenter.default().playbackState = .paused
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
    
    /**
     Проигрывание аудио в фоновом режиме
     */
     func setupAVAudioSession() {
        do {
            
            if #available(iOS 10.0, *) {
                try! AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
            }
            else {
                AVAudioSession.sharedInstance().perform(NSSelectorFromString("setCategory:error:"), with: AVAudioSession.Category.playback)
            }
            
            try AVAudioSession.sharedInstance().setActive(true)
            UIApplication.shared.beginReceivingRemoteControlEvents()
            setupNowPlaying()
        } catch {
            print("Error with setur AV session: \(error)")
        }
    }
    
    /**
     Установить данные аудиокниги (название, обложка, длительность) в MPNowPlayingInfoCenter
     */
    func setupNowPlaying() {
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = self.book[0].name
        
        let coverImg = UIImage(data: self.book[0].image)
        let standartImg = UIImage(named: "AppIcon")
        
        nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork.init(boundsSize: coverImg?.size ?? standartImg!.size, requestHandler: { (size) -> UIImage in
            return coverImg ?? standartImg!
        })
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.playerItem?.currentTime().seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = self.playerItem?.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self.player?.rate
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        //MPNowPlayingInfoCenter.default().playbackState = .playing
    }
    
}
