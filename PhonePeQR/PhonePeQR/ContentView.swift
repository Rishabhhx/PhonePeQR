//
//  ContentView.swift
//  PhonePeQR
//
//  Created by Rishabh Sharma on 02/12/24.
//

import SwiftUI
import CodeScanner

struct ContentView : View {
    @State var isPresentingScanner = false
    @State var scannedCode: String = "Scan a QR code to get started."
    @Environment(\.openURL) var openURL

    var body: some View {
        ZStack {
            CodeScannerView(codeTypes: [.qr]) { result in
                switch result {
                case .success(let success):
                    let url = success.string
                    openURL(URL(string: url)!)
                case .failure(let failure):
                    print(failure)
                }
            }
            ScannerView()
        }
        .ignoresSafeArea()
    }
}

struct ScannerView: View {
    @State var animate: Bool = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.black.opacity(0.2))
            ScannerAreaView(animate: $animate)
                .offset(y: -100)
            VStack {
                Spacer()
                HStack {
                    Image("bhim")
                        .resizable()
                        .frame(width: 70, height: 20)
                    Image("upi")
                        .resizable()
                        .frame(width: 50, height: 20)
                }
                .padding(40)
            }
        }
        .compositingGroup()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


#Preview {
    ContentView()
}

struct EdgeRectangleView: View {
    @Binding var animate: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .trim(from: animate ? 0.35 : 0.34, to: animate ? 0.4 : 0.41)
            .stroke(Color(red: 132/255, green: 44/255, blue: 240/255), style: StrokeStyle(lineWidth: 10, lineCap: .round))
    }
}


struct ScannerAreaView: View {
    @Binding var animate: Bool
    var rotationDegrees: [Double] = [0, 90, 180, 270]
    @State var timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Rectangle()
                .blendMode(.destinationOut)
                .clipShape(.rect(cornerRadius: 20))
            ForEach(0..<4) { item in
                EdgeRectangleView(animate: $animate)
                    .rotationEffect(Angle(degrees: rotationDegrees[item]))
            }
            .padding(20)
        }
        .onReceive(timer, perform: { _ in
            animate.toggle()
        })
        .frame(width: animate ? 320 : 300, height: animate ? 320 : 300)
        .animation(.easeInOut(duration: 0.9), value: animate)
    }
}
