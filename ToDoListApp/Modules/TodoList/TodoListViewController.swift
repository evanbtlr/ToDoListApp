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
    
    private var tasks: [TodoTask] = []

    // MARK: UI Components
    private weak var tableView: UITableView!
    private weak var refreshControl: UIRefreshControl!
    private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.setupConstraints()
        
        self.presenter?.viewDidLoad()
    }
    
    // MARK: Setup
    private func setupUI() {
        self.title = "Todo List"
        self.view.backgroundColor = .systemBackground
        
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(cell: TodoCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.tableFooterView = UIView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView = tableView
        self.view.addSubview(tableView)
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        
        self.activityIndicator = activityIndicator
        self.view.addSubview(activityIndicator)
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.tintColor = .secondaryLabel
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        self.refreshControl = refreshControl
        self.tableView.refreshControl = refreshControl
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: Actions
    @objc private func addButtonTapped() {
        self.presenter?.didTapAddButton()
    }
    
    @objc private func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.presenter?.didReqiredRefresh()
        }
    }
    
    // MARK: Private Methods
    private func showEmptyStateIfNeeded() {
        if tasks.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = "No tasks yet\nTap + to add your first task"
            emptyLabel.textAlignment = .center
            emptyLabel.numberOfLines = 0
            emptyLabel.textColor = .secondaryLabel
            tableView.backgroundView = emptyLabel
        } else {
            tableView.backgroundView = nil
        }
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
}

// MARK: Table View Delegate
extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: View Protocol
extension TodoListViewController: TodoListViewProtocol {
    func showTasks(_ tasks: [TodoTask]) {
        self.tasks = tasks
        
        self.tableView.reloadData()
        self.showEmptyStateIfNeeded()
    }
    
    func showLoading() {
        self.activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        self.activityIndicator.stopAnimating()
        self.refreshControl.endRefreshing()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true)
    }
}
