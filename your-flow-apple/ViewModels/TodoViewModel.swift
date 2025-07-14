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
    @Published var flatTodos: [FlatTodoItem] = []
    @Published var newTitle: String = ""
    
    func loadTodos() async {
        do {
            self.todos = try await TodosApi.getSortedTodos()
        } catch {
            print("Faield to load todos: \(error)")
        }
    }
    
    func childrenFor(todo: TodoItem) -> [TodoItem] {
        todos.filter { $0.parentId == todo.id }
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

    func updateTodo(_ todo: TodoItem) async {
        do {
            try await TodosApi.updateTodo(todo)
            await loadTodos()
        } catch {
            print("Update failed: \(error)")
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
    
    @MainActor
    func buildFlatList() {
        var result: [FlatTodoItem] = []
        
        func appendChildren(of parent: UUID?, level: Int) {
            for todo in todos.filter({ $0.parentId == parent }) {
                result.append(FlatTodoItem(todo: todo, id: todo.id, level: level))
                appendChildren(of: todo.id, level: level + 1)
            }
        }
        
        appendChildren(of: nil, level: 0)
        self.flatTodos = result
    }
    
    @MainActor
    func moveTodo(sourceId: UUID, destinationId: UUID) async {
        guard
            let sourceIndex = flatTodos.firstIndex(where: { $0.id == sourceId }),
            let destinationIndex = flatTodos.firstIndex(where: { $0.id == destinationId }),
            sourceIndex != destinationIndex
        else { return }
        
        var reordered = flatTodos
        
        let moved = reordered.remove(at: sourceIndex)
        reordered.insert(moved, at: destinationIndex)
        
        let newParentId = reordered[destinationIndex - 1].todo.id == moved.todo.id
        ? moved.todo.parentId
        : reordered[destinationIndex - 1].todo.id
        
        var updatedTodo = moved.todo
        updatedTodo.parentId = newParentId
        updatedTodo.order = destinationIndex
        
        do {
            try await TodosApi.updateTodo(updatedTodo)
            self.todos = try await TodosApi.getSortedTodos()
            self.buildFlatList()
        } catch {
            print("Failed to update todo on move: \(error)")
        }
    }
}
