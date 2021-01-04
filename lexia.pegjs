Lenguaje = ___*
  sentencias:Sentencias ___* {return sentencias}
Sentencias = Sentencia_completa*
Sentencia_completa =
  sentencia:( Comentario / Sentencia_de_entendimiento / Sentencia_de_prohibicion / Sentencia_de_obligacion / Sentencia_de_seccion ) {return sentencia}
Sentencia_de_entendimiento = "SE ENTIENDE POR" _+
  concepto:Resto_de_linea ___*
  definicion:Definicion {return {concepto, definicion}}
Definicion = (!(EOS).)+ EOS {return text().trim()}
Sentencia_de_prohibicion = "SE PROHIBE" mandato:Contenidos_de_mandato {return {tipo: "prohibición", ...mandato}}
Contenidos_de_mandato =
  accion:Accion
  aplicantes:Aplicante*
  condicionantes:Condicionantes?
  penas:Penas?
  atenuantes:Atenuante*
  agravantes:Agravante*
  EOS {return {accion, condicionantes, penas, atenuantes, agravantes}}
Sentencia_de_seccion =
  seccion:( "LIBRO" / "TÍTULO" / "CAPÍTULO" / "SECCIÓN" / "ARTÍCULO" / "PUNTO" )
  numeracion:Numeracion_de_seccion
  nombre:Nominalizacion_de_seccion?
  EOS {return {seccion, numeracion, nombre}}
Numeracion_de_seccion = _ [0-9]+ {return parseInt(text().trim())}
Nominalizacion_de_seccion = ":" Resto_de_linea {return text().replace(/^:/g, "").trim()}
Sentencia_de_obligacion = "SE OBLIGA A" mandato:Contenidos_de_mandato {return {tipo: "obligación", ...mandato}}
Accion = ___+
  accion:Resto_de_linea EOL {return accion}
Penas = _+ "CON PENA DE" _
  pena:Resto_de_linea  EOL {return pena}
Atenuante = _+ "CON ATENUANTE DE" _
  atenuante:Resto_de_linea EOL
  condicionantes:Condicionantes? {return {atenuante, condicionantes}}
Agravante = _+ "CON AGRAVANTE DE" _
  agravante:Resto_de_linea EOL
  condicionantes:Condicionantes? {return {agravante, condicionantes}}
Aplicante = _+ "A" _
  aplicante:Resto_de_linea EOL {return aplicante}
Condicionantes =
  nivel:TAB "SI" _
  condicion:Resto_de_linea EOL
  otras_condiciones:Otros_condicionantes* {return {nivel, condiciones: [condicion].concat(otras_condiciones) }}
Otros_condicionantes =
  nivel:TAB
  yuncion:( "Y SI" / "O SI" ) _
  condicion:Resto_de_linea EOL {return {nivel, yuncion, condicion}}
Resto_de_linea = Resto_de_linea_1
Resto_de_linea_1 = (!(EOL).)* {return text().trim()}
EOL = ( __ / EOF ) {return text()}
EOF = !. {return {tipo: "fin"}}
TAB = _+ {return text().length}
___ = ( _ / __ ) {return text()}
__ = ( "\r\n" / "\n" ) {return text()}
_ = ( "\t" / " " ) {return text()}
Comentario = 
  comentario:(Comentario_unilinea / Comentario_multilinea) {return {tipo: "comentario", comentario}}
Comentario_unilinea = "(" (!(")" __).)+ ")" {return text().trim().replace(/^\(|\)$/g, "")}
Comentario_multilinea = "===" "="*
  comentario:Contenido_comentario_multilinea Cerrar_comentario_multilinea {return comentario}
Contenido_comentario_multilinea = (!(Cerrar_comentario_multilinea).)+ {return text()}
Cerrar_comentario_multilinea = __ "===" "="* EOS {return text()}
EOS = ((__ __+) / (___* EOF))















