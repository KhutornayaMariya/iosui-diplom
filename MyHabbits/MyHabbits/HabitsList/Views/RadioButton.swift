//
//  RadioButton.swift
//  MyHabbits
//
//  Created by m.khutornaya on 24.07.2022.
//

import UIKit

final public class RadioButton: UIControl {

    private var color: UIColor!

    override public var isSelected: Bool {
        didSet {
            guard isSelected != oldValue else { return }
            updateAppearance()
        }
    }

    override public var isHighlighted: Bool {
        didSet {
            guard isHighlighted != oldValue else { return }
            updateAppearance()
        }
    }

    private lazy var checkMarkImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .white
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    // MARK: - Subviews setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        layer.cornerRadius = .size / 2
        addSubview(checkMarkImageView)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: .size),
            widthAnchor.constraint(equalToConstant: .size),

            checkMarkImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            checkMarkImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    // MARK: - Setter

    public func setColor(_ color: UIColor) {
        self.color = color
        updateAppearance()
    }

    private func updateAppearance() {
        updateBorder()
        updateImage()
    }

    private func updateBorder() {
        if state == .highlighted || state == .selected {
            layer.borderWidth = .zero
            backgroundColor = color
        } else {
            layer.borderWidth = .borderWidth
            layer.borderColor = color.cgColor
        }
    }

    private func updateImage() {
        guard state == .selected || state == .highlighted else { return }
        checkMarkImageView.isHidden = false
    }
}

private extension CGFloat {
    static let borderWidth: CGFloat = 2
    static let size: CGFloat = 36
}
