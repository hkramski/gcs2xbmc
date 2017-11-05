# $Id: gcs2xbmc.awk,v 1.4 2017/11/05 12:29:53 root Exp root $ 
# Transform GCstar DVD movie collection database into Kodi stub files
# kramski@web.de
# http://www.gcstar.org/
# http://kodi.wiki/view/Media_stubs
# Usage: gawk -f gcs2xbmc.awk mydatabase.gcs
# $Log: gcs2xbmc.awk,v $
# Revision 1.4  2017/11/05 12:29:53  root
# Change references from XBMC to Kodi
#

BEGIN {
   FS="[=\"]"
   # Since=-2 # set to -2 for all or set added date like this to skip old items:
   Since=mktime("2017 11 04 00 00 00")
}

/<item/ {                       # Start of Item
    Title="Unbekannt"
    OutFile="unknown.disc"
    Place="Unbekannt"
    Format=""
    Year=""
    Added=0
    next
}

/^  title=/ {
    # Remove stopwords at end of title
    sub(/ \([dD]er\)\"$/, "")
    sub(/ \([dD]ie\)\"$/, "")
    sub(/ \([dD]as\)\"$/, "")
    sub(/ \([eE]ine\)\"$/, "")
    sub(/ \([eE]in\)\"$/, "")
    sub(/ \([tT]he\)\"$/, "")
    sub(/ \([aA]n\)\"$/, "")
    sub(/ \([aA]\)\"$/, "")

    sub(/, [dD]er\"$/, "")
    sub(/, [dD]ie\"$/, "")
    sub(/, [dD]as\"$/, "")
    sub(/, [eE]ine\"$/, "")
    sub(/, [eE]in\"$/, "")
    sub(/, [tT]he\"$/, "")
    sub(/, [aA]n\"$/, "")
    sub(/, [aA]\"$/, "")

    Title=$3
    # print "Title: >" Title "<"
    next
}

/^  date=/ {
    Year=$3
    # print "Year: >" Year "<"
    next
}

/^  place=/ {
    Place=$3
    next
}

/^  format=\"[dD][vV][dD]/ {
    Format=".dvd"
    next
}

/^  format=\"[bB][lL][uU]/ {
    Format=".blu"
    next
}

/^  added=/ {
    Added=mktime(substr($3, 7, 4) " " substr($3, 4, 2) " " substr($3, 1, 2) " 00 00 00")
    # print Added
    next
}

/<\/item>/ {
   if (Added > Since)
   {
      OutFile = Title
      gsub(/ /, "_", OutFile)
      gsub(/:/, "", OutFile)
      gsub(/ä/, "a", OutFile)
      gsub(/á/, "a", OutFile)
      gsub(/à/, "a", OutFile)
      gsub(/â/, "a", OutFile)
      gsub(/é/, "e", OutFile)
      gsub(/è/, "e", OutFile)
      gsub(/ö/, "o", OutFile)
      gsub(/ô/, "o", OutFile)
      gsub(/ü/, "u", OutFile)
      gsub(/Ä/, "A", OutFile)
      gsub(/Ö/, "O", OutFile)
      gsub(/Ü/, "U", OutFile)
      gsub(/ß/, "ss", OutFile)

      if (Year)
          OutFile = OutFile "_(" Year ")"

      OutFile = OutFile Format ".disc"

      print "Writing " OutFile    

      print "<discstub>" > OutFile
      print "  <title>" Title "</title>" >> OutFile
      print "  <message>Standort: " Place "</message>" >> OutFile
      print "</discstub>" >> OutFile

   }
   next
}
