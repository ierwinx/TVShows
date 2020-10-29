import UIKit

class DetalleViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var lenguajeLabel: UILabel!
    @IBOutlet weak var generoLabel: UILabel!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var descripcionLabel: UILabel!
    @IBOutlet weak var calificacionLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    
    //MARK: Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Metodos
    public func llamadaDesdeWeb(idTvShow: Int) -> Void {
        let tTvShowService = TvShowService()
        tTvShowService.consulta(id: idTvShow) { (callback) in
            
            guard let urlString = callback.image?.original, let nombre = callback.name, let generos = callback.genres, let idioma = callback.language, let descripcion = callback.summary else {
                return
            }
            
            guard let url = URL(string: urlString) else { return }
            guard let imgUrl = try? Data.init(contentsOf: url) else { return }
            
            var generosString = ""
            generos.forEach { i in
                generosString += "\(i) "
            }
            
            self.likeImage.isHidden = true
            self.coverImage.image = UIImage(data: imgUrl)
            self.nombreLabel.text = nombre
            self.generoLabel.text = generosString
            self.lenguajeLabel.text = idioma
            self.descripcionLabel.text = descripcion.replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</p>", with: "").replacingOccurrences(of: "</b>", with: "")
            
        }
    }
    
    public func llamadaDesdeAlmacenamiento(tvShow: Series) -> Void {
        
        guard let imagen = tvShow.detalle?.imagen, let nombre = tvShow.name, let genero = tvShow.detalle?.generos, let lenguaje = tvShow.detalle?.language, let descripcion = tvShow.detalle?.detalle else {
            return
        }
        
        self.likeImage.image = UIImage(named: "like1")
        self.coverImage.image = UIImage(data: imagen)
        self.nombreLabel.text = nombre
        self.generoLabel.text = genero
        self.lenguajeLabel.text = lenguaje
        self.descripcionLabel.text = descripcion
    }
    
}
