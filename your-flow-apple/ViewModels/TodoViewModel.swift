//
//  TodoItemViewModel.swift
//  your-flow-apple
//
//  Created by Artyom Chernykh on 13.07.2025.
//

import Foundation

@MainActor
class TodoViewModel : ObservableObject {
    @Published var todos: [TodoItem] = []
    @Published var newTitle: String = ""
    
    func loadTodos() async {
        do {
            let todos = try await TodosApi.fetchTodos()
            self.todos = self.organizeHierarchy(todos)
        } catch {
            print("Faield to load todos: \(error)")
        }
    }
    
    func organizeHierarchy(_ todos: [TodoItem]) -> [TodoItem] {
        var map = Dictionary(grouping: todos, by: { $0.parentId })
        return map[nil]?.map { todo in
            var t = todo
            t.children = map[todo.id]
            return t
        } ?? []
    }
    
    func addTodo() async {
        let newTodo = TodoItem(id: UUID(), title: newTitle, isCompleted: false, description: "", order: 0, parentId: nil)
        do {
            try await TodosApi.addTodo(newTodo)
            await loadTodos()
            newTitle = ""
        } catch {
            print("Add failed: \(error)")
        }
    }

    func toggleCompleted(_ todo: TodoItem) async {
        do {
            try await TodosApi.toggleCompleted(id: todo.id, isCompleted: !todo.isCompleted)
            await loadTodos()
        } catch {
            print("Toggle failed: \(error)")
        }
    }

    func deleteTodo(_ todo: TodoItem) async {
        do {
            try await TodosApi.deleteTodo(id: todo.id)
            await loadTodos()
        } catch {
            print("Delete failed: \(error)")
        }
    }
}
