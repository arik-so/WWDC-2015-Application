//
// Created by Arik Sosman on 4/19/15.
// Copyright (c) 2015 Arik Sosman. All rights reserved.
//

import Foundation
import UIKit

// this class is responsible for drawing the watch that represents the year and month
class WatchView : UIView {
    
    private var monthLabels = [UILabel]()
    private(set) var circleCenter : CGPoint?
    private(set) var circleRadius : CGFloat?
    
    private var monthFingerLayer : CAShapeLayer?
    
    func initializeWatchView(){

        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        
        let width = self.frame.width
        let screenHeight = self.frame.height
        let height = screenHeight - statusBarHeight; // we don't want to consider the status bar in the calculations
        
        // we first need to draw a circle
        // its diameter is determined by whichever is smaller, width or height
        let diameterLimit = min(width, height)
        
        // however, we want to achieve the golden ratio, so we use 1/1.618th of the space
        let diameter = diameterLimit / 1.618
        let radius = diameter * 0.5
        self.circleRadius = radius
        
        // horizontally, we want it centered
        let leftPadding = (width - diameter) * 0.5
        
        // we want the center of the circle to be at the golden ratio
        let centerTopOffset = height / (1 + 1.618)
        let topPadding = centerTopOffset - (diameter * 0.5) + statusBarHeight // we need to re-add the status bar height to the top offset

        let circleCenter = CGPoint(x: leftPadding + radius, y: topPadding + radius)
        self.circleCenter = circleCenter
        
        var bezierPath = UIBezierPath()
        bezierPath.addArcWithCenter(circleCenter, radius: radius, startAngle: CGFloat(0), endAngle: CGFloat(2 * M_PI), clockwise: true)
        
        var circleLayer = CAShapeLayer()
        circleLayer.path = bezierPath.CGPath
        circleLayer.strokeColor = UIColor.blackColor().CGColor
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.lineWidth = 2
        
        self.layer.addSublayer(circleLayer)
        
        
        
        // now, let's add labels
        
        var i : Double = 0
        var angle = CGFloat(0)
        let monthNames = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
        for currentMonthName in monthNames {
            
            angle += 360/12
            // depending on the angle, we need to align the label position based on different stuff
            let radianAngle = angle * CGFloat(M_PI / 180.0)
            
            let edgePoint = self.calculateEdge(radianAngle)!
            
            
            // the actual text label
            var monthLabel = UILabel()
            monthLabel.text = currentMonthName
            monthLabel.font = UIFont.systemFontOfSize(12)
            monthLabel.textColor = UIColor.blackColor()
            monthLabel.sizeToFit()
            
            var labelFrame = monthLabel.frame
            
            
            // initially, we center the label at the edge point
            monthLabel.center = edgePoint
            
            // however, we actually want to create some spacing that is pleasing to the eye
            // that means that for the top and bottom labels, no horizontal repositioning is necessary
            // whereas for the left and right labels, no vertical repositioning is necessary
            // and for the labels in between, we need to use proper factors
            
            // the new label frame
            labelFrame = monthLabel.frame
            
            // the values below (-4 and 3.5) simply seem to work best, I got them by trial and error
            let verticalPaddingUnit = labelFrame.size.height * 0.25 // we use quarters for the offsets
            let verticalPaddingFactor = (-4) * cos(radianAngle)
            
            let horizontalPaddingUnit = labelFrame.size.width * 0.25
            let horizontalPaddingFactor = 3.5 * sin(radianAngle)
            
            labelFrame.origin.y += verticalPaddingUnit * verticalPaddingFactor
            labelFrame.origin.x += horizontalPaddingUnit * horizontalPaddingFactor
            
            monthLabel.frame = labelFrame
            
            self.addSubview(monthLabel)
            self.monthLabels.append(monthLabel)
            
            
            
            // the other thing that is also part of the label is the edge marker
            
            var bezierPath = UIBezierPath()
            bezierPath.moveToPoint(edgePoint)
            bezierPath.addLineToPoint(circleCenter)
            
            var markerLayer = CAShapeLayer()
            markerLayer.path = bezierPath.CGPath
            markerLayer.strokeColor = UIColor.grayColor().CGColor
            markerLayer.fillColor = UIColor.clearColor().CGColor
            markerLayer.lineWidth = 2
            markerLayer.strokeStart = 0.035
            markerLayer.strokeEnd = 0.12
            
            if((angle % 90) == 0){
                
                // markerLayer.strokeStart = 0.02
                // markerLayer.lineWidth = 5
                // markerLayer.strokeEnd = 0.13
                markerLayer.strokeColor = UIColor.blackColor().CGColor
                
                if((angle % 360) == 0){
                    // markerLayer.lineWidth = 8
                    // markerLayer.strokeEnd = 0.16
                    
                    // a darkish red
                    markerLayer.strokeColor = UIColor(red: 0.8, green: 0, blue: 0, alpha: 1).CGColor
                }
                
            }
            
            
            
            
            self.layer.addSublayer(markerLayer)
            
            
            
            
            
            // let's do some animating
            
            
            // CATransaction.begin()
            
            var fadeInAnimation = CABasicAnimation(keyPath: "opacity")
            fadeInAnimation.fromValue = 0
            fadeInAnimation.toValue = 1
            fadeInAnimation.duration = 1
            
            // this delta between animation beginnings seems to work well
            fadeInAnimation.beginTime = CACurrentMediaTime() + i * fadeInAnimation.duration / 20
            
            fadeInAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            monthLabel.layer.opacity = fadeInAnimation.fromValue as! Float
            
            
            
            /*
            CATransaction.begin()
            
            CATransaction.setCompletionBlock({ () -> Void in
                monthLabel.layer.opacity = fadeInAnimation.toValue as! Float
            })
            
            monthLabel.layer.addAnimation(fadeInAnimation, forKey: "opacity")
            CATransaction.commit()
            */
            
            
            var markerAnimation = CABasicAnimation(keyPath: "strokeEnd")
            markerAnimation.fromValue = 0.035
            markerAnimation.toValue = 0.12
            markerAnimation.duration = fadeInAnimation.duration
            markerAnimation.beginTime = fadeInAnimation.beginTime
            markerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            markerLayer.strokeEnd = 0.035

            
            
            CATransaction.begin()
            
            
            CATransaction.setCompletionBlock({ () -> Void in
                monthLabel.layer.opacity = fadeInAnimation.toValue as! Float
                markerLayer.strokeEnd = 0.12
                
                // the effect where the markers suddenly re-emerge was not originally, but it looked neat, so I left it
                
            })
            
            monthLabel.layer.addAnimation(fadeInAnimation, forKey: "opacityAnimationKey")
            markerLayer.addAnimation(markerAnimation, forKey: "strokeEndAnimationKey")
            
            CATransaction.commit()
            
            

            
            i++
            
        }
        
        
        
    }
    
    func setProgress(progress: CGFloat, firstDate: NSDate, secondDate: NSDate){
        
        var firstAngle = self.calculateAngleForDate(firstDate)
        var secondAngle = self.calculateAngleForDate(secondDate)
        
        // progress is a value between zero and 1
        var angleDelta = secondAngle - firstAngle
        var actualAngle = Double(firstAngle) + Double(progress) * Double(angleDelta)
        
        self.drawFingerAtAngle(actualAngle, animated: false)
        
        
    }
    
    func setDate(timestamp: NSTimeInterval?){
        
        if let date = timestamp{
            
            let dateObject = NSDate(timeIntervalSince1970: date)
            
            let angle = self.calculateAngleForDate(dateObject)
            self.drawFingerAtAngle(Double(angle), animated: true)
            
        }else{
            
        }
        
    }
    
    private func drawFingerAtAngle(angle: Double, animated: Bool){
        
        let radianAngle = CGFloat(angle) * CGFloat(M_PI / 180.0)
        
        if let edgePoint = self.calculateEdge(radianAngle){
            
            // we can draw this stuff
            var bezierPath = UIBezierPath()
            bezierPath.moveToPoint(self.circleCenter!)
            bezierPath.addLineToPoint(edgePoint)
            
            // remove the finger if it's there
            self.monthFingerLayer?.removeFromSuperlayer()
            
            self.monthFingerLayer = CAShapeLayer()
            self.monthFingerLayer?.path = bezierPath.CGPath
            self.monthFingerLayer?.strokeColor = UIColor.blackColor().CGColor
            self.monthFingerLayer?.fillColor = UIColor.clearColor().CGColor
            self.monthFingerLayer?.lineWidth = 2
            self.monthFingerLayer?.strokeStart = 0
            self.monthFingerLayer?.strokeEnd = 0.7
            
            // re-add the layer
            self.layer.addSublayer(self.monthFingerLayer!)
            
            if(animated){
                
                // just some experimentation
                var rotationAnimation = CABasicAnimation(keyPath: "strokeEnd")
                rotationAnimation.fromValue = self.monthFingerLayer!.strokeStart
                rotationAnimation.toValue = self.monthFingerLayer!.strokeEnd
                rotationAnimation.duration = 1
                rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                
                
                self.monthFingerLayer?.addAnimation(rotationAnimation, forKey: "transform.rotation")
                
            }
            
        }
        
    }
    
    private func calculateAngleForDate(date: NSDate) -> Int{
        
        let unitFlags : NSCalendarUnit = NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.YearCalendarUnit
        let components = NSCalendar.currentCalendar().components(unitFlags, fromDate: date)
        
        // we need to see the month of the date
        let month = components.month
        let year = components.year
        
        let angle = (year * 360) + (month * 30)
        
        return angle
        
    }
    
    private func calculateEdge(radianAngle: CGFloat) -> CGPoint? {
        
        if let radius = self.circleRadius{
        
            if let circleCenter = self.circleCenter{
            
                // the y coordinate at which the finger hits the circle perimeter
                let edgeY = circleCenter.y - (radius * cos(radianAngle))
                
                // the x coordinate at which the finger hits the circle perimeter
                let edgeX = circleCenter.x + (radius * sin(radianAngle))
                
                let edgePoint = CGPoint(x: edgeX, y: edgeY)
                return edgePoint
                
            }
            
        }
        
        return nil
        
    }

    
    /*
    override func drawRect(rect: CGRect) {
        
        super.drawRect(rect);
        
        let width = rect.width
        let height = rect.height
        
        // we first need to draw a circle
        // its diameter is determined by whichever is smaller, width or height
        let diameterLimit = min(width, height)
        
        // however, we want to leave some padding for the labels, say, 10 pixels from both sides
        let diameter = diameterLimit - 20
        
        
        
    }
    */
    

}
