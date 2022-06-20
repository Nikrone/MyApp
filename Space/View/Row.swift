//
//  Row.swift
//  Space
//
//  Created by Evgeniy Nosko on 25.04.22.
//

import SwiftUI

struct Row: View {
    let photoInfo: PhotoInfo
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(photoInfo.date).bold()
            Text(photoInfo.title)
        }
    }
}

struct Row_Previews: PreviewProvider {
    static var previews: some View {
        Row(photoInfo: PhotoInfo.createDefault())
            .previewLayout(.fixed(width: 400, height: 100))
    }
}
