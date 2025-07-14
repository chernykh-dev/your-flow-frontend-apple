//
//  DraggableTodoItemRowView.swift
//  your-flow-apple
//
//  Created by Artyom Chernykh on 14.07.2025.
//

import SwiftUI

struct DraggableTodoItemRowView : View {
    var flatTodo: FlatTodoItem
    @ObservedObject var vm: TodoViewModel
    var onDrop: (_ draggedId: UUID, _ targetId: UUID) -> Void
    
    var body: some View {
        TodoItemRowView(todo: flatTodo.todo, vm: vm)
            .padding(.leading, CGFloat(flatTodo.level) * 20)
            .draggable(flatTodo.id)
            .dropDestination(for: UUID.self) { items, location in
                guard let draggedIn = items.first else { return false }
                onDrop(draggedIn, flatTodo.id)
                return true
            }
    }
}
