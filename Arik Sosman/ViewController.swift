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
    let watchView = WatchView(frame: CGRect.zeroRect)
    let scrollView = UIScrollView(frame: CGRect.zeroRect)
    
    let maxBlurViewOpacity : CGFloat = 0.8
    var blurView : UIVisualEffectView?
    var vibrancyView : UIVisualEffectView?
    
    private var statusBarHeight : CGFloat {

        get{
            return UIApplication.sharedApplication().statusBarFrame.size.height
        }
        
    }
    
    var topImageView : UIImageView?
    var bottomImageView: UIImageView?
    
    private let pageConfigurations = [
        [
            "title": "greeting",
            "text": "birth",
            "image": "Tel-Aviv",
            "date": "1995-01"
        ],
        [
            "title": "first_project",
            "text": "galaxy_battle",
            "image": "Galaxy-Battle",
            "date": "2010-02"
        ],
        [
            "title": "graduation",
            "text": "schiller_gymnasium",
            "image": "Hamlin",
            "date": "2012-07"
        ],
        [
            "title": "objective_c",
            "text": "first_app",
            "image": "Leipzig",
            "date": "2013-03"
        ],
        [
            "title": "wwdc_2013",
            "text": "first_dub_dub",
            "image": "San-Francisco",
            "date": "2013-06"
        ],
        [
            "title": "wwdc_2014",
            "text": "second_dub_dub",
            "image": "WWDC-2014",
            "date": "2014-06"
        ],
        [
            "title": "internship",
            "text": "keepy",
            "image": "Mountain-View",
            "date": "2015-03"
        ]
    ]

    
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        let vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
        
        self.blurView = UIVisualEffectView(effect: blurEffect)
        self.blurView?.frame = self.view.frame
        self.blurView?.userInteractionEnabled = false
        
        self.vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView?.frame = self.view.frame
        
        self.watchView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.watchView.vibrancyView = self.vibrancyView!
        self.watchView.initializeWatchView()
        self.watchView.userInteractionEnabled = false
        
        let watchFrame = self.watchView.getWatchFrame()
        
        
        self.scrollView.frame = self.view.frame
        self.scrollView.pagingEnabled = true

        var contentSize = self.view.frame.size
        contentSize.width = CGFloat(self.pageConfigurations.count) * contentSize.width
        self.scrollView.contentSize = contentSize
        self.scrollView.delegate = self
        self.scrollView.showsHorizontalScrollIndicator = false
        
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "didHoldScrollView:")
        self.scrollView.addGestureRecognizer(longPressRecognizer)
        
        
        
        
        
        
        // set the page control to the proper number of pages
        self.pageControl.numberOfPages = self.pageConfigurations.count
        
        
        
        
        self.bottomImageView = UIImageView(frame: self.view.frame)
        self.topImageView = UIImageView(frame: self.view.frame)
        
        self.topImageView?.contentMode = UIViewContentMode.ScaleAspectFill
        self.bottomImageView?.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.view.addSubview(self.bottomImageView!)
        self.view.addSubview(self.topImageView!)
        self.view.addSubview(self.blurView!)
        self.view.addSubview(self.vibrancyView!)
        
        
        
        self.vibrancyView?.contentView.addSubview(self.scrollView)
        // scrollView.addSubview(self.titleLabel!)
        self.vibrancyView?.contentView.addSubview(self.pageControl)
        // vibrancyView.contentView.addSubview(self.watchView)
        
        // self.view.addSubview(scrollView)
        self.view.addSubview(self.watchView) // the watch is above everything else
        
        
        
        
        
        
        
        // initialize the first interaction
        // scrollView.userInteractionEnabled = false
        // self.pageControl.hidden = true
        blurView?.alpha = self.maxBlurViewOpacity
        
        
        self.layoutConfiguration()
        
        
        
    }
    
    private func layoutConfiguration(){
        
        let watchFrame = self.watchView.getWatchFrame()
        
        for (i, configuration) in enumerate(self.pageConfigurations){
            
            var titleText = configuration["title"]!
            var bodyText = configuration["text"]!
            
            var localizedTitleText = NSLocalizedString(titleText, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
            var localizedBodyText = NSLocalizedString(bodyText, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
            
            let titleLabel = UILabel()
            var titleFrame = CGRect.zeroRect
            titleFrame.size.width = self.view.frame.size.width
            titleFrame.size.height = 50
            titleFrame.origin.x = CGFloat(i) * self.view.frame.size.width
            titleLabel.frame = titleFrame
            
            // we need to center the title vertically between the status bar and the watch
            var titleCenterX = titleLabel.center.x
            var titleCenterY = (watchFrame.origin.y - statusBarHeight) * 0.5 + self.statusBarHeight
            titleLabel.center = CGPoint(x: titleCenterX, y: titleCenterY)
            titleLabel.textAlignment = NSTextAlignment.Center
            titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            
            titleLabel.text = localizedTitleText
            
            
            
            
            let textLabel = UILabel()
            var textFrame = CGRect.zeroRect
            textFrame.origin.x = CGFloat(i) * self.view.frame.size.width
            textLabel.text = localizedBodyText
            textLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
            textLabel.numberOfLines = 0
            textLabel.textAlignment = NSTextAlignment.Center
            
            // we need a maximum permissible width (golden ratio)
            var maximumTextWidth = self.view.frame.size.width / 1.618
            textFrame.size = textLabel.sizeThatFits(CGSize(width: maximumTextWidth, height: CGFloat.max))
            
            textFrame.origin.x += (self.view.frame.size.width - textFrame.size.width) * 0.5
            textLabel.frame = textFrame
            
            var textCenterX = textLabel.center.x
            var textCenterY = (watchFrame.origin.y + watchFrame.size.height + self.pageControl.frame.origin.y) * 0.5
            textLabel.center = CGPoint(x: textCenterX, y: textCenterY)
            
            
            
            self.scrollView.addSubview(titleLabel)
            self.scrollView.addSubview(textLabel)
            
        }
        
        
        
        // now we get the first one, and set it
        // let's set the dates properly
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        
        let firstDate = dateFormatter.dateFromString(self.pageConfigurations[0]["date"]!)
        self.watchView.setDate(firstDate)
        
        let firstImage = UIImage(named: self.pageConfigurations[0]["image"]!)
        self.bottomImageView?.image = firstImage!
        self.topImageView?.alpha = 0
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func didHoldScrollView(gestureRecognizer: UILongPressGestureRecognizer){
        
        println("received press")
        
        if(gestureRecognizer.state == UIGestureRecognizerState.Began){
            
            // let's start the animation
            
            UIView.animateWithDuration(3, animations: { () -> Void in
                self.vibrancyView?.alpha = 0
                self.blurView?.alpha = 0
                self.watchView.alpha = 0
            })
            
        }else if(gestureRecognizer.state == UIGestureRecognizerState.Ended){
            
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(0.5)
            
            // let's abort it
            self.vibrancyView?.alpha = 1
            self.blurView?.alpha = self.maxBlurViewOpacity
            self.watchView.alpha = 1

            UIView.commitAnimations()
            
            /* UIView.animateWithDuration(0.5, animations: { () -> Void in
                
                // let's abort it
                self.vibrancyView?.alpha = 1
                self.blurView?.alpha = self.maxBlurViewOpacity
                self.watchView.alpha = 1
                
            }) */
            
        }
        
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        var width = scrollView.frame.size.width
        var offsetX = scrollView.contentOffset.x
        
        var position = offsetX / width
        var pageIndex = round(position)
        self.pageControl.currentPage = Int(pageIndex)
        
        
        
        
        // let's load stuff from the current configuration
        
        
        var firstIndex = Int(floor(position))
        firstIndex = max(0, firstIndex)
        firstIndex = min(firstIndex, self.pageConfigurations.count - 2)
        
        var firstConfiguration = self.pageConfigurations[firstIndex]
        var secondConfiguration = self.pageConfigurations[firstIndex + 1]
        
        
        
        // this thing needs to be initialized
        self.blurView?.alpha = self.maxBlurViewOpacity
        self.vibrancyView?.alpha = 1
        self.watchView.alpha = 1
        
        
        var progress = position - floor(position)
        if(position < 0){
            self.blurView?.alpha = self.maxBlurViewOpacity + position
            self.vibrancyView?.alpha = 1 + position / self.maxBlurViewOpacity // we accelerate the fading so that the arrival at 0 is simultaneous
            self.watchView.alpha = 1 + position / self.maxBlurViewOpacity
            progress = 0
        }
        
        // now, occasionally, if it's the last position, the progress will still be set to 0
        // this, however, is an instance where the progress needs to be set to one
        if(position >= CGFloat(self.pageConfigurations.count - 1)){
            self.blurView?.alpha = self.maxBlurViewOpacity - progress
            self.vibrancyView?.alpha = 1 - progress / self.maxBlurViewOpacity
            self.watchView.alpha = 1 - progress / self.maxBlurViewOpacity
            progress = 1
        }
        
        
        
        // let's set the images properly
        let firstImage = UIImage(named: firstConfiguration["image"]!)
        let secondImage = UIImage(named: secondConfiguration["image"]!)

        self.topImageView?.alpha = progress
        self.bottomImageView?.image = firstImage
        self.topImageView?.image = secondImage
        
        
        
        // let's set the dates properly
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        
        
        let firstDate = dateFormatter.dateFromString(firstConfiguration["date"]!)
        let secondDate = dateFormatter.dateFromString(secondConfiguration["date"]!)
        
        self.watchView.setProgress(progress, firstDate: firstDate!, secondDate: secondDate!)
        
        
        

        
        
        
    }
    

}

