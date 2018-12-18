//
//  PlayerViewController.swift
//  Audioknigi
//
//  Created by Pavel Moslienko on 25/11/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//
import Foundation
import UIKit
import AVFoundation
import MediaPlayer

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var coverView: PlayerCover!
    @IBOutlet weak var controlView: PlayerControl!
    @IBOutlet weak var timerButton: UIBarButtonItem!
    @IBOutlet weak var timerLabel: UIButton!
    
    let player = Player.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controlView.playButton.addTarget(self, action:  #selector(self.playButtonClicked(_:)), for: .touchUpInside)
        controlView.playerSlider.addTarget(self, action:  #selector(self.playerSliderChange(_:)), for: .valueChanged)
        
        UIApplication.shared.beginReceivingRemoteControlEvents()

        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
        
        commandCenter.playCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            print ("Click play")
            self?.playStop()
            MPNowPlayingInfoCenter.default().playbackState = .playing
            return .success
        }
        commandCenter.pauseCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            print ("Click pause")
            self?.playStop()
            MPNowPlayingInfoCenter.default().playbackState = .paused
            return .success
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if player.update {
            print ("test:",player)
            if player.book.count > 0 {
                self.player.initPlayer()
                //NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.playerItem)

                self.view.layer.addSublayer(self.player.getPlayerLayer())
                updatePlayerUI()
                
            }
            player.update = false
            self.player.setupAVAudioSession()
        }
        
    }
    
    func updatePlayerUI() {
        if player.book.count > 0 {
            let bookInfo = player.book[0]
            print ("UI:",bookInfo)
            saveAsLastBook(id: bookInfo.id)
            self.navigationItem.title = bookInfo.name
            coverView.backgroundCover?.image = UIImage(data: bookInfo.image)
            coverView.coverImage?.image = UIImage(data: bookInfo.image)
            controlView.nameBook?.text = bookInfo.name
            controlView.nameCharter?.text = player.playlist[self.player.charterID].name
            
            print ("charter id is:",player.playlist[self.player.charterID])
            //todo изменять интерфейс при переключении на след. главу
            //self.player.startPlayInTime(0)
            
             let duration : CMTime = self.player.getDuration()
             print ("duration:",duration)
             let seconds : Float64 = CMTimeGetSeconds(duration)
             print ("seconds:",seconds)
             print ("current:",CMTimeGetSeconds(self.player.player?.currentTime() ?? CMTime()))
             if seconds > 0 {
                 controlView.playerSlider?.maximumValue = Float(seconds)
                 controlView.playerSlider?.isContinuous = true
                 //Продолжить с места последней сохраненной остановки
                 if bookInfo.time != 0 {
                 let audioTime = bookInfo.time
                 
                 controlView.playerSlider?.value = audioTime
                 controlView.leftTimeLabel?.text = (seconds - Float64(audioTime)).asString(style: .positional) //Сколько осталось
                 
                 Player.shared.startPlayInTime(audioTime)
             }
             else {
                 controlView.leftTimeLabel?.text = seconds.asString(style: .positional) //Конец главы
                 controlView.playerSlider?.value = 0
                 Player.shared.startPlayInTime(0)
             }
             
             self.controlView.hasLeftTimeLabel?.text = CMTimeGetSeconds(player.player?.currentTime() ?? CMTime()).asString(style: .positional)
             
             player.player?.addProgressObserver { hasLeft, left in
             if !hasLeft.isNaN {
             self.controlView.hasLeftTimeLabel?.text = hasLeft.asString(style: .positional)
             self.controlView.playerSlider.value = self.controlView.playerSlider.value + 1
             }
             if !left.isNaN {
             self.controlView.leftTimeLabel?.text = left.asString(style: .positional)
             }
             
             if left.asString(style: .positional) == "0" {
                self.endCharter()
             }
             
             //Таймер
             if self.player.timer < 0 {
                 //Отключить по завершению главы
                 self.timerLabel?.setTitle(self.controlView.leftTimeLabel?.text, for:.normal)
             }
             if self.player.timer > 0 {
                 let newTime = self.player.timer - 1
                 self.timerLabel?.setTitle(newTime.asString(style: .positional), for:.normal)
                 self.player.timer = newTime
             }
             //Отключение
             if self.player.timer == 1 {
                self.player.player?.pause()
             }
             
             
             }
                self.player.startPlayInTime(0)

             //playStop()
             }
        }
    }
    
    
    @IBAction func playerSliderChange(_ sender: UISlider) {
        Player.shared.startPlayInTime(controlView.playerSlider?.value ?? 0)
    }
    
    @IBAction func playButtonClicked(_ sender: UIButton) {
        playStop()
    }
    
    @IBAction func openTimer(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Turn off", style: .default , handler:{ (UIAlertAction)in
            self.setTimer(seconds: 0)
        }))
        alert.addAction(UIAlertAction(title: "In 5 minutes", style: .default , handler:{ (UIAlertAction)in
            self.setTimer(seconds: 5*60)
        }))
        alert.addAction(UIAlertAction(title: "In 10 minutes", style: .default , handler:{ (UIAlertAction)in
            self.setTimer(seconds: 10*60)
        }))
        alert.addAction(UIAlertAction(title: "In 15 minutes", style: .default , handler:{ (UIAlertAction)in
            self.setTimer(seconds: 15*60)
        }))
        alert.addAction(UIAlertAction(title: "In 30 minutes", style: .default , handler:{ (UIAlertAction)in
            self.setTimer(seconds: 30*60)
        }))
        alert.addAction(UIAlertAction(title: "In 45 minutes", style: .default , handler:{ (UIAlertAction)in
            self.setTimer(seconds: 45*60)
        }))
        alert.addAction(UIAlertAction(title: "In 1 hours", style: .default , handler:{ (UIAlertAction)in
            self.setTimer(seconds: 60*60)
        }))
        alert.addAction(UIAlertAction(title: "At the end of this chapter", style: .default , handler:{ (UIAlertAction)in
            self.setTimer(seconds: -1)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func setTimer(seconds:Float64) {
        self.player.timer = seconds
        print ("seconds:",seconds)
        if seconds == 0 {
            //Без таймера
            self.timerLabel?.setTitle("Sleep timer", for:.normal)
        }
        if seconds < 0 {
            //Отключить по окончанию главы
             self.timerLabel?.setTitle(controlView.leftTimeLabel?.text, for:.normal)
        }
        if seconds > 0 {
            //Таймер
            self.timerLabel?.setTitle(seconds.asString(style: .positional), for:.normal)
        }
       
    }
    
    func playStop() {
        self.player.playPauseAction() //Работа с файлом

        //Интерфейс
        var playImg = "pause"
        if self.player.player?.rate == 0 {
            playImg = "play"
        }

        savePlayer(id: player.book[0].id, charter: player.charterID, time: Float(CMTimeGetSeconds(self.player.player?.currentTime() ?? CMTime())))
        
        controlView.playButton?.setImage(UIImage(named: playImg), for: UIControl.State.normal)
    }
    
    /**
     Если конец воспроизведения главы - открыть следующую
     */
    @objc func finishedPlaying( _ myNotification:NSNotification) {
        endCharter()
    }
    
    func endCharter() {
        print ("END")
        print ("timer:",self.player.timer)
        print ("timer:",self.player.playlist.indices.contains(self.player.charterID+1))
        
        //Если есть след. глава и не установлен таймер на остановки после окончания главы
        if self.player.playlist.indices.contains(self.player.charterID+1), self.player.timer != -1 {
            let nextAudio = self.player.playlist[self.player.charterID+1]
            print ("Play next:",nextAudio)
            self.player.url = nextAudio.url
            self.player.charterID += 1
            self.player.book[0].time = 0
            self.player.initPlayer()
            self.player.startPlayInTime(0)
            
            self.updatePlayerUI()
        }
        
        self.player.timer = 0 //Отключить таймер
    }
}
