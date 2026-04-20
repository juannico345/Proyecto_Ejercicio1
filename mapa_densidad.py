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
