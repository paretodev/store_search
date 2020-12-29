//
//  SearchResult.swift
//  storesearch
//
//  Created by 한석희 on 12/25/20.
//

import Foundation

class ResultArray : Codable {
    //MARK: - Data Struct. String Repr.
    var resultCount = 0
    var results = [SearchResult]()
}
//
class SearchResult : Codable, CustomStringConvertible{
    //
    var artistName: String? = ""
    var trackName: String? = ""
    var kind : String? = ""
    var description: String {
        return "\nResult -Kind : \(kind ?? "None"),  Name : \(name), Artist Name : \(artistName ?? "None"), Genre : \(genre)"
    }
    var trackPrice : Double? = 0.0
    var currency : String?  = ""
    var imageSmall = ""
    var imageLarge = ""
    // MARK: - New Properties
    var trackViewUrl : String?
    var collectionName : String?
    var collectionViewUrl : String?
    var collectionPrice : Double?
    var itemPrice : Double?
    var itemGenre : String?
    var bookGenre : [String]?
    // MARK : - USE OPTIONALS TO MAKE COMMON VALUES
        // nil colescing
    var name : String {
        return trackName ?? collectionName ?? "" // 오디오북의 경우에는 컬렉션명을 취해야 한다.
    }
    var storeURL : String {
        return trackViewUrl ?? collectionViewUrl ?? "" // 오디오북의 경우에는 컬렉션view url을 취해야 한다.
    }
    var price : Double {
        return trackPrice ?? collectionPrice ?? itemPrice ?? 0.0 // 오디오북, software, music의 경우 가격을 나타내는 속성명이 다르다
    }
    var genre : String {
        if let genre = itemGenre {
            return genre
        }else if let genres = bookGenre {
            return genres.joined(separator: ", ")
        }
        return ""
    }
    // MARK:- type
        // kind값에 따라서 재정의함
    var type: String {
      let kind = self.kind ?? "audiobook" // if nil, returns "audiobook"
      switch kind {
        case "album": return "Album"
        case "audiobook": return "Audio Book"
        case "book": return "Book"
        case "ebook": return "E-Book"
        case "feature-movie": return "Movie"
        case "music-video": return "Music Video"
        case "podcast": return "Podcast"
        case "software": return "App"
        case "song": return "Song"
        case "tv-episode": return "TV Episode"
        default: break
      }
      return "Unknown"
    }
    var artist : String {
        return artistName ?? ""
    }
    
    //MARK: - Give CodingKeys for "Codable" : take the value for the key into this property
    enum CodingKeys : String, CodingKey {
        // Tell Codable how I want SearchResult properties to match -> JSON Data
        // class에 있는 모든 속성들에 대한 case를 제공해야함
        case imageSmall = "artworkUrl60"
        case imageLarge = "artworkUrl100"
        case itemGenre = "primaryGanreName"
        case bookGenre = "genres"
        case itemPrice = "price"
        // " " 에 있는 속성을 파싱할 때는 다음의 이름으로!! 라는 의미
        case kind, artistName, currency
        case trackName, trackPrice, trackViewUrl
        case collectionName, collectionViewUrl, collectionPrice
    }
    
    //
}

//MARK:- Operator Overloading
    // Overloading Operator
func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
    lhs.artistName = lhs.artistName ?? ""
    rhs.artistName = rhs.artistName ?? ""
    return lhs.artistName!.localizedStandardCompare(rhs.artistName!) == .orderedAscending
}

func > (lhs: SearchResult, rhs: SearchResult) -> Bool {
    lhs.artistName = lhs.artistName ?? ""
    rhs.artistName = rhs.artistName ?? ""
    return rhs.artistName!.localizedStandardCompare(lhs.artistName!) == .orderedAscending
}




