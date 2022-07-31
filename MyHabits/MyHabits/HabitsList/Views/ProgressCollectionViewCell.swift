//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by m.khutornaya on 24.07.2022.
//

import UIKit

final class ProgressCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ProgressCollectionViewCell"

    private let title: UILabel = {
        let view = UILabel()

        view.font = .sfProSemibold(size: 13)
        view.text = .title
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

    private let progressBar: UIProgressView = {
        let view = UIProgressView()

        view.progressViewStyle = .bar
        view.trackTintColor = .lightGray
        view.tintColor = .purple
        view.layer.cornerRadius = .barHeight/2
        view.clipsToBounds = true
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

    public func configure(with progress: Float) {
        self.progress.text = String(Int(progress * 100)) + "%"
        progressBar.setProgress(progress, animated: true)
    }

    private func setup() {
        backgroundColor = .white
        let subviews = [title, progress, progressBar]
        subviews.forEach { addSubview($0) }
        layer.cornerRadius = 8

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 60),
            title.topAnchor.constraint(equalTo: topAnchor, constant: .topAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .safeArea),

            progress.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.safeArea),
            progress.topAnchor.constraint(equalTo: topAnchor, constant: .topAnchor),

            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .safeArea),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.safeArea),
            progressBar.topAnchor.constraint(equalTo: progress.bottomAnchor, constant: .topAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: .barHeight)
        ])
    }
}

private extension String {
    static let title = "Все получится!"
}

private extension CGFloat {
    static let safeArea: CGFloat = 12
    static let topAnchor: CGFloat = 10
    static let barHeight: CGFloat = 7
}
