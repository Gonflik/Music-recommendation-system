import enum
from .base import Base
from sqlalchemy.orm import Mapped, mapped_column, relationship, validates
from sqlalchemy import String, ForeignKey, Enum, CheckConstraint, select
from typing import List, Optional
from app.extensions import db
import hashlib

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
        CheckConstraint("LENGTH(name) > 0 ", name="ck_user_name_length"),
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
        if name is not None:
            if len(name) < 1 or len(name) > 32:
                raise ValueError("Name length out of bounds(1-32 chars)")
        return name
        
    @validates('age')
    def validate_age(self, key, age):
        if age < 6 or age > 120:
            raise ValueError("Invalid age!")
        return age
    
    @validates('location')
    def validate_location(self, key, location):
        if location is not None:
            if len(location) < 2 or len(location) > 100:
                raise ValueError("Name of location is out of bounds!(2-100 chars)")
        return location


    def hash_password(password: str):
        hash_object = hashlib.sha256(password.encode('utf-8'))
        hash_digest = hash_object.hexdigest()
        return hash_digest
    
    @classmethod
    def get_user_by_email(cls, email: str):
        stmt = select(cls).where(cls.email==email)
        user = db.session.scalar(stmt)
        return user
    
    @classmethod
    def get_user_by_id(cls, id: int):
        stmt = select(cls).where(cls.id==id)
        user = db.session.scalar(stmt)
        return user
    
    @classmethod
    def get_all_users(cls, page: int, per_page: int):
        stmt = select(cls).limit(per_page).offset((page-1) * per_page)
        result = db.session.scalars(stmt).all()
        return result

    def save(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()

    def to_dict(self):
        return {
            "email" : self.email,
            "id" : self.id,
            "name" : self.name,
            "age" : self.age,
            "gender": self.gender,
            "location": self.location
        }