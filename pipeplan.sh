ADQL="SELECT TOP 200000 g.Source,w.ALLWISE,g.RA_ICRS,g.DE_ICRS,w.RAJ2000,w.DEJ2000,g.Plx,g.Gmag,w.W1mag,w.W2mag FROM \"I/355/gaiadr3\" AS g JOIN \"II/328/allwise\" AS w ON 1 = CONTAINS(POINT('ICRS',w.RAJ2000,w.DEJ2000),CIRCLE('ICRS',g.RA_ICRS,g.DE_ICRS,0.005)) WHERE 1=CONTAINS(POINT('ICRS',w.RAJ2000,w.DEJ2000),CIRCLE('ICRS',266.41683,-29.00781,0.5))"

# Reemplazamos los espacios por '+' usando 'sed' para que la URL no se rompa en internet
URL_ADQL=$(echo $ADQL | sed 's/ /+/g')
# Definimos el Endpoint base de VizieR
TAP_URL="https://tapvizier.cds.unistra.fr/TAPVizieR/tap/sync?request=doQuery&lang=ADQL&format=csv&query="

echo "Descargando datos....."
wget -O gaia_allwise.csv "$TAP_URL$URL_ADQL"
echo "Datos descargados gaia_allwise.csv"
