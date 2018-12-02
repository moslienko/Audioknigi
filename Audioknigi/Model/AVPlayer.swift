//
//  AVPlayer.swift
//  Audioknigi
//
//  Created by Pavel Moslienko on 26/11/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import Foundation
import AVFoundation

class Player {
    static let shared = Player()
    
    var url:URL?
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    
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
    
    func playPauseAction() {
        if player?.rate == 0
        {
            player?.play()
        } else {
            player?.pause()
        }
    }
}
