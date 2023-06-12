//
//  ContentView.swift
//  Pinch
//
//  Created by Max Alva on 12/06/23.
//

import SwiftUI

struct ContentView: View {
  // MARK: - PROPERTIES
  @State private var isAnimating: Bool = false
  @State private var imageScale: CGFloat = 1
  @State private var imageOffset: CGSize = .zero
  
  // MARK: - RESET FUNCTIONS
  
  func resetImageState() {
    return withAnimation(.spring()) {
      imageScale = 1
      imageOffset = .zero
    }
  }


  var body: some View {
    
    // MARK: - CONTENT
    NavigationView {
      ZStack {
        Color.clear
        // MARK: - PAGE IMAGE
        Image("magazine-front-cover")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .cornerRadius(10)
          .padding()
          .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
          .opacity(isAnimating ? 1 : 0)
          .offset(x: imageOffset.width, y: imageOffset.height)
          .scaleEffect(imageScale)
          .onTapGesture(count: 2, perform: {
            if imageScale == 1 {
              withAnimation(.spring()) {
                imageScale = 5
              }
            } else {
              resetImageState()
            }
          })
        // MARK: - DRAG GESTURE
          .gesture(
            DragGesture()
              .onChanged { value in
                withAnimation(.linear(duration: 1)) {
                  imageOffset = value.translation
                }
              }
              .onEnded { _ in
                if imageScale <= 1 {
                  resetImageState()
                }
              }
          )
      }
      .navigationTitle("Pinch & Zoom")
      .navigationBarTitleDisplayMode(.inline)
      .onAppear(perform: {
        withAnimation(.linear(duration: 1)) {
          isAnimating = true
        }
      })
      // MARK: - INFO PANEL
      .overlay(
        InfoPanelView(scale: imageScale, offset: imageOffset)
          .padding(.horizontal)
          .padding(.top, 30)
        , alignment: .top
      )
      // MARK: - CONTROLS
      .overlay(
        Group {
          HStack {
            Button {
              withAnimation(.spring()) {
                if imageScale > 1 {
                  imageScale -= 1
                  
                  if imageScale <= 1 {
                    resetImageState()
                  }
                }
              }
            } label: {
              ControlImageView(icon: "minus.magnifyingglass")
            }
            
            Button {
              resetImageState()
            } label: {
              ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
            }
            
            Button {
              withAnimation(.spring()) {
                if imageScale < 5 {
                  imageScale += 1
                  
                  if imageScale > 5 {
                    imageScale = 5
                  }
                }
              }
            } label: {
              ControlImageView(icon: "plus.magnifyingglass")
            }
          }
          .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
          .background(.ultraThinMaterial)
          .cornerRadius(12)
          .opacity(isAnimating ? 1 : 0)
        }
          .padding(.bottom, 30)
        , alignment: .bottom
      )
    }
    .navigationViewStyle(.stack)
  }
}

// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
