//
//  UrlRequest+Extension.swift
//  GoodWeather
//
//  Created by PuNeet on 03/02/21.
//  Copyright © 2021 Mohammad Azam. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit


struct Resourse<T> {
    let url: URL
}

extension URLRequest {
    
    static func load<T: Decodable>(resourse: Resourse<T>) -> Observable<T>{
        return Observable.just(resourse.url).flatMap{ url -> Observable<(response: HTTPURLResponse, data: Data)> in
            let request = URLRequest(url: url)
            return URLSession.shared.rx.response(request: request)
        }.map{ response, data -> T in
            
            if 200..<300 ~= response.statusCode{
                return try JSONDecoder().decode(T.self, from: data)
            }else{
                throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
            }
        }.asObservable()
    }
    
//    static func load<T: Decodable>(recourse: Resourse<T>) -> Observable<T?>{
//        return Observable.from([recourse.url]).flatMap { url -> Observable<Data> in
//            let request = URLRequest(url: url)
//            return URLSession.shared.rx.data(request: request)
//        }.map{ data -> T? in
//            return try? JSONDecoder().decode(T.self, from: data)
//        }.asObservable()
//    }
}
