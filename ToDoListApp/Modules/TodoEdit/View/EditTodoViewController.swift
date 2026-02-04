//
//  EditTodoViewController.swift
//  ToDoListApp
//
//  Created by Evan Brother on 04.02.2026.
//

import UIKit

final class EditTodoViewController: UIViewController {
    
    // MARK: Properties
    var presenter: EditTodoPresenterProtocol?
    
    private var isCompleted: Bool = false
    
    // MARK: UI Components
    private weak var scrollView: UIScrollView!
    private weak var contentView: UIView!
    private weak var titleLabel: UILabel!
    private weak var titleTextField: UITextField!
    private weak var validationLabel: UILabel!
    private weak var descriptionLabel: UILabel!
    private weak var descriptionTextView: UITextView!
    private weak var placeholderLabel: UILabel!
    private weak var statusLabel: UILabel!
    private weak var completedSwitch: UISwitch!
    private weak var switchLabel: UILabel!
    private weak var saveButton: UIButton!
    private weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.setupConstraints()
        self.setupNavigationBar()
        self.setupKeyboardHandling()
        self.setupAccessibility()
        
        self.presenter?.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: Setup
    private func setupUI() {
        self.title = "Edit Task"
        self.view.backgroundColor = .systemBackground
        
        // Scroll View
        let scrollView = UIScrollView()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .interactive
        
        self.scrollView = scrollView
        
        // Content View
        let contentView = UIView()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView = contentView
        
        // Title Label
        let titleLabel = UILabel()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Title"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .label
        
        self.titleLabel = titleLabel
        
        // Title Text Field
        let titleTextField = UITextField()
        
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.placeholder = "Enter task title"
        titleTextField.borderStyle = .roundedRect
        titleTextField.font = UIFont.systemFont(ofSize: 16)
        titleTextField.autocapitalizationType = .sentences
        titleTextField.returnKeyType = .next
        
        self.titleTextField = titleTextField
        
        // Validation Label
        let validationLabel = UILabel()
        
        validationLabel.translatesAutoresizingMaskIntoConstraints = false
        validationLabel.font = UIFont.systemFont(ofSize: 14)
        validationLabel.textColor = .systemRed
        validationLabel.numberOfLines = 0
        validationLabel.isHidden = true
        
        self.validationLabel = validationLabel
        
        // Description Label
        let descriptionLabel = UILabel()
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = "Description (optional)"
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        descriptionLabel.textColor = .label
        
        self.descriptionLabel = descriptionLabel
        
        // Description Text View
        let descriptionTextView = UITextView()
        
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.font = UIFont.systemFont(ofSize: 16)
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.systemGray4.cgColor
        descriptionTextView.layer.cornerRadius = 6
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.autocapitalizationType = .sentences
        
        self.descriptionTextView = descriptionTextView
        
        // Status Label
        let statusLabel = UILabel()
        
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.text = "Status"
        statusLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        statusLabel.textColor = .label
        
        self.statusLabel = statusLabel
        
        // Completed Switch
        let completedSwitch = UISwitch()
        
        completedSwitch.translatesAutoresizingMaskIntoConstraints = false
        completedSwitch.onTintColor = .systemGreen
        
        self.completedSwitch = completedSwitch
        
        // switchLabel
        let switchLabel = UILabel()
        
        switchLabel.translatesAutoresizingMaskIntoConstraints = false
        switchLabel.text = "Completed"
        switchLabel.font = UIFont.systemFont(ofSize: 16)
        switchLabel.textColor = .label
        
        self.switchLabel = switchLabel
        
        // saveButton
        let saveButton = UIButton(type: .system)
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.layer.cornerRadius = 12
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        self.saveButton = saveButton
        
        // loadingIndicator
        let loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        
        self.loadingIndicator = loadingIndicator
        
        // Placeholder Label
        let placeholderLabel = UILabel()
        
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.text = "Add description..."
        placeholderLabel.font = UIFont.systemFont(ofSize: 16)
        placeholderLabel.textColor = .tertiaryLabel
        placeholderLabel.isUserInteractionEnabled = false
        
        self.placeholderLabel = placeholderLabel
            
        // Add subviews
        self.view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(titleTextField)
        contentView.addSubview(validationLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(statusLabel)
        contentView.addSubview(completedSwitch)
        contentView.addSubview(switchLabel)
        contentView.addSubview(saveButton)
        contentView.addSubview(loadingIndicator)
        
        descriptionTextView.addSubview(placeholderLabel)
        
        // Setup text field
        titleTextField.delegate = self
        titleTextField.addTarget(self, action: #selector(titleDidChange), for: .editingChanged)
        
        // Setup text view
        descriptionTextView.delegate = self
        
        // Setup switch
        completedSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Title Text Field
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // Validation Label
            validationLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 4),
            validationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            validationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Description Label
            descriptionLabel.topAnchor.constraint(equalTo: validationLabel.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Description Text View
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            // Placeholder Label
            placeholderLabel.topAnchor.constraint(equalTo: descriptionTextView.topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor, constant: 12),
            placeholderLabel.trailingAnchor.constraint(equalTo: descriptionTextView.trailingAnchor, constant: -12),
            
            // Status Label
            statusLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 24),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Completed Switch
            completedSwitch.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 12),
            completedSwitch.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            // Switch Label
            switchLabel.leadingAnchor.constraint(equalTo: completedSwitch.trailingAnchor, constant: 12),
            switchLabel.centerYAnchor.constraint(equalTo: completedSwitch.centerYAnchor),
            
            // Save Button
            saveButton.topAnchor.constraint(equalTo: completedSwitch.bottomAnchor, constant: 40),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            // Loading Indicator
            loadingIndicator.centerXAnchor.constraint(equalTo: saveButton.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelButtonTapped)
        )
        self.navigationItem.leftBarButtonItem?.tintColor = .systemRed
    }
    
    private func setupAccessibility() {
        self.titleTextField.accessibilityIdentifier = "titleTextField"
        self.descriptionTextView.accessibilityIdentifier = "descriptionTextView"
        self.completedSwitch.accessibilityIdentifier = "completedSwitch"
        self.saveButton.accessibilityIdentifier = "saveButton"
    }
    
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    // MARK: Actions
    @objc private func saveButtonTapped() {
        self.dismissKeyboard()
        
        let title = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? String()
        let description = descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let isCompleted = completedSwitch.isOn
        
        self.presenter?.didTapSaveButton(
            title: title,
            description: description.isEmpty ? nil : description,
            isCompleted: isCompleted
        )
    }
    
    @objc private func cancelButtonTapped() {
        self.dismissKeyboard()
        
        self.presenter?.didTapCancelButton()
    }
    
    @objc private func titleDidChange() {
        self.presenter?.didUpdateTitle(titleTextField.text ?? "")
    }
    
    @objc private func switchChanged() {
        // Switch changes handled in save
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: keyboardFrame.height,
            right: 0
        )
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        self.scrollView.contentInset = .zero
        self.scrollView.scrollIndicatorInsets = .zero
    }
    
    // MARK: Private Methods
    private func showValidationLabel(_ message: String) {
        self.validationLabel.text = message
        self.validationLabel.isHidden = false
        
        self.titleTextField.layer.borderWidth = 1
        self.titleTextField.layer.borderColor = UIColor.systemRed.cgColor
        self.titleTextField.layer.cornerRadius = 6
    }
    
    private func clearValidationLabel() {
        self.validationLabel.isHidden = true
        
        self.titleTextField.layer.borderWidth = 0
        self.titleTextField.layer.borderColor = nil
    }
    
    private func updatePlaceholderVisibility() {
        self.placeholderLabel.isHidden = !self.descriptionTextView.text.isEmpty
    }
}

// MARK: Text Field Delegate
extension EditTodoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.titleTextField {
            self.descriptionTextView.becomeFirstResponder()
        }
        
        return true
    }
}

// MARK: Text View Delegate
extension EditTodoViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.updatePlaceholderVisibility()
        self.presenter?.didUpdateDescription(textView.text)
    }
}

// MARK: - Edit Todo View Protocol
extension EditTodoViewController: EditTodoViewProtocol {
    func showData(_ data: EditTodoData) {
        self.titleTextField.text = data.title
        self.descriptionTextView.text = data.description
        self.completedSwitch.isOn = data.isCompleted
        self.updatePlaceholderVisibility()
        
        // Update title based on mode
        self.title = data.id == nil ? "New Task" : "Edit Task"
    }
    
    func showValidationError(_ message: String) {
        self.showValidationLabel(message)
    }
    
    func clearValidationError() {
        self.clearValidationLabel()
    }
    
    func showLoading() {
        self.saveButton.isEnabled = false
        self.loadingIndicator.startAnimating()
    }
    
    func hideLoading() {
        self.saveButton.isEnabled = true
        loadingIndicator.stopAnimating()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func closeModule() {
        navigationController?.popViewController(animated: true)
    }
}
