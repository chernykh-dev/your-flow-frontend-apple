//
//  TodoItem.swift
//  your-flow-apple
//
//  Created by Artyom Chernykh on 12.07.2025.
//

import Foundation

struct TodoItem : Identifiable, Codable, Hashable {
    var id: UUID
    var title: String
    var isCompleted: Bool
    var description: String
    var order: Double
    var parentId: UUID?
    
    var children: [TodoItem]? = []
}
