//
//  EventAPI.swift
//  Events
//
//  Created by Диас Нургалиев on 08.05.2024.
//

import Foundation
import Alamofire
import SVProgressHUD

class EventAPI {
    
    static let shared = EventAPI()
    
    private let baseURL = "https://kudago.com/public-api/v1.4/events/"
    
    func fetchEvents(completion: @escaping ([Event]?, Error?) -> Void) {
        SVProgressHUD.show()
        AF.request(baseURL).responseDecodable(of: EventsResponse.self) { response in
            SVProgressHUD.dismiss()
            switch response.result {
            case .success(let eventsResponse):
                let events = eventsResponse.results.map { result in
                    Event(id: result.id, title: result.title, slug: result.slug)
                }
                completion(events, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

struct EventsResponse: Decodable {
    let results: [EventResult]
}

struct EventResult: Decodable {
    let id: Int
    let title: String
    let slug: String
}
