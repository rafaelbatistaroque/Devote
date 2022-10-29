import SwiftUI

struct NewTaskItemView: View {

	//MARK: - Property
	@AppStorage("isDarkMode") var isDarkMode: Bool = false
	@Environment(\.managedObjectContext) private var viewContext
	@State private var task: String  = ""
	@FocusState private var isFocused: Bool
	@Binding var isShowing: Bool

	private var isButtonDisable: Bool {
		task.isEmpty
	}

	//MARK: - Functions
	func hideKeyboard() {
		isFocused = false
	}

	func clearTaskField() {
		task = ""
	}

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

	//MARK: - Body
    var body: some View {
			VStack{
				Spacer()
				VStack(spacing: 16) {
					TextField("New Task", text: $task)
						.foregroundColor(.pink)
						.font(.system(size: 24, weight: .bold, design: .rounded))
						.focused($isFocused)
						.padding()
						.background(isDarkMode ? Color(UIColor.tertiarySystemBackground) :  Color(UIColor.secondarySystemBackground))
						.cornerRadius(10)

					Button(action: {
						addItem()
						clearTaskField()
						isShowing = false
						hideKeyboard()
					}, label: {
						Spacer()
						Text("SAVE")
							.font(.system(size: 24, weight: .bold, design: .rounded))
						Spacer()
					})
					.disabled(isButtonDisable)
					.padding()
					.foregroundColor(.white)
					.background(isButtonDisable ? .blue : .pink)
					.cornerRadius(10)
				}
				.padding(.horizontal)
				.padding(.vertical, 20)
				.background(
					isDarkMode ? Color(UIColor.secondarySystemBackground) : Color.white
				)
				.cornerRadius(16)
				.shadow(color: Color(red:0, green: 0, blue: 0, opacity: 0.65), radius: 24)
				.frame(maxWidth: 640)
			}
			.padding()
    }
}

struct NewTaskItemView_Previews: PreviewProvider {
    static var previews: some View {
			NewTaskItemView(isShowing: .constant(true))
				.background(Color.gray.edgesIgnoringSafeArea(.all))
    }
}
