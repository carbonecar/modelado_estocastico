import pandas as pd
from datetime import timedelta

# Cargar CSV original
df = pd.read_csv("datos_spy.csv", sep=";", decimal=",")
df["Date"] = pd.to_datetime(df["Date"], format="%d/%m/%Y")

# Obtener última fecha
last_date = df["Date"].max()

# Crear fechas hábiles para el próximo mes (solo días hábiles)
future_dates = pd.date_range(
    start=last_date + timedelta(days=1),
    periods=22,  # Aproximadamente 1 mes hábil
    freq="B"     # B = business day
)

# Crear nuevo DataFrame vacío
future_df = pd.DataFrame({"Date": future_dates, "Close": float("nan")})

# Exportar a CSV
future_df.to_csv("predicciones_mes_siguiente.csv", sep=";", index=False, date_format="%d/%m/%Y", decimal=",")
