//
//  MultiNetworkManager.swift
//  Space
//
//  Created by Evgeniy Nosko on 25.04.22.
//

import Foundation
import Combine
import SwiftUI

class NetworkManager: ObservableObject {
    @Published var info = [PhotoInfo]()
    @Published var daysFromToday: Int = 0
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        $daysFromToday
            .map { daysFromToday in
                return API.createDate(daysFromToday: daysFromToday)
            }.map { date in
                return API.createURL(for: date)
            }.flatMap { (url) in
                return API.createPublisher(url: url)
            }.scan([]) { (partialValue, newValue)  in
                return partialValue + [newValue]
            }
            .tryMap({ (infos)  in
                infos.sorted { $0.formattedDate > $1.formattedDate }
            })
            .catch { (error)  in
                Just([PhotoInfo]())
            }
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .assign(to: \.info, on: self)
            .store(in: &subscriptions)
        getMoreData(for: 22)
    }
    
    func getMoreData(for times: Int) {
        for _ in 0..<times {
            self.daysFromToday += 1
        }
    }
    
    func fetchImage(for photoInfo: PhotoInfo) {
        guard photoInfo.image == nil, let url = photoInfo.url else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("fetch image error: \(error.localizedDescription)")
            } else if let data = data, let image = UIImage(data: data),
                     let index = self.info.firstIndex(where: { $0.id == photoInfo.id }) {
                DispatchQueue.main.async {
                    self.info[index].image = image
                }
            }
        }
        task.resume()
    }
}
