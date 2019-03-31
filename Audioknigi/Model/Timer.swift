//
//  Timer.swift
//  Audioknigi
//
//  Created by Pavel Moslienko on 31/03/2019.
//  Copyright © 2019 Pavel Moslienko. All rights reserved.
//

import Foundation

struct AudioTimer {
    var name:String
    var time:Float64
}

class AudioTimers {
    
    /**
     Получить список таймеров для автоматического выключения
     
     - Returns: Таймеры
     **/
    func getTimersList() -> [AudioTimer] {
        var list = [AudioTimer]()
        
        list += [AudioTimer.init(name: "Turn off", time: 0)]
        list += [AudioTimer.init(name: "In 5 minutes", time: 5*60)]
        list += [AudioTimer.init(name: "In 10 minutes", time: 10*60)]
        list += [AudioTimer.init(name: "In 15 minutes", time: 15*60)]
        list += [AudioTimer.init(name: "In 30 minutes", time: 30*60)]
        list += [AudioTimer.init(name: "In 45 minutes", time: 45*60)]
        list += [AudioTimer.init(name: "In 1 hours", time: 60*60)]
        list += [AudioTimer.init(name: "At the end of this chapter", time: -1)]
        
        return list
    }
    
}
