# frozen_string_literal: true
# frozen_string_literal: true

class Tag
  attr_reader :label, :attributes, :children
  def self.with_label(label)
    new(label)
  end
  def initialize(label)
    @label = label
    @attributes = {}
    @children = []
  end
  def with_label(label)
    @label = label
    self
  end
  def with_attribute(label, value)
    @attributes[label] = value
    self
  end
  def with_child(child)
    @children << child
    self
  end
  def xml(level=0)
    if children.empty?
      "#{"\t" * level}<#{label}#{xml_attributes}/>"
    else
      "#{"\t" * level}<#{label}#{xml_attributes}>\n#{xml_children(level + 1)}\n#{"\t" * level}</#{label}>"
    end
  end
  private
  def xml_children(level)
    self.children.map do |child|
      if child.is_a? Tag
        child.xml(level)
      else
        xml_value(child, level)
      end
    end.join("\n")
  end
  def xml_attributes
    self.attributes.map do |name, value|
      "#{name}=#{xml_value(value, 0)}"
    end.xml_join(' ')
  end
  def xml_value(value, level)
    "\t" * level + if value.is_a? String
                     "\"#{value}\""
                   else
                     value.to_s
                   end
  end
end
class Array
  def xml_join(separator)
    self.join(separator).instance_eval do
      if !empty?
        "#{separator}#{self}"
      else
        self
      end
    end
  end
end

class Document
  attr_reader :tag
  def initialize(&block)
    @tag = instance_eval(&block) if block_given?
  end

  # Como el Doc va a tener adentro el nombre de un tag va a pensar que es el nombre de un método
  # y como no voy a tener ese método, tengo que definir un comportamiento para ese caso
  def method_missing(tagName, *args, &block)
    tag = Tag.new(tagName) # Inicializo el tag
  end
end

class Alumno
  attr_reader :nombre, :legajo, :estado
  def initialize(nombre, legajo, telefono, estado)
    @nombre = nombre
    @legajo = legajo
    @telefono = telefono
    @estado = estado
  end
end
