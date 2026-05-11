from .services.propaganda import PropagandaDranika
from app import create_app

app = create_app()

with app.app_context():
    recs = PropagandaDranika.get_recommendations(3, 10)
    for i in recs:
        print(i.to_dict())