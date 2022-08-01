//
//  HabitCollectionViewCell.swift
//  MyHabits
//
//  Created by m.khutornaya on 24.07.2022.
//

import UIKit

final class HabitCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "HabitCollectionViewCell"

    private enum Constants {
        static let safeArea: CGFloat = 20
    }
    
    private let title: UILabel = {
        let view = UILabel()
        
        view.font = .sfProSemibold(size: 17)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let subtitle: UILabel = {
        let view = UILabel()
        
        view.font = .sfProRegular(size: 12)
        view.textColor = .systemGray2
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let counter: UILabel = {
        let view = UILabel()
        
        view.font = .sfProRegular(size: 13)
        view.textColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    public let tracker: RadioButton = {
        let view = RadioButton()
        
        view.isSelected = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    public var onTapTrackerHander: (() -> Void)? {
        didSet {
            tracker.addTarget(self, action: #selector(tapWrapper), for: .touchUpInside)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tracker.isSelected = false
        tracker.backgroundColor = nil
    }
    
    public func configure(with viewModel: Habit) {
        title.textColor = viewModel.color
        title.text = viewModel.name
        subtitle.text = viewModel.dateString
        counter.text = "Счетчик: \(String(viewModel.trackDates.count))"
        tracker.setColor(viewModel.color)
        tracker.isSelected = viewModel.isAlreadyTakenToday
    }
    
    private func setup() {
        backgroundColor = .white
        let subviews = [title, subtitle, counter, tracker]
        subviews.forEach { addSubview($0) }
        layer.cornerRadius = 8
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 130),
            title.topAnchor.constraint(equalTo: topAnchor, constant: Constants.safeArea),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.safeArea),
            
            subtitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.safeArea),
            subtitle.bottomAnchor.constraint(equalTo: counter.topAnchor, constant: -30),
            
            counter.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.safeArea),
            counter.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.safeArea),
            
            tracker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            tracker.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @objc
    private func tapWrapper() {
        self.onTapTrackerHander?()
    }
}
