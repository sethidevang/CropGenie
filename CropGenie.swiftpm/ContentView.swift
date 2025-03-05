import SwiftUI
import CoreML

struct HomeView: View {
    @State private var isButtonPressed = false // State for button animation
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Image
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.5)
               
                
                VStack {
                    Spacer()
                    
                    // Title
//                    Text("Crop Prediction")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                        .foregroundColor(Color(hex: "#022318"))
//                        .padding(.bottom, 20)
//                    
                    // Description
//                    Text("Predict the best crop for your farm based on environmental and soil conditions.")
//                        .font(.title2)
//                        .multilineTextAlignment(.center)
//                        .foregroundColor(Color(hex: "#022318"))
//                        .padding(.horizontal, 40)
//                        .padding(.bottom, 40)
//                    
                    // Predict Crop Button
                    NavigationLink(destination: ContentView()) {
                        HStack {
                            Text("Predict Crop")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color(hex: "#022318"))
                            
                            Image(systemName: "leaf.fill") // Add an icon
                                .font(.title)
                                .foregroundColor(Color(hex: "#022318"))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "E3B255"))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                        .scaleEffect(isButtonPressed ? 0.95 : 1.0) // Add scaling animation
                        .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0), value: isButtonPressed)
                    }
                    .padding(.horizontal, 40)
                    .simultaneousGesture(
                        TapGesture()
                            .onEnded {
                                isButtonPressed = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    isButtonPressed = false
                                }
                            }
                    )
                    
                    Spacer()
                }
            }
//            .navigationTitle("Crop Predictor")
//            .toolbarBackground(.hidden, for: .navigationBar) // Make navigation bar transparent
        }
        .accentColor(Color(hex: "#000000"))
    }
}

struct ContentView: View {
    @State private var n = 100.0 // Nitrogen (double)
    @State private var p = 100.0 // Phosphorus (double)
    @State private var temperature = 20.0 // Temperature (double)
    @State private var humidity = 60.0 // Humidity (double)
    @State private var ph = 7.0 // pH (double)
    @State private var rainfall = 100.0 // Rainfall (double)
    
    @State private var predictedLabel: String?
    @State private var navigate = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Enter Crop Parameters")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .foregroundColor(Color(hex: "#022318"))
                        .background(Color(hex: "E3B255"))
                        .cornerRadius(10)
                    
                    Spacer()
                    
                    Group {
                        CustomSlider(label: "Nitrogen (kg/ha):", value: $n, range: 0...200, step: 1.0).accentColor(.red)
                        CustomSlider(label: "Phosphorus (kg/ha):", value: $p, range: 0...200, step: 1.0)
                        CustomSlider(label: "Temperature (°C):", value: $temperature, range: 0...50, step: 0.2)
                        CustomSlider(label: "Humidity (%):", value: $humidity, range: 0...100, step: 0.5)
                        CustomSlider(label: "Rainfall (mm):", value: $rainfall, range: 0...300, step: 10)
                        CustomSlider(label: "pH:", value: $ph, range: 1...14, step: 0.1)
                    }
                    .font(.title2)
                    .padding(.horizontal)
                    .background(Color.white.opacity(0.4))
                    .cornerRadius(20)
                    
                    Button("Submit") {
                        predictCrop()
                    }
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "E3B255"))
                    .foregroundColor(Color(hex: "#022318"))
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .padding()
                    
                    NavigationLink("", destination: ResultView(label: predictedLabel ?? ""), isActive: $navigate)
                        .hidden()
                }
                .frame(maxHeight: .infinity)
                .padding()
                Spacer()
                
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .background(
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.5)
            )
        }
//        .navigationTitle("Home")
//        .navigationBarBackButtonHidden(true)
        .navigationBarBackButtonHidden(false)
//        .presentationMode.wrappedValue.dismiss()
//        .navigationBarBackButtonHidden(true) // Hide default back button
//               .navigationTitle("")
        .toolbarBackground(.visible, for: .navigationBar) // Show the navigation bar background
        .toolbarBackground(.automatic, for: .navigationBar)
       // Hide default back button
            
//        .navigationTitle("Crop Prediction Form")
//        .navigationBarTitleDisplayMode(.automatic)
    }
    
    func predictCrop() {
        guard let model = try? crop(configuration: MLModelConfiguration()) else {
            alertMessage = "Failed to load model. Please try again."
            showAlert = true
            return
        }
        
        let input = cropInput(N: Int64(n),
                              P: Int64(p),
                              temperature: temperature,
                              humidity: humidity,
                              ph: ph,
                              rainfall: rainfall)
        
        do {
            let prediction = try model.prediction(input: input)
            predictedLabel = prediction.label
            navigate = true
        } catch {
            alertMessage = "Error making prediction: \(error.localizedDescription)"
            showAlert = true
        }
    }
}

struct CustomSlider: View {
    var label: String
    @Binding var value: Double
    var range: ClosedRange<Double>
    var step: Double = 1.0
    
    var body: some View {
        VStack {
            HStack {
                Text(label)
                    .foregroundColor(Color(hex: "#022318"))
                    .fontWeight(.semibold)
                Spacer()
                Text(String(format: "%.1f", value))
                    .foregroundColor(Color(hex: "#022318"))
            }
            .padding()
            .background(Color.white.opacity(0.3))
            .cornerRadius(10)
            Slider(value: $value, in: range, step: step)
                .accentColor(Color(hex: "#D1772A"))
        }
        .padding(.vertical, 10)
       
    }
}

struct ResultView: View {
    var label: String
    
    let cropImages: [String: String] = [
        "rice": "rice",
        "maize": "maize",
        "chickpea": "chickpea",
        "kidneybeans": "kidney beans",
        "cotton": "cotton",
        "pigeonpeas": "pigeonpeas",
        "mothbeans": "mothbeans",
        "mungbean": "mungbean",
        "banana": "banana",
        "apple": "apple",
        "orange": "orange",
        "mango": "mango",
        "pomegranate": "pomegranate",
        "coconut": "coconut",
        "Peanut": "peanut_image",
        "coffee": "coffee-beans",
        "lentil": "lentil",
        "grapes": "grapes",
        "watermelon": "watermelon",
        "blackgram": "blackgram",
        "muskmelon": "muskmelon",
        "papaya": "papaya",
        "jute": "jute"
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#B7E4C7"), Color(hex: "#A8D08D")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Predicted Crop Type")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#022318"))
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .shadow(radius: 5)
                    
                
                if let imageName = cropImages[label.lowercased().trimmingCharacters(in: .whitespaces)] {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 220, height: 220)
                        
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(radius: 10)
                    }
                    .padding()
                } else {
                    Text("Image not available")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Text(label)
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(Color(hex: "#E3B255"))
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .textCase(.uppercase)
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("Prediction Result", displayMode: .inline)
        }
    }
}

struct AppView: View {
    var body: some View {
        HomeView()
    }
}

#Preview {
    AppView()
}

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexSanitized.hasPrefix("#") {
            hexSanitized.removeFirst()
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue >> 16) & 0xFF) / 255.0
        let green = Double((rgbValue >> 8) & 0xFF) / 255.0
        let blue = Double(rgbValue & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}
