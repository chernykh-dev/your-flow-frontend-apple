//
//  TodoItemRowView.swift
//  your-flow-apple
//
//  Created by Artyom Chernykh on 13.07.2025.
//

import SwiftUI

struct TodoItemRowView : View {
    var todo: TodoItem
    @ObservedObject var vm: TodoViewModel
    @State private var showEdit = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    Task { await vm.toggleCompleted(todo) }
                }) {
                    Image(systemName: todo.isCompleted ? "checkmark.square" : "square")
                }
                
                Text(todo.title)
                    .strikethrough(todo.isCompleted)
                    .fontWeight(todo.isCompleted ? .bold : .regular)
                    .onTapGesture {
                        showEdit = true
                    }
                
                Spacer()
            }
            .contextMenu {
                Button("Add Subtodo") {
                    
                }
                Button("Edit") {
                    showEdit = true
                }
                Button("Delete", role: .destructive) {
                    Task { await vm.deleteTodo(todo) }
                }
            }
            
            if let children = todo.children {
                ForEach(children, id: \.self) {
                    child in TodoItemRowView(todo: child, vm: vm)
                        .padding(.leading)
                }
            }
        }
        .sheet(isPresented: $showEdit) {
            EditTodoView(todo: todo, vm: vm)
        }
    }
}
