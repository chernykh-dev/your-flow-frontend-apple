//
//  TodoListView.swift
//  your-flow-apple
//
//  Created by Artyom Chernykh on 13.07.2025.
//

import SwiftUI

struct TodoListView : View {
    @StateObject var vm = TodoViewModel()
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    TextField("New Todo", text: $vm.newTitle)
                    Button("Add") {
                        Task { await vm.addTodo() }
                    }
                }
                
                ForEach(vm.todos, id: \.self) {
                    todo in TodoItemRowView(todo: todo, vm: vm)
                }
            }
            .navigationTitle("Todos")
        }
        .task {
            await vm.loadTodos()
        }
    }
}
