ADQL="SELECT TOP 200000 g.Source,w.ALLWISE,g.RA_ICRS,g.DE_ICRS,w.RAJ2000,w.DEJ2000,g.Plx,g.Gmag,w.W1mag,w.W2mag FROM \"I/355/gaiadr3\" AS g JOIN \"II/328/allwise\" AS w ON 1 = CONTAINS(POINT('ICRS',w.RAJ2000,w.DEJ2000),CIRCLE('ICRS',g.RA_ICRS,g.DE_ICRS,0.005)) WHERE 1=CONTAINS(POINT('ICRS',w.RAJ2000,w.DEJ2000),CIRCLE('ICRS',266.41683,-29.00781,0.5))"

# Reemplazamos los espacios por '+' usando 'sed' para que la URL no se rompa en internet
URL_ADQL=$(echo $ADQL | sed 's/ /+/g')
# Definimos el Endpoint base de VizieR
TAP_URL="https://tapvizier.cds.unistra.fr/TAPVizieR/tap/sync?request=doQuery&lang=ADQL&format=csv&query="

echo "Descargando datos....."
wget -O gaia_allwise.csv "$TAP_URL$URL_ADQL"
echo "Datos descargados gaia_allwise.csv"
echo "Realizando grafica a partir de los datos obtenidos"

cat <<'EOF'> mapa_densidad.py
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
df = pd.read_csv('gaia_allwise.csv')

df['indice_oi'] = df['Gmag'] - df['W2mag']

# Mapa de densidad
sc = plt.scatter(df['Gmag'], df['indice_oi'], c=df['indice_oi'], cmap='inferno')
plt.colorbar(sc, label='Índice O-I')
plt.title('Indice de Color O-I vs Magnitud Aparente')
plt.grid(alpha=0.3)
plt.savefig('mapa_densidad.png')
plt.show()

print('Imagen de densidad generada')
EOF

python3 mapa_densidad.py

echo "gaia_allwise.csv" >.gitignore
git add pipeplan.sh mapa_densidad.py mapa_densidad.png .gitignore

git commit -m 'Pipeline actualizado'

echo "Resta hacer el analisis fisico"
