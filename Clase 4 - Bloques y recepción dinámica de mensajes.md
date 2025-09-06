# Recepción dinámica de mensajes
### ¿A quién le damos la responsabilidad de determinar qué va a pasar cuando un objeto no entiende el mensaje?
Si llego al final de la jerarquía y no encuentra el método buscado será el objeto el que defina qué 
hacer. Esto se hara con `method_missing(:unMetodo)`, siendo ese un método el método que se había 
enviado anteriormente. 

La clase **Basic Object** tiene una implementación por default para estos casos, la cual es 
lanzar una excepción.

### `method_missing(:unMetodo)`

Es posible redefinir `method_missing(:unMetodo)` en cualquier lugar de la jerarquía. 

Un ejemplo de uso sería:

```ruby
class Persona
  attr_accessor :nombre, :edad
  def initialize(nombre, edad)
    @nombre = nombre
    @edad = edad
  end
end

class Anonimo < BasicObject
  def initialize(persona)
    @persona = persona
  end

  def method_missing(unMetodo, *args, &block)
    # Si no lo encuentra mandarselo a la persona
    @persona.send(unMetodo, *args, &block)
  end
  
  def respond_to_missing?(unMetodo, include_private = false)
    # En este caso solo sabe responderlo si lo sabe responder la persona
    @persona.respond_to?(unMetodo) # true
  end

  def nombre
    "Anon"
  end
end
```

El método `respond_to_missing?` se va a redefinir cuando se redefine el `method_missing`, responde 
true si, como objeto, no tengo un método para responder este mensaje 
pero sé que por la recepción dinámica de mensajes lo voy a saber responder.

Otra cosa que sucede, es que para cada método de Object, debería redefinir el comportamiento para 
falle y que lo vaya a buscar a `Persona` mediante el `method_missing`. 

Por esto subclasificamos como `BasicObject`, el cual es para estos casos.

#### Consideraciones
- Para mantener consistente el respond_to al redefinir el method_missing tenemos que redefinir
respond_to_missing.
- Siempre **delegar a super** si no sabemos responder el mensaje.

---
# Bloques, lambdas, clousures
### proc
Es un objeto que encapsula un bloque de código y puede ser almacenado en una variable, pasado como 
parámetro y ejecutado más tarde. Es una forma de crear closures (clausuras) en Ruby.

- Tiene acceso al contexto del programa pero también define su propio contexto.
- Si se lo llama con más o menos argumentos no se rompe.
- El return, el self estarán ligados al contexto de fuera del proc

Creemos un objeto capaz de ejecutarse:
```ruby
imprimir_hola = proc { puts "hola" }
# o bien
imprimir_hola = proc do
  puts = "hola"
  puts = "chau"
end
```
Luego podremos llamarlo con
```ruby
imprimir_hola.call
```
---
### Bloques
```ruby
[1, 2, 3].each { |numero| puts numero }
```
Aunque sintácticamente lo que está luego del each *parece un objeto*, no esta reificado como objeto. 
Al ejecutar el each lo puedo hacer con un bloque
---
### yield
La palabra clave `yield` ejecuta el bloque asociado al envío de mensajes que causó que un método
se ejecute. Por ejemplo:
```ruby
def m1
  yield
  yield
end

m1 do
  puts "chau"
end
```
Por ende la consola mostrará
```
chau
chau
```
O bien podría **guardarlo como un bloque y ejecutarlo usando call**
```ruby
def m1(&bloque)
  bloque.call
  bloque.call
end

m1 do
  puts "chau"
end
```
---
### Acceder dentro de un método al contexto superior
En el siguiente ejemplo:
```ruby
nombre = "Pepe"
def m1
  puts nombre
end
m1
```
Al llamar a m1, este no puede acceder a nombre porque está fuera de su contexto. Para que lo incluya
es posible utiliza `define_method(:m1)`:
```ruby
nombre = "Pepe"
define_method(:m1) do
  puts nombre
end
m1
```
Este recibe un método y en el cuerpo puede acceder al contexto externo. Lo mismo sucedería con una 
clase:

```ruby
nombre = "Pepe"
C1 = Class.new do
  puts nombre
end
m1
```
Que crea una clase pero permite acceder al contexto superior.

---
### Lambda
- Es como un proc. pero valida la cantidad de argumentos.
```ruby
lam = lambda {|x| puts x.inspect}
lam.call() # Esto rompe
lam.call(2) # Esto no
lam.call(2,3,4) # Esto rompe
```
- El return está **ligado al bloque del propio lambda**.
```ruby
def m1
  lam = lambda { |x| return x}
  lam.call(2)
  44
end
```
En cambio un proc devuelve 2. Porque el return está **ligado a el return del contexto superior**.
```ruby
def m1
  pro = proc { |x| return x}
  pro.call(2)
  44
end
```
---
## Crear objetos en línea
```ruby
def metodoObjeto(&definicion_del_objeto)
  objeto_nuevo = Object.new
  objeto_nuevo.instance_eval(&definicion_del_objeto) # Todos los defs que hagamos dentro del bloque formarán parte de la singleton class
  objeto_nuevo
end
```

---
## Crear clases en línea
```ruby
def clase(&definicion_de_la_clase)
  clase_nueva = Class.new # Instancia de Class
  # Instance eval cuando le paso un bloque con defs define esas cosas 
  # en la signleton Class del objeto que recibe el mensaje instance_eval

  # Tengo que usar class_eval, porque define los metodos en la clase
  # que se definan dentro
  clase_nueva.class_eval(&definicion_de_la_clase) 
  # Todos los defs que hagamos dentro del bloque formarán parte de la singleton class
  clase_nueva
end
```
`instance_eval` evalúa un bloque en el contexto de un objeto (Es decir, self dentro del bloque sería
una referencia al objeto receptor del instance_eval). Los métoodos se definen en la singleton class
del objeto receptor del mensaje.

`target_class` es la clase en la cual voy a definir los métodos cuando tenga defs.

`instance_exec` idem a instance_eval pero con la posibilidad de pasarle argumentos al bloque que se
va a ejecutar

`class_eval/module_eval` evalúa un bloque en el contexto de una clase o un módulo (es decir, self 
dentro del bloque será una referencia al objeto receptor del class_eval).
Los métodos se definen en la clase/módulo receptor del mensaje

`class_exec` / `module_exec` ideam a class_eval/module_eval, pero con la posibilidad de pasarle
argumentos al bloque que se va a ejecutar


---
# Creando un framework de testing
```ruby
require 'colorize'

class Test
  def initialize(contenido)
    @contenido = contenido
  end

  def ejecutar
    @fallar = proc { return :fail }
    instance_eval(&@contenido)
    :pass
  end

  private

  def assert(un_booleano)
    @fallar.call unless un_booleano
  end

  def deny(un_booleano)
    assert !un_booleano
  end
end

class TestSuite
  def initialize(&definicion_de_la_suite)
    @tests = []
    self.instance_eval(&definicion_de_la_suite)
  end

  def test(&contenido_del_test)
    @tests << Test.new(contenido_del_test)
  end

  def ejecutar(notificar_resultados: false)
    @tests.each do |test|
      resultado = test.ejecutar
      mostrar_resultado(resultado) if notificar_resultados
    end
  end

  private

  def mostrar_resultado(resultado)
    if resultado == :fail
      puts "FAIL".red
    else
      puts "PASS".green
    end
  end
end

def test_suite(&definicion_test_suite)
  test_suite = TestSuite.new(&definicion_test_suite)
  test_suite.ejecutar(notificar_resultados: true)
end
```

```ruby
require 'testing_framework'

test_suite do
  test do
    se_ha_ejecutado_el_test = false
    test_suite = TestSuite.new do
      test { se_ha_ejecutado_el_test = true }
    end

    test_suite.ejecutar

    assert se_ha_ejecutado_el_test
  end

  test do
    se_ha_ejecutado_el_test = false
    test_suite = TestSuite.new do
      test { se_ha_ejecutado_el_test = true }
    end

    deny se_ha_ejecutado_el_test
  end

  test do
    ejecutado = false
    test_suite = TestSuite.new do
      test do
        assert false
        ejecutado = true
      end
    end

    test_suite.ejecutar

    deny ejecutado
  end
end
```