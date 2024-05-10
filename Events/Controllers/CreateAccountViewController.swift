//
//  CreateAccountViewController.swift
//  Events
//
//  Created by Диас Нургалиев on 09.05.2024.
//

import UIKit
import SnapKit
import Alamofire

class CreateAccountViewController: UIViewController{
    let account: UILabel = {
        let label = UILabel()
        label.text = "Create an account"
        label.textColor = UIColor(red: 0.07, green: 0.09, blue: 0.15, alpha: 1.00)
        label.font = UIFont(name: "SFProDisplay-Bold", size: 24)

        return label
    }()
    let nameImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person")
        image.tintColor = .gray

        return image
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = UIColor(red: 0.07, green: 0.09, blue: 0.15, alpha: 1.00)
        label.font = UIFont(name: "SFProDisplay-Bold", size: 14)
        return label
    }()

    lazy var nameTextField: TextFIeldWithPadding = {
        let textField = TextFIeldWithPadding()
        textField.placeholder = "Your name"
        textField.font = UIFont(name: "SFProDisplay-Regular", size: 16)
        textField.borderStyle = .none
        textField.layer.borderWidth = 1.0
        textField.textContentType = .name
        textField.textAlignment = .natural
        textField.layer.cornerRadius = 12
        textField.clipsToBounds = true
        textField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.0).cgColor
        textField.delegate = self
        return textField
    }()
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.textColor = UIColor(red: 0.07, green: 0.09, blue: 0.15, alpha: 1.00)
        label.font = UIFont(name: "SFProDisplay-Bold", size: 14)

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
        label.font = UIFont(name: "SFProDisplay-Bold", size: 14)

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
    let createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Enter", for: .normal)
        button.backgroundColor = UIColor(red: 0.47, green: 0.48, blue: 0.43, alpha: 1.00)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Regular", size: 16)

        return button
    }()
    // MARK: Functions -
    func hideKeyboardWhenTappedAround(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }

    @objc func editingDidBegin(_ textField: UITextField) {
        emailTextField.layer.borderColor = UIColor(red: 0.47, green: 0.48, blue: 0.43, alpha: 1.00).cgColor
    }
    @objc func editingDidBeginPass(_ textField: UITextField) {
        passwordTextField.layer.borderColor = UIColor(red: 0.47, green: 0.48, blue: 0.43, alpha: 1.00).cgColor
    }

    @objc func editingDidEnd(_ textField: UITextField) {
        emailTextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
    }
    @objc func editingDidEndPass(_ textField: UITextField) {
        passwordTextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
    }
    @objc func showPassword() {
        passwordTextField.isSecureTextEntry.toggle()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupConstraints()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }

    @objc func create() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let name = nameTextField.text!

        if email.isEmpty || password.isEmpty || name.isEmpty {
            showError(message: "Please fill all fields.")
            return
        }

        let parameters = [
            "name": name,
            "email": email,
            "password": password,
            "confirm_Pass": password
        ]

        AF.request(
            "https://api.mironovayouragency.com/register",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default
        )
        .responseDecodable(of: AuthResponse.self) { [weak self] response in
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
    func showAlert(title: String) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    //MARK: SetpuUI -
    func setupUI() {
        view.addSubview(account)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(nameImage)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(emailImage)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(showPasswordButton)
        view.addSubview(passwordImage)
        view.addSubview(createButton)
        createButton.addTarget(self, action: #selector(create), for: .touchUpInside)
    }

    // MARK: Constraints -
    func setupConstraints() {
        account.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(124)
            make.horizontalEdges.equalTo(24)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(account.snp.bottom).offset(64)
            make.horizontalEdges.equalToSuperview().offset(24)
        }
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        nameImage.snp.makeConstraints { make in
            make.left.equalTo(nameTextField.snp.left).inset(16)
            make.centerY.equalTo(nameTextField)
            make.size.equalTo(20)
        }
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(24)
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
        createButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(56)
        }
    }
}

extension CreateAccountViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(red: 0.47, green: 0.48, blue: 0.43, alpha: 1.00).cgColor
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
    }
}
