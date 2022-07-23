//
//  HabitViewController.swift
//  MyHabbits
//
//  Created by m.khutornaya on 23.07.2022.
//

import UIKit

class HabitViewController: UIViewController {

    private var color: UIColor
    private var habitName: String?
    private var time: Date
    private var timeDescription: String?

    private let habitNameHeader: UILabel = {
        let view = UILabel()

        view.font = .sfProSemibold(size: 13)
        view.textColor = .black
        view.text = .habitNameTitle.uppercased()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let habitColorHeader: UILabel = {
        let view = UILabel()

        view.font = .sfProSemibold(size: 13)
        view.textColor = .black
        view.text = .habitColorTitle.uppercased()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let habitTimeHeader: UILabel = {
        let view = UILabel()

        view.font = .sfProSemibold(size: 13)
        view.textColor = .black
        view.text = .habitTimeTitle.uppercased()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let colorButton: UIButton = {
        let view = UIButton()

        view.layer.cornerRadius = .colorCircleSize/2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(didTapColor), for: .touchUpInside)

        return view
    }()

    private let habitNameInput: UITextField = {
        let view = UITextField()

        view.placeholder = .inputPlaceholder
        view.font = .sfProRegular(size: 17)
        view.textColor = .black
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let habitTimeDescription: UILabel = {
        let view = UILabel()

        view.font = .sfProRegular(size: 17)
        view.textColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let timePicker: UIDatePicker = {
        let view = UIDatePicker()

        view.datePickerMode = .time
        view.preferredDatePickerStyle = .wheels
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(changeTime), for: .valueChanged)

        return view
    }()

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter
    }()

    // MARK: - Life Cycle

    init(color: UIColor = .orange, habitName: String? = nil, time: Date = Date(), timeDescription: String? = nil) {
        self.color = color
        self.habitName = habitName
        self.time = time
        self.timeDescription = timeDescription

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    // MARK: - Private functions

    private func setup() {
        title = "Создать"
        setupHabitProperty()
        let subviews = [habitNameHeader, habitColorHeader, habitTimeHeader, colorButton, habitNameInput, timePicker, habitTimeDescription]
        subviews.forEach {view.addSubview($0) }

        NSLayoutConstraint.activate([
            habitNameHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 21),
            habitNameHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .safeArea),
            habitNameHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.safeArea),

            habitNameInput.topAnchor.constraint(equalTo: habitNameHeader.bottomAnchor, constant: 7),
            habitNameInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .safeArea),
            habitNameInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.safeArea),

            habitColorHeader.topAnchor.constraint(equalTo: habitNameInput.bottomAnchor, constant: 15),
            habitColorHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .safeArea),
            habitColorHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.safeArea),

            colorButton.topAnchor.constraint(equalTo: habitColorHeader.bottomAnchor, constant: 7),
            colorButton.heightAnchor.constraint(equalToConstant: .colorCircleSize),
            colorButton.widthAnchor.constraint(equalToConstant: .colorCircleSize),
            colorButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .safeArea),

            habitTimeHeader.topAnchor.constraint(equalTo: colorButton.bottomAnchor, constant: 15),
            habitTimeHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .safeArea),
            habitTimeHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.safeArea),

            habitTimeDescription.topAnchor.constraint(equalTo: habitTimeHeader.bottomAnchor, constant: 7),
            habitTimeDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .safeArea),
            habitTimeDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.safeArea),

            timePicker.topAnchor.constraint(equalTo: habitTimeDescription.bottomAnchor, constant: 15),
            timePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .safeArea),
            timePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.safeArea),
        ])
    }

    private func setupHabitProperty() {
        colorButton.backgroundColor = color
        setupTimeDescription()
        setupHabitName()
    }

    private func setupTimeDescription() {
        if let timeDescription = timeDescription {
            self.timeDescription = timeDescription
        } else {
            self.timeDescription = "Каждый день в " + dateFormatter.string(from: time)
        }
        let attributedString = NSMutableAttributedString(string: timeDescription!)
        let range = attributedString.getRangeOfString(textToFind: dateFormatter.string(from: time))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.purple, range: range)

        habitTimeDescription.attributedText = attributedString
    }

    private func setupHabitName() {
        guard let habitName = habitName, !habitName.isEmpty else {
            return
        }
        let attributes = [NSAttributedString.Key.font: UIFont.sfProSemibold(size: 17)]
        let attributedString = NSAttributedString(string: habitName, attributes: attributes)
        habitNameInput.attributedText = attributedString
    }

    private func setupNavigationBar() {
        let navBar: UINavigationBar? = navigationController?.navigationBar
        navBar?.isHidden = false
        navBar?.backgroundColor = .white

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: .createNavBarButton,
            style: .plain,
            target: self,
            action: #selector(didTapSaveButton))
        navigationItem.rightBarButtonItem?.tintColor = .purple

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: .cancelNavBarButton,
            style: .plain,
            target: self,
            action: #selector(didTapCancelButton))
        navigationItem.leftBarButtonItem?.tintColor = .purple
    }

    // MARK: - Actions

    @objc private func didTapSaveButton() {
        guard let habitName = habitNameInput.text, !habitName.isEmpty else {
            return
        }
        let newHabit = Habit(name: habitName,
                             date: timePicker.date,
                             color: color)
        let store = HabitsStore.shared
        store.habits.append(newHabit)
        dismiss(animated: true, completion: nil)
    }

    @objc private func didTapCancelButton() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func didTapColor() {
        let picker = UIColorPickerViewController()
        picker.selectedColor = color
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    @objc private func changeTime() {
        let date = timePicker.date

        let attributedString = NSMutableAttributedString(string: "Каждый день в " + dateFormatter.string(from: date))
        let range = attributedString.getRangeOfString(textToFind: dateFormatter.string(from: date))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.purple, range: range)
        habitTimeDescription.attributedText = attributedString
    }
}

// MARK: - Extensions

extension HabitViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        color = viewController.selectedColor
        self.colorButton.backgroundColor = color
    }
}

extension NSMutableAttributedString {
    func getRangeOfString(textToFind:String) -> NSRange{
        return self.mutableString.range(of: textToFind)
    }
}

private extension String {
    static let cancelNavBarButton = "Отменить"
    static let createNavBarButton = "Сохранить"
    static let habitNameTitle = "название"
    static let habitColorTitle = "цвет"
    static let habitTimeTitle = "время"
    static let inputPlaceholder = "Бегать по утрам, спать 8 часов и т.п."
}

private extension CGFloat {
    static let colorCircleSize: CGFloat = 30
    static let safeArea: CGFloat = 16
}
