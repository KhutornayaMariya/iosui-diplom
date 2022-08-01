//
//  TrackedDatesTabelViewCell.swift
//  MyHabits
//
//  Created by m.khutornaya on 26.07.2022.
//

import UIKit

final class TrackedDatesTabelViewCell: UITableViewCell {

    private enum Constants {
        static let today = "Сегодня"
        static let yesterday = "Вчера"

        static let safeArea: CGFloat = 16
    }

    private let title: UILabel = {
        let view = UILabel()

        view.font = .sfProRegular(size: 17)
        view.textColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let image: UIImageView = {
        let view = UIImageView()

        view.contentMode = .scaleAspectFit
        view.image = UIImage(systemName: "checkmark")
        view.tintColor = .purple
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(with viewModel: TrackedDateModel) {
        setupDateName(for: viewModel.date)
        image.isHidden = !viewModel.isHabitTracked
    }

    private func setup() {
        backgroundColor = .white
        let subviews = [title, image]
        subviews.forEach { addSubview($0) }

        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.safeArea),

            image.centerYAnchor.constraint(equalTo: centerYAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.safeArea),
        ])
    }
    
    private func setupDateName(for date: Date) {
        if Calendar.current.isDateInToday(date) {
            title.text = Constants.today
        } else if Calendar.current.isDateInYesterday(date) {
            title.text = Constants.yesterday
        } else {
            title.text = dateFormatter.string(from: date)
        }
    }

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }()
}
