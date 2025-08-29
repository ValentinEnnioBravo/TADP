# 01 - Sintaxis Básica de Ruby

## 📝 Variables y Constantes

### Variables
En Ruby, no necesitas declarar el tipo de variable. Ruby es dinámicamente tipado.

```ruby
# Variables simples
nombre = "Juan"
edad = 25
activo = true
precio = 19.99

# Las variables pueden cambiar de tipo
numero = 42
numero = "Ahora soy texto"
```

### Tipos de Variables

```ruby
# Variable local (snake_case)
mi_variable = "local"

# Variable de instancia (comienza con @)
@variable_instancia = "instancia"

# Variable de clase (comienza con @@)
@@variable_clase = "clase"

# Variable global (comienza con $) - evitar usar
$variable_global = "global"
```

### Constantes
```ruby
# Constantes (SCREAMING_SNAKE_CASE)
PI = 3.14159
NOMBRE_APLICACION = "Mi App Ruby"

# Ruby te advierte si cambias una constante, pero lo permite
PI = 3.14  # Warning: already initialized constant PI
```

## 🔢 Tipos de Datos Básicos

### Números
```ruby
# Enteros
entero = 42
negativo = -15
grande = 1_000_000  # Underscores para legibilidad

# Flotantes
decimal = 3.14
cientifico = 1.5e10

# Operaciones básicas
suma = 10 + 5        # 15
resta = 10 - 3       # 7
multiplicacion = 4 * 6  # 24
division = 15 / 3    # 5
potencia = 2 ** 3    # 8
modulo = 10 % 3      # 1
```

### Strings (Cadenas)
```ruby
# Diferentes formas de crear strings
simple = 'Hola mundo'
doble = "Hola mundo"
multilínea = <<-EOF
Este es un string
de múltiples líneas
EOF

# Interpolación (solo con comillas dobles)
nombre = "Ana"
saludo = "Hola, #{nombre}!"  # "Hola, Ana!"

# Métodos útiles de string
texto = "Hola Mundo"
texto.length        # 10
texto.upcase        # "HOLA MUNDO"
texto.downcase      # "hola mundo"
texto.reverse       # "odnuM aloH"
texto.include?("Mundo")  # true
```

### Símbolos
```ruby
# Los símbolos son como strings inmutables y únicos
simbolo = :mi_simbolo
otro_simbolo = :nombre

# Útiles como keys en hashes o identificadores
estado = :activo
```

### Booleanos
```ruby
verdadero = true
falso = false

# En Ruby, solo nil y false son "falsy"
# Todo lo demás es "truthy" (incluyendo 0 y "")
```

### Nil
```ruby
vacio = nil

# Verificar si algo es nil
vacio.nil?          # true
"algo".nil?         # false
```

## ➕ Operadores

### Operadores Aritméticos
```ruby
a = 10
b = 3

a + b    # 13 (suma)
a - b    # 7  (resta)
a * b    # 30 (multiplicación)
a / b    # 3  (división entera)
a.to_f / b  # 3.333... (división real)
a % b    # 1  (módulo)
a ** b   # 1000 (potencia)
```

### Operadores de Comparación
```ruby
a = 5
b = 10

a == b   # false (igual)
a != b   # true  (diferente)
a < b    # true  (menor)
a > b    # false (mayor)
a <= b   # true  (menor o igual)
a >= b   # false (mayor o igual)
a <=> b  # -1 (spaceship operator: -1, 0, o 1)
```

### Operadores Lógicos
```ruby
verdadero = true
falso = false

verdadero && falso   # false (AND)
verdadero || falso   # true  (OR)
!verdadero          # false (NOT)

# Versiones en palabras (menor precedencia)
verdadero and falso  # false
verdadero or falso   # true
not verdadero        # false
```

### Operadores de Asignación
```ruby
numero = 10

numero += 5   # numero = numero + 5 (15)
numero -= 3   # numero = numero - 3 (12)
numero *= 2   # numero = numero * 2 (24)
numero /= 4   # numero = numero / 4 (6)
numero %= 4   # numero = numero % 4 (2)

# Asignación condicional
variable ||= "valor por defecto"  # Solo asigna si variable es nil o false
```

## 💬 Comentarios

```ruby
# Esto es un comentario de una línea

=begin
Este es un comentario
de múltiples líneas
aunque no es muy común en Ruby
=end

# Es preferible usar # para cada línea
# incluso en comentarios largos
# como este
```

## 📥📤 Entrada y Salida

### Salida (Output)
```ruby
# puts - imprime y añade nueva línea
puts "Hola mundo"
puts 42

# print - imprime sin nueva línea
print "Hola "
print "mundo"  # Resultado: "Hola mundo"

# p - imprime la representación del objeto (útil para debug)
p "Hola mundo"  # "Hola mundo" (con comillas)
p [1, 2, 3]     # [1, 2, 3]

# printf - formato específico
printf "El número es: %d\n", 42
```

### Entrada (Input)
```ruby
# gets - lee una línea completa (incluye \n)
puts "¿Cómo te llamas?"
nombre = gets           # Incluye el \n al final

# gets.chomp - lee una línea y quita el \n
puts "¿Cómo te llamas?"
nombre = gets.chomp     # Sin el \n

# Ejemplo completo
puts "¿Cuál es tu edad?"
edad = gets.chomp.to_i  # Convierte a entero

puts "Hola, tienes #{edad} años"
```

## 🔄 Conversiones de Tipo

```ruby
# String a número
"42".to_i        # 42 (entero)
"3.14".to_f      # 3.14 (flotante)
"abc".to_i       # 0 (si no se puede convertir)

# Número a string
42.to_s          # "42"
3.14.to_s        # "3.14"

# String a símbolo y viceversa
"nombre".to_sym  # :nombre
:nombre.to_s     # "nombre"

# Verificación de tipos
42.class         # Integer
"texto".class    # String
true.class       # TrueClass
```

## 🎯 Ejercicios Prácticos

1. **Calculadora básica**:
```ruby
puts "Primer número:"
num1 = gets.chomp.to_f

puts "Segundo número:"
num2 = gets.chomp.to_f

puts "Suma: #{num1 + num2}"
puts "Resta: #{num1 - num2}"
puts "Multiplicación: #{num1 * num2}"
puts "División: #{num1 / num2}" if num2 != 0
```

2. **Información personal**:
```ruby
puts "¿Cómo te llamas?"
nombre = gets.chomp

puts "¿Cuántos años tienes?"
edad = gets.chomp.to_i

mayor_edad = edad >= 18

puts "Hola #{nombre}, tienes #{edad} años"
puts mayor_edad ? "Eres mayor de edad" : "Eres menor de edad"
```

¡Continúa con el siguiente archivo para aprender sobre condicionales y loops!
