import enum
from .base import Base
from sqlalchemy.orm import Mapped, mapped_column, relationship, validates
from sqlalchemy import String, ForeignKey, Enum, CheckConstraint, select
from typing import List, Optional
#from uuid import uuid4
from werkzeug.security import generate_password_hash, check_password_hash
from app.extensions import db

class UserRole(str, enum.Enum):
    ADMIN = "admin"
    USER = "user"

class GenderEnum(str, enum.Enum):
    MALE = "male"
    FEMALE = "female"
    NON_BINARY = "non_binary"
    PREFER_NOT_TO_SAY = "prefer_not_to_say"

class User(Base):
    __tablename__ = "user"
    
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True) 
    name: Mapped[str] = mapped_column(String(32))
    email: Mapped[str] = mapped_column(String(100), unique=True)
    role: Mapped[UserRole] = mapped_column(
        Enum(UserRole, name="user_role_enum"),
        nullable=False,
        default=UserRole.USER,
    )
    password: Mapped[str] 
    age: Mapped[int]
    gender: Mapped[GenderEnum] = mapped_column(
        Enum(GenderEnum, name="user_gender_enum"),
        nullable=False,
        default=GenderEnum.PREFER_NOT_TO_SAY,
    )
    location: Mapped[str | None] = mapped_column(String(100))

    ratings: Mapped[List["Rating"]] = relationship(back_populates="user")
    tolisten: Mapped[List["ToListen"]] = relationship(back_populates="user")

    __table_args__ = (
        CheckConstraint("LENGTH(name) > 2 ", name="ck_user_name_length"),
        CheckConstraint("email LIKE '%_@__%.__%'", name="ck_user_email_form"),
        CheckConstraint("age BETWEEN 6 AND 119", name="ck_user_age_range"),
        CheckConstraint("LENGTH(location) > 2", name="ck_user_location_length")
    )

    @validates('email')
    def validate_email(self, key, address):
        if '@' not in address:
            raise ValueError("Failed simple email validation!")
        return address.lower().strip()
    
    @validates('name')
    def validate_name(self, key, name):
        if len(name) < 2:
            raise ValueError("Name too short(min 2 chars)")
        return name
        
    @validates('age')
    def validate_age(self, key, age):
        if age < 6 or age > 120:
            raise ValueError("Invalid age!")
        return age
    
    @validates('location')
    def validate_location(self, key, location):
        if location is not None:
            if len(location) < 2:
                raise ValueError("Name of location(country) is too short!(min 2 chars)")
        return location

    def check_password(self, password):
        return check_password_hash(self.password, password)
    
    #tre static method abo class method?
    def get_user_by_email(email):
        stmt = select(User).where(User.email==email)
        user = db.session.scalar(stmt)
        return user
    #tre static method abo class method?
    def get_user_by_id(id):
        stmt = select(User).where(User.id==id)
        user = db.session.scalar(stmt)
        return user

    def save(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()