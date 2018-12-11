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

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timerButton: UIBarButtonItem!
    @IBOutlet weak var timerLabel: UIButton!
    @IBOutlet weak var playerSlider: UISlider!
    
    @IBOutlet weak var hasLeftTimeLabel: UILabel!
    @IBOutlet weak var leftTimeLabel: UILabel!
    
    @IBOutlet weak var nameBook: UILabel!
    @IBOutlet weak var nameCharter: UILabel!
    
    
    let player = Player.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MiniPlayer.shared.hideMiniPlayer()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if player.update {
            print ("test:",player)
            if player.book.count > 0 {
                let bookInfo = player.book[0]
                
                saveAsLastBook(id: bookInfo.id)
                self.navigationItem.title = bookInfo.name
                backgroundImage?.image = UIImage(data: bookInfo.image)
                coverImage?.image = UIImage(data: bookInfo.image)
                nameBook?.text = bookInfo.name
                nameCharter?.text = player.playlist[bookInfo.charter].name
                
                self.player.initPlayer()
                self.view.layer.addSublayer(self.player.getPlayerLayer())
                
                let duration : CMTime = self.player.getDuration()
                print ("duration:",duration)
                let seconds : Float64 = CMTimeGetSeconds(duration)
                print ("seconds:",seconds)
                print ("current:",CMTimeGetSeconds(self.player.player?.currentTime() ?? CMTime()))
                if seconds > 0 {
                    playerSlider?.maximumValue = Float(seconds)
                    playerSlider?.isContinuous = true
                    //Продолжить с места последней сохраненной остановки
                    if self.player.book[0].time != 0 {
                        let audioTime = self.player.book[0].time
                        
                        playerSlider?.value = audioTime
                        leftTimeLabel?.text = (seconds - Float64(audioTime)).asString(style: .positional) //Сколько осталось
    
                        Player.shared.startPlayInTime(audioTime)
                    }
                    else {
                        leftTimeLabel?.text = seconds.asString(style: .positional) //Конец главы
                        playerSlider?.value = 0
                        Player.shared.startPlayInTime(0)
                    }
                    
                    hasLeftTimeLabel?.text = CMTimeGetSeconds(player.player?.currentTime() ?? CMTime()).asString(style: .positional)
                    
                    player.player?.addProgressObserver { hasLeft, left in
                        if !hasLeft.isNaN {
                            self.hasLeftTimeLabel?.text = hasLeft.asString(style: .positional)
                            self.playerSlider.value = self.playerSlider.value + 1
                        }
                        if !left.isNaN {
                            self.leftTimeLabel?.text = left.asString(style: .positional)
                        }
                        
                        //Таймер
                        if self.player.timer < 0 {
                            //Отключить по завершению главы
                            self.timerLabel?.setTitle(self.leftTimeLabel?.text, for:.normal)
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
                    
                    playStop()
                    
                }
                
            }
            player.update = false
        }
    }
    
    @IBAction func playerSliderChange(_ sender: UISlider) {
        Player.shared.startPlayInTime(playerSlider.value)
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
             self.timerLabel?.setTitle(self.leftTimeLabel?.text, for:.normal)
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
        
        self.playButton?.setImage(UIImage(named: playImg), for: UIControl.State.normal)
    }
}
