import SwiftUI
import PassKit

struct ContentView: View {
    @State private var question: String = ""
    @State private var result: String = "Задай вопрос судьбе"
    @State private var showingPaymentSheet = false
    @State private var isProcessing = false

    var body: some View {
        VStack(spacing: 30) {
            Text("🔮 Рандомайзер")
                .font(.largeTitle).bold()
            
            TextField("Введите ваш вопрос...", text: $question)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Text(isProcessing ? "Обработка платежа..." : result)
                .font(.title2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .frame(height: 100)

            Button(action: {
                if !question.isEmpty {
                    triggerFakePayment()
                }
            }) {
                HStack {
                    Image(systemName: "applelogo")
                    Text("Сыграть за 99₽")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding()
    }

    // Имитация вызова Apple Pay
    func triggerFakePayment() {
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.fake.id"
        request.countryCode = "RU"
        request.currencyCode = "RUB"
        request.supportedNetworks = [.visa, .masterCard, .mir]
        request.merchantCapabilities = .capability3DS
        
        // Сумма в чеке
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "1 попытка в Рандомайзере", amount: 99.00)
        ]

        let controller = PKPaymentAuthorizationController(paymentRequest: request)
        controller.delegate = PaymentHandler { success in
            if success {
                generateAnswer()
            }
        }
        controller.present(completion: nil)
    }

    func generateAnswer() {
        isProcessing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            result = Bool.random() ? "ДА" : "НЕТ"
            isProcessing = false
            question = ""
        }
    }
}

// Хэндлер, который симулирует "ОК" без реальной транзакции
class PaymentHandler: NSObject, PKPaymentAuthorizationControllerDelegate {
    var onCompletion: (Bool) -> Void

    init(onCompletion: @escaping (Bool) -> Void) {
        self.onCompletion = onCompletion
    }

    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        // Здесь магия: мы просто говорим системе, что всё успешно
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        onCompletion(true)
    }

    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss(completion: nil)
    }
}
