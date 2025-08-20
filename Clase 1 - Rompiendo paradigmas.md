# Clase 1 - Rompiendo paradigmas
## Conceptos
- **Entropía**: Todos los sistemas tienden al desorden. No hay solución que sea definitiva. Los requerimientos cambian y pueden hacer la solución anterior inadecuada.
- **Polución de namespace**: situació en la que un gran número de nombres o identificadores de diferentes origenes se mezclan en un mismo ámbito, causando conflictos y dificultades para entender y mantener el código.

## Ejemplo
Modelamos a un guerero
```
Guerrero {
    - energia
    - potencialOfensivo
    - potencialDefensivo
    + sufrirDanio(Int)
    + atacar(Guerrero)
}
```

### Se agregan espadachines ¿Qué alternativas encontramos?
Se agregan espadachines, que atacan con una espada, su ataque depende de esa espada y al atacar también la espada pierde vida util. 

#### 1. Copiar la definición de guerrero
Siempre que uno tiene una nueva entidad lo primero que tiende a pensar es que se necesita una nueva clase. Copiar y pegar es fácil. 
```
Espadachin {
    - energia
    - Espada
    - potencialOfensivo
    - potencialDefensivo
    + sufrirDanio(Int)
    + atacar(Guerrero)
}

Espada {
    - vidaUtil
}
```
No hay una representación de forma "dura" en el código. No tengo una relación, una vinculación entre ambos que me permita modificarlos a la vez o reemplazar un método ante un nuevo requerimiento. 

#### 2. Herencia Guerrero --|> Espadachin
```
Guerrero inherits Espadachin{
    - energia
    - potencialOfensivo
    - potencialDefensivo
    + sufrirDanio(Int)
    + atacar(Guerrero)
}

Espadachin {
    - energia
    - Espada
    - potencialOfensivo
    - potencialDefensivo
    + sufrirDanio(Int)
    + atacar(Guerrero)
}

Espada {
    - vidaUtil
}
```
Sería erroneo que el guerrero herede del Espadachin porque si incorporamos más comportamiento al Espadachin lo estaríamos agregando al Guerrero. ¿Qué diferencia hay con que uno herede del otro?
Hoy no cambia el código, pero hoy está mal realizarlo de esta forma. 

¿Cómo sabemos que todo Espadachin es Guerrero y que todo Guerrero no es Espadachin? Porque **conocemos el dominio**. Puedo heredar de la forma que quiera, pero por contexto.
Se decide quién hereda de quién por **mecánica** (técnico) y por **naturaleza** (contexto).

### Se agregan Murallas
Las murallas no atacan pero reciben daño. Sería lógico querer aprovechar la defensa del guerrero. Tenemos tres opciones.
#### 1. Generalizar Guerrero y Muralla con un Defensor.
Es la solución más correcta.
```
Defensor {
    - energia
    - potencialDefensivo
    + sufrirDanio()
}

Muralla inherits Defensor {
    ...
}

Guerrero inherits Defensor {
    ...
}
```

De esta forma, si hay lógica extra en el Guerrero, se la agrego al Guerrero, si hay lógica extra en la Muralla, se lo agrego a la Muralla. El Defensor funciona como concepto unificador.

Pero esta solución tiene un "problema": Muralla es una clase vacía, que solo Hereda de Defensor. Pero Muralla tiene una entidad propia, es modelada heredando de Defensor porque es más específica; si el día de mañana se agrega estatuas, que pueden recibir daño, si no modelo una diferencia entre Muralla y Estatua, el día de mañana tendría instanciados murallas y estatuas como defensores. 

Entonces, si alguno de los dos tuviera un cambio en su comportamiento, no podría modificarlo específicamente, tendría que buscar cada Defensor para diferenciar.


**Hay que aprender a convivir con las cosas que hacen ruido**, es decir, la clase "vacía" Muralla es necesaria, porque sino estoy perdiendo información. 


#### 2. Copiar y pegar el código de la defensa
#### 3. Que Guerrero herede de Muralla
En este caso el Guerrero no es una Muralla, pero ¿Qué pasaría si en vez de llamarse Muralla se llamara Defensor? un Defensor podría ser un Guerrero. Llamarlo Muralla es más específifica. Pero hay un
problema mecánico: si Muralla o Defensor, dejando de lado el nombre, tuviera nuevo comportamiento estaríamos haciendo que Guerrero adquiera todo el comportamiento de la Muralla, por lo que podríamos
llegar a situaciones sin sentido como que un Guerrero tenga un método "revocar()".
Mecánicamente funciona, pero el día de mañana no va a funcionar.
#### 4. Muralla hereda de Guerrero -> Void method
```
Muralla {
    ...
    + sufrirDanio(Int)
    + atacar(Guerrero)
}
```
La Muralla tiene un método atacar pero lo sobrescribo para que lance una excepción, ya que nunca podría en mi dominio pedirle a una muralla que ataque. Es una forma de mitigarlo, si tratás de usarlo se lanza una excepción, pero no es lo mismo que no tenerlo, se tiene una **polución de namespace**. 

El objeto me expone las cosas que sabe hacer, es responsable de sí mismo, por eso en una clase Alumno se tiene un método subirNota(), ya que si modificara solo el atributo (-nota) desde afuera podría estar sateandome cosas como promociones, etc.

### Se agregan misiles
Los misiles pueden atacar. Entonces, lo que se tiende a pensar es: se crea una clase Atacante y que Guerrero y Misil hereden de Atacante. Pero esto generaría un problema: un Guerrero ya está heredando de Defensor. Entonces, la herencia es simple, por lo que un Guerrero no puede herdar a la vez de Atacante y Defensor. ¿Qué hacemos?
En el paradigma orientado puro a objetos no hay una buena forma de hacerlo, algunas soluciones podrían ser:

#### 1. Componer Guerrero con Atacante y Defensor
Ya no serían un Atacante y Defensor, sino quizás una estrategia de Ataque y Defensa. De esta forma, lograríamos resolver el problema pero con algunos inconvenientes asociados.
- Tendría métodos repetidos
- Glue code / Boilerplate: codigo para unir

#### 2. Copiar y pegar
Guerrero y Misil heredan de atacante, Muralla hereda de defensor y el resto de código que no se recibió por herencia se copia a mano.
- Repetción de código

#### 3. Atacante(AtacanteDefensor) hereda de Defensor
Guerrero y Misil heredan de atacante, Muralla hereda de defensor y Atacante hereda de Defensor, de esta forma los Atacantes también pueden defenderse. 

#### ¿Cuál va a ser entonces la solución?
**Copiar y pegar**, la solución más simple y fácil de hacer, que quizás suena más extraña y "fea" en un principio. Pero debido a que la herencia es SIMPLE, no puede solucionarse de otra forma.

La academia y la industria se mueven a ritmos diferentes, muchas veces lo que teóricamente se ve como "mal visto" es la decisión más acertada en la industria/realidad.

La mayoría de tecnologías de la actualidad funcionan con herencia simple, es un problema común. Hoy en día, existen soluciones alternativas, como Herencia múltiple, etc.

