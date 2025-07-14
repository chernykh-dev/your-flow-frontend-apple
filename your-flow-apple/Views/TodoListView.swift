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
                
                ForEach(vm.todos.filter { $0.parentId == nil }) { parent in
                    Section {
                        TodoItemRowView(todo: parent, vm: vm)
                        
                        ForEach(vm.childrenFor(todo: parent)) { child in
                            TodoItemRowView(todo: child, vm: vm)
                                .padding(.leading, 30)
                        }
                    }
                }
            }
            .navigationTitle("Todos")
            .refreshable {
                await vm.loadTodos()
            }
        }
        .task {
            await vm.loadTodos()
        }
    }
}
