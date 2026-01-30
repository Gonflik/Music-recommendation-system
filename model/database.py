import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
from .base import Base

load_dotenv()

engine = create_engine(os.getenv("DATABASE_URL"))

def init_db():
    Base.metadata.create_all(engine)