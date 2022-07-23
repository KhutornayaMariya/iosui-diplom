//
//  HabitsViewController.swift
//  MyHabbits
//
//  Created by m.khutornaya on 19.07.2022.
//

import UIKit

class HabitsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    private func setup() {
        view.backgroundColor = .blue
    }

    private func setupNavigationBar() {
        let navBar: UINavigationBar? = navigationController?.navigationBar
        navBar?.isHidden = false
        navBar?.backgroundColor = .white
        navBar?.shadowImage = UIImage()

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(didTapAddButton)
        )
        navigationItem.rightBarButtonItem?.tintColor = .purple
    }

    @objc private func didTapAddButton() {
        let habitVC = HabitViewController()
        let navigation = UINavigationController(rootViewController: habitVC)
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true, completion: nil)
    }
}
