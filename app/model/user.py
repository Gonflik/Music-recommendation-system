import enum
import datetime
from .base import Base
from sqlalchemy.orm import Mapped, mapped_column, relationship, validates, reconstructor
from sqlalchemy import String, ForeignKey, Enum, CheckConstraint, select, func, DateTime
from sqlalchemy.exc import IntegrityError
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
    bio: Mapped[str | None] = mapped_column(String(300))
    password: Mapped[str] 
    age: Mapped[int | None]
    gender: Mapped[GenderEnum] = mapped_column(
        Enum(GenderEnum, name="user_gender_enum"),
        nullable=False,
        default=GenderEnum.PREFER_NOT_TO_SAY,
    )
    location: Mapped[str | None] = mapped_column(String(100))

    created_at: Mapped[datetime.datetime] = mapped_column(DateTime(), default=func.now())
    updated_at: Mapped[datetime.datetime] = mapped_column(DateTime(), default=func.now(), onupdate=func.now())

    ratings: Mapped[List["Rating"]] = relationship(back_populates="user")
    tolisten: Mapped[List["ToListen"]] = relationship(back_populates="user")
    actions: Mapped[List["Action"]] = relationship(back_populates="user")
    recommendations: Mapped[List["Recommendation"]] = relationship(back_populates="user")

    @reconstructor
    def init_on_load(self):
        self.errors = []

    def __init__(self, **kw):
        self.errors = []
        super().__init__(**kw)

    __table_args__ = (
        CheckConstraint("LENGTH(name) > 0 ", name="ck_user_name_length"),
        CheckConstraint("email LIKE '%_@__%.__%'", name="ck_user_email_form"),
        CheckConstraint("age BETWEEN 6 AND 119", name="ck_user_age_range"),
        CheckConstraint("LENGTH(location) > 1", name="ck_user_location_length")
    )

    #validators
    @validates('email')
    def validate_email(self, key, address):
        if '@' not in address:
            self.errors.append("Failed simple email validation!")
        return address.lower().strip()
    
    @validates('password')
    def validate_password(self, key, password):
        if len(password) < 8:
            self.errors.append("Password is too short!(min 8 chars)")
        return password
    
    @validates('name')
    def validate_name(self, key, name):
        if name is not None:
            if len(name) < 1 or len(name) > 32:
                self.errors.append("Name length out of bounds(1-32 chars)")
        return name
        
    @validates('age')
    def validate_age(self, key, age):
        if age is not None:
            if age < 6 or age > 120:
                self.errors.append("Invalid age!")
        return age
    
    @validates('location')
    def validate_location(self, key, location):
        if location is not None:
            if len(location) < 2 or len(location) > 100:
                self.errors.append("Name of location is out of bounds!(2-100 chars)")
        return location
    
    @validates('role')
    def validate_role(self, key, role):
        if role is not None:
            if role not in UserRole:
                self.errors.append("Role is non-existent!")
        return role
    
    @validates('gender')
    def validate_gender(self, key, gender):
        if gender is not None:
            if gender not in GenderEnum:
                self.errors.append(f"{gender} is not a viable gender option")
        return gender
    
    #get methods/select queries
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

    #useful methods
    def save(self):
        db.session.add(self)
        db.session.commit()

    def to_dict(self):
        return {
            "email" : self.email,
            "id" : self.id,
            "name" : self.name,
            "bio": self.bio,
            "age" : self.age,
            "gender": self.gender,
            "location": self.location
        }
    
    @staticmethod
    def hash_password(password: str):
        hash_object = hashlib.sha256(password.encode('utf-8'))
        hash_digest = hash_object.hexdigest()
        return hash_digest
    

    @classmethod
    def register(cls, data):
        if User.get_user_by_email(data.get('email')) is not None:
            return None, {"message": "User already exists!", "code": 409}
        
        new_user = User(
            name = data.get('name'),
            email = data.get('email'),
            age = data.get('age'),
            password = data.get('password'),
            gender = data.get('gender', 'prefer_not_to_say').lower(),
            location = data.get('location')
        )
                

        if len(new_user.errors) > 0:
            return None, {"error": new_user.errors, "code": 400}
        
        new_user.password = new_user.hash_password(new_user.password)
        new_user.save()

        return new_user, None

    @classmethod
    def login(cls, data):
        user = User.get_user_by_email(data.get('email'))
        if not user:
            return None, {"error": "User not found!", "code": 404}
        
        if User.hash_password(data.get('password')) == user.password: 
            return user, None
        
        return None, {"error" : "Incorrect password!", "code": 401}
        
    def update(self, data):
        
        new_name = data.get('name')
        new_age = data.get('age')
        new_gender = data.get('gender')
        new_location = data.get('location')

        if new_name is not None:
            self.name = new_name

        if new_age is not None:
            self.age = new_age

        if new_gender is not None:
            self.gender = new_gender.lower()
        
        if new_location is not None:
            self.location = new_location

        if len(self.errors) > 0:
            return False, {"error": self.errors, "code": 400}
        
        self.save()
        return True, None

    def delete(self, data):
        if User.hash_password(data.get('password')) == self.password:
            db.session.delete(self)
            db.session.commit()
            return True, {"message" : "User deleted successfully!", "code": 200}
        return False, {"error" : "Incorrect password!", "code": 401}
    