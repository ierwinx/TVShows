import UIKit

class DetalleViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var lenguajeLabel: UILabel!
    @IBOutlet weak var generoLabel: UILabel!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var descripcionTextView: UITextView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var calificacionImage: UIImageView!
    
    //MARK: Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        tocarCorazon(view: likeImage)
    }
    
    //MARK: Metodos
    public func llamada(idTvShow: Int?, tvShow: Series?) -> Void {
        if idTvShow != nil {
            let tTvShowService = TvShowService()
            tTvShowService.consulta(id: idTvShow!) { (callback) in
                
                guard let urlString = callback.image?.original, let nombre = callback.name, let generos = callback.genres, let idioma = callback.language, let descripcion = callback.summary, let promedio = callback.rating?.average else {
                    return
                }
                
                guard let url = URL(string: urlString) else { return }
                guard let imgUrl = try? Data.init(contentsOf: url) else { return }
                
                var generosString = ""
                generos.forEach { i in
                    generosString += "\(i) "
                }
                
                self.likeImage.image = UIImage(named: "like1")
                self.coverImage.image = UIImage(data: imgUrl)
                self.nombreLabel.text = nombre
                self.generoLabel.text = generosString
                self.lenguajeLabel.text = idioma
                self.calificacionImage.image = UIImage(named: "\(Int(round(promedio * 0.5)))")
                self.descripcionTextView.text = descripcion.replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</p>", with: "").replacingOccurrences(of: "</b>", with: "")
                
            }
        } else {
            guard let show = tvShow, let detalle = show.detalle, let imagen = detalle.imagen, let nombre = show.name, let genero = detalle.generos, let lenguaje = detalle.language, let descripcion = detalle.detalle  else {
                return
            }
            
            print(show)
            print(detalle)
            
            self.likeImage.image = UIImage(named: "like2")
            self.coverImage.image = UIImage(data: imagen)
            self.nombreLabel.text = nombre
            self.generoLabel.text = genero
            self.lenguajeLabel.text = lenguaje
            self.calificacionImage.image = UIImage(named: "\(Int(round(detalle.rating * 0.5)))")
            self.descripcionTextView.text = descripcion
        }
    }
    
    //MARK: Eventos
    private func tocarCorazon(view: UIView) -> Void {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetalleViewController.corazonTocado(sender:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func corazonTocado(sender: UITapGestureRecognizer) -> Void {
        if self.likeImage.image == UIImage(named: "like1") {
            self.likeImage.image = UIImage(named: "like2")
        } else {
            self.likeImage.image = UIImage(named: "like1")
        }
        
    }
    
}
