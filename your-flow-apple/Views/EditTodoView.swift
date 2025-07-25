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
                TextField("Description", text: Binding(
                    get: { todo.description ?? "" },
                    set: { todo.description = $0.isEmpty ? nil : $0 }
                ))
                
                if let children = todo.children {
                    Section(header: Text("Subtodos")) {
                        ForEach(children, id: \.self) { child in
                            Text(child.title)
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
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    Task {
                        await vm.updateTodo(todo)
                        dismiss()
                    }
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
}
