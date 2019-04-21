//
//  PomodoroTimerView.swift
//  CustomViewForTimer
//
//  Created by Ацамаз Бицоев on 16/04/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit

enum PomodoroTimerState {
    case work, relax
}


@IBDesignable
class PomodoroTimerView: UIView {
    
    
    @IBInspectable var mainColor: UIColor = #colorLiteral(red: 0.003921568627, green: 0.6745098039, blue: 0.7568627451, alpha: 1)
    @IBInspectable var additionalColor: UIColor = #colorLiteral(red: 0.2901960784, green: 0.6431372549, blue: 0.7137254902, alpha: 1)
    @IBInspectable var arcsRadMultiplier: CGFloat = 0.75
    @IBInspectable var labTimeFontName: String?
    @IBInspectable var labTimeFontSize: CGFloat = 0
    @IBInspectable var shadowColor: UIColor = #colorLiteral(red: 0.368627451, green: 0.2117647059, blue: 0.6980392157, alpha: 1)
    let shadowOffset = CGSize(width: 0, height: 0)
    @IBInspectable var shadowBlurRadius: CGFloat = 4
    
    lazy var width = bounds.width
    lazy var height = bounds.height
    lazy var diameter = min(width, height)
    var radius: CGFloat { get { return diameter / 2 } }
    
    private let labTime = UILabel()
    private var firstDraw = true
    private var timer: Timer?
    
    @IBInspectable var workSeconds: Int = 25
    @IBInspectable var smallRelaxSeconds: Int = 5
    @IBInspectable var bigRelaxSeconds: Int = 20
    @IBInspectable var bigRelaxEvery: Int = 4
    @IBInspectable var totalCircles: Int = 4
    
    var currentCircle: Int = 0
    var currentSeconds = 0 {
        didSet {
            if currentSeconds > workSeconds {
                currentSeconds = workSeconds
            }
            self.setNeedsDisplay()
        }
    }
    var state: PomodoroTimerState = .work
    private var viewConfigured = false
    
    
    override func draw(_ rect: CGRect) {

        mainCircle()
        arcs(radius: radius * arcsRadMultiplier)
        setCircleIndicator()
        if firstDraw {
            createLabTime()
        }
        setLabTimeString()
        firstDraw = false
    }
    
    
    private func mainCircle() {

        let inset = (max(width, height) - diameter)/2
        let isWidthBigger = width > height
        let mainCircleX = isWidthBigger ? inset : 0
        let mainCircleY = isWidthBigger ? 0 : inset
        let mainCircleOrigin = CGPoint(x: mainCircleX, y: mainCircleY)
        let mainRect = CGRect(origin: mainCircleOrigin, size: CGSize(width: diameter, height: diameter))
        let mainCirclePath = UIBezierPath(ovalIn: mainRect)
        mainColor.setFill()
        mainCirclePath.fill()
        
        if firstDraw {
            createShadow(mainRect)
        }
        
    }
    
    private func arcs(radius: CGFloat) {
        
        let center = CGPoint(x: width/2, y: height/2)
        let startAngles: [CGFloat] = [.pi / 12,
                                      .pi / 12 + .pi / 2,
                                      .pi / 12 + .pi,
                                      .pi / 12 + 3 * .pi / 2]
        let endAngles: [CGFloat] = [5 * .pi / 12,
                                    5 * .pi / 12 + .pi / 2,
                                    5 * .pi / 12 + .pi,
                                    5 * .pi / 12 + 3 * .pi / 2]
        
        //Drawing Arcs
        for i in 0..<startAngles.count {
            let arcsPath = UIBezierPath(arcCenter: center,
                                        radius: radius / 2,
                                        startAngle: startAngles[i],
                                        endAngle: endAngles[i],
                                        clockwise: true)
            arcsPath.lineWidth = radius
            additionalColor.setStroke()
            arcsPath.stroke()
        }
    }
    
    private func createShadow(_ rect: CGRect) {
        
        let mainOrigin = CGPoint(x: self.frame.origin.x + rect.origin.x,
                             y: self.frame.origin.y + rect.origin.y)
        let shadowView = UIView(frame: CGRect(origin: mainOrigin,
                                              size: rect.size))
        shadowView.layer.shadowOffset = shadowOffset
        shadowView.layer.shadowColor = shadowColor.cgColor
        shadowView.layer.shadowRadius = shadowBlurRadius
        shadowView.layer.shadowOpacity = 1
        shadowView.backgroundColor = shadowColor
        shadowView.layer.cornerRadius = rect.width / 2
        
        self.superview!.insertSubview(shadowView, at: 0)
    }
    
    private func getCurrentTotalSeconds() -> Int {
        var totalSeconds = 0
        switch state {
        case .work:
            totalSeconds = workSeconds
        case .relax:
            if (currentCircle + 1) % bigRelaxEvery == 0 {
                totalSeconds = bigRelaxSeconds
            } else {
                totalSeconds = smallRelaxSeconds
            }
        }
        return totalSeconds
    }
    
    private func setCircleIndicator() {
        
        let totalSeconds = getCurrentTotalSeconds()
        
        let startAngle: CGFloat = -.pi / 2
        let k = CGFloat(self.currentSeconds) / CGFloat(totalSeconds)
        let angleSize: CGFloat = 2 * .pi * k + 0.00001
        let endAngle = startAngle + angleSize
        let center = CGPoint(x: width / 2,
                             y: height / 2)
        
        let indicatorPath = UIBezierPath(arcCenter: center,
                                         radius: radius / 2,
                                         startAngle: startAngle,
                                         endAngle: endAngle,
                                         clockwise: false)
        UIColor.black.withAlphaComponent(0.5).setStroke()
        indicatorPath.lineWidth = radius
        indicatorPath.stroke()
        print(k)
    }
    
    private func createLabTime() {
        
        labTime.bounds.size = CGSize(width: diameter * 0.37, height: diameter * 0.15)
        labTime.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        labTime.backgroundColor = UIColor.white
        labTime.layer.cornerRadius = 8
        labTime.clipsToBounds = true
        labTime.layer.borderWidth = 1
        labTime.layer.borderColor = UIColor.black.cgColor
        
        if labTimeFontSize == 0 {
            labTimeFontSize = labTime.bounds.height * 0.73
        }
        if let labTimeFontName = labTimeFontName {
            labTime.font = UIFont(name: labTimeFontName, size: labTimeFontSize)
        } else {
            labTime.font = labTime.font.withSize(labTimeFontSize)
        }
        
        labTime.textAlignment = .center
        
        self.addSubview(labTime)
    }
    
    private func setLabTimeString() {
        
        let totalSeconds = getCurrentTotalSeconds()
        
        let secondsRest = totalSeconds - currentSeconds
        let minutes: Int = secondsRest/60
        let seconds: Int = secondsRest - minutes * 60
        var minutesString = String(minutes)
        var secondsString = String(seconds)
        if minutesString.count == 1 {
            minutesString.insert("0", at: minutesString.startIndex)
        }
        if secondsString.count == 1 {
            secondsString.insert("0", at: secondsString.startIndex)
        }
        let timeString = "\(minutesString):\(secondsString)"
        labTime.text = timeString
    }
    
    private func invalidateTimer() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    //MARK: Configure PomodoroTimerView
    func configure(workSeconds: Int,
                   smallRelaxSeconds: Int,
                   bigRelaxSeconds: Int,
                   bigRelaxEvery: Int,
                   currentSeconds: Int,
                   currentCircle: Int,
                   totalCircles: Int,
                   currentState: PomodoroTimerState) {
        
        self.workSeconds = workSeconds
        self.smallRelaxSeconds = smallRelaxSeconds
        self.bigRelaxSeconds = bigRelaxSeconds
        self.bigRelaxEvery = bigRelaxEvery
        self.currentSeconds = currentSeconds
        self.currentCircle = currentCircle
        self.totalCircles = totalCircles
        self.state = currentState
        
        viewConfigured = true
    }
    
    private func timerFinished() {
        
        currentSeconds = 0
        
        switch state {
        case .work:
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "workTimerFinished"), object: nil)
            state = .relax
            startTimer()
            
        case .relax:
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "relaxTimerFinished"), object: nil)
            if currentCircle + 1 < totalCircles {
                currentCircle += 1
                print("Начался круг \(currentCircle)")
                state = .work
                startTimer()
            }
            
        }
    }
    
    private func startWorkTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (thisTimer) in
            
            if self.workSeconds - self.currentSeconds > 0 {
                self.currentSeconds += Int(thisTimer.timeInterval)
                print(self.currentSeconds)
            } else {
                self.invalidateTimer()
                self.timerFinished()
            }
        }
    }
    
    private func startSmallRelaxTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (thisTimer) in
            
            if self.smallRelaxSeconds - self.currentSeconds > 0 {
                self.currentSeconds += Int(thisTimer.timeInterval)
                print(self.currentSeconds)
            } else {
                self.invalidateTimer()
                self.timerFinished()
            }
        }
    }
    
    private func startBigRelaxTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (thisTimer) in
            
            if self.bigRelaxSeconds - self.currentSeconds > 0 {
                self.currentSeconds += Int(thisTimer.timeInterval)
                print(self.currentSeconds)
            } else {
                self.invalidateTimer()
                self.timerFinished()
            }
        }
    }
    
    
    //MARK: Usable Functions
    func startTimer() {
        
        guard viewConfigured else {
            print("Сначала вызови функцию configureView")
            return
        }
        
        invalidateTimer()
        switch state {
        case .work:
            startWorkTimer()
        case .relax:
            
            if (currentCircle + 1) % bigRelaxEvery == 0 {
                startBigRelaxTimer()
            } else {
                startSmallRelaxTimer()
            }
            
        }
    }
    
    func stopTimer() {
        
        currentSeconds = 0
        invalidateTimer()
    }
    
    func pauseTimer() {
        
        invalidateTimer()
    }
    
    func resumeTimer() {
        startTimer()
    }

}
