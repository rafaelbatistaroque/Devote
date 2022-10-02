import SwiftUI

struct BackgoundImageView: View {
    var body: some View {
        Image("rocket")
				.resizable()
				.scaledToFill()
				.ignoresSafeArea(.all)
    }
}

struct BackgoundImageView_Previews: PreviewProvider {
    static var previews: some View {
        BackgoundImageView()
    }
}
