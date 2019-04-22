//
//  ViewController.swift
//  CustomViewForTimer
//
//  Created by Ацамаз Бицоев on 16/04/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var pomodoroTimer: PomodoroTimerView!
    let pomodoroConfiguration = PomodoroTimerConfiguration(workSeconds: 25, smallRelaxSeconds: 5, bigRelaxSeconds: 20, bigRelaxEvery: 4, currentSeconds: 0, currentCircle: 0, totalCircles: 5, currentState: .work)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        pomodoroTimer.configure(configuration: pomodoroConfigurationй)
    }
    
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(workTimerFinished), name: NSNotification.Name("workTimerFinished"), object: nil)
    }
    
    @objc func workTimerFinished() {
        pomodoroTimer.startTimer()
    }

    
    @IBAction func butStartTapped(_ sender: UIButton) {
        pomodoroTimer.startTimer()
    }
    
    @IBAction func butStopTapped(_ sender: UIButton) {
        pomodoroTimer.stopTimer()
    }
    
    @IBAction func butResumeTapped(_ sender: UIButton) {
        pomodoroTimer.resumeTimer()
    }
    
    @IBAction func butPauseTapped(_ sender: UIButton) {
        pomodoroTimer.pauseTimer()
    }
    
    
}

