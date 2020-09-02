//
//  MainScreenViewController.swift
//  SpendWithBrain
//
//  Created by Maxim on 21/08/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit
import SideMenu

class MainScreenViewController: UIViewController {
    private var menu : UISideMenuNavigationController?
    let transition = SlideInTransition()
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "TabBarMain")
        vc.view.bounds = view.bounds
        self.addChild(vc)
        view.addSubview(vc.view)
        NotificationCenter.default.addObserver(self, selector: #selector(changeTitle(_:)), name: Notification.Name(rawValue: "navbartitle"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openSideMenu(_:)), name: Notification.Name(rawValue: "openSideMenu"), object: nil)
    }
    
    @objc func openSideMenu(_ notification: Notification) {
        guard let menu = storyboard?.instantiateViewController(withIdentifier: "customMenu") else { return }
        menu.modalPresentationStyle = .overCurrentContext
        menu.transitioningDelegate = self
        present(menu, animated: true, completion: nil)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func changeTitle(_ notification: Notification){
        if let someTitle = notification.userInfo?["title"] as? String{
            self.tabBarController?.navigationItem.title = someTitle
        }
    }

}
extension MainScreenViewController : UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}
