# Metaprogramación en Ruby
## ¿Qué es la metaprogramación?
Es un proceo o práctica por la cual se escriben programas que generan, manipulan o utilizan otros programas.

Es el modelo mediante el cual se enmarca el modelo de objetos.

Algunos ejemplos pueden ser:
- Compiladores
- Formateador de código
- Herramientas de generación de documentación

### ¿Para qué se usa?
- Desarrollo de frameworks y herramientas
- Dominio de los frameworks
Algunos ejemplos son: como ORMs, Testing (JUnit), Documentadores de código o Analizadores de código

Para manipular, generar o utilizar programas; cuanto más fuertemente tipado sea el lenguaje, más dificil será metaprogramar.

### Reflection
Es *metaprogramar* en el mismo lenguaje que los programas.
#### Tipos de Reflection
- **Introspection**: herramientas del lenguaje para poder analizarse a sí mismo. Que el programa se vea a sí mismo o que revise a otro programa.
- **Self-modification**: el programa puede cambiar el comportamiento, puede modificarse a sí mismo. Como ORMs
- **Intercession**: capacidad en un lenguaje de agregar una característica nueva que no esté previamente.

## Metaprogramación en Ruby
Utilizaremos la consola `pry`.
### Comandos pry
| Comando                                       | Funcionalidad                                                                        | Detalles                                                                                                                                |
|-----------------------------------------------|--------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------|
| `require_relative`                            | Importar archivo                                                                     | -                                                                                                                                       |
| `unObjeto.class`                              | Dice la clase de un objeto                                                           | -                                                                                                                                       |
| `unObjeto.class.superclass `                  | Dice la superclase de un objeto                                                      | -                                                                                                                                       |
| `unaClase.ancestors `                         | Muestra todos los superiores a un objeto                                             | En forma de lista `[]`                                                                                                                  |
| `unaClase.define_method(:saludar) {"Hola!"} ` | Define un método a una clase                                                         | -                                                                                                                                       |
| `unaClase.is_a? otraClase `                   | Devuelve booleano                                                                    | -                                                                                                                                       |
| `unObjeto = Clase.new`                        | Instanciar un objeto                                                                 | -                                                                                                                                       |
| `class B < A end`                             | Crear clase B y heredarla de A                                                       | -                                                                                                                                       |
| `unObjeto.methods`                            | Muestra todos los métodos, en forma de símbolos (:unMetodo), que entiende el objeto. | -                                                                                                                                       |
| `unaClase.singleton_class`                    | Permite obtener la eigenclass de unaClase, *metaclass* **el objeto unaClase**        | Puede servir para ver los métodos de clase, no de instancia                                                                             |
| `unObjeto.methods.include? :method`           | Dice si los métodos incluyen un método                                               | -                                                                                                                                       |
| `unObjeto.unMetodo`                           | Llama al método y muestra el valor de retorno                                        | -                                                                                                                                       |
| `unaClase.instance_methods`                   | Muestra los métodos que implementa la clase y su superclase                          | `instance_methods(false)` no incluye a la superclase                                                                                    |
| `unaClase.instance_method :unMetodo`          | Devuelve un método de esa clase no bindeado a ningún objeto                          | -                                                                                                                                       |
| `unMetodoNoBindeado.bind(unObjeto)`           | Bindea un método no bindeado a un objeto                                             | No se puede bindear un método a un objeto de una clase que no tenga ese método.                                                         |
| `unObjeto.send(:unMetodo)`                    | Llama al método y muestra el valor de retorno                                        | Manda un mensaje explícitamente, más tipo **introspection**. Permite llamar a métodos privados. Permite mandar mensajes no hardcodeados |                         |                              |
| `unObjeto.method(:unMetodo)`                  | Devuelve una instancia de method                                                     | Un método bindeado a la instancia. Lo puedo guardar                                                                                     |`variable = unObjeto.method(:unMetodo)`|
| `unMetodo.call`                               | Llama a un método bindeado a una instancia                                           | -                                                                                                                                       |
| `unMetodo.parameters`                         | Dice todos los metodos de ese objeto                                                 | Los muestra como una lista de tuplas `[[:req, :un_danio]]`, el primero nos dice qué tipo de parametro es y el otro el nombre.           |
| `unMetodo.arity`                              | Dice la cantidad de parámetros de ese método                                         | -                                                                                                                                       |
| `unObjeto.method(:unMetodo).receiver`         | Devuelve a quién está bindeado un método                                             | -                                                                                                                                       |
| `unMetodoNoBindeado.owner`                    | Dice la clase a la que pertenece el metodo, **quien implementó el método**           | -                                                                                                                                       |
---
#### Variables de Instancia
|Comando|Funcionalidad|Detalles|
|---------|--------|--------|
|`unObjeto.instance_variables`| Permite ver los atributos| - |
|`unObjeto.instance_variables_get(:@unAtributo)`| Permite ver el valor de un atributo| - |
|`unObjeto.instance_variables_set(:@unAtributo, valor)`| Permite setear el valor de un atributo| - |

#### Notas
- El `:unMetodo` es un símbolo, un String. El `:` es la forma que tiene Ruby de declarar un símbolo.
- Hacer `unaClase.class` devuelve la clase a la que pertenece. Al sumarle a la clase perteneciente métodos, no se le agregan a la clase a la que pertence porque ensuciaría el ecosistema. 
- El `@` 
- Al escribir `attr_accessor` dentro de la definición de una clase. Se están definiendo los getters y setters de un atributo. Que al final lo que están haciendo es llamar a los `instance_variables_get` y `instance_variables_set` del instance_variable.
- El `unObjeto.send(:unMetodo)` me permitiría mandarle todos los métodos de un array de métodos a un objeto, sin necesidad de hardcodearlo.
- **`send(:method)` vs. `.call`**: el send le envía el mensaje al objeto, se hace el lookup y cuando encuentra la implementación lo ejecuta. Con call no hay lookup, se está ejecutando directamente a la implementación.
- **`methods` vs `instance_methods`** 
- Todo objeto potencialmente tiene todos los atributos, solo tiene que elegir usarlos. **Ya que cualquier método podría agregar ese atributo**. No es necesario declararlos. Por eso unObjeto.instance_variable responde los atributos que tienen un valor que no sea `nil`. **Solo van a aparecer en `.instance_variables` cuando los setee**

## Bind
Permite agregarle métodos a una instancia de una misma jerarquía de Clases que ese método. Si es sacado de un mixin se puede bindear en cualquier lado. 

## Self Modification en Ruby
- #### Open Classes
Es posible en cualquier momento redefinir las clases. 

Por ejemplo si ya tengo mi clase 
```ruby
class unaClase
    def blah
        2
    end
end
```
Como **Ruby es imperativo** puedo redefinir la clase
```ruby
class unaClase
    def blah
        46
    end
end
```
Y este comportamiento **es retroactivo**, el objeto no tiene el comportamiento, se lo pide a la clase.

- #### Duck typing
Por la naturaleza de Ruby de ser dinámicamente tipado, se hace referencia a un tipo de dato no por el tipo en sí sino por el comportamiento que tiene. 

- #### Monkey patching
Posibilidad de modificar un tipo, una clase o un objeto para que satisfazga las necesidades que se tienen.

## Metamodelo en Ruby
Siguiendo el ejemplo de Guerreros, el árbol quedaría de esta manera:

![alt text](image-23.png)

### Notas
- nil es el objeto que representa null
- Todos los caminos llevan a `Object`
- Todas las clases, por ser objetos, deben tener una flecha roja, por eso apuntan a `Class`. Necesitan un proveedor de comportamiento, todas las clases son objetos instancias de la clase `Class`.
- Como todas las clases son objetos, instancias de otra clase, la clase `Class` es una instancia de sì misma.
- Todos los que llegan a object necesitan una flecha azul. Todos los que llegan a class necesitan una flecha roja.
- Clase hereda de `Modulo`, por esto los mixines son Módulos.
- Si quiero que las clases tengan métodos, tengo la necesidad de que tengan una clase que les sirva de proveedor, que no puede ser `Class`, porque sino le estaría poniendo el método a todas las clases. 
Surge entonces la necesidad de tener un elemento intermedio al que se le pueda implementar el comportamiento. Estos serán las **singleton_class**. Cada clase tendrá este compañero que le dará los servicios particulares de esa clase.
- Cada **singleton_class** hereda de una singleton_class superior, con el fin de poder **heredar métodos de clase**. Esto es decisión de Ruby, porque podría heredar directo de clase y ser un método estático.
Todas las flechas rojas de singleton_class van a `Class`, porque son clases.
- ¿Y qué pasa con las flechas verdes de las singleton_class? ¿No necesitan otra singleton_class de la singleton_class? No, Ruby implementa una búsqueda LAZY, por lo que solo va a existir esa relación verde si se le pone un comportamiento a una singleton_class.
- Pero Ruby dice que **cualquier objeto puede tener métodos para él solo**, que lo distinguen de su clase. Por esto, hace lo mismo que hizo con las clases, le crea una singleton_class a cada objeto. Estas, por ser clases su flecha roja apunta a `Class`.
- Finalmente, la singleton_class debe llegar a su super clase. Por esto `#marine` hereda de `Guerrero`

### Objeto auto clase
En Ruby todo es un objeto, los números, strings, arrays y también las Clases. Las clases mismas son instancias de Class. Clases tienen singleton_class Como son objetos, también pueden tener métodos definidos “solo para ellas”.
Las clases son objetos en Ruby, instancias de Class, y por eso pueden tener métodos individuales en su **singleton_class**.

Las clases proveen los métodos para que las instancias los utilicen. Es un objeto pero su finalidad es otra, no es ser un objeto. Entonces las clases no entienden los métodos, los objetos entienden los métodos.
La clase entiende `.superclass`, `.instance_methods`, `.methods`. Una instancia de guerrero entiende `atacar`, no entiende `instance_methods` o `superclass`.

El método lookup general hace:
```
unObjeto ; (flechaRoja) ; (flechaAzul)*
```
- El asterísco significa dar un paso rojo y fijarme que no sea nil.
Solo los objetos en general pueden hacer lookup, porque las clases no tienen flecha roja, y todo lookup empieza con una flecha azul.

El método lookup En Ruby hace lo siguiente entonces:
```
unObjeto ; (flechaVerde) ; n(flechaAzul)
```
Para que, en Ruby, una clase sea un objeto necesito que le salga una flecha roja.
Para ser **proveedor** se debe tener una flecha azul.

Las flechasAzules, que llevaban a la superclass, en ciertas situaciones van a ser reemplazadas por una combinación flechaVerde + flechaAzul

## Metodo estático vs. Método de clase
Los **métodos estáticos** permiten ser llamados desde cualquier lugar, enviandole un mensaje a una clase que puede no estar instanciada. **No hay lookup**.

Los **métodos de clase** tienen asociado si o si una Herencia. Un método de clase es poder enviarle un mensaje a una clase y que sus subclases puedan heredarlo. En cierto punto, para tener métodos de clases necesito que las clases sean objetos. **Hay lookup**