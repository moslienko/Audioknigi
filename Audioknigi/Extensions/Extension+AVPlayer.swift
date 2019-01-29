//
//  Extension+AVPlayer.swift
//  Audioknigi
//
//  Created by Pavel Moslienko on 29/01/2019.
//  Copyright © 2019 Pavel Moslienko. All rights reserved.
//

import AVFoundation

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
