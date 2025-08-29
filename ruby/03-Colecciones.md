# 03 - Colecciones

## 📊 Arrays (Arreglos)

### Creación de Arrays
```ruby
# Diferentes formas de crear arrays
vacio = []
numeros = [1, 2, 3, 4, 5]
mixto = [1, "texto", true, 3.14]
rango_array = (1..5).to_a  # [1, 2, 3, 4, 5]

# Array con new
array_new = Array.new(5)        # [nil, nil, nil, nil, nil]
array_con_valor = Array.new(3, "hola")  # ["hola", "hola", "hola"]

# %w para arrays de strings
colores = %w[rojo verde azul amarillo]  # ["rojo", "verde", "azul", "amarillo"]
```

### Acceso a Elementos
```ruby
frutas = ["manzana", "banana", "naranja", "uva"]

# Índices positivos (desde el inicio)
frutas[0]    # "manzana"
frutas[1]    # "banana"

# Índices negativos (desde el final)
frutas[-1]   # "uva"
frutas[-2]   # "naranja"

# Rangos
frutas[1..3]   # ["banana", "naranja", "uva"]
frutas[1...3]  # ["banana", "naranja"] (excluye el último)

# Métodos de acceso
frutas.first   # "manzana"
frutas.last    # "uva"
frutas.fetch(1)  # "banana"
frutas.fetch(10, "no existe")  # "no existe" (valor por defecto)
```

### Modificación de Arrays
```ruby
numeros = [1, 2, 3]

# Agregar elementos
numeros << 4           # [1, 2, 3, 4] (append)
numeros.push(5)        # [1, 2, 3, 4, 5]
numeros.unshift(0)     # [0, 1, 2, 3, 4, 5] (prepend)

# Insertar en posición específica
numeros.insert(2, 1.5) # [0, 1, 1.5, 2, 3, 4, 5]

# Eliminar elementos
numeros.pop            # Elimina y retorna el último: 5
numeros.shift          # Elimina y retorna el primero: 0
numeros.delete(1.5)    # Elimina valor específico
numeros.delete_at(2)   # Elimina en índice específico

# Asignación directa
numeros[0] = 10        # Cambiar elemento
numeros[10] = 100      # Expande el array con nils
```

### Métodos Útiles de Arrays
```ruby
numeros = [1, 2, 3, 2, 4, 2, 5]

# Información básica
numeros.length         # 7 (también .size)
numeros.empty?         # false
numeros.include?(3)    # true

# Búsqueda
numeros.index(2)       # 1 (primer índice donde aparece 2)
numeros.rindex(2)      # 5 (último índice donde aparece 2)
numeros.find_index { |n| n > 3 }  # 4 (primer índice donde n > 3)

# Transformación
numeros.reverse        # [5, 2, 4, 2, 3, 2, 1]
numeros.sort           # [1, 2, 2, 2, 3, 4, 5]
numeros.uniq           # [1, 2, 3, 4, 5] (elimina duplicados)

# Conversión
numeros.join(", ")     # "1, 2, 3, 2, 4, 2, 5"
numeros.to_s          # "[1, 2, 3, 2, 4, 2, 5]"

# Operaciones
[1, 2, 3] + [4, 5]    # [1, 2, 3, 4, 5] (concatenación)
[1, 2, 3, 4] - [2, 4] # [1, 3] (diferencia)
[1, 2] * 3            # [1, 2, 1, 2, 1, 2] (repetición)
```

### Iteración Avanzada
```ruby
numeros = [1, 2, 3, 4, 5]

# each_with_index
numeros.each_with_index do |numero, indice|
  puts "#{indice}: #{numero}"
end

# map (transforma cada elemento)
cuadrados = numeros.map { |n| n ** 2 }  # [1, 4, 9, 16, 25]

# select (filtra elementos)
pares = numeros.select { |n| n.even? }  # [2, 4]

# reject (filtra elementos negativamente)
impares = numeros.reject { |n| n.even? }  # [1, 3, 5]

# find (encuentra el primer elemento que cumple condición)
primer_par = numeros.find { |n| n.even? }  # 2

# reduce/inject (acumula valores)
suma = numeros.reduce(0) { |acum, n| acum + n }  # 15
suma_simple = numeros.sum  # 15 (método directo)
```

## 🗂 Hashes (Diccionarios)

### Creación de Hashes
```ruby
# Hash vacío
vacio = {}
vacio_new = Hash.new

# Hash con valores
persona = {
  "nombre" => "Ana",
  "edad" => 25,
  "ciudad" => "Madrid"
}

# Hash con símbolos (más común en Ruby)
persona_simbolos = {
  nombre: "Ana",
  edad: 25,
  ciudad: "Madrid"
}

# Hash mixto
configuracion = {
  :host => "localhost",
  "puerto" => 3000,
  activo: true
}
```

### Acceso a Valores
```ruby
persona = { nombre: "Ana", edad: 25, ciudad: "Madrid" }

# Acceso con corchetes
persona[:nombre]     # "Ana"
persona["edad"]      # nil (si usas string en hash de símbolos)

# Métodos de acceso
persona.fetch(:edad)              # 25
persona.fetch(:pais, "España")    # "España" (valor por defecto)

# Verificar existencia
persona.key?(:nombre)      # true (también .has_key?)
persona.value?("Ana")      # true (también .has_value?)
```

### Modificación de Hashes
```ruby
persona = { nombre: "Ana", edad: 25 }

# Agregar/modificar
persona[:ciudad] = "Madrid"
persona[:edad] = 26

# Eliminar
persona.delete(:ciudad)

# Merge (combinar hashes)
datos_extra = { trabajo: "Programadora", pais: "España" }
persona_completa = persona.merge(datos_extra)

# Merge! (modifica el hash original)
persona.merge!(datos_extra)
```

### Métodos Útiles de Hashes
```ruby
persona = { nombre: "Ana", edad: 25, ciudad: "Madrid" }

# Información básica
persona.length         # 3 (también .size)
persona.empty?         # false

# Obtener claves y valores
persona.keys          # [:nombre, :edad, :ciudad]
persona.values        # ["Ana", 25, "Madrid"]

# Iteración
persona.each do |clave, valor|
  puts "#{clave}: #{valor}"
end

persona.each_key { |clave| puts clave }
persona.each_value { |valor| puts valor }

# Transformación
persona.invert        # {"Ana" => :nombre, 25 => :edad, "Madrid" => :ciudad}

# Filtrado
adultos = { ana: 25, luis: 17, maria: 30 }
mayores = adultos.select { |nombre, edad| edad >= 18 }  # {ana: 25, maria: 30}
```

## 📏 Ranges (Rangos)

### Creación de Ranges
```ruby
# Rango inclusivo (incluye el final)
rango_inclusivo = 1..10    # 1, 2, 3, 4, 5, 6, 7, 8, 9, 10

# Rango exclusivo (excluye el final)
rango_exclusivo = 1...10   # 1, 2, 3, 4, 5, 6, 7, 8, 9

# Rangos de letras
letras = 'a'..'z'

# Rangos infinitos (Ruby 2.6+)
desde_10 = (10..)
hasta_100 = (..100)
```

### Uso de Ranges
```ruby
# Convertir a array
(1..5).to_a           # [1, 2, 3, 4, 5]

# Verificar pertenencia
(1..10).include?(5)   # true
(1..10).cover?(5)     # true (más eficiente para rangos)

# Iteración
(1..5).each { |i| puts i }

# En case statements
edad = 25
case edad
when 0..12
  puts "Niño"
when 13..17
  puts "Adolescente"
when 18..64
  puts "Adulto"
else
  puts "Adulto mayor"
end
```

## 🛠 Métodos Avanzados de Colecciones

### Métodos de Enumeración
```ruby
numeros = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# all? (todos cumplen la condición)
todos_positivos = numeros.all? { |n| n > 0 }  # true

# any? (alguno cumple la condición)
hay_pares = numeros.any? { |n| n.even? }      # true

# none? (ninguno cumple la condición)
ninguno_negativo = numeros.none? { |n| n < 0 } # true

# count (contar elementos que cumplen condición)
cantidad_pares = numeros.count { |n| n.even? } # 5

# partition (dividir en dos grupos)
pares, impares = numeros.partition { |n| n.even? }
# pares: [2, 4, 6, 8, 10], impares: [1, 3, 5, 7, 9]

# group_by (agrupar por criterio)
agrupados = numeros.group_by { |n| n.even? ? "par" : "impar" }
# {"impar" => [1, 3, 5, 7, 9], "par" => [2, 4, 6, 8, 10]}
```

### Operaciones con Múltiples Arrays
```ruby
array1 = [1, 2, 3, 4]
array2 = [3, 4, 5, 6]

# Intersección
interseccion = array1 & array2    # [3, 4]

# Unión
union = array1 | array2           # [1, 2, 3, 4, 5, 6]

# Zip (combinar arrays)
combinado = array1.zip(array2)    # [[1, 3], [2, 4], [3, 5], [4, 6]]

# Flatten (aplanar arrays anidados)
anidado = [[1, 2], [3, 4], [5]]
aplanado = anidado.flatten        # [1, 2, 3, 4, 5]
```

## 🎯 Ejemplos Prácticos

### 1. Sistema de Inventario
```ruby
inventario = {
  manzanas: { cantidad: 50, precio: 1.50 },
  bananas: { cantidad: 30, precio: 0.80 },
  naranjas: { cantidad: 25, precio: 2.00 }
}

# Mostrar inventario
inventario.each do |fruta, datos|
  puts "#{fruta.capitalize}: #{datos[:cantidad]} unidades a $#{datos[:precio]} c/u"
end

# Calcular valor total del inventario
valor_total = inventario.sum do |fruta, datos|
  datos[:cantidad] * datos[:precio]
end
puts "Valor total del inventario: $#{valor_total}"

# Frutas con poco stock
poco_stock = inventario.select { |fruta, datos| datos[:cantidad] < 35 }
puts "Frutas con poco stock: #{poco_stock.keys.join(', ')}"
```

### 2. Análisis de Calificaciones
```ruby
estudiantes = [
  { nombre: "Ana", calificaciones: [85, 92, 78, 90] },
  { nombre: "Luis", calificaciones: [76, 82, 89, 85] },
  { nombre: "María", calificaciones: [95, 88, 92, 96] },
  { nombre: "Pedro", calificaciones: [65, 70, 68, 72] }
]

# Calcular promedios
estudiantes.each do |estudiante|
  promedio = estudiante[:calificaciones].sum.to_f / estudiante[:calificaciones].length
  estudiante[:promedio] = promedio.round(2)
  puts "#{estudiante[:nombre]}: Promedio #{estudiante[:promedio]}"
end

# Encontrar el mejor estudiante
mejor_estudiante = estudiantes.max_by { |estudiante| estudiante[:promedio] }
puts "Mejor estudiante: #{mejor_estudiante[:nombre]} con #{mejor_estudiante[:promedio]}"

# Estudiantes aprobados (promedio >= 75)
aprobados = estudiantes.select { |estudiante| estudiante[:promedio] >= 75 }
puts "Estudiantes aprobados: #{aprobados.map { |e| e[:nombre] }.join(', ')}"
```

### 3. Procesamiento de Texto
```ruby
texto = "Ruby es un lenguaje de programación dinámico y expresivo"

# Contar palabras
palabras = texto.downcase.split
frecuencia_palabras = palabras.each_with_object(Hash.new(0)) do |palabra, hash|
  hash[palabra] += 1
end

puts "Frecuencia de palabras:"
frecuencia_palabras.each { |palabra, count| puts "#{palabra}: #{count}" }

# Palabras únicas ordenadas
palabras_unicas = palabras.uniq.sort
puts "Palabras únicas: #{palabras_unicas.join(', ')}"

# Palabras largas (más de 4 caracteres)
palabras_largas = palabras.select { |palabra| palabra.length > 4 }
puts "Palabras largas: #{palabras_largas.uniq.join(', ')}"
```

## 💡 Consejos y Mejores Prácticas

1. **Usa símbolos como keys en hashes** - Son más eficientes que strings
2. **Prefiere each sobre for** - Es más idiomático en Ruby
3. **Usa métodos como map, select, reject** en lugar de each cuando transforms datos
4. **Los hashes mantienen el orden de inserción** desde Ruby 1.9
5. **Usa fetch con valor por defecto** para acceso seguro a hashes
6. **Los ranges son memory-efficient** para secuencias grandes

¡Continúa con el siguiente archivo para aprender sobre métodos y funciones!
