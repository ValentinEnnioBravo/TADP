# 02 - Condicionales y Loops

## 🤔 Estructuras Condicionales

### If, Elsif, Else
```ruby
edad = 18

if edad >= 18
  puts "Eres mayor de edad"
elsif edad >= 13
  puts "Eres adolescente"
else
  puts "Eres un niño"
end

# If de una línea (postfix)
puts "Puedes votar" if edad >= 18

# Operador ternario
estado = edad >= 18 ? "mayor" : "menor"
```

### Unless (lo contrario de if)
```ruby
edad = 15

unless edad >= 18
  puts "No puedes votar"
end

# Unless postfix
puts "Necesitas permiso" unless edad >= 18

# Unless es equivalente a if negativo
if !(edad >= 18)
  puts "No puedes votar"
end
```

### Case/When (similar a switch)
```ruby
dia = "lunes"

case dia
when "lunes"
  puts "Inicio de semana"
when "martes", "miércoles", "jueves"
  puts "Día laboral"
when "viernes"
  puts "¡Por fin viernes!"
when "sábado", "domingo"
  puts "Fin de semana"
else
  puts "Día no válido"
end

# Case con rangos y clases
numero = 85

case numero
when 0..59
  puts "Reprobado"
when 60..79
  puts "Aprobado"
when 80..100
  puts "Excelente"
else
  puts "Número inválido"
end

# Case con tipos
valor = "Hola"

case valor
when String
  puts "Es un texto"
when Integer
  puts "Es un número"
when Array
  puts "Es un arreglo"
end
```

## 🔄 Loops (Bucles)

### While
```ruby
contador = 0

while contador < 5
  puts "Contador: #{contador}"
  contador += 1
end

# While postfix
contador += 1 while contador < 10
```

### Until (lo contrario de while)
```ruby
contador = 0

until contador >= 5
  puts "Contador: #{contador}"
  contador += 1
end

# Until postfix
contador += 1 until contador >= 10
```

### For
```ruby
# For con rango
for i in 1..5
  puts "Número: #{i}"
end

# For con array
frutas = ["manzana", "banana", "naranja"]
for fruta in frutas
  puts "Fruta: #{fruta}"
end
```

### Times (específico de Ruby)
```ruby
# Ejecutar algo n veces
5.times do
  puts "¡Hola!"
end

# Con índice
5.times do |i|
  puts "Iteración #{i}"
end

# Versión de una línea
3.times { puts "Ruby es genial!" }
```

### Each (el más usado en Ruby)
```ruby
# Each con array
[1, 2, 3, 4, 5].each do |numero|
  puts "Número: #{numero}"
end

# Each con hash
persona = { nombre: "Ana", edad: 25, ciudad: "Madrid" }
persona.each do |clave, valor|
  puts "#{clave}: #{valor}"
end

# Each con rango
(1..5).each { |i| puts "Valor: #{i}" }
```

### Upto, Downto, Step
```ruby
# Upto (hacia arriba)
1.upto(5) do |i|
  puts "Subiendo: #{i}"
end

# Downto (hacia abajo)
5.downto(1) do |i|
  puts "Bajando: #{i}"
end

# Step (con pasos específicos)
0.step(20, 5) do |i|
  puts "Paso de 5: #{i}"  # 0, 5, 10, 15, 20
end
```

## 🎛 Control de Flujo

### Break (salir del loop)
```ruby
# Salir completamente del loop
(1..10).each do |i|
  break if i == 6
  puts i
end
# Imprime: 1, 2, 3, 4, 5

# Break con valor de retorno
resultado = (1..10).each do |i|
  break "Encontrado!" if i == 5
  puts i
end
puts resultado  # "Encontrado!"
```

### Next (continuar con la siguiente iteración)
```ruby
# Saltar a la siguiente iteración
(1..5).each do |i|
  next if i == 3
  puts i
end
# Imprime: 1, 2, 4, 5

# Next en loops anidados
(1..3).each do |i|
  (1..3).each do |j|
    next if i == j
    puts "#{i}, #{j}"
  end
end
```

### Redo (repetir la iteración actual)
```ruby
contador = 0
(1..5).each do |i|
  contador += 1
  if contador < 3 && i == 2
    redo  # Repite cuando i = 2
  end
  puts "i: #{i}, contador: #{contador}"
end
```

## 🔄 Loops Infinitos
```ruby
# Loop infinito básico
loop do
  puts "Ingresa 'salir' para terminar:"
  entrada = gets.chomp
  break if entrada == "salir"
  puts "Dijiste: #{entrada}"
end

# While true
while true
  puts "Ingresa un número (0 para salir):"
  numero = gets.chomp.to_i
  break if numero == 0
  puts "El doble es: #{numero * 2}"
end
```

## 🎯 Ejemplos Prácticos

### 1. Menú de opciones
```ruby
loop do
  puts "\n=== MENÚ ==="
  puts "1. Saludar"
  puts "2. Calcular edad"
  puts "3. Salir"
  print "Elige una opción: "
  
  opcion = gets.chomp.to_i
  
  case opcion
  when 1
    print "¿Cómo te llamas? "
    nombre = gets.chomp
    puts "¡Hola, #{nombre}!"
  when 2
    print "¿En qué año naciste? "
    año_nacimiento = gets.chomp.to_i
    edad = Time.now.year - año_nacimiento
    puts "Tienes aproximadamente #{edad} años"
  when 3
    puts "¡Hasta luego!"
    break
  else
    puts "Opción no válida"
  end
end
```

### 2. Validación de entrada
```ruby
def obtener_numero_valido
  loop do
    print "Ingresa un número entre 1 y 10: "
    entrada = gets.chomp
    
    # Verificar si es un número
    if entrada.match?(/^\d+$/)
      numero = entrada.to_i
      if numero >= 1 && numero <= 10
        return numero
      else
        puts "Error: El número debe estar entre 1 y 10"
      end
    else
      puts "Error: Debes ingresar un número válido"
    end
  end
end

numero = obtener_numero_valido
puts "Elegiste el número: #{numero}"
```

### 3. Juego de adivinanza
```ruby
numero_secreto = rand(1..100)  # Número aleatorio entre 1 y 100
intentos = 0
max_intentos = 7

puts "¡Adivina el número entre 1 y 100!"
puts "Tienes #{max_intentos} intentos."

while intentos < max_intentos
  print "Intento #{intentos + 1}: "
  intento = gets.chomp.to_i
  intentos += 1
  
  if intento == numero_secreto
    puts "¡Felicidades! Adivinaste en #{intentos} intentos."
    break
  elsif intento < numero_secreto
    puts "Muy bajo"
  else
    puts "Muy alto"
  end
  
  if intentos == max_intentos
    puts "Se acabaron los intentos. El número era #{numero_secreto}"
  end
end
```

### 4. Procesamiento de lista
```ruby
numeros = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# Filtrar números pares
pares = []
numeros.each do |numero|
  pares << numero if numero.even?
end
puts "Números pares: #{pares}"

# Sumar todos los números
suma = 0
numeros.each { |numero| suma += numero }
puts "Suma total: #{suma}"

# Encontrar el primer número mayor a 5
numeros.each do |numero|
  if numero > 5
    puts "Primer número mayor a 5: #{numero}"
    break
  end
end
```

## 💡 Consejos y Mejores Prácticas

1. **Usa each en lugar de for**: Es más idiomático en Ruby
2. **Prefiere unless para condiciones negativas simples**
3. **Case es mejor que múltiples elsif**
4. **Usa times cuando sepas el número exacto de iteraciones**
5. **Break y next hacen el código más limpio que banderas booleanas**

¡Continúa con el siguiente archivo para aprender sobre colecciones!
