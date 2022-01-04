
import Foundation
import Alamofire

class Manager {
    func doTask(longitude: Double, latitude: Double, radius: Double, onSuccess: @escaping ([Result])->Void, onFailure: @escaping (String)-> Void)  {
        let key = "AIzaSyC-6F4go5xJJmNM8_mL_Ihww6ORS6NF0lo"
        AF.request("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(longitude)%2C\(latitude)&radius=\(radius)&type=parking&keyword=parking&key=\(key)").responseDecodable(of: PlacesResult.self) { responseJSON in
            guard let statusCode = responseJSON.response?.statusCode, (responseJSON.error==nil) else { return }
            
            print("statusCode: ", statusCode)
            
            if (200..<300).contains(statusCode) {
                if let result = responseJSON.value?.results{
                    onSuccess(result)
                }else{
                    onFailure("|fffef")
                }
               
            } else {
                onFailure("|32323232")
            }
        }
    }
    
}

