//
//  ProfileViewController.swift
//  Events
//
//  Created by Диас Нургалиев on 08.05.2024.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {

    let divider4 = SeparatorView()
    let settingVIew = UIView()
    let image = UIImageView()
    let nameLabel = UILabel()
    let emailLabel = UILabel()
    let divider = SeparatorView()
    let darkMode = UIButton()
    let darkModeSwitch = UISwitch()
    let divider1 = SeparatorView()
    let logOutButton:UIButton = {
        let logout = UIButton()
        logout.setImage(UIImage(named: "exit"), for: .normal)
        logout.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
        
        
        return logout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
        setupConstraints()
        setupElem()
        // Do any additional setup after loading the view.
    }
    
    func setupElem() {
        darkMode.setTitle("Switch", for: .normal)
        
        image.image = UIImage(systemName: "person.crop.circle")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        
        settingVIew.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)
        
        nameLabel.text = AuthStorage.shared.currentUser?.name
        nameLabel.textColor = UIColor(red: 0.07, green: 0.09, blue: 0.15, alpha: 1.00)
        nameLabel.font = UIFont(name: "SFProDisplay-Bold", size: 24)
        nameLabel.textAlignment = .center
        
        emailLabel.text = AuthStorage.shared.currentUser?.email
        emailLabel.textColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1.00)
        emailLabel.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        emailLabel.textAlignment = .center
        
        darkMode.setTitleColor(UIColor(red: 0.11, green: 0.14, blue: 0.19, alpha: 1.00), for: .normal)
        darkMode.setTitle("Dark mode", for: .normal)
        darkMode.contentHorizontalAlignment = .leading
        darkMode.titleLabel?.font = UIFont(name: "SFProDisplay-Regular", size: 16)
    }
    
    func setupUI() {
        self.navigationItem.title = "Profile"
        view.addSubview(divider4)
        view.addSubview(settingVIew)
        view.addSubview(image)
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logOutButton)
        settingVIew.addSubview(divider)
        settingVIew.addSubview(darkMode)
        settingVIew.addSubview(darkModeSwitch)
        settingVIew.addSubview(divider1)
        
        darkModeSwitch.addTarget(self, action: #selector(updateInterfaceStyle), for: .valueChanged)
        logOutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
    }
    @objc func logOut() {
        let logoutPage = LogOutViewController()
        logoutPage.modalPresentationStyle = .overFullScreen
        present(logoutPage, animated: true, completion: nil)
    }
    
    func setupConstraints() {
        divider4.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        image.snp.makeConstraints { make in
            make.size.equalTo(75)
            make.top.equalToSuperview().inset(135)
            make.centerX.equalToSuperview()
        }
        
        settingVIew.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(29)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(22)
        }
        divider.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(emailLabel.snp.bottom).offset(24)
            
        }
        darkMode.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(0)
            make.height.equalTo(64)
            make.horizontalEdges.equalTo(24)
        }
        darkModeSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(darkMode)
            make.right.equalToSuperview().inset(24)
        }
        divider1.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(darkMode.snp.bottom)
            
        }

    }
    
    @objc private func updateInterfaceStyle() {
        view.window?.overrideUserInterfaceStyle = darkModeSwitch.isOn ? .dark : .light
        settingVIew.backgroundColor = darkModeSwitch.isOn ? .black : UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)
    }

    
}


class SeparatorView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
       
        backgroundColor = UIColor(red: 0.82, green: 0.84, blue: 0.86, alpha: 1.00)
        self.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }
}
