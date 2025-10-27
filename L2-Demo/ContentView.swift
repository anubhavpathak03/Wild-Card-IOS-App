//
//  ContentView.swift
//  L2-Demo
//
//  Created by anubhavpathak on 25/10/25.
//

import SwiftUI

struct ContentView: View {
    
    @State var playerScore:Int = 0
    @State var cpuScore:Int = 0
    
    @State var playerCard:String = "back"
    @State var cpuCard:String = "back"
    
    
    @State private var flipped = false
    
    
    @State private var showWinAlert:Bool = false // for win alert
    @State private var showTieAlert: Bool = false // for tie
    @State private var winner: String = ""
    
    var body: some View {
        ZStack{
            Image("background-plain")
                .resizable()
                .ignoresSafeArea(edges: .all)
            VStack {
                Spacer()
                
                Image("logo")
                    .shadow(radius: 10)
                
                Spacer()
                
                HStack {
                    Spacer()
                    CardView(imageName: playerCard, isFlipped: flipped)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.6)) {
                                flipped.toggle()
                            }
                        }
                        Spacer()
                    CardView(imageName: cpuCard, isFlipped: flipped)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.6)) {
                                flipped.toggle()
                            }
                        }
                    Spacer()
                }
                
                Spacer()
                
                Button{
                    deal()
                } label: {
                    Image("button")
                        .shadow(radius: 10.0)
                }
        
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    VStack {
                        Text("PLAYER")
                            .font(.title3)
                            .padding(.bottom, 10.0)
                        Text(String(playerScore))
                            .font(.largeTitle)
                    }
                    Spacer()
                    
                    VStack {
                        Text("CPU")
                            .font(.title3)
                            .padding(.bottom, 10.0)
                        Text(String(cpuScore))
                            .font(.largeTitle)
                    }
                    Spacer()
                    
                }
                .foregroundColor(.white)
                Spacer()
            }
        }
        // Tie alert
        .alert(isPresented: $showTieAlert) {
            Alert(
                title: Text("Tie!"),
                message: Text("Tie Happened!"),
                dismissButton: .default(Text("Continue")) {
                    flipped = false // Reset flip state after tie
                }
            )
        }
        
        .alert(isPresented: $showWinAlert) {
            Alert(
                title: Text("Game Over"),
                message: Text(winner),
                dismissButton: .default(Text("New Game")) {
                    resetGame()
                }
            )
        }
    }
    
    func deal() {
//    print("Deal card")  // for testing when we click on DEAL it prints "Deal Card" every time
        
        
//        randomise the Players Cards
        let Random_value_playerCard:Int = Int.random(in: 2...14)
        playerCard = "card" + String(Random_value_playerCard)
        
//        randomise the CPU cards
        let Random_value_cpuCard:Int = Int.random(in: 2...14)
        cpuCard = "card" + String(Random_value_cpuCard)
        
        withAnimation(.easeInOut(duration: 0.4)) {
            flipped = true
        }
        
//        update the score
        if(Random_value_cpuCard > Random_value_playerCard) {
            cpuScore += 1;
        }else if (Random_value_cpuCard < Random_value_playerCard) {
            playerScore += 1;
        }
        else {
            // Tie happen
            showTieAlert = true
            return
        }
        
        if(playerScore >= 10) {
            winner = "Player Wins!"
            showWinAlert = true
        }
        else if cpuScore >= 10 {
            winner = "CPU Wins!"
            showWinAlert = true
        }
    }
    
    
    func resetGame() {
        playerScore = 0;
        cpuScore = 0;
        playerCard = "back"
        cpuCard = "back"
        flipped = false
    }
}

// Custom CardView to handle rotation with front side visible
struct CardView: View {
    let imageName: String
    let isFlipped: Bool
    
    var body: some View {
        ZStack {
            // Front side
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 200)
                .shadow(radius: 10)
                .opacity(isFlipped ? 0 : 1) // Show front when not flipped
            
            // Front side mirrored for back
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 200)
                .shadow(radius: 10)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0)) // Mirror for back
                .opacity(isFlipped ? 1 : 0) // Show mirrored front when flipped
        }
        .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0),
            perspective: 0.5
        )
    }
}


#Preview {
    ContentView()
}
