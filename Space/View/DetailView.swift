//
//  DetailView.swift
//  Space
//
//  Created by Evgeniy Nosko on 25.04.22.
//

import SwiftUI

struct DetailView: View {
    init(photoInfo: PhotoInfo, manager: NetworkManager) {
        print("init detail for \(photoInfo.date)")
        self.photoInfo = photoInfo
        self.manager = manager
    }
    
    @ObservedObject var manager: NetworkManager
    let photoInfo: PhotoInfo
    
    var body: some View {
        VStack {
            if photoInfo.image != nil {
                Image(uiImage: self.photoInfo.image!)
                    .resizable()
                    .scaledToFit()
                    .overlay(NavigationLink(destination: InteractiveImageView(image: photoInfo.image!)) {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(.title).padding()
                    }, alignment: .bottomTrailing)
            } else {
                LoadingAnimationBox()
                    .padding()
                    .frame(height: 300)
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text(photoInfo.title).font(.headline)
                    Text(photoInfo.description)
                }
            }.padding()
        }
        .navigationBarTitle(Text(photoInfo.date), displayMode: .inline)
        .onAppear {
            self.manager.fetchImage(for: self.photoInfo)
        }
    }
}

struct APODDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(photoInfo: PhotoInfo.createDefault(), manager: NetworkManager())
        }
    }
}
