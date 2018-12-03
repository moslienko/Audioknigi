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
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var playerSlider: UISlider!
    
    let player = Player.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MiniPlayer.shared.hideMiniPlayer()
        
        playButton?.isHidden = true
        timerButton?.isHidden = true
                
        if player.book.count > 0 {
            let bookInfo = player.book[0]
            
            saveAsLastBook(id: bookInfo.id)
            self.navigationItem.title = bookInfo.name
            backgroundImage?.image = UIImage(data: bookInfo.image)
            coverImage?.image = UIImage(data: bookInfo.image)
            
            playButton?.isHidden = false
            timerButton?.isHidden = false
            
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
                    Player.shared.startPlayInTime(audioTime)
                }
                else {
                    playerSlider?.value = 0
                    Player.shared.startPlayInTime(0)
                }
                playStop()
                
            }

        }
    }
    
    @IBAction func playerSliderChange(_ sender: UISlider) {
        Player.shared.startPlayInTime(playerSlider.value)
    }
    
    @IBAction func playButtonClicked(_ sender: UIButton) {
        playStop()
    }
    
    @IBAction func openTimer(_ sender: UIButton) {
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
