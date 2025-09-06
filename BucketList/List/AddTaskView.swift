//
//  AddTaskView.swift
//  BucketList
//
//  Created by SUJOY on 05/09/25.
//


import SwiftUI

struct AddTaskView: View {
    @ObservedObject var viewModel: TaskViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Task title", text: $viewModel.newTaskTitle)
                    
                    Picker("Priority", selection: $viewModel.newTaskPriority) {
                        ForEach(TaskItem.Priority.allCases, id: \.self) { priority in
                            Text(priority.displayName).tag(priority)
                        }
                    }
                    
                    DatePicker(
                        "Due Date",
                        selection: $viewModel.newTaskDueDate,
                        displayedComponents: .date
                    )
                }
                
                Section {
                    Button("Add Task") {
                        viewModel.addTask()
                    }
                    .disabled(viewModel.newTaskTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .navigationTitle("Add New Task")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
#endif
                
            }
        }
    }
}

//import SwiftData
//
//#Preview {
//    let container = try! ModelContainer(for: TaskItem.self, inMemory: true)
//    let context = container.mainContext
//    let viewModel = TaskViewModel(modelContext: context)
//
//    AddTaskView(viewModel: viewModel)
//        .modelContainer(container)
//}
