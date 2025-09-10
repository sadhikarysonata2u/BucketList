////
//////
//////  TaskViewModelTests.swift
//////  BucketList
//////
//////  Created by SUJOY on 08/09/25.
//////
////
//@testable import BucketList
//import XCTest
//
//final class MockTaskRepositoryClass: TaskRepositoryProtocol {
//    var tasks: [TaskItem] = []
//    
//    func fetchTasks() -> [TaskItem] {
//        tasks
//    }
//    
//    func addTask(_ task: TaskItem) {
//        tasks.append(task)
//    }
//    
//    func updateTask(_ task: TaskItem) {
//        // find & replace
//        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
//            tasks[index] = task
//        }
//    }
//    
//    func deleteTask(_ task: TaskItem) {
//        tasks.removeAll { $0.id == task.id }
//    }
//}
//
//
//final class TaskViewModelXCTests: XCTestCase {
//    var repository: MockTaskRepository!
//    var viewModel: TaskViewModel!
//    
//    override func setUp() {
//        super.setUp()
//        repository = MockTaskRepository()
//        viewModel = TaskViewModel(repository: repository)
//    }
//    
//    override func tearDown() {
//        repository = nil
//        viewModel = nil
//        super.tearDown()
//    }
//    
//    func testAddTask() {
//        // given
//        viewModel.newTaskTitle = "Buy Milk"
//        viewModel.newTaskPriority = .high
//        
//        // when
//        viewModel.addTask()
//        
//        // then
//        XCTAssertEqual(viewModel.tasks.count, 1)
//        XCTAssertEqual(viewModel.tasks.first?.title, "Buy Milk")
//        XCTAssertEqual(viewModel.tasks.first?.priority, .high)
//    }
//    
//    func testDeleteTask() {
//        // given
//        let task = TaskItem(title: "Temp Task", dueDate: nil, priority: .low)
//        repository.tasks = [task]
//        viewModel.fetchTasks()
//        
//        // when
//        viewModel.deleteTask(task)
//        
//        // then
//        XCTAssertTrue(viewModel.tasks.isEmpty)
//    }
//    
//    func testToggleCompletion() {
//        // given
//        var task = TaskItem(title: "Walk Dog", dueDate: nil, priority: .medium)
//        repository.tasks = [task]
//        viewModel.fetchTasks()
//        
//        // when
//        viewModel.toggleTaskCompletion(task)
//        
//        // then
//        XCTAssertTrue(viewModel.tasks.first?.isCompleted ?? false)
//    }
//    
//    func testSortByTitle() {
//        // given
//        repository.tasks = [
//            TaskItem(title: "Zebra", dueDate: nil, priority: .medium),
//            TaskItem(title: "Apple", dueDate: nil, priority: .high)
//        ]
//        viewModel.fetchTasks()
//        
//        // when
//        viewModel.sortOption = .title
//        viewModel.sortTasks()
//        
//        // then
//        XCTAssertEqual(viewModel.tasks.map { $0.title }, ["Apple", "Zebra"])
//    }
//    
//    func testFilterCompleted() {
//        // given
//        let t1 = TaskItem(title: "Done", dueDate: nil, priority: .low, isCompleted: true)
//        let t2 = TaskItem(title: "Pending", dueDate: nil, priority: .low, isCompleted: false)
//        repository.tasks = [t1, t2]
//        viewModel.fetchTasks()
//        
//        // when
//        viewModel.filterOption = .completed
//        let filtered = viewModel.filterTasks()
//        
//        // then
//        XCTAssertEqual(filtered.count, 1)
//        XCTAssertEqual(filtered.first?.title, "Done")
//    }
//}
