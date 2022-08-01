//
//  HabitViewController.swift
//  MyHabits
//
//  Created by m.khutornaya on 23.07.2022.
//

import UIKit

class HabitViewController: UIViewController {

    private enum Text {
        static let title = "Создать"
        static let cancelNavBarButton = "Отменить"
        static let createNavBarButton = "Сохранить"
        static let nameHeader = "название"
        static let colorHeader = "цвет"
        static let timeHeader = "время"
        static let placeholder = "Бегать по утрам, спать 8 часов и т.п."
        static let timeDescription = "Каждый день в "

        static let alertTitle: String = "Удалить привычку"
        static let alertMessage: String = "Вы хотите удалить привычку "
        static let alertPositiveText: String = "Отмена"
        static let alertNegativeText: String = "Удалить"
    }

    private enum Constraints {
        static let colorCircleSize: CGFloat = 30
        static let safeArea: CGFloat = 16
        static let topHeaderAnchor: CGFloat = 15
        static let topPropertyAnchor: CGFloat = 7
    }

    private let viewModel: Habit?
    private var selectedColor: UIColor

    private let nameHeader: UILabel = {
        let view = UILabel()

        view.font = .sfProSemibold(size: 13)
        view.textColor = .black
        view.text = Text.nameHeader.uppercased()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let colorHeader: UILabel = {
        let view = UILabel()

        view.font = .sfProSemibold(size: 13)
        view.textColor = .black
        view.text = Text.colorHeader.uppercased()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let timeHeader: UILabel = {
        let view = UILabel()

        view.font = .sfProSemibold(size: 13)
        view.textColor = .black
        view.text = Text.timeHeader.uppercased()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var colorButton: UIButton = {
        let view = UIButton()

        view.layer.cornerRadius = Constraints.colorCircleSize/2
        view.backgroundColor = selectedColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(didTapColor), for: .touchUpInside)

        return view
    }()

    private lazy var habitNameInput: UITextField = {
        let view = UITextField()

        view.placeholder = Text.placeholder
        view.font = .sfProRegular(size: 17)
        view.textColor = .black
        view.textAlignment = .left
        view.delegate = self
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

    private lazy var timePicker: UIDatePicker = {
        let view = UIDatePicker()

        view.datePickerMode = .time
        view.preferredDatePickerStyle = .wheels
        view.setDate(Date(), animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(changeTime), for: .valueChanged)

        return view
    }()

    private lazy var deleteButton: UIButton = {
        let view = UIButton()

        view.isHidden = true
        view.setTitle(Text.alertTitle, for: .normal)
        view.setTitleColor(.red, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)

        return view
    }()

    private lazy var alert: UIAlertController = {
        guard let viewModel = viewModel else { return UIAlertController() }

        let message = "\(Text.alertMessage) \"\(viewModel.name)\"?"
        let alert = UIAlertController(title: Text.alertTitle, message: message, preferredStyle: .alert)
        let positive = UIAlertAction(title: Text.alertPositiveText, style: .cancel)
        let negative = UIAlertAction(title: Text.alertNegativeText, style: .destructive) {
            UIAlertAction in
            self.deleteHabitIfNeeded(viewModel)
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(positive)
        alert.addAction(negative)

        return alert
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

    init(viewModel: Habit?) {
        self.viewModel = viewModel
        self.selectedColor = viewModel?.color ?? .purple
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
        tabBarController?.tabBar.isHidden = true
        setupNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Private functions

    private func setup() {
        title = Text.title
        setupHabitProperty()
        let subviews = [nameHeader, colorHeader, timeHeader,
                        colorButton, habitNameInput, timePicker, habitTimeDescription, deleteButton]
        subviews.forEach {view.addSubview($0) }

        NSLayoutConstraint.activate([
            nameHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 21),
            nameHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constraints.safeArea),
            nameHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constraints.safeArea),

            habitNameInput.topAnchor.constraint(equalTo: nameHeader.bottomAnchor, constant: Constraints.topPropertyAnchor),
            habitNameInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constraints.safeArea),
            habitNameInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constraints.safeArea),

            colorHeader.topAnchor.constraint(equalTo: habitNameInput.bottomAnchor, constant: Constraints.topHeaderAnchor),
            colorHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constraints.safeArea),
            colorHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constraints.safeArea),

            colorButton.topAnchor.constraint(equalTo: colorHeader.bottomAnchor, constant: Constraints.topPropertyAnchor),
            colorButton.heightAnchor.constraint(equalToConstant: Constraints.colorCircleSize),
            colorButton.widthAnchor.constraint(equalToConstant: Constraints.colorCircleSize),
            colorButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constraints.safeArea),

            timeHeader.topAnchor.constraint(equalTo: colorButton.bottomAnchor, constant: Constraints.topHeaderAnchor),
            timeHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constraints.safeArea),
            timeHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constraints.safeArea),

            habitTimeDescription.topAnchor.constraint(equalTo: timeHeader.bottomAnchor, constant: Constraints.topPropertyAnchor),
            habitTimeDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constraints.safeArea),
            habitTimeDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constraints.safeArea),

            timePicker.topAnchor.constraint(equalTo: habitTimeDescription.bottomAnchor, constant: Constraints.topHeaderAnchor),
            timePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constraints.safeArea),
            timePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constraints.safeArea),

            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constraints.safeArea)
        ])
    }

    private func setupHabitProperty() {
        deleteButton.isHidden = viewModel == nil ? true : false
        colorButton.backgroundColor = selectedColor
        setupTimePicker()
        setupTimeDescription()
        setupHabitName()
    }

    private func setupTimePicker() {
        guard let viewModel = viewModel else { return }
        timePicker.setDate(viewModel.date, animated: true)
    }

    private func setupTimeDescription() {
        let date = timePicker.date
        let attributedString = NSMutableAttributedString(string: Text.timeDescription + dateFormatter.string(from: date))
        let range = attributedString.getRangeOfString(textToFind: dateFormatter.string(from: date))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.purple, range: range)
        habitTimeDescription.attributedText = attributedString
    }

    private func setupHabitName() {
        guard let viewModel = viewModel else { return }
        let attributes = [NSAttributedString.Key.font: UIFont.sfProSemibold(size: 17)]
        let attributedString = NSAttributedString(string: viewModel.name, attributes: attributes)
        habitNameInput.attributedText = attributedString
    }

    private func setupNavigationBar() {
        let navBar: UINavigationBar? = navigationController?.navigationBar
        navBar?.isHidden = false
        navBar?.backgroundColor = .white
        navBar?.tintColor = .purple

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: Text.createNavBarButton,
            style: .plain,
            target: self,
            action: #selector(didTapSaveButton))

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: Text.cancelNavBarButton,
            style: .plain,
            target: self,
            action: #selector(didTapCancelButton))
    }

    private func deleteHabitIfNeeded(_ viewModel: Habit) {
        if let habit = HabitsStore.shared.habits.firstIndex(where: {$0.name == viewModel.name}) {
            HabitsStore.shared.habits.remove(at: habit)
        }
    }

    // MARK: - Actions

    @objc private func didTapSaveButton() {
        guard let habitName = habitNameInput.text, !habitName.isEmpty else {
            return
        }
        guard let viewModel = viewModel,
              let index = HabitsStore.shared.habits.firstIndex(where: {$0.name == viewModel.name}) else {
            let newHabit = Habit(name: habitName,
                                 date: timePicker.date,
                                 color: selectedColor)
            let store = HabitsStore.shared
            store.habits.append(newHabit)

            dismiss(animated: true, completion: nil)
            return
        }

        viewModel.name = habitName
        viewModel.date = timePicker.date
        viewModel.color = selectedColor
        HabitsStore.shared.habits.remove(at: index)
        HabitsStore.shared.habits.insert(viewModel, at: index)

        navigationController?.popToRootViewController(animated: true)
    }

    @objc private func didTapCancelButton() {
        guard viewModel != nil else {
            dismiss(animated: true, completion: nil)
            return
        }
        navigationController?.popToRootViewController(animated: true)
    }

    @objc private func didTapColor() {
        let picker = UIColorPickerViewController()
        picker.selectedColor = selectedColor
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    @objc private func changeTime() {
        setupTimeDescription()
    }

    @objc private func didTapDelete() {
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Extensions

extension HabitViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        selectedColor = viewController.selectedColor
        self.colorButton.backgroundColor = selectedColor
    }
}

extension HabitViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

extension NSMutableAttributedString {
    func getRangeOfString(textToFind:String) -> NSRange{
        return self.mutableString.range(of: textToFind)
    }
}
