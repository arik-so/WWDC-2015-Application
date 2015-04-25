//
//  InterfaceController.swift
//  Arik Sosman WatchKit Extension
//
//  Created by Arik Sosman on 4/14/15.
//  Copyright (c) 2015 Arik Sosman. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var dateLabel: WKInterfaceLabel!
    @IBOutlet weak var imageView: WKInterfaceImage!
    @IBOutlet weak var bodyLabel: WKInterfaceLabel!
    
    let wormhole = MMWormhole(applicationGroupIdentifier: "group.com.arik.wwdc.2015", optionalDirectory: "arik-wormhole")
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

        self.titleLabel.setText("Arik Sosman")
        self.dateLabel.setHidden(true)
        self.imageView.setHidden(true)
        self.bodyLabel.setText("Please open the app on your iPhone to browse through the slides.")
        
        self.wormhole.listenForMessageWithIdentifier("page-swipe", listener: { (message: AnyObject!) -> Void in
            
            self.dateLabel.setHidden(false)
            self.imageView.setHidden(false)
            
            var configuration = message as! [String: String]
            
            var titleText = configuration["title"]!
            var bodyText = configuration["text"]!
            
            var localizedTitleText = NSLocalizedString(titleText, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
            var localizedBodyText = NSLocalizedString(bodyText, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
            
            var imageName = configuration["image"]!
            
            self.titleLabel.setText(localizedTitleText)
            self.bodyLabel.setText(localizedBodyText)
            self.imageView.setImageNamed(imageName)

            
            // let's set the dates properly
            let dateParser = NSDateFormatter()
            dateParser.dateFormat = "yyyy-MM"
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy"
            
            let date = dateParser.dateFromString(configuration["date"]!)
            let dateString = dateFormatter.stringFromDate(date!)
            self.dateLabel.setText(dateString)
            
            // self.currentValueLabel.setText(localizedTitleText)
        })

    }

    func receivedNotificationFromPhone(){

    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
