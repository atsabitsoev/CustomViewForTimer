//
//  PomodoroTimerConfiguration.swift
//  CustomViewForTimer
//
//  Created by Ацамаз Бицоев on 21/04/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import Foundation

struct PomodoroTimerConfiguration {
    
    static let standard = PomodoroTimerConfiguration(workSeconds: 25 * 60,
                                                     smallRelaxSeconds: 5 * 60,
                                                     bigRelaxSeconds: 20 * 60,
                                                     bigRelaxEvery: 4,
                                                     currentSeconds: 0,
                                                     currentCircle: 0,
                                                     totalCircles: 1,
                                                     currentState: .work)
    
       var workSeconds: Int
       var smallRelaxSeconds: Int
       var bigRelaxSeconds: Int
       var bigRelaxEvery: Int
       var currentSeconds: Int
       var currentCircle: Int
       var totalCircles: Int
       var currentState: PomodoroTimerState
    
}
