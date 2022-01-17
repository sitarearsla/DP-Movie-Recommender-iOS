//
//  MovieDataSource.swift
//  MovieRecommender
//
//  Created by Sitare Arslanturk on 12.01.2022.
//

import Foundation


protocol MovieDataSourceDelegate {
    func moviesRecommended(movieList: [String])
}

class MovieDataSource {
    var delegate : MovieDataSourceDelegate?
    let endpoint = "http://127.0.0.1:5000/"
    
    func postChosenMovies(_ movies: [String:[String: Int]]) {
        guard let url = URL(string: endpoint) else {
            print("Error in creating URL from endpoint")
            return
        }
//        let movies = ["movies":["10 Cloverfield Lane (2016)": 4, "\'Salem\'s Lot (2004)": 5]]
        let movieData = try? JSONSerialization.data(withJSONObject: movies)
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(String(describing: movieData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = movieData
        
        let task = session.dataTask(with: request){
            (data, response, error) in
            guard error == nil else {
                print("Error calling GET")
                print(error!)
                return
            }
            guard data != nil else {
                print("Error on receiving data")
                return
            }
            do {
                guard let movies = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any] else {
                    print("Error converting data to JSON -1")
                    return
                }
                
                guard let movieList = movies["results"] as? NSArray else {
                    print("Error getting results from movies")
                    return
                }
                DispatchQueue.main.async {
                    self.delegate?.moviesRecommended(movieList: movieList as! [String])
                }
            } catch {
                print("Error converting data to JSON -2")
            }
        }
        task.resume()
    }
}
