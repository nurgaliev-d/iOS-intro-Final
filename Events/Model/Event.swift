//
//  Event.swift
//  Events
//
//  Created by Диас Нургалиев on 08.05.2024.
//

import Foundation

struct Event: Codable {
    let id: Int
    let title: String
    let slug: String
    
    init(id: Int, title: String, slug: String) {
        self.id = id
        self.title = title
        self.slug = slug
    }
}


