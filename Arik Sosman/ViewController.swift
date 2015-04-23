//
//  ViewController.swift
//  Arik Sosman
//
//  Created by Arik Sosman on 4/14/15.
//  Copyright (c) 2015 Arik Sosman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    var currentValue = 0
    var pageCount = 5
    let watchView = WatchView(frame: CGRect.zeroRect)
    var timestamps : [NSDate]?
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.watchView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.watchView.initializeWatchView();
        self.view.addSubview(self.watchView)
        
        var currentDate = NSDate()
        self.watchView.setDate(currentDate.timeIntervalSince1970)
        
        var scrollView = UIScrollView(frame: self.view.frame)
        scrollView.pagingEnabled = true

        var contentSize = self.view.frame.size
        contentSize.width = CGFloat(self.pageCount) * contentSize.width
        scrollView.contentSize = contentSize
        scrollView.delegate = self
        
        self.view.addSubview(scrollView)
        
        // set the page control to the proper number of pages
        self.pageControl.numberOfPages = pageCount
        
        var firstDate = NSDate(timeIntervalSinceNow: 0)
        var secondDate = NSDate(timeIntervalSinceNow: 3600 * 24 * 1000)
        var thirdDate = NSDate(timeIntervalSinceNow: 3600 * 24 * 1050)
        self.timestamps = [firstDate, secondDate, thirdDate]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        var width = scrollView.frame.size.width
        var offsetX = scrollView.contentOffset.x
        
        var position = offsetX / width
        var pageIndex = round(position)
        self.pageControl.currentPage = Int(pageIndex)
        
        // now, we need to take the dates that are there and make 
        if let timestamps = self.timestamps{
            var firstDateIndex = Int(floor(position))
            firstDateIndex = max(0, firstDateIndex) // it must not be smaller than zero
            firstDateIndex = min(firstDateIndex, timestamps.count - 2) // it must not be bigger than the second to last element's index
            
            var secondDateIndex = firstDateIndex + 1
            
            var firstDate = timestamps[firstDateIndex]
            var secondDate = timestamps[secondDateIndex]
            
            var progress = position - floor(position) // this is the progress between two pages
            
            if(position <= 0){
                progress = 0
            }
            
            // now, occasionally, if it's the last position, the progress will still be set to 0
            // this, however, is an instance where the progress needs to be set to one
            if(position >= CGFloat(timestamps.count - 1)){
                progress = 1
            }
            
            self.watchView.setProgress(progress, firstDate: firstDate, secondDate: secondDate)
            
            println("Current position: \(position), progress: \(progress)")
            
            
        }
        

        
        
        
    }
    

}

