//
//  TabBarController.swift
//  MyHabits
//
//  Created by m.khutornaya on 19.07.2022.
//

import UIKit

class TabBarController: UITabBarController {

    init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
