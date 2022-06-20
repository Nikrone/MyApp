//
//  ListView.swift
//  Space
//
//  Created by Evgeniy Nosko on 25.04.22.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var manager = NetworkManager()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(manager.info) { info in
                    NavigationLink(destination: DetailView(photoInfo: info, manager: self.manager)) {
                        Row(photoInfo: info)
                    }
                    .onAppear {
                        if let index = self.manager.info.firstIndex(where: { $0.id == info.id }),
                           index == self.manager.info.count - 1 && self.manager.daysFromToday == self.manager.info.count - 1 {
                            self.manager.getMoreData(for: 10)
                        }
                    }
                }
                
                ForEach(0..<15) { _ in
                    Rectangle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(height: 50)
                }
            }.navigationBarTitle("Picture of the Day")
        }
    }
}

struct APODListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}

