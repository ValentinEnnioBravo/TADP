# Lenguaje Tipado
## Definicion de Tipo

### Operacional
Es la definición de un tipo según las operaciones que permite realizar un objeto de ese tipo. Describe qué métodos o comportamientos puede ejecutar un objeto.
Son el **conjunto** de **operacion** que se pueden **hacer** **sobre** el **conjunto** de **valores**

### Representacional
Se refiere a la estructura de datos interna del tipo: los atributos o propiedades que tiene el objeto y cómo están almacenados en memoria.

### Estructural
Es la definición de tipo basada en la estructura que debe tener un objeto (los métodos y atributos), independientemente de la clase o jerarquía. Se usa en sistemas de tipado estructural (como TypeScript o Go).

### Deteccion de errores
- **Estatica**: Detecta los errores antes de correr el código.

- **Dinamica**: Detecta los errores mientras el código está corriendo

### Conformación
- **Nominal**: Un tipo basado en nombres. Si se espera un String tiene que ser eso.
- **Estructural**: Se conforma por su estructura. Si se espera un Float se puede utilizar cualquier cosa que se asemeje a eso, por ejemplo, un Int.

### Notación
- **Implicita**: El programador especifica de forma directa el tipo de datos o estructura. 
- **Explícita**: El tipo no se escribe explícitamente, el lenguaje lo deduce automáticamente. La **Inferencia**, de tipos en programación se basa en el análisis estático del código. El analizador de código examina el contexto en el que se utiliza una variable o una expresión y determina su tipo en función de reglas predefinidas.

### Subtipado
Hace referencia a que los valores pertenecen a distintos tipos.

## Falsos Negativos y Positivos
Entre la unión de los programas que el compilador dice que corren y los que corren se encuentran los programas que corren y compilan. Si un programa dería correr pero no corre porque el compilador no lo permite son llamados falsos negativos. Si un programa no debería corer pero corre porque el compilador lo permite es un falso negativo.

# Scala
### Definicion de clase
Las Clases son funciones que instancian objetos.

### Ejemplo tipo: la variable se comprometa a un tipo
```scala
    var connan : Object = new Guerrero()
    var zorro = new Espadachin(50)
    connan.atacaA(zorro)
```
Conan no puede puede usar el método atacaA(zorro) porque, por más de ser un Guerrero para el compilador es un Object, entonces no entiende el mensaje. **La variable se compromete a un tipo**, esto puede achicar el conjunto de mensajes que entienda o "agrandarlo", pero si el objeto que contiene la variable no entiende ese conjunto "agrandado", esto va a romper porque expone una interfaz que no "tiene".

### Ejemplo tipo: 
```scala
    var connan : Object = new Guerrero()
    var muralla = new Muralla(50)
    connan.atacaA(muralla)
```
En este caso, Guerrero solo puede atacar a otro Guerrero, según su definición, entonces cuando le mando una muralla se rompe, porque por más que muralla entienda el método recibirDanio() que ejecuta atacarA(), atacarA() espera un Guerrero.

Entonces planteo una "interface":
```scala
    trait Defensor {
        def potencial Defensivo: Int
        def recibirDanio(a: Int): Unit
    }
    class Guerrero(. . .) extends Defensor {. . .}
    class Muralla(. . .) extends Defensor {. . .}
```
Pero si Espadachin y Guerrero no extendieran defensor, cuando reciban recibirDanio() rompería.

O bien podría hacer lo siguiente
```scala
    class Guerrerp {
        def atacaA(otro: {
            def potencialDefensivo: Int
            def recibeDanio(a:Int): Unit
        }) = { ...acá implemento el método... }
    }
    class Guerrero(. . .) {. . .}
    class Muralla(. . .)  {. . .}
```
De esta forma, aunque Guerrero y Muralla no tengan un trait que los unifique, se utiliza como parámetro un objeto que entiende ciertos mensajes.
O bien hay una forma de hacerlo menos Nominal (como seria un trait Defensor), más Estructural.
```scala
    trait {
        def potencialDefensivo: Int
        def recibirDanio(a: Int): Unit
    }
    class Guerrero {
        def atacaA(otro: Atacable) = { ...acá implemento el método... }
    }
    class Guerrero(. . .) {. . .}
    class Muralla(. . .)  {. . .}
```
El type está encapsulando eso que antes se ponía como un conjunto de métodos que debía conocer. Si es un trait es nominal, si es un type es estructural. Para el compilador es más fácil encontrar traits que types.
- Estructural: si entendés los mensajes te dejo pasar (type)
- Nominal: debe coincidir el nombre (trait)
Se utiliza nominal hasta que se necesite abrir la puerta a algo más.

### Ejemplo Lista
```
    class Lista {
        var elementos = Array() // Esto no funciona pero es para el ejemplo
        def tamanio : Int
        def concatenar(otra: Lista) : Lista
        def incluye(elemento: Object) : Boolean
        def filtrar(condicion: Object => Boolean) : Lista {
            var respuesta = new Array()
            for(elemento <- elementos){
                if(condicion(elemento))
                    respuesta.add(elemento)
            }
            return respuesta
        }
    }
    var lista = new Lista()
    lista.filtrar((guerrero) => guerrero.asInstanceOf[Guerrero].energia > 10) // Esto era un problema sin asInstanceOf
```
Tenemos un problema. Se especificó, que la condición recibe Object y devuelve Boolean. En este caso, queremos que se utilice la lógica de Guerrero, que entiende una extensión de mensajes que los que entiende Object.

La solución única a esto es apagar el checkeador de tipos, esto se hace con **asInstanceOf**, le decimos al compilador "confiá en mí, que yo te voy a enviar un Guerrero".

El problema de esto, es que para cada uso tengo que especificar. **Scala empujó la vara un poco más** para evitar tener uqe hacer el asInstanceOf.

## Set
```scala
var unaColeccion: Set[Animal] = Set{new Vaca, new Caballo, new Granero}
unaColeccion.filter {animal => animal.estaGordo}
```
La definición de Set es Set[A], Set recibe elementos entoncrs del tipo A. La A es lo que llamamos **tipo paramétrico**.

## Type Bounds
- **Upper Bounds**: <: || :> - Lo que está del lado del menor tiene que ser tipo del otro
- **Lower Bounds**: >: || :< - Lo que está del lado del mayor debe ser supertipo del otroz

Entonces por ejemplo:
```scala
class Corral[A <: Animal](val animales: Set[A]) {
    def bla(a: A): Unit = {
        a.come
        a.estaGordo
    }
}
```
## Varianza
Relación entre el subtipado de un tipo paramétrico teniendo en cuenta como funciona el subtipado de los parámetros que recibe. Cómo varía la relación consigo mismo dependiendo el subtipo que tiene. Ya sé que A es de un tipo u otro (tipado), que es o no de otro (subtipado); ahora, tengo T[A] es subtipo de T[B]? En principio en algunos casos no. 
- El Set es invariante porque un Set de Vacas no es un Subtipo de Set de Animales. A estos casos se los llama **invarianza**
- Es invariante porque si no lo fuera se podrían hacer operaciones sobre el mismo que deje el Set en un estado inconsistente (por ejemplo agregar un animal Caballo a un Set de Vacas)


Que una clase sea invariante o no depende de la definición de esa clase. En el caso del Corral, al decri[A <: Animal] estamos diciendo que es invariante. 

### Reglas
- (A =:= B) => (T[A] <: T[B]) -> Invarianza
- (A =:= B) => (T[A] <: T[B]) -> Bivarianza (T[A] es subtipo de T[B] no importa si está arriba o abajo) (no tenés varianza)

### Ejercicio Interesante
indicar si se crea un `var f: Vaca => Vaca = ???` qué funciones podrían guardarse en la variable f
- `def g(vaca: Vaca): Vaca = ???` -> **Podría**. Todo tipo es, por lo menos, invariante
- `def h(vaca: Vaca): Animal = ???` -> **No podría**
- `def i(vaca: Vaca): VacaLoca = ???` -> **Podría**. Algo que retorna una VacaLoca es algo que retorna una Vaca. El acto de retornar una VacaLoca es retornar una Vaca, todas las operaciones a posteriori se satisfacen porque VacaLoca es subtipo de Vaca.
- `def j(vacaLoca: VacaLoca): Vaca = ???`
- `def i(animal: Animal): Vaca = ???`