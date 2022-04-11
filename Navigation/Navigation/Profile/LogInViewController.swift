//
//  LogInViewController.swift
//  Navigation
//
//  Created by Семён Пряничников on 05.04.2022.
//

import UIKit

class LogInViewController: UIViewController {
    //Обработка появлений клавиатуры
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // подписаться на уведомления
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(kbdShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(kbdHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // отписаться от уведомлений
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // Изменение отступов при появлении клавиатуры
    @objc private func kbdShow(notification: NSNotification) {
        if let kbdSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.logInScrollView.contentInset.bottom = kbdSize.height
            self.logInScrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbdSize.height, right: 0)
        }
    }

    @objc private func kbdHide(notification: NSNotification) {
        self.logInScrollView.contentInset.bottom = .zero
        self.logInScrollView.verticalScrollIndicatorInsets = .zero
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.view.addSubview(self.logInScrollView)
        self.logInScrollView.addSubview(self.logInContentView)
        self.logInContentView.addSubview(self.authorizationStackView)
        self.logInContentView.addSubview(self.logInButton)
        self.logInContentView.addSubview(self.logoImageView)
        setupConstraint()
    }

    private lazy var logInScrollView: UIScrollView = {
        let logInScrollView = UIScrollView()
        logInScrollView.backgroundColor = .white
        logInScrollView.translatesAutoresizingMaskIntoConstraints = false
        return logInScrollView

    }()

    private lazy var logInContentView: UIView = {
        let logInContentView = UIView()
        logInContentView.backgroundColor = .white
        logInContentView.translatesAutoresizingMaskIntoConstraints = false

        return logInContentView
    }()

    private lazy var buttonBackgroundImageView: UIImageView = {
        let buttonBackgroundImageView = UIImageView()
        buttonBackgroundImageView.image = UIImage(named: "blue_pixel")
        return buttonBackgroundImageView
    }()

    private lazy var logInButton: UIButton = {
        let logInButton = UIButton()
        logInButton.layer.cornerRadius = 10
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.setTitle("Log In", for: .normal)
        logInButton.setTitleColor(.white, for: .normal)
        logInButton.setBackgroundImage(buttonBackgroundImageView.image, for: .normal)
        logInButton.addTarget(self, action: #selector(successfulLogin), for: .touchUpInside)
        switch logInButton.state {
        case .normal: logInButton.alpha = 1
        case .selected: logInButton.alpha = 0.8
        case .highlighted: logInButton.alpha = 0.8
        case .disabled: logInButton.alpha = 0.8
        default: logInButton.alpha = 1
        }
        logInButton.clipsToBounds = true
        return logInButton
    }()

    @objc func successfulLogin() {
        let profileViewController = ProfileViewController()
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }


    private lazy var logInTextField: UITextField = {
        let logInTextField = UITextField()
        logInTextField.translatesAutoresizingMaskIntoConstraints = false
        logInTextField.text = " Email or phone"
        logInTextField.backgroundColor = .systemGray6
        logInTextField.font = UIFont(name: "System", size: 16.0)
        logInTextField.textColor = .black
        logInTextField.tintColor = .darkGray
        logInTextField.autocapitalizationType = .none
        logInTextField.layer.borderWidth = 0.5
        logInTextField.layer.borderColor = UIColor.lightGray.cgColor
        logInTextField.addTarget(self, action: #selector(loginTextChanged), for: .editingChanged)
        logInTextField.clipsToBounds = true
        return logInTextField
    }()

    @objc func loginTextChanged(_ textField: UITextField) {
        logInTextField.textColor = .black
    }

    private lazy var passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.text = " Password"
        passwordTextField.backgroundColor = .systemGray6
        passwordTextField.font = UIFont(name: "System", size: 16.0)
        passwordTextField.textColor = .black
        passwordTextField.autocapitalizationType = .none
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextField.addTarget(self, action: #selector(passwordTextChanged), for: .editingChanged)
        passwordTextField.clipsToBounds = true
        return passwordTextField
    }()

    @objc func passwordTextChanged(_ textField: UITextField) {
        passwordTextField.isSecureTextEntry = true
    }

    private lazy var authorizationStackView: UIStackView = {
        let authorizationStackView = UIStackView()
        authorizationStackView.translatesAutoresizingMaskIntoConstraints = false
        authorizationStackView.layer.cornerRadius = 10
        authorizationStackView.layer.borderWidth = 0.5
        authorizationStackView.layer.borderColor = UIColor.lightGray.cgColor
        authorizationStackView.clipsToBounds = true
        authorizationStackView.backgroundColor = .systemGray
        authorizationStackView.axis = .vertical
        authorizationStackView.distribution = .fillEqually
        authorizationStackView.insertArrangedSubview(logInTextField, at: 0)
        authorizationStackView.insertArrangedSubview(passwordTextField, at: 1)
        return authorizationStackView
    }()

    private lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.clipsToBounds = true
        logoImageView.image = UIImage(named: "logo")
        return logoImageView
    }()


    private func setupConstraint() {
        //для authorizationStackView
        authorizationStackView.centerXAnchor.constraint(equalTo: self.logInContentView.centerXAnchor).isActive = true
        authorizationStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120).isActive = true
        authorizationStackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        authorizationStackView.trailingAnchor.constraint(equalTo: self.logInContentView.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        authorizationStackView.leadingAnchor.constraint(equalTo: self.logInContentView.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true

        //для logInScrollView
        logInScrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        logInScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        logInScrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        logInScrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true

        //для logInContentView
        logInContentView.leftAnchor.constraint(equalTo: logInScrollView.leftAnchor).isActive = true
        logInContentView.rightAnchor.constraint(equalTo: logInScrollView.rightAnchor).isActive = true
        logInContentView.topAnchor.constraint(equalTo: logInScrollView.topAnchor).isActive = true
        logInContentView.bottomAnchor.constraint(equalTo: logInScrollView.bottomAnchor).isActive = true
        logInContentView.widthAnchor.constraint(equalTo: self.logInScrollView.widthAnchor).isActive = true
        logInContentView.heightAnchor.constraint(equalTo: self.logInScrollView.heightAnchor).isActive = true

        //Для кнопки залогина
        logInButton.topAnchor.constraint(equalTo: authorizationStackView.bottomAnchor, constant: 16).isActive = true
        logInButton.leadingAnchor.constraint(equalTo: self.logInContentView.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        logInButton.trailingAnchor.constraint(equalTo: self.logInContentView.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        logInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        //Для логотипа
        logoImageView.centerXAnchor.constraint(equalTo: logInContentView.centerXAnchor).isActive = true
        logoImageView.topAnchor.constraint(equalTo: logInContentView.safeAreaLayoutGuide.topAnchor, constant: 120).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}
