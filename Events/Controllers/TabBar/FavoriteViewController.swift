//
//  FavoriteViewController.swift
//  Events
//
//  Created by Диас Нургалиев on 08.05.2024.
//

import UIKit

class FavoriteViewController: UIViewController {

    private let tableView = UITableView()
    private var favEvents: [Event] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getFav()
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getFav()
        tableView.reloadData()
    }

    private func setupTableView() {
        navigationItem.title = "Favorites"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EventCell.self, forCellReuseIdentifier: "EventCell")
    }

    func getFav() {
        guard let email = AuthStorage.shared.currentUser?.email else { return }

        if let favData = UserDefaults.standard.data(forKey: "favorites_\(email)") {
            do {
                favEvents = try JSONDecoder().decode([Event].self, from: favData)
            } catch {}
        }
    }
}

extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return favEvents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell

        let event = favEvents[indexPath.row]
        cell.eventNameLabel.text = event.title

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = favEvents[indexPath.row]
        let detailsVC = EventDetailsViewController(event: event)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            favEvents.remove(at: indexPath.row)

            saveEventsToUserDefaults()

            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    private func saveEventsToUserDefaults() {
        guard let email = AuthStorage.shared.currentUser?.email else { return }

        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(favEvents)
            UserDefaults.standard.set(data, forKey: "favorites_\(email)")
        } catch {
            print("Error encoding events: \(error.localizedDescription)")
        }
    }
}
