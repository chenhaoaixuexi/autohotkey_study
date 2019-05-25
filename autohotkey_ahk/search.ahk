#Include, ./superkey.ahk
CapsLock & Q::
searchSignal := True ; 对应标志位置1
if(func_getClipboard())
	InputBox , SearchString, Searcher, %searchPrompt%,,250,230,,,,,%Clipboard%	
else{
	InputBox , SearchString, Searcher, %searchPrompt%,,250,230,,,,,%SearchString%
}
return

#if WinActive("Searcher ahk_class #32770") ; and (searchSignal == true)

$CapsLock::
Send {esc}
func_tooltip("exit searchMode")
searchSignal := False
return

; ~Enter::
; searchSignal := False
; return

!1::
; $*Enter::funcSearch(1)
<!1::funcSearch(1)
;TODO FIX 不可用

<!2::funcSearch(2)
; !2::funcSearch(2)
<!3::funcSearch(3)
<!4::funcSearch(4)
<!5::funcSearch(5)
<!6::funcSearch(6)
<!7::funcSearch(7)
<!8::funcSearch(8)
<!9::funcSearch(9)
<!0::funcSearch(10)
<!g::funcSearch(-1,0)

<!q::
send ^{a}^{c}{Right}
result := "=" . calc(Clipboard)
send  %result%
searchSignal := False
return

#if

funcSearch(modeID,direcRun:=False){
	global searchEnginString 
	global SearchString
	global searchSignal
	searchSignal := False
	mode := searchEnginString[modeID]
	Send, {Enter}	
	runString := mode . SearchString
	; ListVars
	if (direcRun==False)
		run %runString%
	else
		run   %SearchString%
	WinActivate, ahk_exe chrome.exe
	WinWait, ahk_exe chrome.exe
	func_tooltip("exit searchMode")
	return
}

;TODO 计算
;=======|      function |============================================
calc( t, t0="", t1="", t2="" )
{   ; c-labeled functions by Laszlo: http://www.autohotkey.com/forum/topic17058.html
   static f := "sqrt|log|ln|exp|sin|cos|tan|asin|acos|atan|rad|deg|abs", c := "fib|gcb|min|max|sgn"
          o := "\*\*|\^|\*|/|//|\+|\-|%", pi:="pi", e:="e"
   if ( t0 = "fib"  && t1 != "" && t2 != "" ) {
      a := 0, b := 1 
      Loop % abs(t1)-1
         c := b, b += a, a := c
      return t1=0 ? 0 : t1>0 || t1&1 ? b : -b
   } else if ( t0 != "" && RegExMatch( t0, "(" f "|" c "|" o "|!)" ) && t1 != "" && t2 != "" )
      return t0 == "**" ? t1 ** t2 : t0 == "^" ? t1 ** t2 
           : t0 == "*" ? t1 * t2   : t0 == "/" ? t1 / t2 : t0 == "+" ? t1 + t2 : t0 == "-" ? t1 - t2
          : t0 == "//" ? t1 // t2 : t0 == "%" ? Mod( t1, t2 ) : t0 = "abs" ? abs( calc( t1 ) )
          : t0 == "!" ? ( t1 < 2 ? 1 : t1 * calc( t, t0, t1-1, 0 ) )
          : t0 = "log" ? log( calc( t1 ) ) : t0 = "ln" ? ln( calc ( t1 ) )
          : t0 = "sqrt" ? sqrt( calc( t1 ) ) : t0 = "exp" ? Exp( calc ( t1 ) )
          : t0 = "rad" ? calc( calc( t1 ) "* pi / 180" ) : t0 = "deg" ? calc( calc( t1 ) "* 180 / pi" )
          : t0 = "sin" ? sin( calc( "rad(" t1 ")" ) ) : t0 = "asin" ? asin( calc( "rad(" t1 ")" ) )
          : t0 = "cos" ? cos( calc( "rad(" t1 ")" ) ) : t0 = "acos" ? acos( calc( "rad(" t1 ")" ) )
          : t0 = "tan" ? tan( calc( "rad(" t1 ")" ) ) : t0 = "atan" ? atan( calc( "rad(" t1 ")" ) )
          : t0 = "min" ? ( t1 < t2 ? t1 : t2 ) : t0 = "max" ? ( t1 < t2 ? t2 : t1 )
          : t0 = "gcd" ? ( t2 = 0 ? abs(t1) : calc( t, t0, calc( t1 "%" t2 ) ) )
          : t0 = "sgn" ? (t1>0)-(t1<0) : 0
   
   t := RegExReplace( t, "\s*", "" )
   while ( RegExMatch( t, "i)" f "|" c "|" o "|" pi "|" e "|!" ) )
      if ( RegExMatch( t, "i)\b" pi "\b" ) )
         t := RegExReplace( t, "i)\b" pi "\b", 4 * atan(1) )
      else if ( RegExMatch( t, "i)\b" e "\b" ) )
         t := RegExReplace( t, "i)\b" e "\b", 2.718281828459045 )
      else if ( RegExMatch( t, "i)(" f "|" c ").*", s ) 
             && RegExMatch( s, "(?>[^\(\)]*)\((?>[^\(\)]*)(?R)*(?>[^\(\)]*)\)", m )
            && RegExMatch( m, "(?P<0>[^(]+)\((?P<1>[^,]*)(,(?P<2>.*))?\)", p ) )
         t := RegExReplace( t, "\Q" p "\E", calc( "", p0, p1, p2 != "" ? p2 : 0 ) )
      else if ( RegExMatch( t, "(?P<1>-*\d+(\.\d+)?)!", p) )
         t := RegExReplace( t, "\Q" p "\E", calc( "", "!", p1, 0 ) )
      else if ( RegExMatch( t, "\((?P<0>[^(]+)\)", p ) )
         t := RegExReplace( t, "\Q(" p0 ")\E", calc( p0 ) )
      else
         loop, parse, o, |
            while ( RegExMatch( t, "(?P<1>-*\d+(\.\d+)?)(?P<0>" A_LoopField ")(?P<2>-*\d+(\.\d+)?)", p ) )
               t := RegExReplace( t, "\Q" p "\E", calc( "", p0, p1, p2 ) )
   return t
}
