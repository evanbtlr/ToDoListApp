//
//  TodoListViewController.swift
//  ToDoListApp
//
//  Created by Evan Butler on 01.02.2026.
//

import UIKit

// MARK: View
final class TodoListViewController: UIViewController {
    
    // MARK: Properties
    var presenter: TodoListPresenterProtocol?
    
    private var tasks: [TodoTask] = [] {
        didSet {
            self.tableView.reloadData()
            self.updateEmptyState()
        }
    }

    // MARK: UI Components
    private weak var tableView: UITableView!
    private weak var refreshControl: UIRefreshControl!
    private weak var loadingIndicator: UIActivityIndicatorView!
    
    private weak var emptyStateView: UIView!
    
    private weak var searchController: UISearchController!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.setupEmptyView()
        self.setupConstraints()
        
        self.presenter?.viewDidLoad()
    }
    
    // MARK: Setup
    private func setupUI() {
        self.title = "Todo List"
        self.definesPresentationContext = true
        
        self.view.backgroundColor = .systemBackground
        
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.registerFromNib(cell: TodoCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.tableFooterView = UIView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView = tableView
        self.view.addSubview(tableView)
        
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        
        self.loadingIndicator = loadingIndicator
        self.view.addSubview(loadingIndicator)
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.tintColor = .secondaryLabel
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        self.refreshControl = refreshControl
        self.tableView.refreshControl = refreshControl
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search tasks ..."
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.tintColor = .accent
        
        self.searchController = searchController
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupEmptyView() {
        let emptyView = UIView(frame: self.view.bounds)
        
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.isHidden = true
        emptyView.alpha = 0
        
        let imageView = UIImageView(image: UIImage(systemName: "checklist"))
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        
        let labelsStackView = UIStackView()
        
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        labelsStackView.axis = .vertical
        labelsStackView.alignment = .center
        labelsStackView.distribution = .fillEqually
        labelsStackView.spacing = 8
        
        let titleLabel = UILabel()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "No Tasks Yet"
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        
        
        titleLabel.setContentHuggingPriority(.init(252), for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.init(752), for: .vertical)
        
        let messageLabel = UILabel()
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = "Tap + to add your first task"
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        messageLabel.textColor = .secondaryLabel
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        messageLabel.setContentHuggingPriority(.init(251), for: .vertical)
        messageLabel.setContentCompressionResistancePriority(.init(751), for: .vertical)
        
        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(messageLabel)
        
        emptyView.addSubview(imageView)
        emptyView.addSubview(labelsStackView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -60),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            labelsStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            labelsStackView.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 32),
            labelsStackView.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -32),
        ])
        
        self.emptyStateView = emptyView
        self.view.addSubview(emptyView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: Actions
    @objc private func addButtonTapped() {
        self.presenter?.didTapAddButton()
    }
    
    @objc private func refreshData() {
        self.presenter?.didReqiredRefresh()
    }
    
    // MARK: Private Methods
    
    private func showDeleteConfirmation(for indexPath: IndexPath) {
        let alert = UIAlertController(
            title: "Delete Task",
            message: "Are you sure you want to delete this task?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.presenter?.didDeleteTask(at: indexPath.row)
        })
        
        present(alert, animated: true)
    }
}

// MARK: Table View Data Source
extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TodoCell = tableView.dequeueReusableCell(for: indexPath)
        let task = tasks[indexPath.row]
        
        cell.configurate(with: task)
        
        cell.onToggle = { [weak self] isCompleted in
            self?.presenter?.didToggleTaskCompletion(at: indexPath.row)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.showDeleteConfirmation(for: indexPath)
        }
    }
}

// MARK: Table View Delegate
extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.presenter?.didSelectTask(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete"
        ) { [weak self] _, _, completionHandler in
            self?.presenter?.didDeleteTask(at: indexPath.row)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = tasks[indexPath.row]
        let title = task.isCompleted ? "Mark\nPending" : "Mark\nDone"
        
        let toggleAction = UIContextualAction(
            style: .normal,
            title: title
        ) { [weak self] _, _, completionHandler in
            self?.presenter?.didToggleTaskCompletion(at: indexPath.row)
            completionHandler(true)
        }
        
        toggleAction.backgroundColor = task.isCompleted ? .systemOrange : .systemGreen
        toggleAction.image = UIImage(systemName: task.isCompleted ? "arrow.uturn.left" : "checkmark")
        
        return UISwipeActionsConfiguration(actions: [toggleAction])
    }
}

extension TodoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        presenter?.searchTasks(with: query)
    }
}

// MARK: View Protocol
extension TodoListViewController: TodoListViewProtocol {
    var searchText: String? {
        self.searchController?.searchBar.text
    }
    
    func showTasks(_ tasks: [TodoTask]) {
        self.tasks = tasks
    }
    
    func showLoading() {
        self.loadingIndicator.startAnimating()
    }
    
    func hideLoading() {
        self.loadingIndicator.stopAnimating()
    }
    
    func showRefreshControl() {
        self.refreshControl.beginRefreshing()
    }
    
    func hideRefreshControl() {
        self.refreshControl.endRefreshing()
    }
    
    func updateEmptyState() {
        let shouldShowEmptyState = self.tasks.isEmpty && !self.searchController.isActive
        
        guard shouldShowEmptyState != self.emptyStateView.isHidden else { return }
        
        if shouldShowEmptyState {
            self.emptyStateView.isHidden = false
            
            UIView.animate(withDuration: 0.3) {
                self.emptyStateView.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.emptyStateView.alpha = 0
            }) { _ in
                self.emptyStateView.isHidden = true
            }
        }
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true)
    }
}
