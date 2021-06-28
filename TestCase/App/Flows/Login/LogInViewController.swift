//
//  LogInViewController.swift
//  TestCase
//
//  Created by Anton Scherbaev on 24.06.2021.
//

import UIKit

class LogInViewController: UIViewController {

    // MARK: - Private Properties
    
    private var logInView: LogInView {
        return self.view as! LogInView
    }
    
    // MARK: - Private Methods
    
    @objc private func auth() {
        guard let login: String = self.logInView.logInField.text,
              let password: String = self.logInView.passwordField.text else { return }
        CurrentSession.shared.login(with: login, and: password) { isSuccess in
            isSuccess ? self.showNextScreen() : self.showAlert(with: "Неудачная попытка входа.")
        }
    }
    
    private func showAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func textInFieldsDidChange() {
        if let login = self.logInView.logInField.text,
           let password = self.logInView.passwordField.text,
           !login.isEmpty && !password.isEmpty {
            self.logInView.logInButton.isUserInteractionEnabled = true
            self.logInView.logInButton.backgroundColor = .blue
        } else {
            self.logInView.logInButton.isUserInteractionEnabled = false
            self.logInView.logInButton.backgroundColor = .gray
        }
    }

    private func showNextScreen() {
        let vc = PhotoCollectionViewController(DBService: RealmLogic(), networkService: NetworkService())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        self.view = LogInView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.logInView.logInButton.addTarget(self, action: #selector(auth), for: .touchUpInside)
        self.logInView.logInField.addTarget(self, action: #selector(textInFieldsDidChange), for: .editingChanged)
        self.logInView.passwordField.addTarget(self, action: #selector(textInFieldsDidChange), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
}
