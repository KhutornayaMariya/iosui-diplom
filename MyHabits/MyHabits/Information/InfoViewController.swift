//
//  InfoViewController.swift
//  MyHabits
//
//  Created by m.khutornaya on 19.07.2022.
//

import UIKit

class InfoViewController: UIViewController {

    private enum Constants {
        static let title = "Информация"
        static let safeArea: CGFloat = 16
    }

    private let info: HabitsInformation = HabitsInformation()

    private let scrollView: UIScrollView = {
        let view = UIScrollView()

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let contentView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let textTitle: UILabel = {
        let view = UILabel()

        view.font = .sfProSemibold(size: 20)
        view.textColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let desc: UILabel = {
        let view = UILabel()

        view.font = .sfProRegular(size: 17)
        view.textColor = .black
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    // MARK: Lifecycle

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        title = Constants.title
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [textTitle, desc].forEach { contentView.addSubview($0) }

        textTitle.text = info.title
        desc.text = info.description

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            textTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
            textTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.safeArea),
            textTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.safeArea),

            desc.topAnchor.constraint(equalTo: textTitle.bottomAnchor, constant: Constants.safeArea),
            desc.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.safeArea),
            desc.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.safeArea),
            desc.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.safeArea),
        ])
    }
}
