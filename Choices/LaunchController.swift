//
//  LaunchController.swift
//  zFramework
//
//  Created by Computer on 15/3/2.
//  Copyright (c) 2015年 Computer. All rights reserved.
//

import UIKit

class LaunchController: UIViewController, UIScrollViewDelegate {
    
    var handler: LaunchHandler?

    @IBOutlet weak var imageCanvas: UIScrollView!
    @IBOutlet weak var imagePage: UIPageControl!
    @IBOutlet weak var Welcome: UIButton!
    @IBOutlet weak var WelcomeIndicator: UIActivityIndicatorView!
    
    var imageArray: [UIImage?] = []
    var imageArrayView: [UIImageView?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handler?.initData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var _check = NewUser()
        if !_check { // 用户非第一次登陆
            Welcome.hidden = false
            WelcomeIndicator.hidden = false
            imagePage.hidden = true
            self.handler?.launchCountdown()
        } else { // 用户是第一次登陆
            Welcome.hidden = true
            WelcomeIndicator.hidden = true
            prepareCalculateScrollView()
        }

    }

    func prepareCalculateScrollView() {
        let p1 = UIImage(named: "IMG_0195_6.png")
        
        imageArray.append(p1)
        imageArray.append(p1)
        imageArray.append(p1)
        imageArray.append(p1)
        
        imagePage.currentPage = 0
        imagePage.numberOfPages = imageArray.count
        
        imageCanvas.contentSize = CGSizeMake(zFWidth*CGFloat(imageArray.count), zFHeight)
        
        for var i = 0; i<imageArray.count; i++ {
            let tempView = UIImageView(image: imageArray[i])
            tempView.contentMode = UIViewContentMode.ScaleAspectFill
            
            tempView.frame = CGRectMake(zFWidth*CGFloat(i), 0.0, zFWidth, zFHeight)
            imageArrayView.append(tempView)
            imageCanvas.addSubview(tempView)
        }
    }
    
    func loadPageChange() {
        let page = Int(floor(imageCanvas.contentOffset.x * 2.0 + zFWidth) / (zFWidth * 2.0))
        imagePage.currentPage = page
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        loadPageChange()
    }

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if imagePage.currentPage == 3 {
            self.Welcome.hidden = false
        } else {
            self.Welcome.hidden = true
        }
    }
    
    @IBAction func UserClickFirstTime(sender: UIButton) {
        self.WelcomeIndicator.hidden = false
        self.WelcomeIndicator.startAnimating()
        // 跳转
        self.handler?.launchCountdown()
    }
    
    // MARK: - 检测使用是否是第一次登陆
    private func NewUser() -> Bool {
        var userDefault = NSUserDefaults.standardUserDefaults()
        if let checkNewUser = userDefault.objectForKey(lNewUser) as? String {
            return false
        } else {
            userDefault.setObject("1", forKey: lNewUser)
            userDefault.synchronize()
            return true
        }
    }
}
