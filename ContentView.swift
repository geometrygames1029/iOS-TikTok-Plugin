import SwiftUI

struct ContentView: View {
    @State private var position: CGFloat = 0.5 // 0.5 — середина
    @State private var winner: String? = nil
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Зона Брата (сверху)
                ZStack {
                    Color.blue
                    Text("БРАТ").font(.largeTitle).bold().rotationEffect(.degrees(180))
                }
                .frame(maxHeight: .infinity)
                .frame(height: UIScreen.main.bounds.height * position)
                .onTapGesture { self.moveLine(by: 0.02) } // Брат тянет вниз (увеличивает свою долю)

                // Зона Твоя (снизу)
                ZStack {
                    Color.red
                    Text("ТЫ").font(.largeTitle).bold()
                }
                .frame(maxHeight: .infinity)
                .onTapGesture { self.moveLine(by: -0.02) } // Ты тянешь вверх
            }

            // Линия фронта
            Rectangle()
                .fill(Color.white)
                .frame(height: 10)
                .offset(y: (UIScreen.main.bounds.height * position) - (UIScreen.main.bounds.height / 2))

            if let winnerName = winner {
                VStack {
                    Text("Победа: \(winnerName)!")
                        .font(.system(size: 40, weight: .black))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(20)
                    
                    Button("РЕВАНШ") {
                        withAnimation {
                            position = 0.5
                            winner = nil
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }

    func moveLine(by amount: CGFloat) {
        guard winner == nil else { return }
        
        withAnimation(.interactiveSpring()) {
            position += amount
            if position >= 0.9 { winner = "БРАТ" }
            if position <= 0.1 { winner = "ТЫ" }
        }
    }
}
