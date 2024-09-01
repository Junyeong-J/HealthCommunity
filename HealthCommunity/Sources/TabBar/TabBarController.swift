//
//  TabBarController.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/22/24.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .myAppMain
        tabBar.unselectedItemTintColor = .gray
        
        enum TabBase: Int, CaseIterable {
            case main, myRoutine, chat, profile
            
            var title: String {
                switch self {
                case .main:
                    return "메인"
                case .myRoutine:
                    return "내 루틴"
                case .chat:
                    return "클래스"
                case .profile:
                    return "프로필"
                }
            }
            
            var image: UIImage? {
                switch self {
                case .main:
                    return UIImage(systemName: "house")
                case .myRoutine:
                    return UIImage(systemName: "figure.run")
                case .chat:
                    return UIImage(systemName: "figure.run")
                case .profile:
                    return UIImage(systemName: "person")
                }
            }
            
            var viewController: UIViewController {
                switch self {
                case .main:
                    return MainViewController()
                case .myRoutine:
                    return MyRoutineViewController()
                case .chat:
                    return HealthClassViewController()
                case .profile:
                    return ProfileViewController()
                }
            }
        }
        
        let vc = TabBase.allCases.map { tabView in
            let navItem = UINavigationController(rootViewController: tabView.viewController)
            navItem.tabBarItem = UITabBarItem(title: tabView.title, image: tabView.image, tag: tabView.rawValue)
            return navItem
        }
        
        setViewControllers(vc, animated: true)
    }
}
