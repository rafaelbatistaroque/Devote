import SwiftUI
import CoreData

struct ContentView: View {
	//MARK: property
	@State var task: String = ""
	@FocusState private var isFocused: Bool
	private var isButtonDisable: Bool {
		task.isEmpty
	}

//MARK: - functions
	func hideKeyboard() {
		isFocused = false
	}

	func clearTaskField() {
		task = ""
	}

	//MARK: - fetching data
	@Environment(\.managedObjectContext) private var viewContext
	
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
		animation: .default)
	private var items: FetchedResults<Item>

	//MARK: - function
	private func addItem() {
		withAnimation {
			let newItem = Item(context: viewContext)
			newItem.timestamp = Date()
			newItem.task = task
			newItem.completion = false
			newItem.id = UUID()

			do {
				try viewContext.save()
			} catch {
				let nsError = error as NSError
				fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
			}
		}
	}

	private func deleteItems(offsets: IndexSet) {
		withAnimation {
			offsets.map { items[$0] }.forEach(viewContext.delete)

			do {
				try viewContext.save()
			} catch {
				let nsError = error as NSError
				fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
			}
		}
	}

	var body: some View {
		NavigationView {
			VStack {
				VStack(spacing: 16) {
					TextField("New Task", text: $task)
						.focused($isFocused)
						.padding()
						.background(Color(UIColor.systemGray6))
						.cornerRadius(10)

					Button(action: {
						addItem()
						clearTaskField()
						hideKeyboard()
					}, label: {
						Spacer()
						Text("Save")
						Spacer()
					})
					.disabled(isButtonDisable)
					.padding()
					.font(.headline)
					.foregroundColor(.white)
					.background(isButtonDisable ? .gray : .pink)
					.cornerRadius(10)
				}
				.padding()

				List {
					ForEach(items) { item in
						VStack(alignment: .leading, spacing: 2) {
							Text(item.task ?? "")
								.font(.headline)
								.fontWeight(.bold)

							Text("Item at \(item.timestamp!, formatter: itemFormatter)")
								.font(.footnote)
								.foregroundColor(.gray)
						}
					}
					.onDelete(perform: deleteItems)
				}
				.onTapGesture {
					hideKeyboard()
				}
			}
			.navigationBarTitle("Daily Tasks")
			.navigationBarTitleDisplayMode(.large)
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					EditButton()
				}
			}
			Text("Select an item")
		}
	}
}

//MARK: - preview
struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
