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
                    print("toggled in \(todo.title)")
                    Task { await vm.toggleCompleted(todo) }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(todo.isCompleted ? Color.blue : Color.gray, lineWidth: 1.5)
                            .frame(width: 28, height: 28)

                        if todo.isCompleted {
                            Image(systemName: "checkmark")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.blue)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                Text(todo.title)
                    .strikethrough(todo.isCompleted)
                    .fontWeight(todo.isCompleted ? .bold : .regular)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showEdit = true
                    }
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
        }
        .sheet(isPresented: $showEdit) {
            NavigationView {
                EditTodoView(todo: todo, vm: vm)
            }
        }
    }
}
