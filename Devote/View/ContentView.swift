import SwiftUI
import CoreData

struct ContentView: View {
	//MARK: - Properties

	@AppStorage("isDarkMode") private var isDarkMode: Bool = false
	@State private var showNewTaskItem: Bool = false

	//MARK: - fetching data
	@Environment(\.managedObjectContext) private var viewContext
	
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
		animation: .default)
	private var items: FetchedResults<Item>

	//MARK: - function
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
		NavigationStack {
			ZStack {

				VStack {

					HStack(spacing: 10) {
						Text("Devote")
							.font(.system(.largeTitle, design: .rounded))
							.fontWeight(.heavy)
							.padding(.leading, 4)

						Spacer()

						EditButton()
							.font(.system(size: 16, weight: .semibold, design: .rounded))
							.padding(.horizontal, 10)
							.frame(minWidth: 70, minHeight: 24)
							.background(Capsule().stroke(.white, lineWidth: 2))

						Button(action: {
							isDarkMode.toggle()
						}, label: {
							Image(systemName: isDarkMode ? "moon.circle.fill" : "moon.circle")
								.resizable()
								.frame(width: 24, height: 24)
								.font(.system(.title, design: .rounded))
						})
					}
					.padding()
					.foregroundColor(.white)

					Spacer(minLength: 80)

					Button(action: {
						showNewTaskItem = true
					}, label: {
						Image(systemName: "plus.circle")
							.font(.system(size: 30, weight: .semibold, design: .rounded))

						Text("New Task")
							.font(.system(size: 24, weight: .bold, design: .rounded))
					})
					.foregroundColor(.white)
					.padding(.horizontal, 20)
					.padding(.vertical, 15)
					.background(
						LinearGradient(colors: [Color.pink, Color.blue], startPoint: .leading, endPoint: .trailing)
							.clipShape(Capsule())
					)
					.shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 9, x: 0, y: 4.0)

					List {
						ForEach(items) { item in
							ListRowItemView(item: item)
						}
						.onDelete(perform: deleteItems)
					}
					.listStyle(InsetGroupedListStyle())
					.scrollContentBackground(.hidden)
					.shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12)
					.padding(.vertical, 0)
					.frame(maxWidth: 640)
				}

				if showNewTaskItem {
					BlankView()
						.onTapGesture {
							withAnimation() {
								showNewTaskItem = false
							}
						}
					NewTaskItemView(isShowing: $showNewTaskItem)
				}
			}
			.navigationBarTitle("Daily Tasks")
			.navigationBarTitleDisplayMode(.large)
			.toolbar(.hidden)
			.background(BackgoundImageView())
			.background(backgroundGradient.ignoresSafeArea(.all))
		}
	}
}

//MARK: - preview
struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
