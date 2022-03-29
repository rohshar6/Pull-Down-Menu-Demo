import UIKit
protocol ImageManagerDelegate: AnyObject {
    func imageManager(_ manager: ImageManager, didReceive data: [ImageData])
    func imageManager(_ manager: ImageManager, didReceive data: Data, for index: Int)
}
class ImageManager {
    weak var delegate: ImageManagerDelegate?
    func fetchImage() {
        let url = URL(string: Constants.apiUrl)!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode([ImageData].self, from: data)
                    self.delegate?.imageManager(self, didReceive: decodedData)
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func fetchSingleImage(with url: URL, for index: Int) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            if let safeData = data {
                self.delegate?.imageManager(self, didReceive: safeData, for: index)
            }
        }
        task.resume()
    }
}
