import Foundation

//MARK: formatter
private let itemFormatter: DateFormatter = {
	let formatter = DateFormatter()
	formatter.dateStyle = .short
	formatter.timeStyle = .medium
	return formatter
}()

//MARK: UI

//MARK: UX
