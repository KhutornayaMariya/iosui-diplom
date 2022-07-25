//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by m.khutornaya on 19.07.2022.
//

import UIKit

class HabitsViewController: UIViewController {

    private var dataItems: [Habit] = []

    private let header: HeaderCollectionView = {
        let view = HeaderCollectionView()

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.showsVerticalScrollIndicator = false
        view.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: "HabitCollectionViewCell")
        view.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: "ProgressCollectionViewCell")
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataItems = HabitsStore.shared.habits
        collectionView.reloadData()
        setupNavigationBar()
    }

    private func setup() {
        view.backgroundColor = .white
        [header, collectionView].forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: header.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupNavigationBar() {
        let navBar: UINavigationBar? = navigationController?.navigationBar
        navBar?.isHidden = false
        navBar?.backgroundColor = .white
        navBar?.shadowImage = UIImage()

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(didTapAddButton)
        )
        navigationItem.rightBarButtonItem?.tintColor = .purple
    }

    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case .progressSectionIndex:
                return .progressSection
            default:
                return .habitSection
            }
        }
    }

    @objc private func didTapAddButton() {
        let habitVC = HabitViewController()
        let navigation = UINavigationController(rootViewController: habitVC)
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true, completion: nil)
    }

    private func onTrackerTap(habit: Habit) {
        guard !habit.isAlreadyTakenToday else { return }
        HabitsStore.shared.track(habit)
        dataItems = HabitsStore.shared.habits
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension HabitsViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case .progressSectionIndex:
            return 1
        default:
            return dataItems.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case .progressSectionIndex:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProgressCollectionViewCell", for: indexPath) as! ProgressCollectionViewCell
            let todayProgress = HabitsStore.shared.todayProgress
            cell.configure(with: todayProgress)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HabitCollectionViewCell", for: indexPath) as! HabitCollectionViewCell
            let habitData = dataItems[indexPath.row]
            cell.configure(with: habitData)
            cell.onTapHander = { [weak self] in self?.onTrackerTap(habit: habitData) }
            return cell
        }
    }
}

// MARK: - NSCollectionLayoutSection

private extension NSCollectionLayoutSection {
    static let progressSection: NSCollectionLayoutSection = {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 22, leading: .safeArea, bottom: 0, trailing: .safeArea)

        return section
    }()

    static let habitSection: NSCollectionLayoutSection = {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(130))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 18, leading: .safeArea, bottom: 0, trailing: .safeArea)

        return section
    }()
}

extension HabitsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case .progressSectionIndex:
            return
        default:
            navigationController?.pushViewController(HabitDetailsViewController(), animated: true)
        }
    }
}

private extension Int {
    static let progressSectionIndex: Int = 0
}

private extension CGFloat {
    static let safeArea: CGFloat = 16
}
