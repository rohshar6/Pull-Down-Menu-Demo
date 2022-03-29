import UIKit

class ViewController: UIViewController {
    let manager = ImageManager()
    var images = [Int: Data]()
    
    private lazy var button: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("text me", for: .normal)
        button.showsMenuAsPrimaryAction = true
        button.menu = menu
        return button
    }()
    
    private lazy var first = UIAction(title: "first", image: UIImage(systemName: "pencil.circle"), attributes: [], state: .off) { action in
        print("first")
    }
    
    private lazy var second = UIAction(title: "second", image: UIImage(systemName: "pencil.circle"), attributes: [.destructive], state: .on) { action in
        print("second")
    }
    
    private lazy var third = UIAction(title: "third", image: UIImage(systemName: "pencil.circle"), attributes: [], state: .off) { action in
        print("third")
    }
    
    private lazy var fourth = UIAction(title: "fourth", image: UIImage(systemName: "pencil.circle"), attributes: [.disabled], state: .off) { action in
        print("fourth")
    }
    
    private lazy var camera = UIAction(title: "Camera", image: UIImage(systemName: "camera")){ _ in
        print("camera tapped")
    }
    private lazy var photo = UIAction(title: "Photo", image: UIImage(systemName: "photo.on.rectangle.angled")){ _ in
        print("photo tapped")
    }
    
    private lazy var elements: [UIAction] = [first, second, third, fourth]
    private lazy var menu = UIMenu(title: "new", children: elements)
    
    // Deferred menu
    private lazy var deferredMenu = UIDeferredMenuElement { (menuElements) in
        let menu = UIMenu(title: "Welcome", options: .displayInline,  children: [self.camera, self.photo])
        menuElements([menu])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(button)
        
        manager.delegate = self
        
        addConstraints()
        
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        menu = menu.replacingChildren([first, second, third, fourth, deferredMenu])
        navigationItem.rightBarButtonItem?.menu = menu
        // fetch images
        manager.fetchImage()
    }
    
    private func addConstraints() {
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 100).isActive = true
        button.backgroundColor = .blue
    }
    
    private func updateMenu(for index: Int) {
        guard let imageData = images[index] else { return }
        let image = UIImage(data: imageData)
        
        let element = elements[index]
        element.image = image
        elements.remove(at: index)
        elements.insert(element, at: index)
        delayMenuImageLoading(with: 10)
    }
    
    private func delayMenuImageLoading(with interval: TimeInterval, useDeferredMenu: Bool = false) {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.navigationItem.rightBarButtonItem?.menu = self.menu
            self.button.menu = self.menu
        }
    }
}
// MARK: -  Extension: ImageMangerDelegate
extension ViewController: ImageManagerDelegate {
    func imageManager(_ manager: ImageManager, didReceive data: Data, for index: Int) {
        images[index] = data
        updateMenu(for: index)
    }
    
    func imageManager(_ manager: ImageManager, didReceive data: [ImageData]) {
        for (index, value) in data.enumerated() {
            manager.fetchSingleImage(with: value.urls.regularUrl, for: index)
        }
    }
}
