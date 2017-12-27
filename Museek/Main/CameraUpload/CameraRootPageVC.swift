//
//  CameraRootPageVCViewController.swift
//  Museek
//
//  Created by Mauricio Monsivais on 12/18/17.
//  Copyright © 2017 Museek. All rights reserved.
//

import UIKit

extension UIPageViewController {
    var isPagingEnabled: Bool {
        get {
            var isEnabled: Bool = true
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    isEnabled = subView.isScrollEnabled
                }
            }
            return isEnabled
        }
        set {
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    subView.isScrollEnabled = newValue
                }
            }
        }
    }
}

class CameraRootPageVC: UIPageViewController, UIPageViewControllerDataSource {
    //list of view controllers in page view controller
    private lazy var viewControllerList: [UIViewController] = {
        let sb = UIStoryboard(name: "Camera", bundle: nil)
        let cameraVC = sb.instantiateViewController(withIdentifier: "CameraVC")
        let mediaGalleryVC = sb.instantiateViewController(withIdentifier: "MediaGalleryVC")
        
        return [cameraVC, mediaGalleryVC]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        if let firstVC = viewControllerList.first {
            self.setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(enableSwipe(notification:)), name:NSNotification.Name(rawValue: "enableSwipe"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disableSwipe(notification:)), name:NSNotification.Name(rawValue: "disableSwipe"), object: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.index(of: viewController) else { return nil }
        let prevIndex = vcIndex - 1
        guard prevIndex >= 0 else { return nil }
        guard viewControllerList.count > prevIndex else { return nil }
        return viewControllerList[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.index(of: viewController) else { return nil }
        let nextIndex = vcIndex + 1
        guard nextIndex < viewControllerList.count else { return nil }
        return viewControllerList[nextIndex]
    }
    
    @objc fileprivate func disableSwipe(notification: Notification){
        self.dataSource = nil
    }
    
    @objc fileprivate func enableSwipe(notification: Notification){
        self.dataSource = self
    }
}
