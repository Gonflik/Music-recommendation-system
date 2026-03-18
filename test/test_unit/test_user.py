import pytest
from ..factories import UserFactory
from sqlalchemy.exc import IntegrityError

def test_create_user(db_session):
    user = UserFactory()
    db_session.commit()
    assert user is not None
    assert user.name is not None


def test_user_age_constraint(db_session):
    user = UserFactory(age=3)
    len(user.errors) > 0
    
def test_user_name_len_constraint(db_session):
    user1 = UserFactory(name='')
    assert len(user1.errors) > 0
    user2 = UserFactory(name='598137051434036359116386563415771d')
    assert len(user2.errors) > 0

def test_user_name_none(db_session):
    with pytest.raises(IntegrityError):
        user = UserFactory(name=None)
        db_session.add(user)
        db_session.commit()

def test_user_location_len_constraint(db_session):
    user = UserFactory(location='A')
    assert len(user.errors) > 0
def test_user_email_form_constraint(db_session):
    user = UserFactory(email="shnelashnekla.bobobo")
    len(user.errors) > 0
