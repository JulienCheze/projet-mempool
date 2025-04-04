import pandas as pd
import dash
from dash import dcc, html
import plotly.express as px
from dash.dependencies import Input, Output

app = dash.Dash(__name__)
app.title = "Dashboard Mempool"

app.layout = html.Div([
    html.H1("Dashboard Mempool Bitcoin"),
    dcc.Graph(id='live-graph'),
    dcc.Interval(
        id='interval-component',
        interval=60*1000,  # 60 sec
        n_intervals=0
    ),
    html.P("Données mises à jour automatiquement toutes les 60 secondes."),
])

@app.callback(
    Output('live-graph', 'figure'),
    Input('interval-component', 'n_intervals')
)
def update_graph(n):
    df = pd.read_csv("data.csv")
    fig = px.line(df, x="timestamp", y=["fastestFee", "nonConfirmedCount"], markers=True,
                  title="Évolution des frais rapides et des transactions non confirmées")
    return fig

if __name__ == "__main__":
    app.run(debug=False, host="0.0.0.0", port=8050)







