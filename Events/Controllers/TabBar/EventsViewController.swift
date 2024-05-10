//
//  EventsViewController.swift
//  Events
//
//  Created by Диас Нургалиев on 08.05.2024.
//

import UIKit
import SnapKit

class EventsViewController: UIViewController {
    
    private let tableView = UITableView()
    private var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        fetchEvents()
    }
    
    private func setupTableView() {
        navigationItem.title = "Events"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EventCell.self, forCellReuseIdentifier: "EventCell")
    }
    
    private func fetchEvents() {
        EventAPI.shared.fetchEvents { [weak self] events, error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching events: \(error)")
                return
            }
            if let events = events {
                self.events = events
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension EventsViewController: UITableViewDataSource, UITableViewDelegate {
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
}
