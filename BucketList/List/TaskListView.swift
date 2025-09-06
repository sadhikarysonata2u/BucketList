//
//  TaskListView.swift
//  BucketList
//
//  Created by SUJOY on 05/09/25.
//

import SwiftUI
import SwiftData

struct TasksView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: TaskViewModel
    
    init() {
        let modelContext = ModelContext(TaskItem.container)
        _viewModel = StateObject(wrappedValue: TaskViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Filter and Sort Controls
                HStack {
                    Picker("Filter", selection: $viewModel.filterOption) {
                        ForEach(TaskViewModel.FilterOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Spacer()
                    
                    Picker("Sort", selection: $viewModel.sortOption) {
                        ForEach(TaskViewModel.SortOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: viewModel.sortOption) { _,_ in
                        viewModel.sortTasks()
                    }
                }
                .padding(.horizontal)
                
                // Tasks List
                List {
                    ForEach(viewModel.filterTasks()) { task in
                        TaskRowView(task: task, viewModel: viewModel)
                            .swipeActions {
                                Button("Delete", role: .destructive) {
                                    viewModel.deleteTask(task)
                                }
                            }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Tasks")
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.showAddTask.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
//#elseif os(macOS)
                
                
#endif
            }
            .sheet(isPresented: $viewModel.showAddTask) {
                AddTaskView(viewModel: viewModel)
            }
        }
    }
}

struct TaskRowView: View {
    let task: TaskItem
    @ObservedObject var viewModel: TaskViewModel
    
    var body: some View {
        HStack {
            Button {
                viewModel.toggleTaskCompletion(task)
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .strikethrough(task.isCompleted)
                    .foregroundColor(task.isCompleted ? .gray : .primary)
                
                if let dueDate = task.dueDate {
                    Text("Due: \(dueDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Circle()
                .fill(Color(task.priority.color))
                .frame(width: 12, height: 12)
        }
        .padding(.vertical, 4)
    }
}







#Preview {
    TasksView()
}
