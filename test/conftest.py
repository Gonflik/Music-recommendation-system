import pytest
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.model import Base
from .factories import all_factories

engine = create_engine("sqlite://")
Session = sessionmaker(bind=engine)

@pytest.fixture(scope="session", autouse=True)
def db():
    Base.metadata.create_all(engine)
    yield
    Base.metadata.drop_all(engine)

@pytest.fixture(scope="function")
def db_session():
    connection = engine.connect()
    transaction = connection.begin()

    session = Session(bind=connection)
    #ніби можна забрати, якшо тести для кожної моделі в окремому файлі, там і біндити
    for factory_class in all_factories:
        factory_class._meta.sqlalchemy_session = session

    yield session

    session.close()
    transaction.rollback()
    connection.close()
