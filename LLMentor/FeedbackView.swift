import SwiftUI

struct FeedbackView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                Spacer()

                // Header Section
                VStack(spacing: 16) {
                    Text("We'd Love to Hear From You!")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    
                    Text("Your input helps us improve LLMentor and ensure it meets your needs. Share your thoughts, suggestions, or any issues.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                // Email Section
                VStack(spacing: 16) {
                    Text("Email Your Feedback To:")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    
                    Text("info@pharmatools.ai")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.center)
                        .onTapGesture {
                            // Open email app
                            if let url = URL(string: "mailto:info@pharmatools.ai") {
                                UIApplication.shared.open(url)
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .background(
                            Capsule()
                                .fill(Color.blue.opacity(0.1))
                        )
                }
                .padding(.horizontal, 16)

                // Encouragement Section
                VStack(spacing: 12) {
                    Text("We appreciate every message we receive!")
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    Text("Your feedback is invaluable to us and helps make LLMentor even better for everyone.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Spacer()

                // Close Button
                Button(action: {
                    dismiss()
                }) {
                    Text("Close")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.bluePrimary)
                        .cornerRadius(8)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                .padding(.horizontal, 24)

                Spacer()
            }
            .padding(.vertical, 16)
            .navigationTitle("Feedback")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    FeedbackView()
}
