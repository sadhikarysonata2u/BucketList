//
//  TaskListView.swift
//  BucketList
//
//  Created by SUJOY on 05/09/25.
//

import SwiftUI
import SwiftData

struct TasksView: View {
    @StateObject private var viewModel: TaskViewModel
    
    init(viewModel: TaskViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Filter & Sort Controls
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
                    .onChange(of: viewModel.sortOption) { _, _ in
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




private struct MockTaskRepository_Preview: TaskRepositoryProtocol {
    private var sampleTasks: [TaskItem] = [
        TaskItem(title: "Buy groceries", dueDate: .now, priority: .high),
        TaskItem(title: "Walk the dog", dueDate: .now.addingTimeInterval(3600), priority: .medium),
        TaskItem(title: "Finish report", dueDate: nil, priority: .low)
    ]
    
    func fetchTasks() -> [TaskItem] { sampleTasks }
    func addTask(_ task: TaskItem) {}
    func updateTask(_ task: TaskItem) {}
    func deleteTask(_ task: TaskItem) {}
}



struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        let mockRepository = MockTaskRepository_Preview()
        let viewModel = TaskViewModel(repository: mockRepository)
        TasksView(viewModel: viewModel)
    }
}
