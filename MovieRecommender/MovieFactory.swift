//
//  MovieFactory.swift
//  MovieRecommender
//
//  Created by Sitare Arslanturk on 14.01.2022.
//

import Foundation

func loadCSV(from csvFile: String) -> [Movie] {
    var csvToStruct = [Movie]()
    guard let filePath = Bundle.main.path(forResource: csvFile, ofType: "csv") else {
        return []
    }
    var data = ""
    do {
        data = try String(contentsOfFile: filePath)
    } catch {
        print(error)
        return []
    }
    
    var rows = data.components(separatedBy: "\n")
    let columnCount = rows.first?.components(separatedBy: ",").count
    rows.removeFirst()
    
    for row in rows {
        let csvColumns = row.components(separatedBy: ",")
        if csvColumns.count == columnCount {
            let movieStruct = Movie.init(raw: csvColumns)
            csvToStruct.append(movieStruct)
        }
    }
    return csvToStruct
}
