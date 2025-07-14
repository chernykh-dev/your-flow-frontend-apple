//
//  FlatTodoItem.swift
//  your-flow-apple
//
//  Created by Artyom Chernykh on 14.07.2025.
//

import Foundation

struct FlatTodoItem : Identifiable, Equatable {
    let todo: TodoItem
    let id: UUID
    let level: Int
}
