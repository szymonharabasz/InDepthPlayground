//
// Created by Szymon Harabasz on 25.09.21.
//

import Foundation

enum NetworkError: Error {
    case fetchFailed(Error)
}

enum SearchResultError: Error {
    case invalidTerm(String)
    case underlyingError(NetworkError)
    case invalidData
}

typealias SearchResult<Success> = Result<Success, SearchResultError>
typealias JSON = [String: Any]

extension Result {
    init(value: Success?, error: Failure?) {
        if let error = error {
            self = .failure(error)
        } else if let value = value {
            self = .success(value)
        } else {
            fatalError("Could not create Result")
        }
    }
}

func callURL(with url: URL, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
    let task = URLSession.shared.dataTask(with: url, completionHandler: {
        (data, response, error) -> Void in
        let dataTaskError = error.map { NetworkError.fetchFailed($0) }
        let result = Result<Data, NetworkError>(value: data, error: dataTaskError)
        completionHandler(result)

    })
    task.resume()
}

func search(term: String, completionHandler: @escaping (SearchResult<JSON>) -> Void) {
    let encodedString = term.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    let path = encodedString.map {  "https://itunes.apple.com/search?term=" + $0}

    guard let url = path.flatMap(URL.init) else {
        let result = SearchResult<JSON>.failure(.invalidTerm(term))
        completionHandler(result)
        return
    }

    callURL(with: url) { result in
        let convertedResult: SearchResult<JSON> = result
                .mapError { (networkError: NetworkError) -> SearchResultError in
                    return SearchResultError.underlyingError(networkError)
                }
                .flatMap { (data: Data) -> SearchResult<JSON> in
                    guard
                            let json = try? JSONSerialization.jsonObject(with: data, options: []),
                            let jsonDictionary = json as? JSON else {
                        return SearchResult.failure(.invalidData)
                    }
                    return SearchResult.success(jsonDictionary)
                }
        completionHandler(convertedResult)
    }
}

