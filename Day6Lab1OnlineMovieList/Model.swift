//
//  Model.swift
//  Day6Lab1OnlineMovieList
//
//  Created by Hossam on 08/05/2023.
//

import Foundation


public class Item : NSObject, Decodable{
    var id : String?
    var rank : String?
    var header : String?
    var image : String?
    var weekend : String?
    var gross : String?
    var weeks : String?
    
    enum CodingKeys: String, CodingKey{
        case id = "id"
        case rank = "rank"
        case header = "title"
        case image = "image"
        case weekend = "weekend"
        case gross = "gross"
        case weeks = "weeks"
    }
}

class MyResult : Decodable {
    var items : [Item]
    var errorMessage : String?
}

func loadData(compilitionHandler: @escaping (MyResult?) -> Void){
    //1-
    let url = URL(string: "https://imdb-api.com/en/API/BoxOffice/k_96idbvgo")
    guard let urlFinal = url else {
        return
    }
    //2-
    let request = URLRequest(url: urlFinal)
    //3-
    let session = URLSession(configuration: .default)
    //4-
    let task = session.dataTask(with: request) { (data, response, error) in
        //6-
        guard let data = data else{
            return
        }
        do{
            let result = try JSONDecoder().decode(MyResult.self, from: data)
           
            compilitionHandler(result)
            
        }catch let error{
            print(error.localizedDescription)
            compilitionHandler(nil)
        }
    }
    //5-
    task.resume()
    
}
