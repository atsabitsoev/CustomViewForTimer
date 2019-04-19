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
    @IBInspectable var labTimeFontSize: CGFloat = 30
    
    @IBInspectable var shadowColor: UIColor = #colorLiteral(red: 0.368627451, green: 0.2117647059, blue: 0.6980392157, alpha: 1)
    let shadowOffset = CGSize(width: 0, height: 0)
    @IBInspectable var shadowBlurRadius: CGFloat = 4
    
    lazy var width = bounds.width
    lazy var height = bounds.height
    lazy var diameter = min(width, height)
    var radius: CGFloat { get { return diameter / 2 } }
    
    let labTime = UILabel()
    
    var firstDraw = true
    
    var totalSeconds = 30
    var currentSeconds = 0 {
        didSet {
            print("didset")
            self.setNeedsDisplay()
        }
    }
    
    
    override func draw(_ rect: CGRect) {

        mainCircle()
        arcs(radius: radius * arcsRadMultiplier)
        setCircleIndicator(totalSeconds: totalSeconds, currentSeconds: currentSeconds, state: .work)
        setLabTimeString()
        firstDraw = false
    }
    
    override func layoutSubviews() {
        if firstDraw {
            createLabTime()
        }
        
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
    
    private func setCircleIndicator(totalSeconds: Int, currentSeconds: Int, state: PomodoroTimerState) {
        
        let startAngle: CGFloat = -.pi / 2
        let k = CGFloat(currentSeconds) / CGFloat(totalSeconds)
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
        
        labTime.bounds.size = CGSize(width: 100, height: 41)
        labTime.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        labTime.backgroundColor = UIColor.white
        labTime.layer.cornerRadius = 8
        labTime.clipsToBounds = true
        labTime.layer.borderWidth = 1
        labTime.layer.borderColor = UIColor.black.cgColor
        if let labTimeFontName = labTimeFontName {
            labTime.font = UIFont(name: labTimeFontName, size: labTimeFontSize)
        }
        labTime.textAlignment = .center
        
        self.addSubview(labTime)
    }
    
    func setLabTimeString() {
        let secondsRest = totalSeconds - currentSeconds
        let minutes: Int = secondsRest/60
        let seconds: Int = secondsRest - minutes * 60
        let timeString = "\(minutes):\(seconds)"
        labTime.text = timeString
    }
    
    
    //MARK: Usable Functions
    func startTimer(totalSeconds: Int, currentSeconds: Int, state: PomodoroTimerState) {
        
        self.totalSeconds = totalSeconds
        self.currentSeconds = currentSeconds
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            
            if self.totalSeconds - self.currentSeconds > 0 {
                self.currentSeconds += Int(timer.timeInterval)
                print(self.currentSeconds)
            } else {
                timer.invalidate()
            }
        }
    }
    

}
