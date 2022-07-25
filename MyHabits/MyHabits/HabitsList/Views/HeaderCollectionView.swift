//
//  HeaderCollectionView.swift
//  MyHabits
//
//  Created by m.khutornaya on 24.07.2022.
//

import UIKit

final class HeaderCollectionView: UIView {


    private let title: UILabel = {
        let view = UILabel()

        view.font = .sfProSemibold(size: 34)
        view.text = "Сегодня"
        view.textColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .white
        addSubview(title)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 50),
            title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
        ])
    }
}
