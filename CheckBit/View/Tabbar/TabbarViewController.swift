//
//  TabbarViewController.swift
//  CheckBit
//
//  Created by 이상민 on 3/7/25.
//

import UIKit

final class TabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    private func configureView() {
        let firstVC = UINavigationController(rootViewController: TransactionViewController())
        firstVC.tabBarItem = UITabBarItem(
            title: "거래소",
            image: UIImage(systemName: "chart.line.uptrend.xyaxis"),
            tag: 0
        )
        
        
        let secondVC = UINavigationController(rootViewController: CoinInformationViewController())
        secondVC.tabBarItem = UITabBarItem(
            title: "코인정보",
            image: UIImage(systemName: "chart.bar.fill"),
            tag: 1
        )
        
        let thirdVC = PortfolioViewController()
        thirdVC.tabBarItem = UITabBarItem(
            title: "포트폴리오",
            image: UIImage(systemName: "star"),
            selectedImage: UIImage(systemName: "star.fill")
        )
        thirdVC.tabBarItem.tag = 2
        
        
        self.tabBar.tintColor = UIColor(resource: .main)
        self.tabBar.backgroundColor = .white
        self.tabBar.unselectedItemTintColor = UIColor(resource: .secondary)
        self.viewControllers = [firstVC, secondVC, thirdVC]
    }
}
