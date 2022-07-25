//
//  ProgressCollectionViewCell.swift
//  MyHabbits
//
//  Created by m.khutornaya on 24.07.2022.
//

import UIKit

final class ProgressCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ProgressCollectionViewCell"

    private var filledProgressBarConstraint: NSLayoutConstraint!

    private let title: UILabel = {
        let view = UILabel()

        view.font = .sfProSemibold(size: 13)
        view.text = "Все получится!"
        view.textColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let progress: UILabel = {
        let view = UILabel()

        view.font = .sfProRegular(size: 13)
        view.textColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let defaultProgressBar: UIView = {
        let view = UIView()

        view.backgroundColor = .lightGray
        view.layer.cornerRadius = .barHeight/2
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let filledProgressBar: UIView = {
        let view = UIView()

        view.backgroundColor = .purple
        view.layer.cornerRadius = .barHeight/2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(with progress: Float) {
        self.progress.text = String(Int(progress * 100)) + "%"
        updateProgressBarConstraint(progress)
    }

    private func updateProgressBarConstraint(_ progress: Float) {
        guard progress != 0 else { return }
        let defaultSize = UIScreen.main.bounds.size.width - 4 * .safeArea
        filledProgressBarConstraint.constant = -defaultSize * (1.0 - CGFloat(progress))
        filledProgressBar.isHidden = false
    }

    private func setup() {
        backgroundColor = .white
        let subviews = [title, progress, defaultProgressBar, filledProgressBar]
        subviews.forEach { addSubview($0) }
        layer.cornerRadius = 8

        filledProgressBarConstraint = filledProgressBar.widthAnchor.constraint(equalTo: defaultProgressBar.widthAnchor)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 60),
            title.topAnchor.constraint(equalTo: topAnchor, constant: .topAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .safeArea),

            progress.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.safeArea),
            progress.topAnchor.constraint(equalTo: topAnchor, constant: .topAnchor),

            defaultProgressBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .safeArea),
            defaultProgressBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.safeArea),
            defaultProgressBar.topAnchor.constraint(equalTo: progress.bottomAnchor, constant: .topAnchor),
            defaultProgressBar.heightAnchor.constraint(equalToConstant: .barHeight),

            filledProgressBar.leadingAnchor.constraint(equalTo: defaultProgressBar.leadingAnchor),
            filledProgressBar.heightAnchor.constraint(equalTo: defaultProgressBar.heightAnchor),
            filledProgressBar.topAnchor.constraint(equalTo: defaultProgressBar.topAnchor),
            filledProgressBarConstraint
        ])
    }
}

private extension CGFloat {
    static let safeArea: CGFloat = 12
    static let topAnchor: CGFloat = 10
    static let barHeight: CGFloat = 7
}
