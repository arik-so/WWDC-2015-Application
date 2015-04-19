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

    @IBOutlet weak var currentValueLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

        // Configure interface objects here.
        if let notificationCenter = CFNotificationCenterGetDarwinNotifyCenter(){
            // CFNotificationCenterAddObserver(notificationCenter, nil, receivedNotificationFromPhone, "com.arik.wwdc.updateFromPhone", nil, CFNotificationSuspensionBehavior.DeliverImmediately);
        }

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
