//
//  TodosApi.swift
//  your-flow-apple
//
//  Created by Artyom Chernykh on 12.07.2025.
//

import Foundation

class TodosApi {
    static let baseUrl = URL(string: "http://your-flow.online:5206/api/v1/todos")!
    
    static func fetchTodos() async throws -> [TodoItem] {
        let (data, _) = try await URLSession.shared.data(from: baseUrl)
        return try JSONDecoder().decode([TodoItem].self, from: data)
    }
    
    static func getSortedTodos(id: UUID) async throws -> [TodoItem] {
        let url  = baseUrl.appendingPathComponent("sorted")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(TodoItem.self, from: data)
    }

    static func getTodo(id: UUID) async throws -> TodoItem {
        let url = baseUrl.appendingPathComponent(id.uuidString)
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(TodoItem.self, from: data)
    }
    
    static func addTodo(_ todo: TodoItem) async throws {
        var request = URLRequest(url: baseUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(todo)
        _ = try await URLSession.shared.data(for: request)
    }
    
    static func updateTodo(_ todo: TodoItem) async throws {
        var request = URLRequest(url: baseUrl.appendingPathComponent(todo.id.uuidString))
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(todo)
        _ = try await URLSession.shared.data(for: request)
    }

    static func toggleCompleted(id: UUID, isCompleted: Bool) async throws {
        var request = URLRequest(url: baseUrl.appendingPathComponent("toggle/\(id.uuidString)"))
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = try JSONEncoder().encode(["isCompleted": isCompleted])
        request.httpBody = body
        _ = try await URLSession.shared.data(for: request)
    }

    static func deleteTodo(id: UUID) async throws {
        var request = URLRequest(url: baseUrl.appendingPathComponent(id.uuidString))
        request.httpMethod = "DELETE"
        _ = try await URLSession.shared.data(for: request)
    }
}
