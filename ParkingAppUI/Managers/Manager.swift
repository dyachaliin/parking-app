
import Foundation

class Manager {
    let config: URLSessionConfiguration
    let session: URLSession

    let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=50.4558284%2C30.4099940&radius=1500&type=parking&keyword=parking&key=AIzaSyC-6F4go5xJJmNM8_mL_Ihww6ORS6NF0lo")!
   
    init() {
        self.config = URLSessionConfiguration.default
        self.session = URLSession(configuration: config)
    }
    
    func dotask() {
        let task = session.dataTask(with: url) { data, response, error in

            guard error == nil else {
                print ("error: \(error!)")
                return
            }
            
            guard let content = data else {
                print("No data")
                return
            }
            
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                print("Not containing JSON")
                return
            }
            
            print("gotten json response dictionary is \n \(json)")
        }

        task.resume()
    }
    
 
}


