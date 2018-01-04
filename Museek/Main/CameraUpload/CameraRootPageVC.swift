//
//  CameraRootPageVCViewController.swift
//  Museek
//
//  Created by Mauricio Monsivais on 12/18/17.
//  Copyright © 2017 Museek. All rights reserved.
//

import UIKit

//extension UIPageViewController {
//    func goToPreviousPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
//        if let currentViewController = viewControllers?[0] {
//            if let prevPage = dataSource?.pageViewController(self, viewControllerBefore: currentViewController) {
//                setViewControllers([prevPage], direction: .reverse, animated: animated, completion: completion)
//            }
//        }
//
//    }
//}

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
        NotificationCenter.default.addObserver(self, selector: #selector(enableSwipe), name: Notification.Name(rawValue: "enableSwipe"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disableSwipe), name: Notification.Name(rawValue: "disableSwipe"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(turnToPreviousPage(notification:)), name: Notification.Name(rawValue: "turnToPreviousPage"), object: nil)
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
    
    @objc fileprivate func disableSwipe(){
        self.dataSource = nil
    }
    
    @objc fileprivate func enableSwipe(){
        self.dataSource = self
    }
    
    //@TODO attempt to re show imagepicker
    @objc fileprivate func turnToPreviousPage(notification: Notification){
        goToPreviousPage()
    }
    
    fileprivate func goToPreviousPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        if let currentViewController = viewControllers?[0] {
            if let prevPage = dataSource?.pageViewController(self, viewControllerBefore: currentViewController) {
                setViewControllers([prevPage], direction: .reverse, animated: animated, completion: completion)
            }
        }
    }
}
