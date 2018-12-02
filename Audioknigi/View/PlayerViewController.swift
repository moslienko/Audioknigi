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
    var playlist = [Charter]() //Данные о главе
    var charterID = 0 //Номер главы (с tableView)
    
    let url = playerURL() //URL файла
    //todo Объединить??
    let audioPlayer = Player.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton?.isHidden = true
        timerButton?.isHidden = true
        
        if self.book.count > 0 {
            let bookInfo = self.book[0]
            
            self.url.bookID = bookInfo.id
            self.url.charterName = self.playlist[charterID].name

            saveAsLastBook(id: bookInfo.id)

            self.navigationItem.title = bookInfo.name
            
            backgroundImage?.image = UIImage(data: bookInfo.image)
            coverImage?.image = UIImage(data: bookInfo.image)
            //todo переместить в мини плеер, в любом случае это в МОДЕЛЬ
            let url = self.url.currentUrlStr
            print ("mp3 url is:", url)

                playButton?.isHidden = false
                timerButton?.isHidden = false
            
                let playerItem:AVPlayerItem = AVPlayerItem(url: url)
                self.audioPlayer.player = AVPlayer(playerItem: playerItem)
                
                let playerLayer=AVPlayerLayer(player: self.audioPlayer.player!)
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
                    Player.shared.startPlayInTime(self.book[0].time)
                }
            
                NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)


            
        }
    }
    
    @objc func finishedPlaying( _ myNotification:NSNotification) {
        print ("END")
        if self.playlist.indices.contains(self.charterID+1) {
            print ("Play next:",self.playlist[self.charterID+1].name)
        }
    }
    
    @IBAction func playerSliderChange(_ sender: UISlider) {
        Player.shared.startPlayInTime(playerSlider.value)
    }
    
    @IBAction func playButtonClicked(_ sender: UIButton) {
        audioPlayer.playPauseAction() //Работа с файлом
        //Интерфейс
        var playImg = "pause"
        if Player.shared.player?.rate == 0 {
            playImg = "play"
        }
        //todo сохранение времени остановки
        self.playButton?.setImage(UIImage(named: playImg), for: UIControl.State.normal)
    }
    
    @IBAction func openTimer(_ sender: UIButton) {
    }
}
