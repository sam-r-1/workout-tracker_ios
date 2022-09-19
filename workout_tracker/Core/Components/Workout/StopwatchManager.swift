//
//  StopwatchManager.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/16/22.
//

import Foundation

enum stopwatchMode {
    case running, paused //, stopped
}

class StopwatchManager: ObservableObject {
    @Published var mode: stopwatchMode = .paused
    @Published var elapsedTime = 0.0 // time in seconds
    
    var timer = Timer()
    
    // start the timer
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.elapsedTime += 0.1
        }
        
        mode = .running
    }
    
    // pause the timer
    func pause() {
        timer.invalidate()
        mode = .paused
    }
}
