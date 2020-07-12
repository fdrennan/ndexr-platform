import plotly.express as px

def plot_line_2d(data, x, y):
    fig = px.line(data, x=x, y=y)
    fig.show()
