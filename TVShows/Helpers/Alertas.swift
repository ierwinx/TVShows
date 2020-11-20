import Foundation
import UIKit

class Alertas {
    
    public static func eliminaGuarda(status: Bool, eliminar: Bool) -> UIAlertController {
        let titulo = status ? (eliminar ? "Eliminado" : "Guardado") : "Oops, algo salió mal!"
        let mensaje = status ? (eliminar ? "Se elimino de favoritos" : "Se agrego a favoritos") : "Hubo un problema al guardar este show de TV"
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Ok", style: .default))
        return alerta
    }
    
    public static func preguntaEliminar(controlador: UIViewController, callBack: @escaping ((Bool) -> ())) -> Void {
        let alerta = UIAlertController(title: "Eliminar", message: "¿Deseas eliminar de favoritos?", preferredStyle: .alert)
        let si = UIAlertAction(title: "Si", style: .destructive) { accion in
            callBack(true)
        }
        let no = UIAlertAction(title: "No", style: .default) { accion in
            callBack(false)
        }
        alerta.addAction(si)
        alerta.addAction(no)
        
        controlador.present(alerta, animated: true, completion: nil)
    }
    
    public static func errorInternet(controlador: UIViewController, callBack: @escaping ((Bool) -> ())) -> Void {
        let alerta = UIAlertController(title: "Oops, algo salió mal!", message: "Hubo un error al consultar el servicio. ¿Quieres intentar nuevamente?", preferredStyle: .alert)
        let acceptar = UIAlertAction(title: "Aceptar", style: .default) { accion in
            callBack(true)
        }
        let cancelar = UIAlertAction(title: "Cancelar", style: .default) { accion in
            callBack(false)
        }
        alerta.addAction(acceptar)
        alerta.addAction(cancelar)
        controlador.present(alerta, animated: true, completion: nil)
    }
    
}
