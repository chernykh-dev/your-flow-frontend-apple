//
//  EditTodoView.swift
//  your-flow-apple
//
//  Created by Artyom Chernykh on 13.07.2025.
//

import SwiftUI

struct EditTodoView : View {
    @Environment(\.dismiss) var dismiss
    @State var todo: TodoItem
    var vm: TodoViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Toggle("Completed", isOn: $todo.isCompleted)
                TextField("Title", text: $todo.title)
                TextField("Description", text: $todo.description)
                
                if let children = todo.children {
                    Section(header: Text("Subtodos")) {
                        ForEach(children, id: \.self) {
                            child in Text(child.title)
                        }
                    }
                }
                
                Button("Delete", role: .destructive) {
                    Task {
                        await vm.deleteTodo(todo)
                        dismiss()
                    }
                }
            }
        }
        .navigationTitle("Edit Todo")
        .toolbar {
            Button("Save") {
                Task {
                    try? await TodosApi.updateTodo(todo)
                    await vm.loadTodos()
                    dismiss()
                }
            }
        }
    }
}
