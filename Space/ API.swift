//
//   API.swift
//  Space
//
//  Created by Evgeniy Nosko on 25.04.22.
//

import Foundation
import Combine

struct API {
    static func createFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    static  func createURL(for date: Date) -> URL {
        let formatter = API.createFormatter()
        let dateString = formatter.string(from: date)
        let url = URL(string: Constants.baseURL)!
        let fullURL = url.withQuery(["api_key" : Constants.key, "date" : dateString])!
        return fullURL
    }
    
    static func createDate(daysFromToday: Int) -> Date {
        let today = Date()
        if let newDate = Calendar.current.date(byAdding: .day, value: -daysFromToday, to: today) {
            return newDate
        } else {
            return today
        }
    }
    
    static func createPublisher(url: URL) -> AnyPublisher<PhotoInfo, Never> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PhotoInfo.self, decoder: JSONDecoder())
            .catch { (error)  in
                Just(PhotoInfo())
            }
            .eraseToAnyPublisher()
    }
}

extension URL {
    func withQuery(_ query: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = query.map { URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}
