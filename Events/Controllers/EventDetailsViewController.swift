//
//  EventDetailsViewController.swift
//  Events
//
//  Created by Диас Нургалиев on 08.05.2024.
//

import UIKit
import SnapKit

class EventDetailsViewController: UIViewController {

    var event: Event

    // UI Components
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    let slugLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()

    let idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()

    let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = UIColor(red: 0.47, green: 0.48, blue: 0.43, alpha: 1.00)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(register), for: .touchUpInside)
        return button
    }()

    let favButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "star"), for: .normal)

        return button
    }()

    init(event: Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Event Details"
        view.backgroundColor = .systemBackground
        setupViews()
        updateUI()
        checkIfRegistered()
        checkIfFavorite()
    }

    private func checkIfRegistered() {
        guard let email = AuthStorage.shared.currentUser?.email else { return }

        if let registerData = UserDefaults.standard.data(forKey: "registeredEvents_\(email)") {
            if let events = try? JSONDecoder().decode([Event].self, from: registerData) {
                registerButton.isEnabled = !(events.contains(where: { $0.id == event.id }))
                if (!registerButton.isEnabled) {
                    registerButton.backgroundColor = .gray
                    registerButton.setTitleColor(.black, for: .normal)
                }
            }
        }
    }

    private func checkIfFavorite() {
        guard let email = AuthStorage.shared.currentUser?.email else { return }

        if let favData = UserDefaults.standard.data(forKey: "favorites_\(email)") {
            if let favEvents = try? JSONDecoder().decode([Event].self, from: favData) {
                favButton.isHidden = favEvents.contains(where: { $0.id == event.id })
            }
        }
    }

    private func setupViews() {
        view.addSubview(nameLabel)
        view.addSubview(slugLabel)
        view.addSubview(idLabel)
        view.addSubview(registerButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favButton)
        favButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)

        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }

        slugLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
        }

        idLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(slugLabel.snp.bottom).offset(8)
        }

        registerButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }

    private func updateUI() {
        nameLabel.text = event.title
        slugLabel.text = "Slug: \(event.slug)"
        idLabel.text = "ID: \(event.id)"
    }
    @objc func favoriteButtonTapped() {
        guard let email = AuthStorage.shared.currentUser?.email else { return }

        var events: [Event] = [event]

        if let favData = UserDefaults.standard.data(forKey: "favorites_\(email)") {
            do {
                events += try JSONDecoder().decode([Event].self, from: favData)
            } catch {}
        }
        do {
            let favData = try JSONEncoder().encode(events)
            UserDefaults.standard.setValue(favData, forKey: "favorites_\(email)")
            navigationItem.rightBarButtonItems = []
        } catch {}
    }

    @objc func register() {
        registerButton.isEnabled = false
        registerButton.backgroundColor = .gray
        registerButton.setTitleColor(.black, for: .normal)
        saveRegisteredEventsToUserDefaults()
    }
    func saveRegisteredEventsToUserDefaults() {
        guard let email = AuthStorage.shared.currentUser?.email else { return }

        var events: [Event] = [event]
        if let registerData = UserDefaults.standard.data(forKey: "registeredEvents_\(email)") {
            do {
                events += try JSONDecoder().decode([Event].self, from: registerData)
            } catch {}
        }
        do {
            let registerData = try JSONEncoder().encode(events)
            UserDefaults.standard.setValue(registerData, forKey: "registeredEvents_\(email)")
        } catch {}
    }
}

