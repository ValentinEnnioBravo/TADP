require_relative '../lib/refactor'

describe 'Test de creación de un Documento: ' do

  before do
    @document = Document.new() do
      alumno nombre: "Matias", legajo: "123456-7" do
        telefono { "1234567890" }
        estado es_regular: true do
          finales_rendidos { 3 }
          materias_aprobadas { 5 }
        end
      end
    end
  end

  it 'El primer tag es la raiz del documento' do
    tagRaiz = @document.root
    expect(tagRaiz.label).to eq("alumno")
    expect(tagRaiz.attributes[:nombre]).to eq("Matias")
    expect(tagRaiz.attributes[:legajo]).to eq("123456-7")
    expect(tagRaiz.attributes).to eq({nombre: "Matias", legajo: "123456-7"})
  end

  it 'Los hijos del tag raiz son los adecuados' do
    tagRaiz = @document.root
    expect(tagRaiz.children[0].label).to eq("telefono")
    expect(tagRaiz.children[1].label).to eq("estado")
    expect(tagRaiz.children.size).to eq(2)
  end

  it 'Los bloques que no son tags se cargan como hijos' do
    telefono = @document.root.children[0]
    finalesRendidos = @document.root.children[1].children[0]
    materiasAprobadas = @document.root.children[1].children[1]

    expect(telefono.children[0]).to eq("1234567890")
    expect(finalesRendidos.children[0]).to eq(3)
        expect(materiasAprobadas.children[0]).to eq(5)
  end
end

describe 'Al serializar un documento retorna lo esperado' do
  class Alumno
    attr_reader :nombre, :legajo, :estado
    def initialize(nombre, legajo, telefono, estado)
      @nombre = nombre
      @legajo = legajo
      @telefono = telefono
      @estado = estado
    end
  end

  class Estado
    attr_reader :finales_rendidos, :materias_aprobadas, :es_regular
    def initialize(finales_rendidos, materias_aprobadas, es_regular)
      @finales_rendidos = finales_rendidos
      @es_regular = es_regular
      @materias_aprobadas = materias_aprobadas
    end
  end

  unEstado = Estado.new(3, 5, true)
  unAlumno = Alumno.new("Matias","123456-8", "1234567890", unEstado)

  documento_manual = Document.new do
     alumno nombre: unAlumno.nombre, legajo: unAlumno.legajo do
     estado finales_rendidos: unAlumno.estado.finales_rendidos,
      materias_aprobadas: unAlumno.estado.materias_aprobadas,  
      es_regular: unAlumno.estado.es_regular
    end
  end

  documento_automatico = Document.serialize(unAlumno)

  # documento_automatico = Tag.xml
  # documento_manual = Doc

  it 'Un documento se serializa correctamente de forma manual' do
    expect(documento_manual.xml).to eq("<alumno nombre=\"Matias\" legajo=\"123456-8\">\n\t<estado finales_rendidos=3 materias_aprobadas=5 es_regular=true/>\n</alumno>")
    expect(documento_automatico.xml).to eq("<alumno nombre=\"Matias\" legajo=\"123456-8\">\n\t<estado finales_rendidos=3 es_regular=true materias_aprobadas=5/>\n</alumno>")
  end
  
end