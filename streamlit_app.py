"""
Application Streamlit : classificateur de fleurs (VGG16 fine-tuné sur tf_flowers)

Lancement :
    streamlit run streamlit_app.py
"""

import numpy as np
import pandas as pd
import streamlit as st
import tensorflow as tf
from PIL import Image
from tensorflow.keras.applications.vgg16 import preprocess_input

# ------------------------------------------------------------------
# Paramètres
# ------------------------------------------------------------------
CHEMIN_MODELE = "E:\\deploiement_fleurs\\classificateur_fleurs_vgg16.h5"
TAILLE = 224  # même taille que pendant l'entraînement

# Même ordre que les étiquettes de tf_flowers (0 à 4)
CLASSES = ["pissenlit", "marguerite", "tulipe", "tournesol", "rose"]


# ------------------------------------------------------------------
# 1. Charger le modèle (une seule fois grâce au cache)
# ------------------------------------------------------------------
@st.cache_resource
def charger_modele():
    return tf.keras.models.load_model("E:\\deploiement_fleurs\\classificateur_fleurs_vgg16.h5")


# ------------------------------------------------------------------
# 2. Prétraitement : exactement le même que dans le notebook
# ------------------------------------------------------------------
def pretraiter(image):
    image = image.convert("RGB")                       # enlève la transparence des PNG
    tableau = np.array(image, dtype=np.float32)        # (hauteur, largeur, 3)
    tableau = tf.image.resize(tableau, (TAILLE, TAILLE)).numpy()
    tableau = preprocess_input(tableau)                # préparation VGG16 (pas de /255)
    return np.expand_dims(tableau, axis=0)             # (1, 224, 224, 3) : un lot d'une image


# ------------------------------------------------------------------
# 3. Interface
# ------------------------------------------------------------------
st.title("🌼 Classificateur de fleurs")
st.write(
    "Téléverse une photo de fleur. Le modèle (VGG16 fine-tuné) reconnaît "
    "5 espèces : pissenlit, marguerite, tulipe, tournesol et rose."
)

modele = charger_modele()

fichier = st.file_uploader("Choisis une image", type=["jpg", "jpeg", "png"])

if fichier is not None:
    image = Image.open(fichier)
    st.image(image, caption="Image téléversée", use_container_width=True)

    # Prédiction
    entree = pretraiter(image)
    probabilites = modele.predict(entree, verbose=0)[0]   # 5 probabilités
    indice = int(np.argmax(probabilites))

    st.subheader(f"Prédiction : {CLASSES[indice]}")
    st.write(f"Confiance : **{probabilites[indice]:.1%}**")

    # Graphique des probabilités
    st.write("Probabilité de chaque classe :")
    df = pd.DataFrame({"probabilité": probabilites}, index=CLASSES)
    st.bar_chart(df)
else:
    st.info("En attente d'une image…")
