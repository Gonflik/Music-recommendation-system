import pytest
from app.model import User
from .factories import UserFactory
from sqlalchemy.exc import IntegrityError

def test_create_user(db_session):
    user = UserFactory()
    assert user is not None

def test_user_age_constraint(db_session):
    with pytest.raises(ValueError):
        user = UserFactory(age=3)
    
def test_user_name_len_constraint(db_session):
    with pytest.raises(ValueError):
        user = UserFactory(name='A')

#na rivni pitona name=None prohodit, ale v bd no
def test_user_name_none(db_session):
    with pytest.raises(IntegrityError):
        user = UserFactory(name=None)
        db_session.add(user)
        db_session.commit()

def test_user_location_len_constraint(db_session):
    with pytest.raises(ValueError):
        user = UserFactory(location='A')

def test_user_email_form_constraint(db_session):
    with pytest.raises(ValueError):
        user = UserFactory(email="shnelashnekla.bobobo")
