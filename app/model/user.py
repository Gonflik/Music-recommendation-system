import enum
from .base import Base
from sqlalchemy.orm import Mapped, mapped_column, relationship, validates
from sqlalchemy import String, ForeignKey, Enum, CheckConstraint, select
from typing import List, Optional
#from uuid import uuid4
from werkzeug.security import generate_password_hash, check_password_hash
from app.extensions import db

class UserRole(enum.Enum):
    ADMIN = "admin"
    USER = "user"

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
    gender: Mapped[str | None] = mapped_column(String(30))
    location: Mapped[str | None] = mapped_column(String(100))

    ratings: Mapped[List["Rating"]] = relationship(back_populates="user")
    tolisten: Mapped["ToListen"] = relationship(back_populates="user")

    __table_args__ = (
        CheckConstraint("LENGTH(name) > 2 ", name="ck_name_length"),
        CheckConstraint("email LIKE '%_@__%.__%'", name="ck_email_form"),
        CheckConstraint("LENGTH(password) > 8", name="ck_password_length"),
        CheckConstraint("age BETWEEN 6 AND 119", name="ck_age_range")
    )

    @validates('email')
    def validate_email(self, key, address):
        if '@' not in address:
            raise ValueError("Failed simple email validation!")
        return address.lower().strip()
    
    @validates('name')
    def validate_name(self, key, name):
        if len(name) < 2:
            raise ValueError("Password too short(min 2 chars)")
        return name
        
    @validates('age')
    def validate_age(self, key, age):
        if age < 5 or age > 120:
            raise ValueError("Invalid age!")
        return age

    def check_password(self, password):
        return check_password_hash(self.password, password)
    
    def get_user_by_email(email):
        stmt = select(User).where(User.email==email)
        user = db.session.scalar(stmt)
        return user

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