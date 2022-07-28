//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by m.khutornaya on 24.07.2022.
//

import UIKit

struct TrackedDateModel {
    let date: Date
    let isHabitTracked: Bool
}

class HabitDetailsViewController: UIViewController {
    
    private let viewModel: Habit
    
    private lazy var dataItems: [TrackedDateModel] = {
        let dates = HabitsStore.shared.dates
        var items: [TrackedDateModel] = []
        dates.forEach {
            let isTracked = HabitsStore.shared.habit(viewModel, isTrackedIn: $0)
            items.append(TrackedDateModel(date: $0, isHabitTracked: isTracked))
        }
        return items
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        
        view.backgroundColor = .lightGray
        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rowHeight = UITableView.automaticDimension
        
        view.register(TrackedDatesTabelViewCell.self, forCellReuseIdentifier: String(describing: TrackedDatesTabelViewCell.self))
        
        return view
    }()
    
    init(viewModel: Habit) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    private func setUp() {
        title = viewModel.name
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        let navBar: UINavigationBar? = navigationController?.navigationBar
        navBar?.isHidden = false
        navBar?.backgroundColor = .white
        navBar?.tintColor = .purple
        navBar?.prefersLargeTitles = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: .editNavBarButton,
            style: .plain,
            target: self,
            action: #selector(didTapEditButton))
    }
    
    // MARK: - Actions
    
    @objc private func didTapEditButton() {
        navigationController?.pushViewController(HabitViewController(viewModel: viewModel), animated: true)
    }
}

extension HabitDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: TrackedDatesTabelViewCell.self), for: indexPath) as! TrackedDatesTabelViewCell
        cell.configure(with: dataItems[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return .sectionHeader.uppercased()
    }
}

private extension String {
    static let editNavBarButton = "Править"
    static let backNavBarButton = "Сегодня"
    static let sectionHeader = "Активность"
}
