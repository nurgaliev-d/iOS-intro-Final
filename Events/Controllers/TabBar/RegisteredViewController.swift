//
//  RegisteredViewController.swift
//  Events
//
//  Created by Диас Нургалиев on 09.05.2024.
//

import UIKit
import SnapKit

class RegisteredViewController: UIViewController {
    private let tableView = UITableView()
    private var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRegistered()
        tableView.reloadData()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRegistered()
        tableView.reloadData()
    }

    func getRegistered() {
        guard let email = AuthStorage.shared.currentUser?.email else { return }

        if let registerData = UserDefaults.standard.data(forKey: "registeredEvents_\(email)") {
            do {
                events = try JSONDecoder().decode([Event].self, from: registerData)
            } catch {}
        }
    }
    
    private func setupTableView() {
        navigationItem.title = "Registered"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EventCell.self, forCellReuseIdentifier: "EventCell")
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension RegisteredViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        let event = events[indexPath.row]
        cell.eventNameLabel.text = event.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = events[indexPath.row]
        let detailsVC = EventDetailsViewController(event: event)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                events.remove(at: indexPath.row)
                
                saveEventsToUserDefaults()
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        private func saveEventsToUserDefaults() {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(events)
                UserDefaults.standard.set(data, forKey: "registeredEvents")
            } catch {
                print("Error encoding events: \(error.localizedDescription)")
            }
        }
}
