//
// Created by Arik Sosman on 4/19/15.
// Copyright (c) 2015 Arik Sosman. All rights reserved.
//

import Foundation
import UIKit

// this class is responsible for drawing the watch that represents the year and month
class WatchView : UIView {

    private let outerCircleView = UIView()
    
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
        
        // horizontally, we want it centered
        let leftPadding = (width - diameter) * 0.5

        /*
        // but vertically, we want the ratio between the bottom and the top distances be golden
        let verticalSpace = height - diameter
        
        // we know that bottomPadding / topPadding = 1.618
        // and we know that bottomPadding + topPadding = verticalSpace
        // therefore verticalSpace = topPadding + 1.618 * topPadding = (1 + 1.618) * topPadding
        // conversely, topPadding = verticalSpace / (1 + 1.618)
        let topPadding = verticalSpace / (1 + 1.618)
        */
        
        // on second thought, we want the center of the circle to be at the golden ratio
        let centerTopOffset = height / (1 + 1.618)
        let topPadding = centerTopOffset - (diameter * 0.5) + statusBarHeight // we need to re-add the status bar height to the top offset
        // let topPadding = CGFloat(0)

        let circleCenter = CGPoint(x: leftPadding + radius, y: topPadding + radius)
        
        var bezierPath = UIBezierPath()
        bezierPath.addArcWithCenter(circleCenter, radius: radius, startAngle: CGFloat(0), endAngle: CGFloat(2 * M_PI), clockwise: true)
        
        var circleLayer = CAShapeLayer()
        circleLayer.path = bezierPath.CGPath
        circleLayer.strokeColor = UIColor.blackColor().CGColor
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.lineWidth = 2
        
        self.layer.addSublayer(circleLayer)
        
        var angle = CGFloat(0)
        let monthNames = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
        for currentMonthName in monthNames {
            
            angle += 360/12
            // depending on the angle, we need to align the label position based on different stuff
            let radianAngle = angle * CGFloat(M_PI / 180.0)
            
            var monthLabel = UILabel()
            monthLabel.text = currentMonthName
            monthLabel.font = UIFont.systemFontOfSize(12)
            monthLabel.textColor = UIColor.blackColor()
            monthLabel.sizeToFit()
            
            var labelFrame = monthLabel.frame
            // let labelDiagonal = sqrt(pow(labelFrame.size.width, 2) + pow(labelFrame.size.height, 2))
            
            // this is some additional padding in order to make the label positions look good
            // if the current angle is vertical, we need to extend the distance by the height of the label
            // if the angle is horizontal, we need to extend the distance by the width of the label
            // for the stuff in between, we need appropriate factors
            var extensionPadding = sqrt(pow(labelFrame.width * sin(radianAngle), 2) + pow(labelFrame.height * cos(radianAngle), 2))
            var extendedRadius = radius // + 0.65 * extensionPadding
            
            
            
            // the y coordinate at which the finger hits 
            let edgeY = circleCenter.y - (extendedRadius * cos(radianAngle))
            
            // the x coordinate at which the finger hits
            let edgeX = circleCenter.x + (extendedRadius * sin(radianAngle))
            
            
            // labelFrame.origin.y = edgeY
            // labelFrame.origin.x = edgeX
            monthLabel.center = CGPoint(x: edgeX, y: edgeY)
            
            // the new label frame
            labelFrame = monthLabel.frame
            let verticalPaddingUnit = labelFrame.size.height * 0.25 // we use quarters for the offsets
            let verticalPaddingFactor = (-4) * cos(radianAngle)
            
            let horizontalPaddingUnit = labelFrame.size.width * 0.25
            let horizontalPaddingFactor = 3.5 * sin(radianAngle)
            
            labelFrame.origin.y += verticalPaddingUnit * verticalPaddingFactor
            labelFrame.origin.x += horizontalPaddingUnit * horizontalPaddingFactor
            
            monthLabel.frame = labelFrame
            
            self.addSubview(monthLabel)
            // break
            
        }
        
        // now, let's add labels
        // we are not gonna add all labels, but only the ones which are skewed
        // these are JAN, FEB, –, APR, MAY, –, JUL, AUG, –, OCT, NOV, –
        
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
