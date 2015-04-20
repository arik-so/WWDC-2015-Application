//
//  ViewController.swift
//  Arik Sosman
//
//  Created by Arik Sosman on 4/14/15.
//  Copyright (c) 2015 Arik Sosman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var currentValue = 0
    let watchView = WatchView(frame: CGRect.zeroRect)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.watchView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.watchView.initializeWatchView();
        self.view.addSubview(self.watchView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

