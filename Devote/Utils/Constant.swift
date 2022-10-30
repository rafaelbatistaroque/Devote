import SwiftUI

//MARK: - formatter
let itemFormatter: DateFormatter = {
	let formatter = DateFormatter()
	formatter.dateStyle = .short
	formatter.timeStyle = .medium
	return formatter
}()

//MARK: UI
var backgroundGradient: LinearGradient {
	LinearGradient(colors: [.pink, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
}

//MARK: UX
let feedback = UINotificationFeedbackGenerator()
