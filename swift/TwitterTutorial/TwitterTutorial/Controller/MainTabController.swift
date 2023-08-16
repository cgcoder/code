//
//  MainTabController.swift
//  TwitterTutorial
//
//  Created by Chandrasekaran, Gopinath on 8/7/23.
//

import UIKit

class MainTabController: UITabBarController {

    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .blue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(MainTabController.self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    func configureUI() {        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56/2
    }
    // MARK: - Selectors
    @objc func actionButtonTapped() {
        print(123)
    }

    // MARK: - Helpers
    func configureViewControllers() {
        let feed = FeedController()
        let nav1 = templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: feed)
        
        let explore = ExploreController()
        let nav2 = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: explore)
        
        let notifications = NotificationsController()
        let nav3 = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: notifications)
        
        let conversations = ConversationsController()
        let nav4 = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: conversations)
        viewControllers = [nav1, nav2, nav3, nav4]
    }

    func templateNavigationController(image: UIImage!, rootViewController: UIViewController) -> UINavigationController {
        let nav1 = UINavigationController(rootViewController: rootViewController)
        
        nav1.tabBarItem.image = image
        nav1.tabBarItem.selectedImage = image
        nav1.navigationBar.barTintColor = .white
        return nav1
    }
}
