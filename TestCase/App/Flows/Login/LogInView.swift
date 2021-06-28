//
//  LogInView.swift
//  TestCase
//
//  Created by Anton Scherbaev on 24.06.2021.
//

import UIKit

class LogInView: UIView {

    // MARK: - Subviews
    
    let logInField = UITextField()
    let passwordField = UITextField()
    let logInButton = UIButton()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    
    // MARK: - UI
    
    private func configureUI() {
        self.backgroundColor = .white
        self.addlogInField()
        self.addPasswordField()
        self.addLogInButton()
        self.setupConstraints()
    }
    
    private func addlogInField() {
        self.logInField.placeholder = "Login"
        self.logInField.translatesAutoresizingMaskIntoConstraints = false
        self.logInField.layer.borderColor = UIColor.gray.cgColor
        self.addSubview(self.logInField)
    }
    
    private func addPasswordField() {
        self.passwordField.placeholder = "Password"
        self.passwordField.isSecureTextEntry = true
        self.passwordField.translatesAutoresizingMaskIntoConstraints = false
        self.passwordField.layer.borderColor = UIColor.gray.cgColor
        self.addSubview(self.passwordField)
    }
    
    private func addLogInButton() {
        self.logInButton.translatesAutoresizingMaskIntoConstraints = false
        self.logInButton.setTitle("Log In", for: .normal)
        self.logInButton.backgroundColor = .gray
        self.logInButton.isUserInteractionEnabled = false
        self.logInButton.layer.cornerRadius = 10
        self.addSubview(self.logInButton)
    }
    
    private func setupConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.logInField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.logInField.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 100),
            self.logInField.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 50),
            self.logInField.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -50),
            
            self.passwordField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.passwordField.topAnchor.constraint(equalTo: self.logInField.bottomAnchor, constant: 30),
            self.passwordField.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 50),
            self.passwordField.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -50),
            
            self.logInButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.logInButton.topAnchor.constraint(equalTo: self.passwordField.bottomAnchor, constant: 30),
            self.logInButton.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 100),
            self.logInButton.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -100),
            
            ])
    }
}
