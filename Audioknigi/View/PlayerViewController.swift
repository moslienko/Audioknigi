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
    
    var book = [AudioBooks]() //Данные о книги
    var charter = [Audio]() //Данные о главе
    var charterID = 0 //Номер главы (с tableView)
    
    let url = playerURL() //URL файла
    
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton?.isHidden = true
        timerButton?.isHidden = true
        
        if self.book.count > 0 {
            let bookInfo = self.book[0]
            
            self.url.bookID = bookInfo.id
            self.url.charterName = self.charter[0].name

            
            saveAsLastBook(id: bookInfo.id)

            self.navigationItem.title = bookInfo.name
            
            backgroundImage?.image = UIImage(data: bookInfo.image)
            coverImage?.image = UIImage(data: bookInfo.image)
            
            if self.url.checkAudioURL() {
                print ("mp3 url is:",self.url.currentUrlStr)
                
                playButton?.isHidden = false
                timerButton?.isHidden = false
                
                let url = self.url.currentUrlStr
                let playerItem:AVPlayerItem = AVPlayerItem(url: url)
                player = AVPlayer(playerItem: playerItem)
                
                let playerLayer=AVPlayerLayer(player: player!)
                playerLayer.frame=CGRect(x:0, y:0, width:10, height:50)
                self.view.layer.addSublayer(playerLayer)
                
                
                playerSlider?.minimumValue = 0
                
                
                let duration : CMTime = playerItem.asset.duration
                let seconds : Float64 = CMTimeGetSeconds(duration)
                
                playerSlider?.maximumValue = Float(seconds)
                playerSlider?.isContinuous = true
                
                //Продолжить с места последней сохраненной остановки
                if self.book[0].time != 0 {
                    playerSlider?.value = self.book[0].time
                    startPlayInTime(time: self.book[0].time)
                }
            }
            
        }
    }
    
    
    @IBAction func playerSliderChange(_ sender: UISlider) {
        startPlayInTime(time: playerSlider.value)
    }
    
    func startPlayInTime(time:Float) {
        let seconds : Int64 = Int64(time)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        player!.seek(to: targetTime)

        if player!.rate == 0
        {
            player?.play()
        }
    }
    
    
    @IBAction func playButtonClicked(_ sender: UIButton) {
        if player?.rate == 0
        {
            player!.play()
            self.playButton?.setTitle("Pause", for: UIControl.State.normal)
        } else {
            player!.pause()
            self.playButton?.setTitle("Play", for: UIControl.State.normal)
            //Сохранить
            savePlayer(id: self.book[0].id, charter: self.charterID, time: playerSlider.value)
        }
    }
    
    @IBAction func openTimer(_ sender: UIButton) {
    }
}
