alias m.cm {
  var %z, %n, %c
  if (!$readini($1,modulo,nombre)) { write modulos\carga.log $asctime(HH:nn:ss dd/mm) -> ERROR en $nopath($1) * Falta parámetro: prefijo. | %z = 1 }
  if (!$readini($1,modulo,prefijo)) { write modulos\carga.log $asctime(HH:nn:ss dd/mm) -> ERROR en $nopath($1) * Falta parámetro: nombre. | %z = 1 }
  if (!$readini($1,modulo,nick)) { write modulos\carga.log $asctime(HH:nn:ss dd/mm) -> ERROR en $nopath($1) * Falta parámetro: nick. | %z = 1 }
  if (!$readini($1,modulo,serv)) { write modulos\carga.log $asctime(HH:nn:ss dd/mm) -> ERROR en $nopath($1) * Falta parámetro: serv. | %z = 1 }
  if ($readini($1,modulo,nombre) == $readini($1,modulo,nick)) { write modulos\carga.log $asctime(HH:nn:ss dd/mm) -> ERROR en $nopath($1) * Nombre y nick del módulo coincidentes. | %z = 1 }
  if ($hget(+modulos,$readini($1,modulo,nombre)) && !$2) { write modulos\carga.log $asctime(HH:nn:ss dd/mm) -> ERROR en carga de $nopath($1) * El módulo ya está cargado. | %z = 1 }
  if ($hget(+bots,$readini($1,modulos,serv))) { write modulos\carga.log $asctime(HH:nn:ss dd/mm) -> ERROR en $nopath($1) * La función de este módulo ya está instalada. | %z = 1 }
  if (%z == 1 && !$2) {
    if ($input(Se han producido errores y no es posible la carga del módulo $nopath($1). $crlf $crlf $+ ¿Quiere ver el archivo carga.log?,yh,Errores)) { run modulos\carga.log }
    halt
  }
  if (!$readini($1,modulo,ayuda)) { write modulos\carga.log $asctime(HH:nn:ss dd/mm) -> ADVERTENCIA en $nopath($1) * No se ha especificado archivo de ayuda. | %z = 2 }
  %c = $numtok($readini($1,modulo,ayuda),44) | while (%c) { if (!$isfile(modulos\ $+ $gettok($readini($1,modulo,ayuda),%c,44))) { write modulos\carga.log $asctime(HH:nn:ss dd/mm) -> ADVERTENCIA en $nopath($1) * No se ha encontrado el archivo $gettok($readini($1,modulo,ayuda),%c,44) $+ . | %z = 2 } | dec %c }
  %c = $numtok($readini($1,modulo,archivos),44) | while (%c) { if (!$isfile(modulos\ $+ $gettok($readini($1,modulo,archivos),%c,44))) { write modulos\carga.log $asctime(HH:nn:ss dd/mm) -> ADVERTENCIA en $nopath($1) * No se ha encontrado el archivo $gettok($readini($1,modulo,archivos),%c,44) $+ . | %z = 2 } | dec %c }
  if ($readini($1,modulo,conf) && !$isfile(modulos\ $+ $readini($1,modulo,conf))) { write modulos\carga.log $asctime(HH:nn:ss dd/mm) -> ADVERTENCIA en $nopath($1) * No se ha encontrado el archivo de configuración. | %z = 2 }
  if (!$readini($1,modulo,version)) { write modulos\carga.log $asctime(HH:nn:ss dd/mm) -> ADVERTENCIA en $nopath($1) * No se ha especificado versión. | %z = 2 }
  if (!$readini($1,modulo,autor)) { write modulos\carga.log $asctime(HH:nn:ss dd/mm) -> ADVERTENCIA en $nopath($1) * No se ha especificado autor. | %z = 2 }
  if (!$readini($1,modulo,mail)) { write modulos\carga.log $asctime(HH:nn:ss dd/mm) -> ADVERTENCIA en $nopath($1) * No se ha especificado mail. | %z = 2 }
  else if (!$regex($readini($1,modulo,mail),^(.+\@.+\..+)$)) { write modulos\carga.log $asctime(HH:nn:ss dd/mm) -> ADVERTENCIA en $nopath($1) * No parece un mail válido. | %z = 2 }
  if (!$readini($1,modulo,url)) { write modulos\carga.log $asctime(HH:nn:ss dd/mm) -> ADVERTENCIA en $nopath($1) * No se ha especificado url. | %z = 2 }
  if ($readini($1,modulo,residente) && $left($readini($1,modulo,residente),1) != $chr(35)) { write modulos\carga.log $asctime(HH:nn:ss dd/mm) -> ADVERTENCIA en $nopath($1) * Canal incorrecto. | %z = 2 }
  if (!$ini($1,comandos)) { write modulos\carga.log $asctime(HH:nn:ss dd/mm) -> ADVERTENCIA en $nopath($1) * No se han encontrado comandos. | %z = 2 }
  hadd -m +modulos $readini($1,modulo,nombre) $1 $readini($1,modulo,prefijo) $readini($1,modulo,nick) | if ($readini($1,modulo,activo)) { hadd -m +bots $readini($1,modulo,serv) $readini($1,modulo,nick) }
  if ($_.conf($1,resident)) { hadd -m +residente $readini($1,modulo,serv) 1 }
  %n = $readini($1,modulo,nombre)
  hadd -m %n _prefijo $readini($1,modulo,prefijo) 
  .load -rs $1
  if ($gettok($1,2,92)) { writeini -n tmp/rutas rutas $gettok($1,2,92) $gettok($1,1,92) $+ / }
  if (!$gettok($1,2,92)) { writeini -n tmp/rutas rutas $gettok($1,2,47) $gettok($1,1,47) $+ / }
  %c = $numtok($readini($1,modulo,ayuda),44) | while (%c) { if (!$isfile(modulos\ $+ $gettok($readini($1,modulo,ayuda),%c,44))) { dec %c | continue } | .load -rs modulos\ $+ $gettok($readini($1,modulo,ayuda),%c,44) | dec %c }
  %c = $numtok($readini($1,modulo,archivos),44) | while (%c) { if (!$isfile(modulos\ $+ $gettok($readini($1,modulo,archivos),%c,44))) { dec %c | continue } | .load -rs modulos\ $+ $gettok($readini($1,modulo,archivos),%c,44) | dec %c }
  hadd %n _version $readini($1,modulo,version) | hadd %n _autor $readini($1,modulo,autor) | hadd %n _mail $readini($1,modulo,mail) | hadd %n _url $readini($1,modulo,url) | hadd %n _creditos $readini($1,modulo,creditos)
  writeini -n conf\main.conf modulos %n $1
  var %i = 1 | while ($ini($1,comandos,%i)) { hadd %n $ifmatch $+($hget(%n,_prefijo),.,$readini($1,comandos,$ifmatch)) | inc %i }
  if ($dialog(principal)) { 
    did -a principal $_id(listbots) %n 
    did -a principal $_id(listbotsext) $+(0 0 0 $iif($readini($1,modulo,activo),2,1) $readini($1,modulo,nick),$chr(9),$readini($1,modulo,ident),$chr(9),$readini($1,modulo,host),$chr(9),$readini($1,modulo,realname),$chr(9),$readini($1,modulo,modos),$chr(9),$readini($1,modulo,nombre)) 
  }
  if (%z == 2 && !$2) { if ($input(Se han producido advertencias $nopath($1) $+ . $crlf $crlf $+ ¿Quiere ver el archivo carga.log?,yw,Advertencias)) { run modulos\carga.log } }
  if ($readini($1,modulo,activo) && $sock(ircd)) {
    sockwrite -nt ircd $_.tok(NICK) $gettok($hget(+modulos,%n),3,32) 1 $ctime $readini($gettok($hget(+modulos,%n),1,32),modulo,ident) $replace($readini($gettok($hget(+modulos,%n),1,32),modulo,host),&red,$_.net) $_.serv 0 : $+ $readini($gettok($hget(+modulos,%n),1,32),modulo,realname)
    k $gettok($hget(+modulos,%n),3,32) $_.tok(UMODE2) $readini($gettok($hget(+modulos,%n),1,32),modulo,modos)
    k $gettok($hget(+modulos,%n),3,32) $_.tok(JOIN) $readini($gettok($hget(+modulos,%n),1,32),modulo,residente)
    if ($_conf(bots,autobop)) { var %j = $numtok($readini($gettok($hget(+modulos,%n),1,32),modulo,residente),44) | while (%j) { k $_.serv $_.tok(MODE) $gettok($readini($gettok($hget(+modulos,%n),1,32),modulo,residente),%j,44) o $gettok($hget(+modulos,%n),3,32) | dec %j } }
  }
}
alias m.dm { 
  if ($readini($gettok($hget(+modulos,$1),1,32),modulo,activo)) { k $gettok($hget(+modulos,$1),3,32) $_.tok(QUIT) :Descargando módulo... }
  %c = $numtok($readini($gettok($hget(+modulos,$1),1,32),modulo,ayuda),44) | while (%c) { .unload -rs modulos\ $+ $gettok($readini($gettok($hget(+modulos,$1),1,32),modulo,ayuda),%c,44) | dec %c }
  %c = $numtok($readini($gettok($hget(+modulos,$1),1,32),modulo,archivos),44) | while (%c) { .unload -rs modulos\ $+ $gettok($readini($gettok($hget(+modulos,$1),1,32),modulo,archivos),%c,44) | dec %c }
  .unload -rs $gettok($hget(+modulos,$1),1,32) | remini conf\main.conf modulos $1 | hdel +bots $hfind(+bots,$gettok($hget(+modulos,$1),3,32)).data | hfree $1 | hdel +modulos $1 
  if ($dialog(principal)) { did -d principal 84 $didwm(principal,84,* $+ $1,1) }
}
alias _.conf if ($readini($1,modulo,conf)) return $readini(modulos\ $+ $ifmatch,misc,$2)
