//
//  SignInViewController.swift
//  Events
//
//  Created by Диас Нургалиев on 08.05.2024.
//

import UIKit
import SnapKit
import Alamofire
import SVProgressHUD

class SignInViewController: UIViewController{
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello"
        label.textColor = UIColor(red: 0.07, green: 0.09, blue: 0.15, alpha: 1.00)
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    let loginAccountLabel: UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.textColor = UIColor(red: 0.42, green: 0.45, blue: 0.50, alpha: 1.00)
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.textColor = UIColor(red: 0.07, green: 0.09, blue: 0.15, alpha: 1.00)
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()

    lazy var emailTextField: TextFIeldWithPadding = {
        let textField = TextFIeldWithPadding()
        textField.autocapitalizationType = .none
        textField.placeholder = "Your email"
        textField.font = .systemFont(ofSize: 16)
        textField.borderStyle = .none
        textField.layer.borderWidth = 1.0
        textField.textContentType = .emailAddress
        textField.textAlignment = .natural
        textField.layer.cornerRadius = 12
        textField.clipsToBounds = true
        textField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.0).cgColor
        textField.delegate = self
        return textField
    }()

    lazy var passwordTextField: TextFIeldWithPadding = {
        let textField = TextFIeldWithPadding()
        textField.autocapitalizationType = .none
        textField.placeholder = "Your password"
        textField.font = .systemFont(ofSize: 16)
        textField.borderStyle = .none
        textField.layer.borderWidth = 1.0
        textField.textContentType = .password
        textField.isSecureTextEntry = true
        textField.textAlignment = .natural
        textField.layer.cornerRadius = 12
        textField.clipsToBounds = true
        textField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.0).cgColor
        textField.delegate = self
        return textField
    }()

    let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Құпия сөз"
        label.textColor = UIColor(red: 0.07, green: 0.09, blue: 0.15, alpha: 1.00)
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()

    let emailImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "envelope")
        image.tintColor = .gray
        return image
    }()

    lazy var showPasswordButton: UIButton = {
        let button  = UIButton(type: .system)
        button.isSelected = false
        button.setImage(UIImage(systemName: "eye.circle"), for: .normal)
        button.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
        button.tintColor = .gray
        button.contentMode = .scaleAspectFill
        return button
    }()

    let passwordImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "lock")
        image.tintColor = .gray
        return image
    }()

    let forgotPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Forgot you password?"
        label.textColor = UIColor(red: 0.47, green: 0.48, blue: 0.43, alpha: 1.00)
        label.font = UIFont(name: "SFProDisplay-Semibold", size: 14)
        label.textAlignment = .right
        return label
    }()
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Enter", for: .normal)
        button.backgroundColor = UIColor(red: 0.47, green: 0.48, blue: 0.43, alpha: 1.00)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Regular", size: 16)
        return button
    }()
    let createAccLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have an account yet?"
        label.textColor = UIColor(red: 0.42, green: 0.45, blue: 0.50, alpha: 1.00)
        label.font = UIFont(name: "SFProDisplay-Semibold", size: 14)
        label.textAlignment = .right
        return label
    }()

    lazy var createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create", for: .normal)
        button.setTitleColor(UIColor(red: 0.47, green: 0.48, blue: 0.43, alpha: 1.00), for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 14)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(createPage), for: .touchUpInside)
        return button
    }()


    // MARK: - Functions
    func hideKeyboardWhenTappedAround(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupConstraints()
        hideKeyboardWhenTappedAround()
    }

    @objc func createPage() {
        let createPG = CreateAccountViewController()
        show(createPG, sender: self)
    }

    @objc func dismissKeyboard(){
        view.endEditing(true)
    }

    @objc func showPassword() {
        passwordTextField.isSecureTextEntry.toggle()
    }

    @objc func signIn() {
        let email = emailTextField.text!
        let password = passwordTextField.text!

        if email.isEmpty || password.isEmpty {
            showError(message: "Please enter both email and password.")
            return
        }

        let parameters = [
            "email": email,
            "password": password
        ]
        SVProgressHUD.show()
        AF.request(
            "https://api.mironovayouragency.com/login",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default
        )
        .responseDecodable(of: AuthResponse.self) { [weak self] response in
            SVProgressHUD.dismiss()
            print(String(data: response.data ?? Data(), encoding: .utf8))
            switch response.result {
            case .success(let data):
                AuthStorage.shared.token = data.token
                AuthStorage.shared.currentUser = data.user
                self?.startApp()
            case .failure(let error):
                self?.showError(message: error.localizedDescription)
            }
        }
    }

    func startApp(){
        let tabBarController = TabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
        if let window = view.window {
            UIView.transition(with: window, duration: 1.0, options: .transitionFlipFromRight) {
                window.rootViewController = tabBarController
            }
        }
    }

    func showError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Setup UI
    func setupUI() {
        view.addSubview(welcomeLabel)
        view.addSubview(loginAccountLabel)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(emailImage)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(showPasswordButton)
        view.addSubview(passwordImage)
        view.addSubview(forgotPasswordLabel)
        view.addSubview(loginButton)
        view.addSubview(createAccLabel)
        view.addSubview(createAccountButton)
        loginButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    }

    // MARK: Constraints -
    func setupConstraints() {
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(124)
            make.horizontalEdges.equalTo(24)
        }
        loginAccountLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom)
            make.horizontalEdges.equalTo(24)
        }
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(loginAccountLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().offset(24)
        }
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        emailImage.snp.makeConstraints { make in
            make.left.equalTo(emailTextField.snp.left).inset(16)
            make.centerY.equalTo(emailTextField)
            make.size.equalTo(20)
        }
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(21)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        showPasswordButton.snp.makeConstraints { make in
            make.centerY.equalTo(passwordTextField)
            make.right.equalTo(passwordTextField.snp.right).inset(16)
            make.size.equalTo(30)
        }
        passwordImage.snp.makeConstraints { make in
            make.left.equalTo(passwordTextField.snp.left).inset(16)
            make.centerY.equalTo(passwordTextField)
            make.size.equalTo(20)
        }
        forgotPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(17)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(forgotPasswordLabel.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(56)
        }
        createAccLabel.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(24)
            make.right.equalTo(createAccountButton.snp.left)
            make.height.equalTo(22)
            make.width.equalTo(270)
        }
        createAccountButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(24)
            make.left.equalTo(createAccLabel.snp.right)
            make.right.equalToSuperview().inset(24)
            make.height.equalTo(22)
            make.width.equalTo(121)
        }
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(red: 0.47, green: 0.48, blue: 0.43, alpha: 1.00).cgColor
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
    }
}
