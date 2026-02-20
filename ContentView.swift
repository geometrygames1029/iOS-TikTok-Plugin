import SwiftUI

struct ContentView: View {
    @State private var isConnected = false
    @State private var selectedCountry = "USA"
    
    let countries = [
        ["name": "USA", "flag": "🇺🇸", "mcc": "310"],
        ["name": "Kazakhstan", "flag": "🇰🇿", "mcc": "401"],
        ["name": "Belarus", "flag": "🇧🇾", "mcc": "257"],
        ["name": "Germany", "flag": "🇩🇪", "mcc": "262"]
    ]

    var body: some View {
        VStack(spacing: 30) {
            Text("TikTok Region Changer")
                .font(.largeTitle).bold()
            
            // Кнопка ВКЛ/ВЫКЛ
            Button(action: { isConnected.toggle() }) {
                ZStack {
                    Circle()
                        .fill(isConnected ? Color.green : Color.red)
                        .frame(width: 150, height: 150)
                    Text(isConnected ? "ON" : "OFF")
                        .foregroundColor(.white)
                        .font(.system(size: 40, weight: .black))
                }
            }
            
            // Выбор региона
            Picker("Выбери страну", selection: $selectedCountry) {
                ForEach(countries, id: \.self) { country in
                    Text("\(country["flag"]!) \(country["name"]!)").tag(country["name"]!)
                }
            }
            .pickerStyle(.wheel)
            
            Text("Статус: \(isConnected ? "Имитация сим-карты \(selectedCountry)" : "Выключено")")
                .foregroundColor(.secondary)
        }
    }
}
