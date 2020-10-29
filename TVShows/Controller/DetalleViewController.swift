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
    
    //MARK: Propiedades
    public var idTvShow: Int!
    public var tvShow: Series!
    public var tvShowRes: TvShowRes!
    
    //MARK: Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                
                self.likeImage.image = self.validaFavorito(id: self.idTvShow!) ? UIImage(named: "like2") : UIImage(named: "like1")
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
            
            self.likeImage.image = UIImage(named: "like2")
            self.coverImage.image = UIImage(data: imagen)
            self.nombreLabel.text = nombre
            self.generoLabel.text = genero
            self.lenguajeLabel.text = lenguaje
            self.calificacionImage.image = UIImage(named: "\(Int(round(detalle.rating * 0.5)))")
            self.descripcionTextView.text = descripcion
        }
        
        tocarCorazon(view: likeImage)
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
            self.alerta(valida: ShowsRepository.guardar(tvShow: tvShowRes), eliminar: false)
        } else {
            self.likeImage.image = UIImage(named: "like1")
            self.alerta(valida: ShowsRepository.eliminar(id: idTvShow != nil ? idTvShow : Int(tvShow.id)), eliminar: true)
        }
        
    }
    
    //MARK: Metodos
    private func validaFavorito(id: Int) -> Bool {
        guard let _ = ShowsRepository.consultar(id: id) as? Series else {
            return false
        }

        return true
    }
    
    private func alerta(valida: Bool, eliminar: Bool) -> Void {
        let titulo = valida ? ( eliminar ? "Eliminado" : "Guardado" ) : "Error"
        let mensaje = valida ? ( eliminar ? "Se elimino de tus favoritos" : "Se agrego a favoritos" ) : "Error al realizar operación"
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alerta, animated: true, completion: nil)
    }
    
}
