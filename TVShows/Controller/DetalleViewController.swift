import UIKit

class DetalleViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var lenguajeLabel: UILabel!
    @IBOutlet weak var generoLabel: UILabel!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var descripcionLabel: UILabel!
    @IBOutlet weak var calificacionLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    
    //MARK: Properties
    public var id: Int!
    
    //MARK: Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tTvShowService = TvShowService()
        tTvShowService.consulta(id: self.id) { (callback) in
            
            guard let urlString = callback.image?.original, let nombre = callback.name, let generos = callback.genres, let idshow = callback.id, let idioma = callback.language, let descripcion = callback.summary else {
                return
            }
            
            self.id = idshow
            
            guard let url = URL(string: urlString) else { return }
            guard let imgUrl = try? Data.init(contentsOf: url) else { return }
            
            var generosString = ""
            generos.forEach { i in
                generosString += "\(i) "
            }
            
            self.coverImage.image = UIImage(data: imgUrl)
            self.nombreLabel.text = nombre
            self.generoLabel.text = generosString
            self.lenguajeLabel.text = idioma
            self.descripcionLabel.text = descripcion.replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</p>", with: "").replacingOccurrences(of: "</b>", with: "")
            
        }
    }
    
}
